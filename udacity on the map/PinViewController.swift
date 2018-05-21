//
//  PinViewController.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 17/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import UIKit
import MapKit

class PinViewController: BaseController, MKMapViewDelegate {

    var userLocation: StudentInformation?
    
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var urlText: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if locationText != nil {
            locationText.delegate = self
        }
        
        if urlText != nil {
            urlText.delegate = self
        }
        
        if userLocation?.latitude != nil, userLocation?.longitude != nil, mapView != nil {
            setMapLocation(location: CLLocationCoordinate2D(latitude: (userLocation?.latitude)!, longitude: (userLocation?.longitude)!))
        }
        
    }
    
    func setMapLocation(location: CLLocationCoordinate2D!) {
        let pointAnnotation = MKPointAnnotation()
        
        pointAnnotation.title = userLocation?.mapString
        pointAnnotation.coordinate = location
        
        let region = MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.01, 0.01))
        
       DispatchQueue.main.async {
            self.mapView.addAnnotation(pointAnnotation)
            self.mapView.setRegion(region, animated: true)
            self.mapView.regionThatFits(region)
        }
    }

    @IBAction func SavePin(_ sender: Any) {
        guard urlText.text != "" else {
            showAlert(message: "Please insert some link", title: "Error")
            return
        }
        
        var url = urlText.text
        
        if !((url?.hasPrefix("http://"))! || (url?.hasPrefix("https://"))!) {
            url = "http://" + url!
        }
        
        guard UIApplication.shared.canOpenURL(URL(string: url!)!) else {
            showAlert(message: "Please insert a valid link", title: "Error")
            return
        }
        
        self.userLocation?.mediaURL = url
        
        startActivityIndicator()
        ParseClient.sharedInstance().upsertUserLocation(self.userLocation!) { (success, error) in
            self.dismissActivityIndicator()
            if success {
                
                self.showAlert(message: "Location Updated", title: "Success")
                
                self.dismiss(animated: true, completion: nil)
            } else {
                
                self.showAlert(message: "Error while updating user location, try again", title: "Error")
                
            }
        }
        
    }
    
    @IBAction func findLocation(_ sender: Any) {
        guard let txtLocation = locationText.text, locationText.text != "" else {
            showAlert(message: "please insert location", title: "error")
            return
        }
        startActivityIndicator()
        CLGeocoder().geocodeAddressString(txtLocation) { (placemark, error) in
            self.dismissActivityIndicator()
            guard error == nil else {
                
                    self.showAlert(message: "Unable to find location", title: "Error")
                
                return
            }
            
            weak var tempController = self.presentingViewController
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "enterLinkView") as! PinViewController
            
            controller.userLocation = self.userLocation
            controller.userLocation?.mapString = txtLocation
            controller.userLocation?.latitude = placemark!.first!.location!.coordinate.latitude
            controller.userLocation?.longitude = placemark!.first!.location!.coordinate.longitude
            
            self.dismiss(animated: true, completion: {
                tempController!.present(controller, animated: true)
            })
            
        }
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension PinViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }
}
