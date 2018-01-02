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
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	var expense = Expense(context:PersistanceService.context)
	var pickerDataSource = ["Food", "Travel", "Leisure", "Supplies","Other"];
    override func viewDidLoad() {
        super.viewDidLoad()
		// Do any additional setup after loading the view.
		expenseDate.maximumDate = Date()
		self.expenseType.dataSource = self
		self.expenseType.delegate = self
		self.expenseName.delegate = self
		self.expensePrice.delegate = self
//		if((expense.name?.isEqual(""))! && expense.price == 0 && (expense.type?.isEqual(""))! && (expense.date?.isEqual(Date() as NSDate))!) {
//			self.expense = Expense(context:PersistanceService.context)
//		} else {
			expenseName.text = expense.name
			expensePrice.text = String(expense.price)
			if let tempDate = expense.date{
				expenseDate.date = tempDate as Date
			}
		if let type = expense.type{
			expenseType.selectRow(pickerDataSource.index(of: type)!, inComponent: 0, animated: false)
		}
		//}
    }
	override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?){
		view.endEditing(true)
		super.touchesBegan(touches, with: with)
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBOutlet var expenseName: UITextField!
	@IBOutlet var expensePrice: UITextField!
	@IBOutlet var expenseDate: UIDatePicker!
	@IBOutlet var expenseType: UIPickerView!

	@IBOutlet weak var submitButton: UIButton!
	@IBAction func buttonSave(){
		let name = expenseName.text!
		if(name.count <= 0){
			performSegue(withIdentifier: "emptySubmit", sender: nil)
			return
		}else{
			expense.name = name
		}
		
		if let price = Double(expensePrice.text!) {
			expense.price = price
		} else {
			print("Not a valid number: \(expensePrice.text!)")
			performSegue(withIdentifier: "emptySubmit", sender: nil)
			return
		}
		let date = expenseDate.date
		expense.date = date as NSDate
		
		let type = pickerDataSource[expenseType.selectedRow(inComponent: 0)]
		expense.type = type
		PersistanceService.saveContext()
		performSegue(withIdentifier: "submitSegue", sender: expense)
	}
	// The number of rows of data
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerDataSource.count
	}
	
	// The data to return for the row and component (column) that's being passed in
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerDataSource[row]
	}
	
	
	// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "submitSegue" {
			
			//Initial your second view data control
			let ExchangeViewData = segue.destination as! ExpenseViewTable
			
			//Send your data with segue
//            print((sender as! Expense).type)
//            print((sender as! Expense).name)
//            print((sender as! Expense).price)
//            print((sender as! Expense).date)
			ExchangeViewData.allExpenses.append(sender as! Expense)
		}
		if(segue.identifier == "cancelSegue"){
			PersistanceService.context.delete(expense)
		}
    }
    
    @IBAction func takePhoto(_ sender: Any) {
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = UIImagePickerControllerSourceType.camera
			imagePicker.allowsEditing = false
			self.present(imagePicker, animated: true, completion: nil)
			
		}
    }
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			expense.image = pickedImage
		}
		picker.dismiss(animated: true, completion: nil)
	}
    
}
