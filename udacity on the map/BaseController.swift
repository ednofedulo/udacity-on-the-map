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
        confirm(message: "Do you want do logout?", completionHandler: { (_) in
            ParseClient.sharedInstance().studentsInformations = nil
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func doRefresh(sender: UIBarButtonItem){
        print("refresh pressed")
    }
    
    @objc func doPlacePin(sender: UIBarButtonItem){
        performSegue(withIdentifier: "createPinSegue", sender: self)
    }
    
    func showAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func confirm(message: String, confirmButtonTitle: String = "OK", completionHandler: @escaping ((UIAlertAction) -> Void)) {
        let alertController = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(UIAlertAction(title: confirmButtonTitle, style: .default, handler: completionHandler))
        
        self.present(alertController, animated: true, completion: nil)
    }

}

