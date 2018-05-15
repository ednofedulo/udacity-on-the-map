//
//  MapViewController.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 14/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseClient.sharedInstance().loadLocations(completionHandler: completionHandler)
        // Do any additional setup after loading the view.
    }
    
    func populateMap() {
        
        var annotations = [MKPointAnnotation]()
        
        for pin in ParseClient.sharedInstance().pins!{
            if pin.longitude == nil, pin.latitude == nil {
                continue
            }
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(pin.latitude!)
            let long = CLLocationDegrees(pin.longitude!)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = pin.firstName!
            let last = pin.lastName!
            let mediaURL = pin.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    func completionHandler(_ success: Bool, _ error: String?) {
        if success {
            DispatchQueue.main.async {
                self.populateMap()
            }
        } else {
            print(error!)
        }
    }

}
