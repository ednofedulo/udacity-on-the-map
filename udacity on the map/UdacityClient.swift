//
//  UdacityClient.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 14/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import Foundation

struct UdacityResponse: Decodable {
    let account: UdacityAccount
    let session: UdacitySession
}

struct UdacityAccount: Decodable {
    let registered: Bool
    let key: String
}

struct UdacitySession: Decodable {
    let id: String
}

class UdacityClient {
    // shared session
    var session = URLSession.shared
    
    var sessionId: String?
    var userId: String?
    
    
    
    func doLogin(username: String, password: String, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void ) {
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let request = ApiUtils.generatePostRequest(url: Constants.AuthorizationUrl, body: jsonBody)
        
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
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            guard let udacityResponse = try? JSONDecoder().decode(UdacityResponse.self, from: newData) else {
                completionHandler(false, "error parsing data")
                return
            }
            
            self.sessionId = udacityResponse.session.id
            self.userId = udacityResponse.account.key
            
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
