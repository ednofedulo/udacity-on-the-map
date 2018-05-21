//
//  ViewController.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 14/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//
import UIKit

class BaseController: UIViewController {
    
    let udacityClient = UdacityClient.sharedInstance()
    let activityIndicator = ActivityIndicatorViewController()
    
    @IBAction func doPlacePin(_ sender: Any) {
        
        ParseClient.sharedInstance().loadUserLocation((udacityClient.user?.id)!) { (userLocation, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            
            if userLocation != nil {
                self.confirm(message: "You have already posted a Student Location. Would you like to overwrite your current location?", confirmButtonTitle: "Overwrite", completionHandler: { (_) in
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "chooseLocationView") as? PinViewController
                    
                    controller?.userLocation = userLocation
                    
                    self.present(controller!, animated: true)
                })
            } else {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "chooseLocationView") as? PinViewController
                let user = self.udacityClient.user!
                
                controller?.userLocation = StudentInformation(firstName: user.firstName, lastName: user.lastName, latitude: nil, longitude: nil, mapString: nil, mediaURL: nil, objectId: nil, uniqueKey: user.id, updatedAt: nil, createdAt: nil)
                
                self.present(controller!, animated: true)
            }   
        }
    }
    
    @IBAction func doLogout(_ sender: Any) {
        confirm(message: "Do you want do logout?", completionHandler: { (_) in
            
            self.udacityClient.doLogout(completionHandler: { (success, error) in
                if success {
                    ParseClient.sharedInstance().studentsInformations = nil
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAlert(message: "Unable to logout from server", title: "Error")
                }
            })
            
        })
    }
    
    func startActivityIndicator() {
        
        
        // add the spinner view controller
        addChildViewController(activityIndicator)
        activityIndicator.view.frame = view.frame
        view.addSubview(activityIndicator.view)
        activityIndicator.didMove(toParentViewController: self)
        
        // wait two seconds to simulate some work happening
        
    }
    
    func dismissActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.willMove(toParentViewController: nil)
            self.activityIndicator.view.removeFromSuperview()
            self.activityIndicator.removeFromParentViewController()
        }
    }
    
    func showAlert(message: String, title: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) in
                alertController.dismiss(animated: true, completion: nil)
            })
            
            self.present(alertController, animated: true, completion: nil)
        }
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

