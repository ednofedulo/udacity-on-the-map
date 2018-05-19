//
//  StudentInformation.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 15/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import Foundation

struct StudentInformation:Decodable {
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: Date?
    var createdAt: Date?
}

struct StudentsInformationResponse:Decodable {
    var results: [StudentInformation]?
}
