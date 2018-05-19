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
    
    static func getErrorMessage(error: ErrorEnum!) -> String{
        switch error {
        case .incorrectCredentials:
            return "Wrong login or password"
        case .network:
            return "Network error"
        case .application:
            return "Internal error"
        default:
            return "Unknown error"
        }
    }
    
    static func validate(data: Data?, response: URLResponse?, error: Error?, udacity: Bool! = false, parse: Bool! = false) -> (String?, Data?) {
        guard error == nil else {
            return (ApiUtils.getErrorMessage(error: .network), nil)
        }
        
        let httpResponse = response as? HTTPURLResponse
        
        guard (httpResponse?.statusCode)! > 199, (httpResponse?.statusCode)! < 300 else {
            print(String(data: data!, encoding: .utf8)!)
            return (ApiUtils.getErrorMessage(error: .incorrectCredentials), nil)
        }
        
        guard let data = data else {
            return (ApiUtils.getErrorMessage(error: .network), nil)
        }
        
        if udacity {
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            return (nil, newData)
        }
        
        return (nil, data)
    }
}
