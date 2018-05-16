//
//  ViewController.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 14/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import UIKit

class BaseController: UIViewController {
    
    func configureNavBar(){
        let pinImage = UIImage(named: Constants.UI.PinIcon)
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(doRefresh))
        
        let pinButton = UIBarButtonItem(image: pinImage, style: .plain, target: self, action: #selector(doPlacePin))
        
        self.navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(doLogout))
    }
    
    @objc func doLogout(sender: UIBarButtonItem){
        print("logout pressed")
    }
    
    @objc func doRefresh(sender: UIBarButtonItem){
        print("refresh pressed")
    }
    
    @objc func doPlacePin(sender: UIBarButtonItem){
        print("place pin pressed")
    }

}

