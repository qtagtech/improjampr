package com.improjam

class User extends SecUser {

    String name
    String email
    String telephone
    String address
    Date birthdate
    Long latitude
    Long longitude
    String city
    String country
    BigInteger uid = 0
    String accessToken = ""


    static constraints = {
    }

    static mapping = {
        datasource "trans"
    }
}
