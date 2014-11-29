package com.improjam

import com.mongodb.BasicDBObject
import grails.converters.JSON


class RegisterController extends grails.plugin.springsecurity.ui.RegisterController {
    // override default value from base class
    static defaultAction = 'index'

    // override default value from base class
    static allowedMethods = [register: 'POST']

    def mailService
    def messageSource
    def saltSource
    def utilityService
    def mongo

    def index() {
        def copy = [:] + (flash.chainedParams ?: [:])
        copy.remove 'controller'
        copy.remove 'action'
        [command: new RegisterCommand(copy)]
    }


    def register(RegisterCommand command) {

        if (command.hasErrors()) {
            render view: 'index', model: [command: command]
            return
        }
        def pass  = utilityService.generateUserPassword()

        def contestant = new Contestant(
                name: command.name,
                telephone: command.telephone,
                address: "NA",
                country: command.country,
                city: command.city,
                email: command.email,
                username: command.email,
                videourl: command.videourl,
                passwordExpired: false,
                password: pass,
                accountLocked: false,
                accountExpired: false,
                enabled: true
        )

        if(!contestant.save(failOnError: true,flush: true)){
            println contestant.errors.allErrors
            render view: 'index', model: [errors: "Hubo errores guardando el Participante: "+contestant.errors.allErrors]
            return
        }
        def contestantRole = SecRole.findByAuthority('ROLE_CONTESTANT') ?: new SecRole(authority: 'ROLE_CONTESTANT').save(failOnError: true)
        if (!contestant.authorities.contains(contestantRole)) {
            SecUserSecRole.create contestant, contestantRole
        }
        try {
            //save video to mongodb
            def db = mongo.getDB(grailsApplication.config.com.improjam.database)
            BasicDBObject query = new BasicDBObject().append("user" , contestant.id)
            def existing = db.videos.findOne(query)
            if(!!existing == false){
                def resultado = db.videos.insert("user" : contestant.id, "dateCreated" : new Date(), "lastUpdated" : new Date(),"url":command.videourl,"uploader":command.videoyoutuber,"title":command.videotitle)
            }
            else{
                BasicDBObject newfields = new BasicDBObject("user" : contestant.id)
                        .append("lastUpdated",new Date())
                BasicDBObject setObject = new BasicDBObject('$set' : newfields)
                def filas = db.videos.update(query,setObject)
            }
        }
        catch (Exception e){
            println e
        }


        sendMail {
            to command.email
            from "contacto@qtagtech.com"
            subject "¡Has sido seleccionado para que la gente vote por tu #IMPROJAM!"
            html '<h1>¡Felicitaciones '+command.name+'!</h1><p>Tu video: <h5>('+command.videotitle+')</h5> ha sido seleccionado y la gente podrá votar por él en la página del concurso de #IMPROJAM.</p><h4>Para acceder al sistema utiliza tu correo electrónico y la clave temporal: '+pass+'</h4>'
        }

        render view: 'index', model: [emailSent: true]
    }

}

class RegisterCommand {

    String name
    String email
    String country
    String city
    String telephone
    String videourl
    String videotitle
    String videoyoutuber

    def grailsApplication

    static constraints = {
        email blank: false,email: true, validator: { value, command ->
            if (value) {
                if (Contestant.findByEmail(value)) {
                    return 'El email registrado ya existe en la base de datos'
                }
            }
        }
        name blank: false
        country blank: false
        city blank: false
        telephone blank: false
        videourl blank: false
        videourl blank: false
        videoyoutuber blank: false
       // password blank: false, validator: RegisterController.passwordValidator
        //password2 validator: RegisterController.password2Validator
    }
}

class ResetPasswordCommand {
    String username
    String password
    String password2

    static constraints = {
        password blank: false, validator: RegisterController.passwordValidator
        password2 validator: RegisterController.password2Validator
    }
}
