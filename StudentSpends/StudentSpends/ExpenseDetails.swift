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
	weak var delegate: UpdateExpenseTableDelegate?

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		//show the image associated with expense if it exists, else show a blue box
		if let imageIDOfExpense = expenseObject.image{
			expensePhoto.backgroundColor = UIColor.clear
			let fetchRequest: NSFetchRequest<ExpenseImage> = ExpenseImage.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "imageID == %@", imageIDOfExpense as CVarArg)
			do {
				expensePhoto.image = try PersistanceService.context.fetch(fetchRequest)[0].image as? UIImage
			} catch {
				print("Cannot fetch Expense Photo")
			}
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

	@IBAction func done() {
		self.dismiss(animated: true, completion: nil)
	}
	@IBAction func deleteExpense() {
		delegate?.remove(with: expenseObject)
		if let imageIDOfExpense = expenseObject.image{
			expensePhoto.backgroundColor = UIColor.clear
			let fetchRequest: NSFetchRequest<ExpenseImage> = ExpenseImage.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "imageID == %@", imageIDOfExpense as CVarArg)
			do {
				PersistanceService.context.delete(try PersistanceService.context.fetch(fetchRequest)[0])
			} catch {
				print("No expense photo to delete")
			}
		} else{
			expensePhoto.backgroundColor = UIColor.blue
		}
		PersistanceService.context.delete(expenseObject)
		PersistanceService.saveContext()
		self.dismiss(animated: true, completion: nil)
	}
	

}
