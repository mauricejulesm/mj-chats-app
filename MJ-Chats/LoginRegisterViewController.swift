//
//  LoginRegisterViewController.swift
//  MJ-Chats
//
//  Created by maurice on 7/13/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginRegisterViewController: UIViewController {
	
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		let tab: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginRegisterViewController.dismissKeyboard))
		view.addGestureRecognizer(tab)
		
		
	}
	
	// custome function to dismiss keyboard
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	@IBAction func loginClicked(_ sender: Any) {

		if !verifyUserInputs(){
			return
		}
		
		let email = emailField.text
		let password = passwordField.text
		
		Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
			if let error = error {
				
				Utilities().showAlert(title: "Error!", message: error.localizedDescription, vc:self)
				
				print("Error occured while signing in, check below:")
				print(error.localizedDescription)
				return
			}
			print("Awesome !, signed in successfully!")
		}
		
	}
	
	func verifyUserInputs() -> Bool {
		if (emailField.text?.count)! < 5 {
			emailField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
			Utilities().showAlert(title: "Error!", message: "Bad Email Format", vc:self)
			return false
		}else{
			emailField.backgroundColor = UIColor.white
		}
		
		// checking for password
		if (passwordField.text?.count)! < 5 {
			passwordField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
			Utilities().showAlert(title: "Error!", message: "Password must not be less than 6 chars", vc:self)
			return false
		}else{
			passwordField.backgroundColor = UIColor.white
			return true
		}
	}
	
	@IBAction func registerClicked(_ sender: Any) {
		if !verifyUserInputs(){
			return
		}
		
		let confirmAlert = UIAlertController(title: "Confirm", message: "Please confirm you password", preferredStyle: .alert)
		confirmAlert.addTextField { (textField) in
			textField.placeholder = "password"
		}
			confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
			confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
				(action) -> Void in
				let passConfirm = confirmAlert.textFields![0] as UITextField
				
				if (passConfirm.text!.isEqual(self.passwordField.text!)){
					
					//begin registration
					let email = self.emailField.text
					let password = self.emailField.text
					
					Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
						if let error = error {
							Utilities().showAlert(title: "Error", message: error.localizedDescription, vc: self)
							return
						}
						self.dismiss(animated: true, completion: nil)
					})
					
				}
				else{
					Utilities().showAlert(title: "Error", message: "Passwords do not match", vc: self)
				}
				
			}))
		
		self.present(confirmAlert, animated: true, completion: nil)
		
	}
	
	@IBAction func forgotPassClicked(_ sender: Any) {
		
		if (!emailField.text!.isEmpty) {
			let email = self.emailField.text
			
			Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
				if let error = error{
					Utilities().showAlert(title: "Error", message: error.localizedDescription, vc: self)
					return
				}else{
					Utilities().showAlert(title: "Success", message:"Reset instructions were sent to your email. Please check it.", vc: self)
				}
			}
		}else{
			Utilities().showAlert(title: "Error", message:"Please provide an email", vc: self)
		}
	}
	
}
