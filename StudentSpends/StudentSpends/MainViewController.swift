//
//  ViewController.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 12/29/17.
//  Copyright © 2017 ribsthak. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		allExpenses = [Expense]()
		week = false
		month = false
		year = false
		//creating neccessary arrays in order to store the data for specified time intervals
		weekExpensesByDate = Dictionary<String, Double>()
		monthExpensesByDate = Dictionary<String, Double>()
		yearExpensesByDate = Dictionary<String, Double>()
		weekExpensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
		monthExpensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
		yearExpensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
		
		//read all of the data from CoreData platform
		getData()
    }
	//instantiate class variables
	var week: Bool = false
	var month: Bool = false
	var year: Bool = false
	var allExpenses = [Expense]()
	var weekExpensesByDate = Dictionary<String, Double>()
	var monthExpensesByDate = Dictionary<String, Double>()
	var yearExpensesByDate = Dictionary<String, Double>()
	var weekExpensesByCategory = ["Food": 0.00, "Travel": 0.00, "Leisure": 0.00, "Supplies": 0.00, "Other": 0.00]
	var monthExpensesByCategory = ["Food": 0.00, "Travel": 0.00, "Leisure": 0.00, "Supplies": 0.00, "Other": 0.00]
	var yearExpensesByCategory = ["Food": 0.00, "Travel": 0.00, "Leisure": 0.00, "Supplies": 0.00, "Other": 0.00]
	
	// Method to access all of the Expense data
	func getData() {
		//Create fetch request object and apply the sorting descriptor for most recent dates to older dates
		let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
		let sort = NSSortDescriptor(key: #keyPath(Expense.date), ascending: false)
		fetchRequest.sortDescriptors = [sort]
		//fetch the array of Expense objects and set it to the class variable
		do {
			let expenses = try PersistanceService.context.fetch(fetchRequest)
			self.allExpenses = expenses
		} catch {
			print("Cannot fetch Expenses")
		}
	}
	
	//method to perform segue and send the dictionaries for week
	@IBAction func viewWeekGraphs(_ sender: Any) {
		//create an array of dictionaries to send while perfomring segue
		week = true
		performSegue(withIdentifier: "graphSegue", sender: nil)
		
	}
	
	//method to perform segue and send the dictionaries for month
	@IBAction func viewMonthGraphs(_ sender: Any) {
		//create an array of dictionaries to send while performing segue
		month = true
		performSegue(withIdentifier: "graphSegue", sender: nil)
	}
	
	//method to perform segue and send dictionaries for year
	@IBAction func viewYearGraphs(_ sender: Any) {
		//create array of dictionaries to send while performing segue
		year = true
		performSegue(withIdentifier: "graphSegue", sender: nil)
	}
	
	//method to send data before segue
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		if(segue.identifier == "graphSegue"){
			let dest = segue.destination as! LineGraphViewController
			dest.allExpenses = allExpenses
			if(week){
				dest.setupWeeklyGraphValuesFrom(weekOf: Date())
				dest.week = true
			}
			else if(month){
				dest.setupMonthGraphValuesFrom(monthOf: Date())
				dest.month = true
			}
			else{
				dest.setupYearGraphValuesFrom(yearOf: Date())
				dest.year = true
			}
		}
	}
}

