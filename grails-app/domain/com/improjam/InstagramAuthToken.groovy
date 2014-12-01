package com.improjam

class InstagramAuthToken {
    static belongsTo = [user: User]
    String access_token
    String username
    Long userid
    String fullname
    String picture
    Boolean active
    Date dateCreated

    static mapping = {
        datasource "trans"
    }




    static constraints = {
    }
}
