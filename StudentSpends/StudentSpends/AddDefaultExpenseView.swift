//
//  AddDefaultExpenseView.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 4/8/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//
import UIKit
import CoreData

class AddDefaultExpenseView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	
	//Connections to story board and class instance variables
	@IBOutlet var expenseName: UITextField!
	@IBOutlet var expensePrice: UITextField!
	@IBOutlet var expenseType: UITextField!
	let expenseTypePicker = UIPickerView()
	var expense:ExpenseDefault?
	var saved:Bool = false
	var pickerDataSource = ["Food", "Travel", "Leisure", "Supplies", "Other"]
	
	override func viewWillAppear(_ animated: Bool) {
		expense = ExpenseDefault(context:PersistanceService.context)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		//setup the input objects' delegates and restrictions
		expenseTypePicker.dataSource = self
		expenseTypePicker.delegate = self
		expenseType.delegate = self
		expenseName.delegate = self
		expensePrice.delegate = self
		
		expenseType.inputView = expenseTypePicker
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		if !saved {
		PersistanceService.context.delete(expense!)
		}
		saved = false
	}
	
	@IBAction func buttonSave(){
		let name = expenseName.text!
		//if empty name is submit then automatically cancel or else upate expense object name
		if(name.count <= 0){
			cancel()
			return
		} else{
			expense?.name = name
		}
		
		//if empty price is submit then automatically cancel or else update expense object price
		if let price = Double(expensePrice.text!) {
			expense?.price = price
		} else {
			print("Not a valid number: \(expensePrice.text!)")
			cancel()
			return
		}
		
		//update expense object type
		let typeText = expenseType.text
		if typeText == nil || typeText!.count<=0 {
			cancel()
			return
		} else {
			let type = pickerDataSource[expenseTypePicker.selectedRow(inComponent: 0)]
			expense?.type = type
		}
		self.navigationController?.popViewController(animated: true)
		//save to CoreData and perform segue to return to tableView of expenses
		PersistanceService.saveContext()
		saved = true
		self.dismiss(animated: true, completion: nil)
	}
	
	
	
	//Methods to setup the PICKERVIEW for the expenseType picker
	// The number of rows of data
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerDataSource.count
	}
	
	// The data to return for the row and component (column) that's being passed in
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerDataSource[row]
	}
	//number of columns in data
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		expenseType.text = pickerDataSource[row]
	}
	//methods to close keyboard once we're done typing
	override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?){
		view.endEditing(true)
		super.touchesBegan(touches, with: with)
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField.isEqual(expenseType) {
			expenseType.text = "Food"
		}
	}
	
	@IBAction func cancel() {
		self.dismiss(animated: true, completion: nil)
	}
}
