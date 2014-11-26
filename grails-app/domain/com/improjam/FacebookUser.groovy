package com.improjam

import com.improjam.SecUser

class FacebookUser {

    Long uid
    String accessToken
    Date accessTokenExpires

    static belongsTo = [user: User]

    static constraints = {
        uid unique: true
    }
    static mapping = {
        datasource "trans"
        autoTimestamp true
    }
}
