//
//  AddExpenseView.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 12/30/17.
//  Copyright © 2017 ribsthak. All rights reserved.
//

import UIKit
import CoreData

class AddExpenseView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	
	//Connections to story board and class instance variables
	@IBOutlet var expenseName: UITextField!
	@IBOutlet var expensePrice: UITextField!
	@IBOutlet var expenseDate: UIDatePicker!
	@IBOutlet var expenseType: UIPickerView!
	@IBOutlet weak var submitButton: UIButton!
	var expense = Expense(context:PersistanceService.context)
	var pickerDataSource = ["Food", "Travel", "Leisure", "Supplies","Other"];
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		// Do any additional setup after loading the view.
		//setup the input objects' delegates and restrictions
		expenseDate.maximumDate = Date()
		self.expenseType.dataSource = self
		self.expenseType.delegate = self
		self.expenseName.delegate = self
		self.expensePrice.delegate = self
		
		//update prewritten information if there is any
		expenseName.text = expense.name
		expensePrice.text = String(expense.price)
		if let tempDate = expense.date{
			expenseDate.date = tempDate as Date
		}
		if let type = expense.type{
			expenseType.selectRow(pickerDataSource.index(of: type)!, inComponent: 0, animated: false)
		}
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	@IBAction func buttonSave(){
		let name = expenseName.text!
		//if empty name is submit then automatically cancel or else upate expense object name
		if(name.count <= 0){
			performSegue(withIdentifier: "cancelSegue", sender: nil)
			return
		} else{
			expense.name = name
		}
		
		//if empty price is submit then automatically cancel or else update expense object price
		if let price = Double(expensePrice.text!) {
			expense.price = price
		} else {
			print("Not a valid number: \(expensePrice.text!)")
			performSegue(withIdentifier: "cancelSegue", sender: nil)
			return
		}
		
		//update expense object date
		let date = expenseDate.date
		expense.date = date as NSDate
		
		//update expense object type
		let type = pickerDataSource[expenseType.selectedRow(inComponent: 0)]
		expense.type = type
		
		//save to CoreData and perform segue to return to tableView of expenses
		PersistanceService.saveContext()
		performSegue(withIdentifier: "submitSegue", sender: expense)
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
	
	//methods to close keyboard once we're done typing
	override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?){
		view.endEditing(true)
		super.touchesBegan(touches, with: with)
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	
	//Methods to allow CAMERA functionality for the receipts
	@IBAction func takePhoto(_ sender: Any) {
		//if we can access camera, allow imagePicker to use camera as source and save picture to expense's image field in CoreData
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = UIImagePickerControllerSourceType.camera
			imagePicker.allowsEditing = false
			self.present(imagePicker, animated: true, completion: nil)
			
		}
	}
	//method to update the Expense instance
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			expense.image = pickedImage
		}
		picker.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Navigation

	//Method to prepare for segue
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       	//If the segue is to submit the data, then we update the list of all expenses for the table
		if segue.identifier == "submitSegue" {
			let ExchangeViewData = segue.destination as! ExpenseViewTable
			ExchangeViewData.allExpenses.append(sender as! Expense)
		}
		//if expense is canceled, then delete it from CoreData
		if(segue.identifier == "cancelSegue"){
			PersistanceService.context.delete(expense)
		}
    }
    
}
