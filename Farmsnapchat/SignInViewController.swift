//
//  SignInViewController.swift
//  Farmsnapchat
//
//  Created by Nasir Uddin on 06/02/2017.
//  Copyright © 2017 Nasir Uddin. All rights reserved.
// This class deal with signin/turn up and registration

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!  
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   

    // signed in with email authenticated by firebase
    // within this function withemail and passward takes string
    // the completion takes the function, print signed in report
    
    @IBAction func turnUpTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!,password:passwordTextField.text!, completion: {(user,error) in //completion block in swift
            print("we tried to sign in")
            if error != nil {
                print("There is an error:\(String(describing: error))")
                
                // Creating account in Firebase
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {(user,error) in
                    print("We tried to create a user")
                    if error != nil {
                        print("There is an error: \(String(describing: error))")
                    } else{
                        print("Created User Successfully")
                        
                        // Here manage firebase database similar to key:value like a dictionary.
                        Database.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
                            
                        self.performSegue(withIdentifier: "signinsegue", sender: nil)
                    }
                })
            }else {
                print("Signed in Successfully")
                self.performSegue(withIdentifier: "signinsegue", sender: nil)
            }
        })
       
    }
}
