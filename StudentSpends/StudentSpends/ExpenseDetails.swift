//
//  ExpenseDetails.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 1/2/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit
import CoreData

class ExpenseDetails: UIViewController {
	
	//Define connections to storyboard and class varibles
	@IBOutlet weak var expensePhoto: UIImageView!
	@IBOutlet weak var expenseName: UILabel!
	@IBOutlet weak var expenseCost: UILabel!
	@IBOutlet weak var expenseType: UILabel!
	@IBOutlet weak var expenseDate: UILabel!
	var expenseObject = Expense()
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		//show the image associated with expense if it exists, else show a blue box
		if let imageOfExpense = expenseObject.image{
			expensePhoto.backgroundColor = UIColor.clear
			expensePhoto.image = imageOfExpense as? UIImage
		} else{
			expensePhoto.backgroundColor = UIColor.blue
		}
		//show and format the price, name, date, and type of the expense
		expenseCost.text = "Price: " + String(format: "$%.02f", expenseObject.price)
		expenseName.text = expenseObject.name
		let when = expenseObject.date as Date?
		let formatter = DateFormatter()
		formatter.dateFormat = "MM/dd/yyyy"
		let result = formatter.string(from: when!)
		expenseDate.text = "Date: " + result
		expenseType.text = "Type of Expense: " +  expenseObject.type!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//clear all of the labels and objects once we segue away from this view
		expensePhoto.image = nil
		expenseName.text = ""
		expenseDate.text = ""
		expenseCost.text = ""
		//if delete button is pressed, then delete this expense object
		if segue.identifier == "deleteSegue" {
			PersistanceService.context.delete(expenseObject)
			PersistanceService.saveContext()
		}
    }
	

}