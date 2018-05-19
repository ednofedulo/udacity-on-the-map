//
//  UdacityClient.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 14/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient {
    // shared session
    var session = URLSession.shared
    
    var sessionId: String?
    
    var user: User?
    
    let baseURL = "https://www.udacity.com/api"
    
    func loadUserData(_ userId: String, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void )  {
               
        let request = URLRequest(url: URL(string: "\(self.baseURL)/users/\(userId)")!)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            let (errorMessage, newData) = ApiUtils.validate(data: data, response: response, error: error, udacity: true)
            
            guard errorMessage == nil else {
                completionHandler(false, errorMessage)
                return
            }
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
            } catch {
                completionHandler(false, ApiUtils.getErrorMessage(error: .application))
            }
            
            guard let user = parsedResult!["user"] as? [String:AnyObject],
            let firstName = user["first_name"] as? String,
            let lastName = user["last_name"] as? String else {
                completionHandler(false, ApiUtils.getErrorMessage(error: .application))
                return
            }
            
            self.user = User(firstName: firstName, lastName: lastName, id: userId)
            
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    func doLogout( completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void )  {
        
        var request = URLRequest(url: URL(string: "\(self.baseURL)/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            let (errorMessage, newData) = ApiUtils.validate(data: data, response: response, error: error, udacity: true)
            
            guard errorMessage == nil else {
                completionHandler(false, errorMessage)
                return
            }
            
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func doLogin(username: String, password: String, completionHandler: @escaping (_ userId: String?, _ error: String?) -> Void ) {
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let request = ApiUtils.generatePostRequest(url: "\(self.baseURL)/session", body: jsonBody)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            let (errorMessage, newData) = ApiUtils.validate(data: data, response: response, error: error, udacity: true)
            
            guard errorMessage == nil else {
                completionHandler(nil, errorMessage)
                return
            }
            
            guard let udacityResponse = try? JSONDecoder().decode(UdacityResponse.self, from: newData!) else {
                completionHandler(nil, ApiUtils.getErrorMessage(error: .application))
                return
            }
            
            self.sessionId = udacityResponse.session.id
            
            completionHandler(udacityResponse.account.key, nil)
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
