//
//  Expense.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 12/30/17.
//  Copyright © 2017 ribsthak. All rights reserved.
//
import UIKit
import Foundation

class Expense {
	var name: String?
	var price: Double
	var day: Date?
	var type: String?
	var image: UIImage?
	
	init(name: String, price: Double, when: Date, type: String) {
		self.name = name
		self.price = price
		day = when
		self.type = type
	}
	
	init(name: String, price: Double, when: Date, type: String, photo: UIImage) {
		self.name = name
		self.price = price
		day = when
		self.type = type
		image = photo
	}
	
}
