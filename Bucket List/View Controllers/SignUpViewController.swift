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
    
    var bucketListClient: BucketListClient?
    
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
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let blClient = self.bucketListClient,
            let name = self.nameTextField.text, !name.isEmpty,
            let email = self.emailAddressTextField.text, !email.isEmpty,
            let password = self.newPasswordTextField.text, !password.isEmpty else { return }
        
        let newUser = blClient.createUser(withName: name, withEmail: email, withPassword: password)
        blClient.register(with: newUser, completion: { (error) in
            if let error = error {
                NSLog("Error registering user: \(error)")
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message: "Error registering user: \(error)", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true)
                }
                
                return
            }
        })
    }
    
}
