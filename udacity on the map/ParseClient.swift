//
//  ParseClient.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 14/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import Foundation

class ParseClient {
    
    var studentsInformations: [StudentInformation]?
    
    func generateRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        return request
    }
    
    func loadLocations(completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void){
        
        let request = generateRequest()
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completionHandler(false, "\(error!)")
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            
            guard (httpResponse?.statusCode)! > 199, (httpResponse?.statusCode)! < 300 else {
                completionHandler(false, "Request returned invalid status code")
                return
            }
            
            guard let data = data else {
                completionHandler(false, "No data returned")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            guard let parsedData = try? decoder.decode(StudentsInformationResponse.self, from: data) else {
                completionHandler(false, "error parsing data")
                return
            }
            
            self.studentsInformations = parsedData.results?.sorted(by: { $0.updatedAt! > $1.updatedAt! })
            
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
