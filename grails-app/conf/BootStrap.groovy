import com.improjam.SecRole
import com.improjam.SecUserSecRole
import com.improjam.User

class BootStrap {

    def init = { servletContext ->
        def userRole = SecRole.findByAuthority('ROLE_USER') ?: new SecRole(authority: 'ROLE_USER').save(failOnError: true)
        def adminRole = SecRole.findByAuthority('ROLE_ADMIN') ?: new SecRole(authority: 'ROLE_ADMIN').save(failOnError: true)
        def facebookRole = SecRole.findByAuthority('ROLE_FACEBOOK') ?: new SecRole(authority: 'ROLE_FACEBOOK').save(failOnError: true)
        def contestantRole = SecRole.findByAuthority('ROLE_CONTESTANT') ?: new SecRole(authority: 'ROLE_CONTESTANT').save(failOnError: true)


        def adminUser = User.findByUsername('juanda6') ?: new User(
                username: 'juanda6',
                password: 'farroyavefami',
                enabled: true,
                name : 'Juan David Arroyave Henao',
                email: 'juanda6@gmail.com',
                accountExpired: false,
                accountLocked: false,
                passwordExpired: false,
                telephone: "+573145599976",
                address: "Calle 7AA #30-244",
                birthdate: new Date(),
                latitude: 0L,
                longitude: 0L,
                city: 'Medellin',
                country: 'Colombia').save(failOnError: true)


        if (!adminUser.authorities.contains(adminRole)) {
            SecUserSecRole.create adminUser, adminRole
        }
    }
    def destroy = {
    }
}
