//
//  StudentInformation.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 15/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import Foundation

struct StudentInformation:Decodable {
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: Date?
}

struct StudentsInformationResponse:Decodable {
    let results: [StudentInformation]?
}
