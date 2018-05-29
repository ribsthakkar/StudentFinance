//
//  MainGraphViewController.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 5/29/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit

class MainGraphViewController: UITabBarController, UpdateRangeDelegate {
	var allExpenses = [Expense]()
	var expensesByDate = [String: Double]()
	var expensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
	let formatter = DateFormatter()
	var currentRange = DateRange.Weekly
	var date = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
		// Do any additional setup after loading the view.
		formatter.dateFormat = "MM/dd"
		//set date range for the graph
		update(with: date, range: currentRange)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		let backButton: UIBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editDateRanges))
		self.navigationItem.rightBarButtonItem = backButton
	}
	
	@IBAction func editDateRanges() {
		//Go to the specific picker of the range of dates initially picked
		switch currentRange {
		case .Weekly:
			performSegue(withIdentifier: "weekEditor", sender: allExpenses)
		case .Monthly:
			performSegue(withIdentifier: "monthEditor", sender: allExpenses)
		case .Yearly:
			performSegue(withIdentifier: "yearEditor", sender: allExpenses)
		}
	}
	
	func update(with date: Date, range: DateRange) {
		expensesByDate = [String: Double]()
		expensesByCategory = ["Food": 0.0, "Travel": 0.0, "Leisure": 0.0, "Supplies": 0.0, "Other": 0.0]
		switch range {
		case .Weekly:
			currentRange = DateRange.Weekly
			setupWeeklyGraphValuesFrom(weekOf: date)
		case .Monthly:
			currentRange = DateRange.Monthly
			setupMonthGraphValuesFrom(monthOf: date)
		case .Yearly:
			currentRange = DateRange.Yearly
			setupYearGraphValuesFrom(yearOf: date)
		}
		if let lineController = self.viewControllers?[0] as! LineGraphViewController? {
			lineController.expensesByDate = expensesByDate
		}
		if let pieController = self.viewControllers?[1] as! PieGraphViewController? {
			pieController.expensesByCategory = expensesByCategory
		}
	}
	
	//Method to setup the Dictionaries for the weekly time interval
	func setupWeeklyGraphValuesFrom(weekOf: Date){
		var index = 0
		//create keys in dictionary for the past seven days
		for time in -7...0{
			let calendar = Calendar.current
			let daysAway = calendar.date(byAdding: .day, value: time, to: weekOf)
			expensesByDate.updateValue(0.00, forKey: formatter.string(from: daysAway!))
		}
		
		//loop through each of the expenses and update the dictionary values
		while index < allExpenses.count {
			let when = allExpenses[index].date! as Date //access date for the expense
			
			//find difference in number of years to make sure the date isn't more than a year away
			let years = Calendar.current.component(.year, from: when) - Calendar.current.component(.year, from: weekOf)
			if(years == 0) {
				//if key exists in dictionary update the total spent on that day or total spent on that category
				if let curr = expensesByDate[formatter.string(from: when)]{
					expensesByDate.updateValue(curr + allExpenses[index].price, forKey: formatter.string(from: when))
					expensesByCategory.updateValue(allExpenses[index].price + expensesByCategory[allExpenses[index].type!]!, forKey: allExpenses[index].type!)
				}
			}
			index += 1
		}
	}
	
	//method to setup the dictionaries for the month time interval
	func setupMonthGraphValuesFrom(monthOf: Date){
		var index = 0
		//create a DateFormatter object to convert the date of the month into an int
		let dayFormat = DateFormatter()
		dayFormat.dateFormat = "dd"
		
		//add all of the dates from the start of the month to today into as keys of the dictionary
		for time in ((Int(dayFormat.string(from: monthOf))! - 1) * -1)...0{
			let calendar = Calendar.current
			let daysAway = calendar.date(byAdding: .day, value: time, to: monthOf)
			expensesByDate.updateValue(0.00, forKey: formatter.string(from: daysAway!))
		}
		//loop through expenses and update dictionary values
		while index < allExpenses.count {
			let when = allExpenses[index].date! as Date
			let monthFormat = DateFormatter()
			let yearFormat = DateFormatter()
			monthFormat.dateFormat = "MM"
			yearFormat.dateFormat = "yyyy"
			//check if the month and the year match
			if(monthFormat.string(from: when) == monthFormat.string(from: monthOf) && yearFormat.string(from: when) == yearFormat.string(from: monthOf)) {
				//if key exists in dictionary update the total spent on that day or total spent on that category
				if let curr = expensesByDate[formatter.string(from: when)]{
					expensesByDate.updateValue(curr + allExpenses[index].price, forKey: formatter.string(from: when))
					expensesByCategory.updateValue(allExpenses[index].price + expensesByCategory[allExpenses[index].type!]!, forKey: allExpenses[index].type!)
				}
			}
			index += 1
		}
	}
	
	//setup dictionaries for the year time interval
	func setupYearGraphValuesFrom(yearOf: Date) {
		var index = 0
		//array of months to add as keys to dictionary
		let months = ["01Jan","02Feb","03Mar","04Apr","05May","06Jun","07Jul","08Aug","09Sep","10Oct","11Nov","12Dec"]
		for month in 0..<months.count{
			expensesByDate.updateValue(0.00, forKey: months[month])
		}
		//loop through all of the expenses
		while index < allExpenses.count {
			let when = allExpenses[index].date! as Date
			
			//date format object to make sure we are from the same year
			let format = DateFormatter()
			format.dateFormat = "yyyy"
			
			//create other format object to convert month to indicies for months array
			let otherFormat = DateFormatter()
			otherFormat.dateFormat = "MM"
			
			if(format.string(from: when) == format.string(from: yearOf)) {
				//if key exists, then update the total spent in that month and total spent in that category
				if let curr = expensesByDate[months[Int(otherFormat.string(from: when))! - 1]]{
					let month = months[Int(otherFormat.string(from: when))! - 1]
					expensesByDate.updateValue(curr + allExpenses[index].price, forKey: month)
					expensesByCategory.updateValue(allExpenses[index].price + expensesByCategory[allExpenses[index].type!]!, forKey: allExpenses[index].type!)
				}
			}
			index += 1
		}
	}
	
    // MARK: - Navigation

	// Prepare for the segues
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//Update the week of the data to be presented
		if(segue.identifier == "weekEditor"){
			let dest = segue.destination as! UpdateWeekRange
			dest.allExpenses = allExpenses
			dest.delegate = self
		}
		//Update the month of the data to be presented
		if(segue.identifier == "monthEditor"){
			let dest = segue.destination as! UpdateMonthRange
			dest.allExpenses = allExpenses
			dest.delegate = self
		}
		//Update the year of the data to be presented
		if(segue.identifier == "yearEditor"){
			let dest = segue.destination as! UpdateYearRange
			dest.allExpenses = allExpenses
			dest.delegate = self
		}
	}
	
	
	enum DateRange {
		case Weekly
		case Monthly
		case Yearly
	}
}


