package com.improjam

import com.mongodb.BasicDBList
import com.mongodb.BasicDBObject
import grails.converters.JSON
import groovyx.net.http.HTTPBuilder
import groovyx.net.http.Method
import org.bson.types.ObjectId
import org.joda.time.DateTime
import twitter4j.Twitter
import twitter4j.TwitterFactory
import twitter4j.auth.AccessToken
import twitter4j.conf.Configuration
import twitter4j.conf.ConfigurationBuilder

import java.text.SimpleDateFormat

import static groovyx.net.http.ContentType.TEXT
import static groovyx.net.http.ContentType.URLENC

class VoteController {
    def mongo
    def springSecurityService

    def index() {
        def db = mongo.getDB(grailsApplication.config.com.improjam.database)
        BasicDBObject query = new BasicDBObject().append("round",1)
        def results = db.fixtures.find(query)
        def ronda1 = false
        def ronda2 = false
        def ronda3 = false
        def fechas1 = [:]
        def fechas2 = [:]
        def fechas3 = [:]
        if(results){
            //ronda1 = true
            def obj = results?.next()
            def today  =  new Date()
            fechas1['startDate'] = obj?.initDate
            fechas1['endDate'] = obj?.endDate
            if(obj?.initDate <= today && today <= obj?.endDate)
                ronda1 = true
        }
        BasicDBObject queryf = new BasicDBObject().append("round",1)
        def fixturesfirst = db.fixtures.find(queryf)
        def videoList = []
        while(fixturesfirst.hasNext()){
            def actual = fixturesfirst.next()
            if(!!actual.video_1 != false && !!actual.video_2!= false){
                BasicDBObject querya = new BasicDBObject().append("_id", new ObjectId(actual.video_1))
                BasicDBObject queryb = new BasicDBObject().append("_id", new ObjectId(actual.video_2))
                def video1 = db.videos.findOne(querya)
                def video2 = db.videos.findOne(queryb)
                def user1  = Contestant.findById(video1.user as Long)
                def user2  = Contestant.findById(video2.user as Long)
                BasicDBObject queryva = new BasicDBObject().append("video",actual.video_1)
                BasicDBObject queryvb = new BasicDBObject().append("video",actual.video_2)
                def votes1 = db.votes.count(queryva)
                def votes2 = db.votes.count(queryvb)
                if(user1 && user2){
                    def video1id = video1?.url.split("=")[1]
                    def video2id = video2?.url.split("=")[1]
                    videoList.add([video1: [user: user1,video: video1,id: video1id,votes: votes1],video2:[user: user2, video: video2, id: video2id, votes: votes2],fixtureid: actual._id.toString()])
                }
            }



        }
        def fbUser = springSecurityService.currentUser ? FacebookUser.findByUser(springSecurityService.currentUser) : null
        def curUser = User.findByEmail(springSecurityService.currentUser?.email as String)
        def ytAT = YoutubeAuthToken.findByUserAndActive(curUser,true)
        def twAT = TwitterAuthToken.findByUserAndActive(curUser,true)
        def inAT = InstagramAuthToken.findByUserAndActive(curUser,true)
        def subYoutube = checkYoutube(curUser)
        def folTwitter = checkTwitter(curUser)
        def folInstagram = checkInstagram(curUser)
//        println folInstagram
        if(subYoutube == 2){//reautorizar
                reauthorizeUser(curUser)
                subYoutube = checkYoutube(curUser)
        }
        [currentUser: curUser,youtube: [token: ytAT,subscribed:subYoutube],twitter:[token: twAT,follows: folTwitter],instagram:[token: inAT,follows: folInstagram], facebookUser: fbUser,ronda1:ronda1,ronda2:ronda2,ronda3:ronda3,fechas1:fechas1,fechas2:fechas2,fechas3:fechas3,videos: videoList]
    }

    def vote(){
        def user = springSecurityService.currentUser
        if(!!user == false){
            response.setStatus(200)
            def result = ["status": 0, "message": "Debes Iniciar Sesión para votar."]
            render result as JSON
            return
        }
        def videoid = params.videoid
        def round = params.round
        def ipaddr = params.ipaddr
        def fingerprint = params.fingerprint
        if(!!videoid == false){
            response.setStatus(200)
            def result = ["status": 0, "message": "Hay errores en los parámetros recibidos."]
            render result as JSON
            return
        }
        def db = mongo.getDB(grailsApplication.config.com.improjam.database)
        def oid = null
        try{
            oid = new ObjectId(videoid as String)
        }catch(Exception e){println e}
        BasicDBObject query = new BasicDBObject().append("_id",oid)
        def video = db.videos.findOne(query)
        if(!!video == false){
            response.setStatus(200)
            def result = ["status": 0, "message": "El video por el que tratas de votar no existe."]
            render result as JSON
            return
        }
        BasicDBObject query2 = new BasicDBObject().append("round",round as Integer)
        def resultado = db.fixtures.findOne(query2)
        if(!!resultado == false){
            response.setStatus(200)
            def result = ["status": 0, "message": "Aún no hay enfrentamientos en la ronda especificada."]
            render result as JSON
            return
        }

        //revisar si esta en competencia en esta ronda
        BasicDBObject clause1 = new BasicDBObject("video_1", videoid as String)
        BasicDBObject clause2 = new BasicDBObject("video_2", videoid as String)
        BasicDBList or = new BasicDBList();
        or.add(clause1)
        or.add(clause2)
        BasicDBObject query4 = new BasicDBObject().append('$or', or)
                .append('round',round as Integer)
        def resulta = db.fixtures.findOne(query4)
        if(!!resulta == false){
            response.setStatus(200)
            def result = ["status": 0, "message": "El video por el que votas, no se encuentra participando en esta ronda de votaciones."]
            render result as JSON
            return
        }
        def contender
        if(resulta.video_1 == videoid){
           BasicDBObject query5 = new BasicDBObject().append('_id', new ObjectId(resulta.video_2))
            contender = db.videos.findOne(query5)

        }else{
            BasicDBObject query5 = new BasicDBObject().append('_id', new ObjectId(resulta.video_1))
            contender = db.videos.findOne(query5)
        }
        if(!!contender == false){
            response.setStatus(200)
            def result = ["status": 0, "message": "El contendor del video por el que votas no existe en la plataforma."]
            render result as JSON
            return
        }
        //revisar fechas
        Date today = new Date()
        Date initDate = resultado.initDate as Date
        Date endDate = resultado.endDate as Date
        if(today < initDate){
            response.setStatus(200)
            def result = ["status": 0, "message": "ERROR: La fecha de votación para esta ronda aun no ha llegado."]
            render result as JSON
            return
        }
        if(today > endDate){
            response.setStatus(200)
            def result = ["status": 0, "message": "ERROR: Las fechas de votación para esta ronda ya pasaron."]
            render result as JSON
            return
        }
        //tomar votos con usuario para ese video en esa ronda, si hay en el mismo día no valerlo
        BasicDBObject
        def dates = magicDates(params)
        def sDate = dates.startDate
        def eDate = dates.endDate
        BasicDBObject queryu = new BasicDBObject().append("user",user.id as Integer)
                .append("round",round as Integer)
                .append("video",videoid as String)
                .append("dateCreated",new BasicDBObject('$gte', sDate).append('$lt', eDate)) //revisar bien en servidor porque ahi no pondra timezone de colombia

        def rows = db.votes.count(queryu)
        if(rows > 0){
            response.setStatus(200)
            def result = ["status": 0, "message": "ERROR: Ya has votado en esta batalla día de hoy. Inténtalo de nuevo mañana."]
            render result as JSON
            return
        }
        //tomar votos con fingerprint para ese video en esa ronda, si hay en el mismo día no valerlo
        BasicDBObject
        BasicDBObject queryr = new BasicDBObject().append("fingerprint",fingerprint as String)
                .append("round",round as Integer)
                .append("video",videoid as String)
                .append("dateCreated",new BasicDBObject('$gte', sDate).append('$lt', eDate)) //revisar bien en servidor porque ahi no pondra timezone de colombia

        def filas = db.votes.count(queryr)
        if(filas > 0){
            response.setStatus(200)
            def result = ["status": 0, "message": "ERROR: Ya has votado en esta batalla día de hoy. Inténtalo de nuevo mañana."]
            render result as JSON
            return
        }

        BasicDBObject newvote = new BasicDBObject().append("video",videoid as String)
                                    .append("dateCreated",new Date())
                                    .append("lastUpdated",new Date())
                                    .append("round",round as Integer)
                                    .append("user",user.id)
                                    .append("ip",ipaddr)
                                    .append("fingerprint",fingerprint)
        db.votes.insert(newvote)
        BasicDBObject query3 = new BasicDBObject().append("video",videoid)
                                            .append("round",round as Integer)
        BasicDBObject query7 = new BasicDBObject().append("video",contender._id.toString())
                .append("round",round as Integer)
        def votos = db.votes.count(query3)
        def votosc = db.votes.count(query7)
        response.setStatus(200)
        def result = ["status": 1, "message": "Tu voto ha sido contabilizado con éxito.","own": votos, "contender": votosc, "totales": votos+votosc,"ownid" : video._id.toString(),"contenderid" : contender._id.toString(),fixtureid: resulta._id.toString()]
        render result as JSON
        return
    }


    def remoteCheckAll(){
        def user = springSecurityService.currentUser as User
        def yt = checkYoutube(user)
        if(yt == 2){
            reauthorizeUser(user)
            yt = checkYoutube(user)
        }
        def tw = checkTwitter(user)
        def inst = checkInstagram(user)
        response.setStatus(200)
        def result = [youtube: 1, instagram: 1, twitter: 1]
//        def result = [youtube: yt, instagram: inst, twitter: tw]
        render result as JSON
        return
    }


    private Integer checkYoutube(User user){
        def http = new HTTPBuilder( "https://www.googleapis.com" )
        def jsonData
        def result
        def aut = YoutubeAuthToken.findByUserAndActive(user,true)
        if(!aut){
            return 0
        }
        http.request( Method.GET ,TEXT) {
            uri.path = '/youtube/v3/subscriptions'
            uri.query =  [part: 'id', mine: 'true',access_token : aut.access_token,forChannelId : grailsApplication.config.com.improjam.youtube.channelid]
            headers.'User-Agent' = 'Mozilla/5.0 Ubuntu/8.10 Firefox/3.0.4'
            response.success = { resp, json ->
                try{
                    jsonData = JSON.parse(json)

                }catch (Exception e){
                    println e
                }
                if((!!jsonData != false) && ((jsonData.pageInfo.totalResults as Integer) > 0) )
                    return 1
                return 0
            }
            response.failure = { resp,json ->
                println "Unexpected error: ${resp.statusLine.statusCode} : ${resp.statusLine.reasonPhrase}"
                //redirect(uri: '/')
                if(resp.statusLine.statusCode == 401){ //no autorizado
                    return 2 //reauthorize

                }
            }
            return 0
    }
    }

    private Integer checkInstagram(User user){
        def http = new HTTPBuilder( "https://api.instagram.com" )
        def jsonData
        def result
        def aut = InstagramAuthToken.findByUserAndActive(user,true)
        if(!aut){
            return 0
        }
        ///v1/users/1574083/relationship?access_token=ACCESS-TOKEN
        http.request( Method.GET ,TEXT) {
            uri.path = '/v1/users/'+grailsApplication.config.com.improjam.instagram.nickyjamid+'/relationship'
            uri.query =  [access_token : aut.access_token]
            headers.'User-Agent' = 'Mozilla/5.0 Ubuntu/8.10 Firefox/3.0.4'
            response.success = { resp, json ->
                try{
                    jsonData = JSON.parse(json)

                }catch (Exception e){
                    println e
                }
                if((!!jsonData != false) && ((jsonData.data.outgoing_status) == "follows") )
                    return 1
                return 0
            }
            response.failure = { resp,json ->
                println "Unexpected error: ${resp.statusLine.statusCode} : ${resp.statusLine.reasonPhrase}"
                //redirect(uri: '/')
            }
            return 0
    }
    }


    private Integer checkTwitter(User user){
        ConfigurationBuilder builder = new ConfigurationBuilder();
        builder.setOAuthConsumerKey(grailsApplication.config.com.improjam.twitter.consumerkey as String);
        builder.setOAuthConsumerSecret(grailsApplication.config.com.improjam.twitter.consumersecret as String);
        Configuration configuration = builder.build();
        TwitterFactory factory = new TwitterFactory(configuration);
        Twitter twitter = factory.getInstance();
        def token = TwitterAuthToken.findByUserAndActive(user, true)
        if(!token){
            return 0
        }
        AccessToken at = new AccessToken(token.access_token,token.secret)
        twitter.setOAuthAccessToken(at)
        def rel = twitter.showFriendship(at.getUserId()/*,1306173511*/,246967511)
        if(rel.sourceFollowingTarget){
            return 1
        }else{
            return 0
        }
        return 0


    }

    private void reauthorizeUser(User user){
        //reautoriar usario con authToken viejo
        def http = new HTTPBuilder( "https://accounts.google.com" )
        def jsonData
        def result
        def aut = YoutubeAuthToken.findByUserAndActive(user,true)
//        println aut.access_token
        if(!aut){
            return
        }
        http.request( Method.POST ) {
            uri.path = '/o/oauth2/token'
            send URLENC, [grant_type: 'refresh_token',client_id: grailsApplication.config.com.improjam.youtube.clientid,client_secret: grailsApplication.config.com.improjam.youtube.clientsecret,refresh_token:user.ytRefreshToken]
            response.success = { resp, json ->
//                println json

                def tokens = YoutubeAuthToken.findAllByUser(user)
                tokens.each {
                    it.active = false
                    it.save(flush: true)
                }
                def at = new YoutubeAuthToken(
                        user: user,
                        access_token: json.access_token,
                        expires_in: json.expires_in as Integer,
                        type: json.token_type,
                        active: true,
                        dateCreated: new Date()
                ).save(flush: true,failOnError: true)
                try{
                    YoutubeAuthToken.where{ eq( "user", user ) && eq("active",false) }.deleteAll()
                }catch(Exception e){
                    println e
                }
            }
            response.failure = { resp,json ->
//                println json
                println "Unexpected error: ${resp.statusLine.statusCode} : ${resp.statusLine.reasonPhrase}"
            }
        }
    }

    private magicDates(params){
        /***************
         *
         *
         *
         *      FECHAS - TOMADO DE QPON 0.2.2 BY QTAG TECHNOLOGIES
         *
         *
         *
         *
         *
         * ************************/


        def startDate
        def endDate
        def sentDate = params.reportDate ?: 'default'
        //def sentDate = "04/9/2014-04/13/2014"
        if(sentDate == 'Fecha de inicio de la ronda') //lo que diga el widget que se ponga
        {
            sentDate = 'default'
        }
        if(sentDate == 'default')
        {


            def start = Calendar.getInstance(TimeZone.getTimeZone(grailsApplication.config.app.timezone))
            def end = Calendar.getInstance(TimeZone.getTimeZone(grailsApplication.config.app.timezone))
            start.set(start.get(Calendar.YEAR),start.get(Calendar.MONTH),start.get(Calendar.DATE),0,0,0)
            end.set(end.get(Calendar.YEAR),end.get(Calendar.MONTH),end.get(Calendar.DATE) + 1,0,0,0)
            //println "inicial: "+start.getTime()
            //println "final"+end.getTime()

            startDate = start.getTime()
            endDate = end.getTime()


        }
        //
        else //recibió la fecha del calendario que seleccionó el usuario
        {

            def values = sentDate.split('-')
            if(values.size() == 1) //la fecha recibida es un día único
            {

                def fechas = values[0].split('/')

                def month
                switch (fechas[0].trim())
                {
                    case '01': month = Calendar.JANUARY
                        break
                    case '02': month = Calendar.FEBRUARY
                        break
                    case '03': month = Calendar.MARCH
                        break
                    case '04': month = Calendar.APRIL
                        break
                    case '05': month = Calendar.MAY
                        break
                    case '06': month = Calendar.JUNE
                        break
                    case '07': month = Calendar.JULY
                        break
                    case '08': month = Calendar.AUGUST
                        break
                    case '09': month = Calendar.SEPTEMBER
                        break
                    case '10': month = Calendar.OCTOBER
                        break
                    case '11': month = Calendar.NOVEMBER
                        break
                    case '12': month = Calendar.DECEMBER
                        break
                }

                def start = Calendar.getInstance(TimeZone.getTimeZone(grailsApplication.config.app.timezone))
                start.set(year: fechas[2].toInteger(), month: month, date: fechas[1].toInteger(), hourOfDay: 0, minute: 0,second: 0,millisecond: 0)
                def end = Calendar.getInstance(TimeZone.getTimeZone(grailsApplication.config.app.timezone))
                end.set(year: fechas[2].toInteger(), month: month, date: fechas[1].toInteger() + 1, hourOfDay: 0, minute: 0,second: 0,millisecond: 0)
                startDate = start.getTime()
                endDate = end.getTime()
                //println start
                //println end
                /*
                startDate = new Date().parse('MM/dd/yyyy', values[0])
                //println startDate
                endDate = startDate.next()
                def start = Calendar.getInstance(TimeZone.getTimeZone(grailsApplication.config.app.timezone))
                //println start
                def end = Calendar.getInstance(TimeZone.getTimeZone(grailsApplication.config.app.timezone))
                start.setTime(startDate)
                //println start
                end.setTime(endDate)
                start.clearTime()
                println start
                end.clearTime()
                startDate = start.getTime()
                //println startDate
                endDate = end.getTime()
                */
            }
            else //Es un rango de fechas
            {
//                println "en rango de fechas"
                assert values.size() == 2
                def fecha1 = values[0].split('/')
                def fecha2 = values[1].split('/')

                def month1
                def month2
                switch (fecha1[0].trim())
                {
                    case '01': month1 = Calendar.JANUARY
                        break
                    case '02': month1 = Calendar.FEBRUARY
                        break
                    case '03': month1 = Calendar.MARCH
                        break
                    case '04': month1 = Calendar.APRIL
                        break
                    case '05': month1 = Calendar.MAY
                        break
                    case '06': month1 = Calendar.JUNE
                        break
                    case '07': month1 = Calendar.JULY
                        break
                    case '08': month1 = Calendar.AUGUST
                        break
                    case '09': month1 = Calendar.SEPTEMBER
                        break
                    case '10': month1 = Calendar.OCTOBER
                        break
                    case '11': month1 = Calendar.NOVEMBER
                        break
                    case '12': month1 = Calendar.DECEMBER
                        break
                }
                switch (fecha2[0].trim())
                {
                    case '01': month2 = Calendar.JANUARY
                        break
                    case '02': month2 = Calendar.FEBRUARY
                        break
                    case '03': month2 = Calendar.MARCH
                        break
                    case '04': month2 = Calendar.APRIL
                        break
                    case '05': month2 = Calendar.MAY
                        break
                    case '06': month2 = Calendar.JUNE
                        break
                    case '07': month2 = Calendar.JULY
                        break
                    case '08': month2 = Calendar.AUGUST
                        break
                    case '09': month2 = Calendar.SEPTEMBER
                        break
                    case '10': month2 = Calendar.OCTOBER
                        break
                    case '11': month2 = Calendar.NOVEMBER
                        break
                    case '12': month2 = Calendar.DECEMBER
                        break
                }
                def start = Calendar.getInstance(TimeZone.getTimeZone(grailsApplication.config.app.timezone))
                start.set(year: fecha1[2].toInteger(), month: month1, date: fecha1[1].toInteger(), hourOfDay: 0, minute: 0,second: 0,millisecond: 0)
                def end = Calendar.getInstance(TimeZone.getTimeZone(grailsApplication.config.app.timezone))
                end.set(year: fecha2[2].toInteger(), month: month2, date: fecha2[1].toInteger() + 1, hourOfDay: 0, minute: 0,second: 0,millisecond: 0)
//                println start
//                println end
                startDate = start.getTime()
                endDate = end.getTime()
            }

        }
        SimpleDateFormat sdf = new SimpleDateFormat ("MM/dd/yyyy HH:mm:ss") //poner que esto siempre sea 00:00:00
        sdf.setTimeZone (TimeZone.getTimeZone ("UTC"))
        startDate = sdf.format(startDate)
        //println startDate
        endDate = sdf.format(endDate)
        startDate = new Date().parse('MM/dd/yyyy HH:mm:ss',startDate)
        endDate = new Date().parse('MM/dd/yyyy HH:mm:ss',endDate)
//        println "fechas"
//        println startDate
//        println endDate
        DateTime sDt = new DateTime(startDate)
        DateTime eDt = new DateTime(endDate)
        def res = [startDate: startDate,endDate:endDate]
        return res
    }
}
