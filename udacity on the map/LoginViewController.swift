//
//  LoginViewController.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 14/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var feedbackMsgLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
    }

    @IBAction func loginPressed(_ sender: Any) {
        guard !usernameTextField.text!.isEmpty, !passwordTextField.text!.isEmpty else {
            feedbackMsgLabel.text = "Please provide username & password to login."
            return
        }
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        setUIEnabled(false)
        
        UdacityClient.sharedInstance().doLogin(username: username, password: password, completionHandler: completionHandler)
        
        setUIEnabled(true)
    }
    
    func completionHandler(success: Bool, error: String?) {
        if !success {
            DispatchQueue.main.async {
                self.displayError(error!)
            }
        } else {
            ParseClient.sharedInstance().loadLocations(completionHandler: {_,_ in
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "NavigationController")
                self.present(controller, animated: true)
            })
        }
    }
    
    func displayError(_ error: String) {
        setUIEnabled(true)
        feedbackMsgLabel.text = error
    }

}

private extension LoginViewController {
    func setUIEnabled(_ enabled: Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        feedbackMsgLabel.text = ""
        feedbackMsgLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func configureUI() {
        // configure background gradient
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [Constants.UI.LoginColorTop, Constants.UI.LoginColorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        loginButton.backgroundColor = UIColor(red:0.84, green:0.35, blue:0.00, alpha:1.0)
        
    }
}
