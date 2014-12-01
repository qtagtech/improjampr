package com.improjam

class YoutubeAuthToken {
    static belongsTo = [user: User]
    String access_token
    String type
    Integer expires_in
    Boolean active
    Date dateCreated

    static mapping = {
        datasource "trans"
    }




    static constraints = {
    }
}
