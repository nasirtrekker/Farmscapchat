//
//  PictureViewController.swift
//  Farmsnapchat
//
//  Created by Nasir Uddin on 07/02/2017.
//  Copyright © 2017 Nasir Uddin. All rights reserved.
// Deals with camera and image uploading

import UIKit
import Firebase
import FirebaseStorage

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!    
    @IBOutlet weak var nextButton: UIButton!
    
    //create imagePicker variable
    var imagePicker = UIImagePickerController()
    var uuid = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        nextButton.isEnabled = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        //once picked image change the background color
        imageView.backgroundColor = UIColor.clear
        nextButton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // Camera function when it tapped
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary // set up from camera or photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated:true, completion: nil)
    }
    
    // Next button tapped function
    
    @IBAction func nextTapped(_ sender: Any) {
        
        nextButton.isEnabled = false
        
        //here adding things in firebase folder eg. images
        //we used NSUUID() for giving uniniq name of image for eachtime
        let imagesFolder = Storage.storage().reference().child("images")//put name of the firebasefolder
        //instead of png make it jpeg for faster uploading
        let imageData = UIImageJPEGRepresentation(imageView.image!,0.1)!
        // us the uuid for giving different id of the stored image everytime
        imagesFolder.child("\(uuid).jpg").putData(imageData, metadata: nil, completion: {(metadata, error) in
            print("We tried to upload!")
            if error != nil {
                print("We had an error:\(String(describing: error))")
            } else {
                
                // giving the printoout of the url in console
                print(metadata?.downloadURL() as Any)
                
                self.performSegue(withIdentifier: "selectUsersegue", sender: metadata!.downloadURL()!.absoluteString)
            }
        })    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC = segue.destination as! SelectUserViewController
        nextVC.imageURL = sender as! String
        nextVC.descrip = descriptionTextField.text!
        nextVC.uuid = uuid
    }
}
