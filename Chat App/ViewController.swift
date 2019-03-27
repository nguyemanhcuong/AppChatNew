//
//  ViewController.swift
//  Chat App
//
//  Created by cuongDeptrai on 3/21/19.
//  Copyright © 2019 cuongDeptrai. All rights reserved.

import UIKit
import Firebase
class ViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout, UITextFieldDelegate  {
    
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool {  //delegate method
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.colectionView.dequeueReusableCell(withReuseIdentifier: "fromCell", for: indexPath) as! FromCell
        if (indexPath.row == 0 ) { // Sign In Cell
            cell.usernameContainer.isHidden = true
            cell.actionButton.setTitle("Login", for: .normal)
            cell.siderButton.setTitle(" Sign Up ☝️", for: .normal)
            cell.siderButton.addTarget(self, action: #selector(slideToSignInCell(_:)), for: .touchUpInside)
            
              cell.actionButton.addTarget(self, action: #selector(didPressSignIn(_:)), for: .touchUpInside)
            
        } else  if (indexPath.row == 1 ) { // Sign up Cell
            cell.usernameContainer.isHidden = false
            cell.actionButton.setTitle("Sign Up", for: .normal)
            cell.siderButton.setTitle(" 👈 Sign in ", for: .normal)
            cell.siderButton.addTarget(self, action: #selector(slideToSignUpCell(_:)), for: .touchUpInside)
            
            
            cell.actionButton.addTarget(self, action: #selector(didPressSignUp(_:)), for: .touchUpInside)
        }
        return cell
    }

    
    @objc func didPressSignIn(_ sender: UIButton){
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.colectionView.cellForItem(at: indexPath) as! FromCell
        guard let emailAddress = cell.emailAdressFiled.text, let password = cell.passwordTextFiled.text else {
            return
        }
        
        if(emailAddress.isEmpty == true || password.isEmpty == true){
            self.displayError(errorText: "Please fill empty fields")
            
        } else {
            Auth.auth().signIn(withEmail: emailAddress, password: password) { (result, error) in
                if(error == nil){
                    
                   self.dismiss(animated: true, completion: nil)
                    print(result?.user)
                    
                    print("I love you")
                    
                } else {
                    
                    self.displayError(errorText: "Wrong username or password")
                }
            }
        }
    }
    
    @objc func didPressSignUp(_ sender: UIButton) {
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = self.colectionView.cellForItem(at: indexPath) as! FromCell
        guard let emailAddress = cell.emailAdressFiled.text, let password = cell.passwordTextFiled.text else {
            return
        }
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in
            if(error == nil){
                guard let userId = result?.user.uid, let userName = cell.userNameTextFiled.text else {
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
                
                let reference = Database.database().reference()
                let user = reference.child("users").child(userId)
                let dataArray:[String: Any] = ["username": userName]
                user.setValue(dataArray)
            }
        }
    }
    
    
    
    
    @objc func slideToSignInCell(_ sender: UIButton) {
        let indexPath = IndexPath(row: 1, section: 0)
        self.colectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    
    @objc func slideToSignUpCell(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        self.colectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }

    func displayError(errorText: String){
        let alert = UIAlertController.init(title: "Error", message: errorText, preferredStyle: .alert)
        
        let dismissButton = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        
        alert.addAction(dismissButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBOutlet var colectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colectionView.delegate = self
        self.colectionView.dataSource = self
        
        let reference = Database.database().reference()
        let rooms = reference.child("roomsTest")
        rooms.setValue("hello Wrold!")
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }

}

