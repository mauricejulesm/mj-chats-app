//
//  ViewController.swift
//  MJ-Chats
//
//  Created by maurice on 7/12/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
	
	var messages:[DataSnapshot] = [DataSnapshot]()
	
	var ref:DatabaseReference!
	private var _refHandle:DatabaseHandle!
	
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var textField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		
		//setting the tableview delegate
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.textField.delegate = self
		
		configureDatabase()
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
	}
	
	// stop listerning fro keyboard hide/show events
	deinit {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		
		// removing database observers
		self.ref.child("messages").removeObserver(withHandle: _refHandle)
		
	}
	
	
	@objc func keyboardWillChange(notification: Notification) {
		guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
			return
		}
		
		if (notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification) {
			
			view.frame.origin.y = -keyboardRect.height
		}else{
			view.frame.origin.y = 0
		}
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		// cheking the current user
		
		if (Auth.auth().currentUser == nil) {
			let vs = self.storyboard?.instantiateViewController(withIdentifier: "firebaseLoginViewController")
			self.navigationController?.present(vs!, animated: true, completion: nil)
			
		}
	}
	
	// configuring the database
	func configureDatabase() {
		ref = Database.database().reference()
		_refHandle = self.ref.child("messages").observe(.childAdded, with: { (snapshot) in
			self.messages.append(snapshot)
			self.tableView.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .automatic)
		})
		
	}
	
	func sentMessage(data:[String:String]) {
		var packet = data
		packet[Constants.MessageFields.dateTime] = Utilities().getCurrentDate()
		
		self.ref.child("messages").childByAutoId().setValue(packet)
		
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let data = [Constants.MessageFields.text: textField.text! as String]
		if textField.text != "" {
			sentMessage(data: data)
		}

		textField.text = ""
		self.view.endEditing(true)
		return true
		
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath)
		
		let messageSnap:DataSnapshot = self.messages[indexPath.row]
		let message = messageSnap.value as! Dictionary<String, String>
		if let text = message[Constants.MessageFields.text] as String?{
			cell.textLabel?.text = text
		}
		
		if let subText = message[Constants.MessageFields.dateTime] {
			cell.detailTextLabel?.text = subText
		}
		return cell
		
		
	}
	
	@IBAction func clickedLogoutBtn(_ sender: Any) {
		
		// logging out the user
		
//		let firebaseAuth = Auth.auth()
//		do {
//		try firebaseAuth.signOut()
//		} catch let signOutError as NSError {
//		print("Error signing out: \(signOutError)")
//		}
		

		self.performSegue(withIdentifier: "logoutSegue", sender: self)
	}
}

