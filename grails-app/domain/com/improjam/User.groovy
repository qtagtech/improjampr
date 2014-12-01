package com.improjam

class User extends SecUser {

    static hasMany = [ytAccessTokens: YoutubeAuthToken,twAccessTokens: TwitterAuthToken]

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
    String ytRefreshToken = ""


    static constraints = {
    }

    static mapping = {
        datasource "trans"
    }
}
