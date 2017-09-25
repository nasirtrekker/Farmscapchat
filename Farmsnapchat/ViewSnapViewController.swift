//
//  ViewSnapViewController.swift
//  Farmsnapchat
//
//  Created by Nasir Uddin on 08/02/2017.
//  Copyright © 2017 Nasir Uddin. All rights reserved.
//This class will receive/show the snap pic

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class ViewSnapViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var snap = Snap()
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imageURL))
        
    }
    // View disappearing function if someone click backbutton
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("snaps").child(snap.key).removeValue()
        // delete picture from firebase storage
        Storage.storage().reference().child("images").child("\(snap.uuid).jpg").delete { (error) in
            print("we deleted the pic")
        }
    }
    
}
