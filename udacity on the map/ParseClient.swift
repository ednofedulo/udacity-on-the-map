//
//  ParseClient.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 14/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import Foundation
import UIKit

class ParseClient {
    
    var studentsInformations: [StudentInformation]?
    var userInformation: StudentInformation?
    let session = URLSession.shared
    let baseURL = "https://parse.udacity.com/parse/classes"
    
    func generateRequest(_ url: String, method: String? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        
        if method != nil {
            request.httpMethod = method!
        } else if method == "POST", method == "PUT" {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        return request
    }
    
    func generateHttpBody(_ information: StudentInformation) -> Data {
        let json = "{\"uniqueKey\": \"\(information.uniqueKey!)\", \"firstName\": \"\(information.firstName!)\", \"lastName\": \"\(information.lastName!)\",\"mapString\": \"\(information.mapString!)\", \"mediaURL\": \"\(information.mediaURL!)\",\"latitude\": \(information.latitude!), \"longitude\": \(information.longitude!)}"
        
        return json.data(using: .utf8)!
    }
    
    func upsertUserLocation(_ information: StudentInformation, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        var URL = "\(baseURL)/StudentLocation"
        var httpMethod = "POST"
        if information.objectId != nil {
            URL += "/\(information.objectId!)"
            httpMethod = "PUT"
        }
        
        var request = generateRequest(URL, method: httpMethod)
        request.httpBody = generateHttpBody(information)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            let (errorMessage, newData) = ApiUtils.validate(data: data, response: response, error: error)
            
            guard errorMessage == nil else {
                completionHandler(false, errorMessage)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            guard (try? decoder.decode(StudentsInformationResponse.self, from: newData!)) != nil else {
                completionHandler(false, ApiUtils.getErrorMessage(error: .incorrectCredentials))
                return
            }
            
            completionHandler(true, nil)
        }
        task.resume()
        
    }
    
    func loadUserLocation(_ userId: String, completionHandler: @escaping (_ userInformation: StudentInformation?, _ error: String?) -> Void) {
        
        let params = "where={\"uniqueKey\":\"\(userId)\"}".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let request = generateRequest("\(self.baseURL)/StudentLocation?\(params!)")
        
        let task = session.dataTask(with: request) { data, response, error in
            
            let (errorMessage, newData) = ApiUtils.validate(data: data, response: response, error: error)
            
            guard errorMessage == nil else {
                completionHandler(nil, errorMessage)
                return
            } 
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            guard let parsedData = try? decoder.decode(StudentsInformationResponse.self, from: newData!) else {
                completionHandler(nil, ApiUtils.getErrorMessage(error: .incorrectCredentials))
                return
            }
            
            guard parsedData.results != nil, (parsedData.results?.count)! > 0 else {
                completionHandler(nil, nil)
                return
            }
            
            completionHandler(parsedData.results?[0], nil)
        }
        task.resume()
    }
    
    func loadLocations(completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void){
        
        let request = generateRequest("\(self.baseURL)/StudentLocation?limit=100&order=-updatedAt")
        
        let task = session.dataTask(with: request) { data, response, error in
            
            let (errorMessage, newData) = ApiUtils.validate(data: data, response: response, error: error)
            
            guard errorMessage == nil else {
                completionHandler(false, errorMessage)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            guard let parsedData = try? decoder.decode(StudentsInformationResponse.self, from: newData!) else {
                completionHandler(false, ApiUtils.getErrorMessage(error: .incorrectCredentials))
                return
            }
            
            SharedData.shared.studentsInformations = parsedData.results!
            
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
