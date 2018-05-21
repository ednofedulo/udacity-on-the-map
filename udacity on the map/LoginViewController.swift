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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginPressed(_ sender: Any) {
        guard !usernameTextField.text!.isEmpty, !passwordTextField.text!.isEmpty else {
            feedbackMsgLabel.text = "Username & Password are required"
            return
        }
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        setUIEnabled(false)
        
        UdacityClient.sharedInstance().doLogin(username: username, password: password, completionHandler: completionHandler)
        
        setUIEnabled(true)
    }
    
    func completionHandler(userId: String?, error: String?) {
        if userId == nil {
            DispatchQueue.main.async {
                self.displayError(error!)
            }
            return
        }
            
        UdacityClient.sharedInstance().loadUserData(userId!, completionHandler: { (success, error) in
            if success {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "NavigationController")
                self.present(controller, animated: true)
            } else {
                DispatchQueue.main.async {
                    self.displayError("Error loading user data")
                }
            }
        })
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
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
}
