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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let bucketListClient = self.bucketListClient else { return }
        
        if let username = self.usernameTextField.text, !username.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty {
            let user = User(username: username, password: password)
            bucketListClient.signIn(with: user) { (error) in
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
