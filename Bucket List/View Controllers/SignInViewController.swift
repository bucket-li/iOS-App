//
//  SignInViewController.swift
//  Bucket List
//
//  Created by Bobby Keffury on 8/22/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    var bucketListClient: BucketListClient?
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearances()
        // Do any additional setup after loading the view.
    }
    
    private func setupAppearances() {
        self.emailTextField.font = AppearanceHelper.SourceSansProFont(with: .body, pointSize: 17)
        self.passwordTextField.font = AppearanceHelper.SourceSansProFont(with: .body, pointSize: 17)
        
        let emailBorder = CALayer()
        let emailWidth = CGFloat(1.0)
        emailBorder.borderColor = UIColor.darkGray.cgColor
        emailBorder.frame = CGRect(x: 0, y: self.emailTextField.frame.size.height - emailWidth, width:  self.emailTextField.frame.size.width, height: self.emailTextField.frame.size.height)
        emailBorder.borderWidth = emailWidth
        self.emailTextField.layer.addSublayer(emailBorder)
        self.emailTextField.layer.masksToBounds = true
        
        let passwordBorder = CALayer()
        let passwordWidth = CGFloat(1.0)
        passwordBorder.borderColor = UIColor.darkGray.cgColor
        passwordBorder.frame = CGRect(x: 0, y: self.passwordTextField.frame.size.height - passwordWidth, width:  self.passwordTextField.frame.size.width, height: self.passwordTextField.frame.size.height)
        passwordBorder.borderWidth = passwordWidth
        self.passwordTextField.layer.addSublayer(passwordBorder)
        self.passwordTextField.layer.masksToBounds = true
                
        self.emailTextField.backgroundColor = .clear
        self.passwordTextField.backgroundColor = .clear
        
        self.emailTextField.textColor = .darkGray
        self.passwordTextField.textColor = .darkGray
                
        self.emailTextField.keyboardAppearance = .dark
        self.passwordTextField.keyboardAppearance = .dark
        
        self.registerButton.layer.borderColor = UIColor.darkGray.cgColor
        self.registerButton.layer.borderWidth = 1
        
        self.signInButton.layer.cornerRadius = 5
        self.registerButton.layer.cornerRadius = 5
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let blClient = self.bucketListClient else { return }
        
        if segue.identifier == "signUpSegue" {
            guard let signUpVC = segue.destination as? SignUpViewController else { return }
            signUpVC.bucketListClient = blClient
        }
    }
 
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let blClient = self.bucketListClient else { return }
        
        if let email = self.emailTextField.text, !email.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty {
            
            blClient.login(withEmail: email, withPassword: password) { (error) in
                if let error = error {
                    NSLog("Error occurred during sign in: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
