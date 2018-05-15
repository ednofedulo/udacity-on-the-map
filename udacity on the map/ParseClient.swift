//
//  ParseClient.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 14/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import Foundation



struct Pin:Decodable {
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
}

struct ParseResult:Decodable {
    let results: [Pin]
}

class ParseClient {
    
    var pins: [Pin]?
    
    func loadLocations(completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void){
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
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
            
            guard let parseResult = try? JSONDecoder().decode(ParseResult.self, from: data) else {
                completionHandler(false, "error parsing data")
                return
            }
            self.pins = parseResult.results
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
