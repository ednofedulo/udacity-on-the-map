//
//  ActivityIndicatorViewController.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 21/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicatorViewController: UIViewController {
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
