//
//  BucketListTableViewController.swift
//  LambdaBucketList
//
//  Created by Michael Stoffer on 8/27/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class BucketListTableViewController: UITableViewController {
    
    @IBOutlet var createTripTextField: UITextField!
    var bucketListClient = BucketListClient()
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if bucketListClient.token == nil {
            performSegue(withIdentifier: "signInModalSegue", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bucketListClient.fetchLoggedInUser { (result) in
            if let user = try? result.get() {
                self.user = user.user
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return self.bucketListClient.completedItems.count > 0 ? "Completed Items" : ""
            default:
                return self.bucketListClient.notCompletedItems.count > 0 ? "Not Completed Items" : ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return self.bucketListClient.completedItems.count
            default:
                return self.bucketListClient.notCompletedItems.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as? TripTableViewCell else { return UITableViewCell() }

        let item = itemFor(indexPath: indexPath)
        cell.messageLabel.text = item.description
        cell.delegate = self
        
        let image = item.completed == true ? UIImage(named: "checked") : UIImage(named: "unchecked")
        cell.completedButton.setImage(image, for: .normal)

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemFor(indexPath: indexPath)
            self.bucketListClient.deleteItem(item)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    @IBAction func createTrip(_ sender: UITextField) {
        guard let message = self.createTripTextField.text,
            let user = self.user else { return }
        
        self.bucketListClient.createItem(withUserId: user.id, withDescription: message, withId: UUID())
        self.createTripTextField.text = nil
        self.tableView.reloadData()
//        self.bucketListClient.createItem(withUserId: user.id, withDescription: message, withId: UUID()) { (error) in
//            if let error = error {
//                NSLog("Error creating your Trip: \(error)")
//            }
//
//            DispatchQueue.main.async {
//                self.createTripTextField.text = nil
//                self.tableView.reloadData()
//            }
//        }
    }
    
    private func itemFor(indexPath: IndexPath) -> Item {
        if indexPath.section == 0 {
            return self.bucketListClient.completedItems[indexPath.row]
        } else {
            return self.bucketListClient.notCompletedItems[indexPath.row]
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signInModalSegue" {
            guard let loginVC = segue.destination as? SignInViewController else { return }
            loginVC.bucketListClient = self.bucketListClient
        }
    }
}

extension BucketListTableViewController: TripTableViewCellDelegate {
    func toggleCompleted(for cell: TripTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        
        let item = itemFor(indexPath: indexPath)
        self.bucketListClient.toggleItemCompletion(item)
        
        self.tableView.reloadData()
    }
}
