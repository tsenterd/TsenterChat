//
//  LoginController+handlers.swift
//  Chat
//
//  Created by Tsenter, David on 7/30/16.
//  Copyright © 2016 Tsenter, David. All rights reserved.
//

import UIKit
import Firebase
extension LoginController :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func changeImage(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImage:UIImage?
        if let editedImage = info ["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImage = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"]as? UIImage {
            selectedImage = originalImage
        }
        if let selectedImg = selectedImage{
            profileImageView.image = selectedImg
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    func handleLoginRegister(){
        if loginRegisterSegControl.selectedSegmentIndex == 0{
            handleLogin()
        }
        else{
            handleRegister()
        }
    }
    func displayError(err:String){
        var mssg = String(err).characters.split("\"").map(String.init)
        let alert = UIAlertController(title: "Error", message: mssg[1], preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }
    func handleLogin(){
        guard let email = emailTextField.text,password = passwordTextField.text else{
            print ("Form Not Valid")
            return
        }
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                self.displayError(String(error))
                print (error)
                return
            }
            //successful login
            
            
            self.messagesController?.fetchUserAndUpdateTitle()
            
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
    
    func handleRegister(){
        guard let email = emailTextField.text,password = passwordTextField.text,name = nameTextField.text else{
            print ("Form Not Valid")
            return
        }
        if (name == "David Tsenter (Creator)"){
            let alert = UIAlertController(title: "Error", message: "Only David Tsenter can have that name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return

        }
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: {(user:FIRUser?,error) in
            if error != nil {
                self.displayError(String(error))
                print (error)
                return
            }
            guard let uid = user?.uid else{return}
            //successfully authenticated user
            let imageName = NSUUID().UUIDString
            let storageRef = FIRStorage.storage().reference().child("profileImages").child("\(imageName).jpg")
            if let profileImageView = self.profileImageView.image, uploadData = UIImageJPEGRepresentation(profileImageView, 0.1){
    
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                    if err != nil{
                        self.displayError(String(error))
                        print(err)
                        return
                    }
                    if let imgURL = metadata?.downloadURL()?.absoluteString{
                     let values = ["name":name, "email": email, "profileImageUrl": imgURL]
                    self.registerUser(uid, values: values)

                    }
                   
                    
                })
            

            }
            
    
            
            
        })
    }
    private func registerUser(uid: String, values: [String:AnyObject]){
        let ref = FIRDatabase.database().reference()
        let usersRef = ref.child("users").child(uid)
        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                self.displayError(String(err))
                print (err)
                return
            }
            
            //self.messagesController?.navigationItem.title = values["name"] as? String
            let user =  User()
            user.setValuesForKeysWithDictionary(values)
            self.messagesController?.setupNavBarWithUser(user)
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })
    }
}

