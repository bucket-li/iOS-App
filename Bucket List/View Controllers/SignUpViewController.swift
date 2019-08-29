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
    @IBOutlet var registerButton: UIButton!
    
    var bucketListClient: BucketListClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearances()
        // Do any additional setup after loading the view.
    }
    
    private func setupAppearances() {
        self.nameTextField.font = AppearanceHelper.SourceSansProFont(with: .body, pointSize: 17)
        self.emailAddressTextField.font = AppearanceHelper.SourceSansProFont(with: .body, pointSize: 17)
        self.newPasswordTextField.font = AppearanceHelper.SourceSansProFont(with: .body, pointSize: 17)
        self.confirmPasswordTextField.font = AppearanceHelper.SourceSansProFont(with: .body, pointSize: 17)
        
        let emailBorder = CALayer()
        let emailWidth = CGFloat(1.0)
        emailBorder.borderColor = UIColor.darkGray.cgColor
        emailBorder.frame = CGRect(x: 0, y: self.emailAddressTextField.frame.size.height - emailWidth, width:  self.emailAddressTextField.frame.size.width, height: self.emailAddressTextField.frame.size.height)
        emailBorder.borderWidth = emailWidth
        self.emailAddressTextField.layer.addSublayer(emailBorder)
        self.emailAddressTextField.layer.masksToBounds = true
        
        let nameBorder = CALayer()
        let nameWidth = CGFloat(1.0)
        nameBorder.borderColor = UIColor.darkGray.cgColor
        nameBorder.frame = CGRect(x: 0, y: self.nameTextField.frame.size.height - nameWidth, width:  self.nameTextField.frame.size.width, height: self.nameTextField.frame.size.height)
        nameBorder.borderWidth = nameWidth
        self.nameTextField.layer.addSublayer(nameBorder)
        self.nameTextField.layer.masksToBounds = true
        
        let passwordBorder = CALayer()
        let passwordWidth = CGFloat(1.0)
        passwordBorder.borderColor = UIColor.darkGray.cgColor
        passwordBorder.frame = CGRect(x: 0, y: self.newPasswordTextField.frame.size.height - passwordWidth, width:  self.newPasswordTextField.frame.size.width, height: self.newPasswordTextField.frame.size.height)
        passwordBorder.borderWidth = passwordWidth
        self.newPasswordTextField.layer.addSublayer(passwordBorder)
        self.newPasswordTextField.layer.masksToBounds = true
        
        let confirmBorder = CALayer()
        let confirmWidth = CGFloat(1.0)
        confirmBorder.borderColor = UIColor.darkGray.cgColor
        confirmBorder.frame = CGRect(x: 0, y: self.confirmPasswordTextField.frame.size.height - confirmWidth, width:  self.confirmPasswordTextField.frame.size.width, height: self.confirmPasswordTextField.frame.size.height)
        confirmBorder.borderWidth = confirmWidth
        self.confirmPasswordTextField.layer.addSublayer(confirmBorder)
        self.confirmPasswordTextField.layer.masksToBounds = true
        
        self.emailAddressTextField.backgroundColor = .clear
        self.nameTextField.backgroundColor = .clear
        self.newPasswordTextField.backgroundColor = .clear
        self.confirmPasswordTextField.backgroundColor = .clear
        
        self.emailAddressTextField.textColor = .darkGray
        self.nameTextField.textColor = .darkGray
        self.newPasswordTextField.textColor = .darkGray
        self.confirmPasswordTextField.textColor = .darkGray
        
        self.emailAddressTextField.keyboardAppearance = .dark
        self.nameTextField.keyboardAppearance = .dark
        self.newPasswordTextField.keyboardAppearance = .dark
        self.confirmPasswordTextField.keyboardAppearance = .dark
        
        self.registerButton.layer.cornerRadius = 5
    }
    
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
