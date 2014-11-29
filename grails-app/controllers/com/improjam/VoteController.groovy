package com.improjam

import com.mongodb.BasicDBObject

class VoteController {
    def mongo

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
        [ronda1:ronda1,ronda2:ronda2,ronda3:ronda3,fechas1:fechas1,fechas2:fechas2,fechas3:fechas3]
    }
}
