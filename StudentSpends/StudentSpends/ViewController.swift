//
//  ViewController.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 12/29/17.
//  Copyright © 2017 ribsthak. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		allExpenses = [Expense]()
		weekExpensesByDate = Dictionary<String, Double>()
		monthExpensesByDate = Dictionary<String, Double>()
		yearExpensesByDate = Dictionary<String, Double>()
		weekExpensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
		monthExpensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
		yearExpensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
		getData()
		formatter.dateFormat = "MM/dd"
    }
	let formatter = DateFormatter()
	var allExpenses = [Expense]()
	var weekExpensesByDate = Dictionary<String, Double>()
	var monthExpensesByDate = Dictionary<String, Double>()
	var yearExpensesByDate = Dictionary<String, Double>()
	var weekExpensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
	var monthExpensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
	var yearExpensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
	
	func getData() {
		let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
		let sort = NSSortDescriptor(key: #keyPath(Expense.date), ascending: false)
		fetchRequest.sortDescriptors = [sort]
		do {
			let expenses = try PersistanceService.context.fetch(fetchRequest)
			self.allExpenses = expenses
		} catch {
			print("Cannot fetch Expenses")
		}
	}
	func setupWeeklyGraphValues(){
		var index = 0
		var done = false
		while index < allExpenses.count && done == false {
			let when = allExpenses[index].date! as Date
			let days = Calendar.current.component(.day, from: when)
			let years = Calendar.current.component(.year, from: when) - Calendar.current.component(.year, from: Date())
			//let components = calendar.dateComponents([Calendar.Component.day], from: when, to: D)
			if(days <= 6 && years == 0) {
				if let curr = weekExpensesByDate[formatter.string(from: when)]{
					weekExpensesByDate.updateValue(curr + allExpenses[index].price, forKey: formatter.string(from: when))
				} else{
					weekExpensesByDate.updateValue(allExpenses[index].price, forKey: formatter.string(from: when))
				}
				weekExpensesByCategory.updateValue(allExpenses[index].price + weekExpensesByCategory[allExpenses[index].type!]!, forKey: allExpenses[index].type!)
			} else {
				done = true
			}
			index += 1
		}
	}
	func setupMonthGraphValues(){
		var index = 0
		var done = false
		while index < allExpenses.count && done == false {
			let when = allExpenses[index].date! as Date
			let monthFormat = DateFormatter()
			let yearFormat = DateFormatter()
			monthFormat.dateFormat = "MM"
			yearFormat.dateFormat = "yyyy"
			print(formatter.string(from: when))
			if(monthFormat.string(from: when) == monthFormat.string(from: Date()) && yearFormat.string(from: when) == yearFormat.string(from: Date())) {
				if let curr = monthExpensesByDate[formatter.string(from: when)]{
					monthExpensesByDate.updateValue(curr + allExpenses[index].price, forKey: formatter.string(from: when))
				} else{
					monthExpensesByDate.updateValue(allExpenses[index].price, forKey: formatter.string(from: when))
				}
				monthExpensesByCategory.updateValue(allExpenses[index].price + monthExpensesByCategory[allExpenses[index].type!]!, forKey: allExpenses[index].type!)
			} else {
				done = true
			}
			index += 1
		}
	}
	func setupYearGraphValues() {
		var index = 0
		var done = false
		while index < allExpenses.count && done == false {
			let when = allExpenses[index].date! as Date
			let format = DateFormatter()
			format.dateFormat = "yyyy"
			if(format.string(from: when) == format.string(from: Date())) {
				if let curr = yearExpensesByDate[formatter.string(from: when)]{
					yearExpensesByDate.updateValue(curr + allExpenses[index].price, forKey: formatter.string(from: when))
				} else{
					yearExpensesByDate.updateValue(allExpenses[index].price, forKey: formatter.string(from: when))
				}
				yearExpensesByCategory.updateValue(allExpenses[index].price + yearExpensesByCategory[allExpenses[index].type!]!, forKey: allExpenses[index].type!)
			} else {
				done = true
			}
			index += 1
		}
	}
	@IBAction func viewWeekGraphs(_ sender: Any) {
		setupWeeklyGraphValues()
		var expensesData: [Dictionary<String, Double>] = []
		expensesData.append(weekExpensesByDate)
		expensesData.append(weekExpensesByCategory)
		performSegue(withIdentifier: "graphSegue", sender: expensesData)
	}
	
	@IBAction func viewMonthGraphs(_ sender: Any) {
		setupMonthGraphValues()
		var expensesData: [Dictionary<String, Double>] = []
		expensesData.append(monthExpensesByDate)
		expensesData.append(monthExpensesByCategory)
		performSegue(withIdentifier: "graphSegue", sender: expensesData)
	}
	
	@IBAction func viewYearGraphs(_ sender: Any) {
		setupYearGraphValues()
		var expensesData: [Dictionary<String, Double>] = []
		expensesData.append(yearExpensesByDate)
		expensesData.append(yearExpensesByCategory)
		performSegue(withIdentifier: "graphSegue", sender: expensesData)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		if(segue.identifier == "graphSegue"){
			let dest = segue.destination as! GraphsViewController
			dest.expensesByCategory = (sender as! [Dictionary<String, Double>])[1]
			dest.expensesByDate = (sender as! [Dictionary<String, Double>])[0]
		}
	}
}

