import com.improjam.*
import com.the6hours.grails.springsecurity.facebook.FacebookAuthToken
import groovyx.net.http.HTTPBuilder
import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import org.springframework.web.context.request.RequestContextHolder

class FacebookAuthService {




    FacebookUser create(FacebookAuthToken token) {
        def session = RequestContextHolder.currentRequestAttributes().getSession()
        def fbPrUser = FacebookUser.findByUid(token.uid)
        if(fbPrUser)
            return fbPrUser
        def http = new HTTPBuilder('https://graph.facebook.com')
        def json = http.get( path : '/me', query : [access_token:token.accessToken?.accessToken] )
        def email = json.email ? json.email : "$token.uid@facebook.com"
        def name = json.name ? json.name : "Sin Nombre"
        def username = json.username ? json.username : "facebook_$token.uid"
        def birthday
        try{
            DateTimeFormatter formatter = DateTimeFormat.forPattern('MM/dd/yyyy')
            DateTime dt =
            birthday = json.birthday ? (formatter.parseDateTime(json.birthday as String )).toDate() : new Date()
        }catch(Exception e){
            birthday = new Date()
        }
        def location =  json.location ? ((json?.location?.name?.split(","))[0]) : 'medellin' //Medellín, Antioquia, Medellín
        def minus = location.toLowerCase() //medellín
        minus = minus.replaceAll( /([àáâãäå])/, 'a' )
        minus = minus.replaceAll( /([èéêë])/, 'e' )
        minus = minus.replaceAll( /([ìíîï])/, 'i' ) //medellin
        minus = minus.replaceAll( /([òóôõö])/, 'o' )
        minus = minus.replaceAll( /([ùúûü])/, 'u' )
        minus = minus.replaceAll( /([ñ])/, 'n' )
        minus = minus.replaceAll( /([ýÿ])/, 'y' )
        minus = minus.replaceAll( /([ç])/, 'c' )
        minus = minus.replaceAll( /([^a-zA-Z0-9\ ])/, '_' )
        minus = minus.replaceAll( /([\ ])/, '-' )
        def existing = User.findByEmail(email)
        def newUser = existing ?: new User(
                    username: username,
                    password: token.accessToken?.accessToken,
                    enabled: true,
                    accountExpired: false,
                    passwordExpired: false,
                    accountLocked: false,
                    name : name,
                    email: email,
                    uid: token.uid,
                    telephone: "NA",
                    address: "NA",
                    birthdate: birthday ?: " ",
                    latitude: 0L,
                    longitude: 0L,
                    city: location,
                    country: "NA"
                    ).save(failOnError: true,flush: true)

        newUser.uid = token?.uid
        newUser.accessToken =  token.accessToken?.accessToken ?: ""
        newUser.save(failOnError: true,flush: true)
        if(!existing){
                def userRole = SecRole.findByAuthority('ROLE_USER') ?: new SecRole(authority: 'ROLE_USER').save(failOnError: true)
                def facebookRole = SecRole.findByAuthority('ROLE_FACEBOOK') ?: new SecRole(authority: 'ROLE_FACEBOOK').save(failOnError: true)
                SecUserSecRole.create newUser, userRole

        }
        FacebookUser fbUser = new FacebookUser(
                    uid: token.uid,
                    accessToken: token.accessToken?.accessToken,
                    accessTokenExpires: token.accessToken?.expireAt,
                    user: newUser
        )
        fbUser.save()
        return fbUser




    }





}
