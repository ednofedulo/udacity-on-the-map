//
//  User.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 15/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

struct UdacityResponse: Decodable {
    let account: UserAccount
    let session: UserSession
}

struct UserAccount: Decodable {
    let registered: Bool
    let key: String
}

struct UserSession: Decodable {
    let id: String
}

struct User {
    let firstName: String
    let lastName: String
    let id: String
}
