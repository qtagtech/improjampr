dataSource {
    pooled = true
    driverClassName = "org.h2.Driver"
    username = "sa"
    password = ""
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory'
}
// environment specific settings
environments {
    development {
        dataSource_trans {
            dbCreate = "update"
            driverClassName = "org.postgresql.Driver"
            dialect = "org.hibernate.dialect.PostgreSQLDialect"
            host = System.env.OPENSHIFT_POSTGRESQL_DB_HOST
            port = System.env.OPENSHIFT_POSTGRESQL_DB_PORT
            url = "jdbc:postgresql://"+host+":"+port+"/"+System.env.OPENSHIFT_APP_NAME
            username = System.env.OPENSHIFT_POSTGRESQL_DB_USERNAME
            password = System.env.OPENSHIFT_POSTGRESQL_DB_PASSWORD
/*
            dbCreate = "update"
            driverClassName = "org.postgresql.Driver"
            dialect = "org.hibernate.dialect.PostgreSQLDialect"
            url = "jdbc:postgresql://localhost:5432/improjam"
            username = "postgres"
            password = "qtagtech"*/
        }


            grails {
                mongo {
                    //mongodb://<user>:<password>@c1088.candidate.18.mongolayer.com:11088,c1049.candidate.20.mongolayer.com:11049/improjam?replicaSet=set-5525c0b4390d2196d9000123
                    host = "c1088.candidate.18.mongolayer.com"
                    port = 11088
                    username = "improjam"
                    password="NickyQtag1!.."
                    databaseName = "improjam"
                    /*host = "localhost"
                    port = 27017
                    username = ""
                    password=""
                    databaseName = "improjam"*/
                }
            }

    }

    production {
        grails {
            mongo {
                host = "ds061170-a0.mongolab.com"
                port = 61170
                username = "improjam"
                password="nickyQtag"
                databaseName = "improjam"
            }
        }
        dataSource_trans {
            dbCreate = "update"
            driverClassName = "org.postgresql.Driver"
            dialect = "org.hibernate.dialect.PostgreSQLDialect"
            host = System.env.OPENSHIFT_POSTGRESQL_DB_HOST
            port = System.env.OPENSHIFT_POSTGRESQL_DB_PORT
            url = "jdbc:postgresql://"+host+":"+port+"/"+System.env.OPENSHIFT_APP_NAME
            username = System.env.OPENSHIFT_POSTGRESQL_DB_USERNAME
            password = System.env.OPENSHIFT_POSTGRESQL_DB_PASSWORD
        }
    }
}

