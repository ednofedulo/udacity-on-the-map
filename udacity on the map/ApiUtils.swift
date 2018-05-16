//
//  ApiUtils.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 14/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import Foundation
class ApiUtils {

    static func generatePostRequest(url: String!, body: Data!) -> URLRequest {
        var request = URLRequest(url: URL(string: url )!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = body
        return request
    }
    
    

}
