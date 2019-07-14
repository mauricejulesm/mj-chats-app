//
//  Utilities.swift
//  MJ-Chats
//
//  Created by maurice on 7/13/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
	func showAlert(title: String, message: String,vc: UIViewController ) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		vc.present(alert, animated: true, completion: nil)
		
	}
}
