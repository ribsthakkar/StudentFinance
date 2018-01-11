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
		
		//creating neccessary arrays in order to store the data for specified time intervals
		weekExpensesByDate = Dictionary<String, Double>()
		monthExpensesByDate = Dictionary<String, Double>()
		yearExpensesByDate = Dictionary<String, Double>()
		weekExpensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
		monthExpensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
		yearExpensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
		
		//read all of the data from CoreData platform
		getData()
		
		//set main date format
		formatter.dateFormat = "MM/dd"
    }
	//instantiate class variables
	let formatter = DateFormatter()
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
	
	//Method to setup the Dictionaries for the weekly time interval
	func setupWeeklyGraphValues(){
		var index = 0
		var done = false
		//create keys in dictionary for the past seven days
		for time in -7...0{
			let calendar = Calendar.current
			let daysAway = calendar.date(byAdding: .day, value: time, to: Date())
			weekExpensesByDate.updateValue(0.00, forKey: formatter.string(from: daysAway!))
		}
		//loop through each of the expenses and update the dictionary values
		while index < allExpenses.count && done == false {
			let when = allExpenses[index].date! as Date //access date for the expense
			
			//find difference in number of years to make sure the date isn't more than a year away
			let years = Calendar.current.component(.year, from: when) - Calendar.current.component(.year, from: Date())
			if(years == 0) {
				//if key exists in dictionary update the total spent on that day or total spent on that category
				if let curr = weekExpensesByDate[formatter.string(from: when)]{
					weekExpensesByDate.updateValue(curr + allExpenses[index].price, forKey: formatter.string(from: when))
					weekExpensesByCategory.updateValue(allExpenses[index].price + weekExpensesByCategory[allExpenses[index].type!]!, forKey: allExpenses[index].type!)
				}
			} else { //if we ever reach a date that doesn't meet this requirement we know following dates will not either
				done = true
			}
			index += 1
		}
	}
	
	//method ot setup the dictionaries for the month time interval
	func setupMonthGraphValues(){
		var index = 0
		var done = false
		
		//create a DateFormatter object to convert the date of the month into an int
		let dayFormat = DateFormatter()
		dayFormat.dateFormat = "dd"
		
		//add all of the dates from the start of the month to today into as keys of the dictionary
		for time in ((Int(dayFormat.string(from: Date()))! - 1) * -1)...0{
			let calendar = Calendar.current
			let daysAway = calendar.date(byAdding: .day, value: time, to: Date())
			monthExpensesByDate.updateValue(0.00, forKey: formatter.string(from: daysAway!))
		}
		
		//loop through expenses and update dictionary values
		while index < allExpenses.count && done == false {
			let when = allExpenses[index].date! as Date
			let monthFormat = DateFormatter()
			let yearFormat = DateFormatter()
			monthFormat.dateFormat = "MM"
			yearFormat.dateFormat = "yyyy"
			//check if the month and the year match
			if(monthFormat.string(from: when) == monthFormat.string(from: Date()) && yearFormat.string(from: when) == yearFormat.string(from: Date())) {
				//if key exists in dictionary update the total spent on that day or total spent on that category
				if let curr = monthExpensesByDate[formatter.string(from: when)]{
					monthExpensesByDate.updateValue(curr + allExpenses[index].price, forKey: formatter.string(from: when))
					monthExpensesByCategory.updateValue(allExpenses[index].price + monthExpensesByCategory[allExpenses[index].type!]!, forKey: allExpenses[index].type!)
				}
			} else { //if we reach amonth and year that dont' match then we know the rest of the dates don't either
				done = true
			}
			index += 1
		}
	}
	
	//setup dictionaries for the year time interval
	func setupYearGraphValues() {
		var index = 0
		var done = false
		//array of months to add as keys to dictionary
		let months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
		for month in 0..<months.count{
			yearExpensesByDate.updateValue(0.00, forKey: months[month])
		}
		//loop through all of the expenses
		while index < allExpenses.count && done == false {
			let when = allExpenses[index].date! as Date
			
			//date format object to make sure we are from the same year
			let format = DateFormatter()
			format.dateFormat = "yyyy"
			
			//create other format object to convert month to indicies for months array
			let otherFormat = DateFormatter()
			otherFormat.dateFormat = "MM"
			
			if(format.string(from: when) == format.string(from: Date())) {
				//if key exists, then update the total spent in that month and total spent in that category
				if let curr = yearExpensesByDate[months[Int(otherFormat.string(from: when))!]]{
					yearExpensesByDate.updateValue(curr + allExpenses[index].price, forKey: months[Int(otherFormat.string(from: when))!])
					yearExpensesByCategory.updateValue(allExpenses[index].price + yearExpensesByCategory[allExpenses[index].type!]!, forKey: allExpenses[index].type!)
				}
			} else { //if we hit any other year, then we know all other elements in array are not from current year
				done = true
			}
			index += 1
		}
	}
	
	//method to perform segue and send the dictionaries for week
	@IBAction func viewWeekGraphs(_ sender: Any) {
		setupWeeklyGraphValues() //method call to setup values
		//create an array of dictionaries to send while perfomring segue
		var expensesData: [Dictionary<String, Double>] = []
		expensesData.append(weekExpensesByDate)
		expensesData.append(weekExpensesByCategory)
		performSegue(withIdentifier: "graphSegue", sender: expensesData)
	}
	
	//method to perform segue and send the dictionaries for month
	@IBAction func viewMonthGraphs(_ sender: Any) {
		setupMonthGraphValues() //method call to setup values
		//create an array of dictionaries to send while performing segue
		var expensesData: [Dictionary<String, Double>] = []
		expensesData.append(monthExpensesByDate)
		expensesData.append(monthExpensesByCategory)
		performSegue(withIdentifier: "graphSegue", sender: expensesData)
	}
	
	//method to perform segue and send dictionaries for year
	@IBAction func viewYearGraphs(_ sender: Any) {
		setupYearGraphValues() //method call to setup values
		//create array of dictionaries to send while performing segue
		var expensesData: [Dictionary<String, Double>] = []
		expensesData.append(yearExpensesByDate)
		expensesData.append(yearExpensesByCategory)
		performSegue(withIdentifier: "graphSegue", sender: expensesData)
	}
	
	//method to send data before segue
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		if(segue.identifier == "graphSegue"){
			let dest = segue.destination as! LineGraphViewController
		
			//update destination dictionaries with neccessary data
			dest.expensesByCategory = (sender as! [Dictionary<String, Double>])[1]
			dest.expensesByDate = (sender as! [Dictionary<String, Double>])[0]
		}
	}
}

