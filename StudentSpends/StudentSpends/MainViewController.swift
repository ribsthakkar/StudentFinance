//
//  ViewController.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 12/29/17.
//  Copyright © 2017 ribsthak. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, DidDataUpdateDelegate {
	
	func updated(yes: Bool){
		changed = yes
	}
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		allExpenses = [Expense]()
//		navigationController?.navigationBar.prefersLargeTitles = true
    }
	override func viewDidAppear(_ animated: Bool) {
		week = false
		month = false
		year = false
		if changed {
			getData()
			changed = false
		}
	}
	//instantiate class variables
	var week: Bool = false
	var month: Bool = false
	var year: Bool = false
	var changed: Bool = true
	var allExpenses = [Expense]()
	
	// Method to access all of the Expense data
	func getData() {
		//Create fetch request object and apply the sorting descriptor for most recent dates to older dates
		let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
		let sort = NSSortDescriptor(key: #keyPath(Expense.date), ascending: true)
		fetchRequest.sortDescriptors = [sort]
		//fetch the array of Expense objects and set it to the class variable
		do {
			let expenses = try PersistanceService.context.fetch(fetchRequest)
			self.allExpenses = expenses
		} catch {
			print("Cannot fetch Expenses")
		}
	}
	
	@IBAction func viewExpenseTable(_ sender: Any) {
		performSegue(withIdentifier: "viewTableSegue", sender: nil)
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
			let dest = segue.destination as! UITabBarController
			if let graphTypes = dest.customizableViewControllers {
			let realDest = (graphTypes[0] as! UINavigationController).viewControllers[0] as! LineGraphViewController
				realDest.allExpenses = allExpenses
				if(week){
					realDest.currentRange = MainGraphViewController.DateRange.Weekly
				}
				else if(month){
					print("setMonthly")
					realDest.currentRange = MainGraphViewController.DateRange.Monthly
				}
				else if(year){
					print("setYearly")
					realDest.currentRange = MainGraphViewController.DateRange.Yearly
				}
			} else {
				print("Tab Bar controller error")
			}
		} else if(segue.identifier == "viewTableSegue") {
			let dest = segue.destination as! ExpenseViewTable
			dest.allExpenses = allExpenses
			dest.delegate = self
		}
	}
}

