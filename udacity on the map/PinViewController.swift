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

    var coordinate: CLLocationCoordinate2D?
    var foundLocation: String?
    
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var urlText: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if coordinate != nil {
            setMapLocation(location: coordinate)
        }
        // Do any additional setup after loading the view.
    }
    
    func setMapLocation(location: CLLocationCoordinate2D!) {
        let pointAnnotation = MKPointAnnotation()
        
        pointAnnotation.title = self.foundLocation
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
        
        
    }
    
    @IBAction func findLocation(_ sender: Any) {
        guard let txtLocation = locationText.text, locationText.text != "" else {
            showAlert(message: "please insert location", title: "error")
            return
        }
        
        CLGeocoder().geocodeAddressString(txtLocation) { (placemark, error) in
            
            guard error == nil else {
                print("error getting location")
                return
            }
            
            weak var tempController = self.presentingViewController
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "enterLinkView") as! PinViewController
            
            controller.coordinate = placemark!.first!.location!.coordinate
            controller.foundLocation = txtLocation
            
            self.dismiss(animated: true, completion: {
                tempController!.present(controller, animated: true)
            })
            
        }
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
