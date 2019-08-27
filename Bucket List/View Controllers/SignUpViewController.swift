//
//  SignUpViewController.swift
//  Bucket List
//
//  Created by Bobby Keffury on 8/22/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var bucketListClient: BucketListClient?
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let blClient = self.bucketListClient,
            let name = self.nameTextField.text, !name.isEmpty,
            let email = self.emailAddressTextField.text, !email.isEmpty,
            let password = self.newPasswordTextField.text, !password.isEmpty,
            let confirmPassword = self.confirmPasswordTextField.text, !confirmPassword.isEmpty else { return }
        
        if password != confirmPassword {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            }
        }
        
        blClient.register(withName: name, withEmail: email, withPassword: password, completion: { (error) in
            if let error = error {
                NSLog("Error registering user: \(error)")
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message: "Error registering user: \(error)", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true)
                }
                
                return
            } else {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        })
    }
    
}
