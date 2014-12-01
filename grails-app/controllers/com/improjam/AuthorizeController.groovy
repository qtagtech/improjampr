package com.improjam

import grails.converters.JSON
import groovyx.net.http.ContentType
import groovyx.net.http.HTTPBuilder
import groovyx.net.http.Method
import twitter4j.Twitter
import twitter4j.TwitterException
import twitter4j.TwitterFactory
import twitter4j.auth.AccessToken
import twitter4j.auth.RequestToken
import twitter4j.conf.Configuration
import twitter4j.conf.ConfigurationBuilder

import static groovyx.net.http.ContentType.*


class AuthorizeController {
    def mongo
    def springSecurityService



    def index() {
        def http = new HTTPBuilder( "https://accounts.google.com/o/oauth2/auth" )
        def jsonData
        def result
        http.request( Method.GET, ContentType.TEXT ) {
            uri.path = grailsApplication.config.com.nest5.Nest5Client.bigDataPath+'rowOps/fetchProperty'
            uri.query = [company:user.id,table: 'product_category']
            headers.'User-Agent' = 'Mozilla/5.0 Ubuntu/8.10 Firefox/3.0.4'
            response.success = { resp, json ->
                jsonData = JSON.parse(json)
            }
            response.failure = { resp,json ->
                println "Unexpected error: ${resp.statusLine.statusCode} : ${resp.statusLine.reasonPhrase}"
//                println JSON.parse(json)
                result = [status: 404, message: json]
            }
        }

        if(jsonData?.status != 200){
            result = [status: jsonData?.status, message: jsonData?.message]
        }

    }

    def redirectyoutube(){
        redirect(url: 'https://accounts.google.com/o/oauth2/auth?'+
                'client_id='+grailsApplication.config.com.improjam.youtube.clientid+'&' +
                'redirect_uri='+URLEncoder.encode(grailsApplication.config.com.improjam.youtube.redirecturi,"UTF-8")+'&' +
                'scope=https://www.googleapis.com/auth/youtube&' +
                'response_type=code&' +
//                'approval_prompt=force&' +
                'access_type=offline')
        return
    }

    def redirecttwitter(){
        // The factory instance is re-useable and thread safe.
        ConfigurationBuilder builder = new ConfigurationBuilder();
        builder.setOAuthConsumerKey(grailsApplication.config.com.improjam.twitter.consumerkey as String);
        builder.setOAuthConsumerSecret(grailsApplication.config.com.improjam.twitter.consumersecret as String);
        Configuration configuration = builder.build();
        TwitterFactory factory = new TwitterFactory(configuration);
        Twitter twitter = factory.getInstance();
        try {
            RequestToken requestToken = twitter.getOAuthRequestToken(
                    grailsApplication.config.com.improjam.url+"/authorize/twitter");
            session["requestToken"] = requestToken
            redirect(url:  requestToken.getAuthorizationURL())
            return
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    def redirectinstagram(){
        redirect(url: 'https://api.instagram.com/oauth/authorize/?'+
                'client_id='+grailsApplication.config.com.improjam.instagram.clientid+'&' +
                'redirect_uri='+URLEncoder.encode(grailsApplication.config.com.improjam.instagram.redirecturi,"UTF-8")+'&' +
                'scope=basic+relationships+likes+comments&' +
                'response_type=code')
        return
    }


    def youtube(){
        def user = springSecurityService.currentUser
        if(!!user == false){
            redirect(uri: '/')
            return
        }
        if(params.error == "access_denied"){
            redirect(uri: '/')
            return
        }
        def code = params.code
        //println params
        if(!!code == false){
            redirect(uri: '/')
            return
        }
        def http = new HTTPBuilder( "https://accounts.google.com" )
        def jsonData
        def result
        http.request( Method.POST ) {
            uri.path = '/o/oauth2/token'
            send URLENC, [code:code,client_id: grailsApplication.config.com.improjam.youtube.clientid,client_secret: grailsApplication.config.com.improjam.youtube.clientsecret,grant_type:'authorization_code',redirect_uri: grailsApplication.config.com.improjam.youtube.redirecturi]
            headers.'User-Agent' = 'Mozilla/5.0 Ubuntu/8.10 Firefox/3.0.4'
            response.success = { resp, json ->
//                println resp
//                println json
               def userobj = User.findById(user.id)
                if(!!userobj == false){
                    redirect(uri: '/')
                    return
                }
                def tokens = YoutubeAuthToken.findAllByUser(userobj)
                tokens.each {
                    it.active = false
                    it.save(flush: true)
                }
                def at = new YoutubeAuthToken(
                        user: userobj,
                        access_token: json.access_token,
                        expires_in: json.expires_in as Integer,
                        type: json.token_type,
                        active: true,
                        dateCreated: new Date()
                ).save(flush: true)
                userobj.ytRefreshToken = json.refresh_token
                userobj.save(flush:true)
                redirect(uri: '/')
                return
            }
            response.failure = { resp,json ->
                println "Unexpected error: ${resp.statusLine.statusCode} : ${resp.statusLine.reasonPhrase}"
                redirect(uri: '/')
                return
            }
        }


        return
    }

    def instagram(){
        def user = springSecurityService.currentUser
        if(!!user == false){
            redirect(uri: '/')
            return
        }
        if(params.error == "access_denied"){
            redirect(uri: '/')
            return
        }
        def code = params.code
        //println params
        if(!!code == false){
            redirect(uri: '/')
            return
        }
        def http = new HTTPBuilder( "https://api.instagram.com" )
        def jsonData
        def result
        http.request( Method.POST ) {
            uri.path = '/oauth/access_token'
            send URLENC, [code:code,client_id: grailsApplication.config.com.improjam.instagram.clientid,client_secret: grailsApplication.config.com.improjam.instagram.clientsecret,grant_type:'authorization_code',redirect_uri: grailsApplication.config.com.improjam.instagram.redirecturi]
            headers.'User-Agent' = 'Mozilla/5.0 Ubuntu/8.10 Firefox/3.0.4'
            response.success = { resp, json ->
//                println resp
//                println json
               def userobj = User.findById(user.id)
                if(!!userobj == false){
                    redirect(uri: '/')
                    return
                }
                def tokens = InstagramAuthToken.findAllByUser(userobj)
                tokens.each {
                    it.active = false
                    it.save(flush: true)
                }
                def at = new InstagramAuthToken(
                        user: userobj,
                        access_token: json.access_token,
                        username: json.user.username ?: "NA",
                        fullname: json.user.full_name ?: "NA",
                        userid: json.user.id as Long,
                        picture: json.user.profile_picture ?: "http://",
                        active: true,
                        dateCreated: new Date()
                ).save(flush: true,failOnError: true)
                try{
                    InstagramAuthToken.where{ eq( "user", user ) && eq("active",false) }.deleteAll()
                }catch(Exception e){
                    println e
                }
                redirect(uri: '/')
                return
            }
            response.failure = { resp,json ->
                println "Unexpected error: ${resp.statusLine.statusCode} : ${resp.statusLine.reasonPhrase}"
                redirect(uri: '/')
                return
            }
        }


        return
    }



    def twitter(){
        def user = springSecurityService.currentUser
        ConfigurationBuilder builder = new ConfigurationBuilder();
        builder.setOAuthConsumerKey(grailsApplication.config.com.improjam.twitter.consumerkey as String);
        builder.setOAuthConsumerSecret(grailsApplication.config.com.improjam.twitter.consumersecret as String);
        Configuration configuration = builder.build();
        TwitterFactory factory = new TwitterFactory(configuration);
        Twitter twitter = factory.getInstance();
        AccessToken accTok = null;
        try {
            RequestToken rqt = (RequestToken) session["requestToken"]
//            println rqt
            accTok = twitter.getOAuthAccessToken(rqt,params.oauth_verifier as String);
        } catch (Exception e) {
            e.printStackTrace();
        }
        if(accTok){
            def userobj = User.findById(user.id)
            if(!!userobj == false){
                redirect(uri: '/')
                return
            }
            def tokens = TwitterAuthToken.findAllByUser(userobj)
            tokens.each {
                it.active = false
                it.save(flush: true)
            }
            def at = new TwitterAuthToken(
                    user: userobj,
                    access_token: accTok.getToken(),
                    secret: accTok.getTokenSecret(),
                    active: true,
                    dateCreated: new Date()
            ).save(flush: true,failOnError: true)
            try{
                TwitterAuthToken.where{ eq( "user", user ) && eq("active",false) }.deleteAll()
            }catch(Exception e){
                println e
            }
            redirect(uri: '/')
            return
        }
        redirect(uri: '/')
        return
    }


}
