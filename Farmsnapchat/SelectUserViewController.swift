//
//  SelectUserViewController.swift
//  Farmsnapchat
//
//  Created by Nasir Uddin on 07/02/2017.
//  Copyright © 2017 Nasir Uddin. All rights reserved.
//
// this class show snaps email id into table view format
//push pull snaps email from firebase data base
// select/show user from table view showing recieved snaps

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class SelectUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    var imageURL = ""
    var descrip = ""
    var uuid = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // added new child/data in the firebase, firebase snapshot called
        Database.database().reference().child("users").observe(DataEventType.childAdded, with:{(snapshot) in
            print(snapshot)
            
            // key user uid, value email
            let user = User()
            user.email = (snapshot.value as! NSDictionary)["email"] as! String
            user.uid = snapshot.key
            self.users.append(user)
            //shos list of users in the table view
            self.tableView.reloadData()
            
            
            
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number will be number of users
        return users.count
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email
        return cell
    }
    // pushing/pulling snap object to firebase database as json/key-value formmat
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        let snap = ["from":Auth.auth().currentUser!.email!, "description":descrip, "imageURL":imageURL, "uuid":uuid]
        
        Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
        
        navigationController!.popToRootViewController(animated: true)
    }
}
