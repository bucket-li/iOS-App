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
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let blClient = self.bucketListClient else { return }
        
        if segue.identifier == "signUpSegue" {
            let signUpVC = segue.destination as? SignUpViewController
            signUpVC?.bucketListClient = blClient
        }
    }
 
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let bucketListClient = self.bucketListClient else { return }
        
        if let username = self.usernameTextField.text, !username.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty {
            
            //
            
//            bucketListClient.signIn(with: user) { (error) in
//                if let error = error {
//                    NSLog("Error occurred during sign in: \(error)")
//                } else {
//                    DispatchQueue.main.async {
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                }
//            }
        }
    }
    
    
    
    

}
