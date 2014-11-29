package com.improjam

import com.mongodb.BasicDBObject
import grails.converters.JSON
import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter

import java.text.SimpleDateFormat

class AdminController {
    def mongo

    def index() {
        def db = mongo.getDB(grailsApplication.config.com.improjam.database)
        def videos = db.videos.find()
        def videoList = []
        while(videos.hasNext()){
            def actual = videos.next()
            def cont = Contestant.findById(actual.user as Long)
            if(cont){
                videoList.add([user: cont,video:actual])
            }

        }
        BasicDBObject query = new BasicDBObject().append("round",1)
        def results = db.fixtures.find(query)
        def ronda1 = false
        def ronda2 = false
        def ronda3 = false
        def fechas1 = [:]
        def fechas2 = [:]
        def fechas3 = [:]
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");
        if(results){
            ronda1 = true
            def obj = results?.next()
            //def initDate = obj?.initDate ? dtf.parseDateTime(obj.initDate).toDate() : new Date()
            //def endDate = obj?.endDate ? dtf.parseDateTime(obj.endDate).toDate() : new Date()
            fechas1['startDate'] = obj?.initDate
            fechas1['endDate'] = obj?.endDate
        }

        [videos:videoList, ronda1: ronda1, ronda2: ronda2, ronda3: ronda3,fechas1:fechas1,fechas2:fechas2,fechas3:fechas3]
    }

    def generateFixtures(){
        //def dates = magicDates(params)
        if(!!params.ronda1_video_0 == true){//está enviando parametros de ronda 1
            def vids = []
            def vid1 = params.ronda1_video_0
            def vid2 = params.ronda1_video_1
            def vid3 = params.ronda1_video_2
            def vid4 = params.ronda1_video_3
            def vid5 = params.ronda1_video_4
            def vid6 = params.ronda1_video_5
            def vid7 = params.ronda1_video_6
            def vid8 = params.ronda1_video_7
            def vid9 = params.ronda1_video_8
            def vid10 = params.ronda1_video_9
            def vid11 = params.ronda1_video_10
            def vid12 = params.ronda1_video_1
            def vid13 = params.ronda1_video_12
            def vid14 = params.ronda1_video_13
            def vid15 = params.ronda1_video_14
            def vid16 = params.ronda1_video_15
            /*if(!!vid1 == false || !!vid2 == false || !!vid3 == false || !!vid4 == false || !!vid5 == false || !!vid6 == false || !!vid7 == false ||
                    !!vid8 == false || !!vid9 == false || !!vid10 == false || !!vid11 == false || !!vid12 == false || !!vid13 == false || !!vid14 == false || !!vid15 == false){
                response.setStatus(200)
                def result = ["status": 0, "message": "ERROR: Faltan videos por configurar para la primera ronda. Deben ser 16."]
                render result as JSON
                return
            }*/
            vids.add(vid1)
            vids.add(vid2)
            vids.add(vid3)
            vids.add(vid4)
            vids.add(vid5)
            vids.add(vid6)
            vids.add(vid7)
            vids.add(vid8)
            vids.add(vid9)
            vids.add(vid10)
            vids.add(vid11)
            vids.add(vid12)
            vids.add(vid13)
            vids.add(vid14)
            vids.add(vid15)
            vids.add(vid16)
            def db = mongo.getDB(grailsApplication.config.com.improjam.database)
            BasicDBObject query = new BasicDBObject().append("round",1)
            def results = db.fixtures.find(query)
            if(results){
                response.setStatus(200)
                def result = ["status": 0, "message": "ATENCIÓN: La Ronda 1 ya había sido configurada y guardada con anterioridad."]
                render result as JSON
                return
            }
            DateTimeFormatter formatter = DateTimeFormat.forPattern("MM/dd/yyyy HH:mm:ss")
            DateTime startDate = formatter.parseDateTime(params.startDate as String)
            DateTime endDate = formatter.parseDateTime(params.endDate as String)
            def i = 0

            while(i < 15) {
                BasicDBObject fixtt = new BasicDBObject().append("video_1", vids.get(i))
                        .append("round",1)
                        .append("video_2", vids.get(i + 1))
                        .append("dateCreated", new Date())
                        .append("lastUpdated", new Date())
                        .append("initDate", startDate.toDate())
                        .append("endDate", endDate.toDate())
                db.fixtures.insert(fixtt)
                i += 2
            }

        }
        response.setStatus(200)
        def result = ["status": 1, "message": "¡ÉXITO!: Ronda 1 Configurada satisfactoriamente."]
        render result as JSON
        return
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
                println "en rango de fechas"
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
                println start
                println end
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
        println "fechas"
        println startDate
        println endDate
        DateTime sDt = new DateTime(startDate)
        DateTime eDt = new DateTime(endDate)
        def res = [startDate: startDate,endDate:endDate]
        return res
    }
}
