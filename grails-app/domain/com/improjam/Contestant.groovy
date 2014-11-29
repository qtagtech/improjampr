package com.improjam

class Contestant extends SecUser {

    String name
    String email
    String telephone
    String address
    String city
    String country
    String videourl


    static constraints = {
    }

    static mapping = {
        datasource "trans"
    }
}
