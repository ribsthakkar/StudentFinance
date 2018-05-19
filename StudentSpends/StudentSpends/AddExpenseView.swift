//
//  AddExpenseView.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 12/30/17.
//  Copyright © 2017 ribsthak. All rights reserved.
//

import UIKit
import CoreData
//import TesseractOCR
protocol UpdateExpenseTableDelegate: class {
	func update(with expense: Expense)
	func remove(with expnese: Expense)
}

class AddExpenseView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,InsertDefaultInfoDelegate {
	
	func insertDefaults(sender: ExpenseDefault) {
		expenseName.text = sender.name
		expenseType.text = sender.type
		expenseTypePicker.selectRow(pickerDataSource.index(of: sender.type!)!, inComponent: 0, animated: true)
		let amountString = String(format: "%.02f", sender.price)
		expensePrice.text = amountString
	}
	//Connections to story board and class instance variables
	@IBOutlet var expenseName: UITextField!
	@IBOutlet var expensePrice: UITextField!
	let expenseDatePicker = UIDatePicker()
    let expenseTypePicker = UIPickerView()
    @IBOutlet var expenseDate: UITextField!
    @IBOutlet var expenseType: UITextField!
	@IBOutlet weak var submitButton: UIButton!
	var expense = Expense(context:PersistanceService.context)
	var pickerDataSource = ["Food", "Travel", "Leisure", "Supplies", "Other"];
	weak var delegate: UpdateExpenseTableDelegate?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		// Do any additional setup after loading the view.
		//setup the input objects' delegates and restrictions
		expenseDatePicker.maximumDate = Date()
		expenseDatePicker.datePickerMode = .date
		expenseDatePicker.addTarget(self, action: #selector(self.datePickerValueChanged(datePicker:)), for: .valueChanged)
		
		expenseTypePicker.dataSource = self
		expenseTypePicker.delegate = self
		
		expenseName.delegate = self
		expensePrice.delegate = self
		
		expenseType.inputView = expenseTypePicker
		
		expenseDate.inputView = expenseDatePicker
		
    }
	
	@IBAction func buttonSave(){
		let name = expenseName.text!
		//if empty name is submit then automatically cancel or else upate expense object name
		if(name.count <= 0){
			cancel()
			return
		} else{
			expense.name = name
		}
		
		//if empty price is submit then automatically cancel or else update expense object price
		if let price = Double(expensePrice.text!) {
			expense.price = price
		} else {
			print("Not a valid number: \(expensePrice.text!)")
			cancel()
			return
		}
		
		//update expense object date
        let dateText = expenseDate.text
        if dateText == nil || dateText!.count<=0{
            cancel()
            return
        }else {
            let date = expenseDatePicker.date
            expense.date = date as NSDate
        }
		
		//update expense object type
        let typeText = expenseType.text
        if typeText == nil || typeText!.count<=0 {
            cancel()
            return
        } else {
            let type = pickerDataSource[expenseTypePicker.selectedRow(inComponent: 0)]
            expense.type = type
        }
		
		//save to CoreData and perform segue to return to tableView of expenses
		PersistanceService.saveContext()
		delegate?.update(with: expense)
		self.dismiss(animated: true, completion: nil)
	}
	
	//Method to setup responsiveness of DATEPICKERVIEW for expenseDatePicker
	@objc func datePickerValueChanged(datePicker: UIDatePicker) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		
		expenseDate.text = dateFormatter.string(from: datePicker.date)
	}
	
	
	//Methods to setup the PICKERVIEW for the expenseTypePicker picker
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
			expense.image = UUID()
			let expenseImage = ExpenseImage(context:PersistanceService.context)
			expenseImage.imageID = expense.image
			expenseImage.image = pickedImage			
		}
		picker.dismiss(animated: true, completion: nil)
	}
	@IBAction func cancel() {
		PersistanceService.context.delete(expense)
		self.dismiss(animated: true, completion: nil)
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		if(segue.identifier == "defaultExpenseTableSegue"){
			let dest = segue.destination as! UINavigationController
			let realDest = dest.viewControllers[0] as! DefaultExpenseViewTable
			realDest.delegate = self
		}
	}
    
}
