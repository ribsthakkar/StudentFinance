//
//  DefaultExpenseView.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 3/12/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit
import CoreData
class DefaultExpenseViewTable: UIViewController, DefaultExpenseTableCellDelegate {
	//instantiate class variables (table for expenses) and array of expenses
	@IBOutlet weak var expenseTable: UITableView!
	private let cellId = "defaultExpenseCell"
	var allDefaultExpenses = [ExpenseDefault]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		//apply nib for expense table cell
		expenseTable.register(UINib(nibName: "DefaultExpenseTableCell", bundle: .main), forCellReuseIdentifier: cellId)
		expenseTable.reloadData()
	}
	override func viewWillAppear(_ animated: Bool) {
		getData()
	}
	//function called to perfom segue with a specific cell is tapped
	func cellTapped(sender: DefaultExpenseTableCell) {
		if let indexPath = expenseTable.indexPath(for: sender) {
			
		}
	}
	@IBAction func done() {
		self.dismiss(animated: true, completion: nil)
	}
	
	func getData() {
		//Create fetch request object and apply the sorting descriptor for most recent dates to older dates
		let fetchRequest: NSFetchRequest<ExpenseDefault> = ExpenseDefault.fetchRequest()
		//fetch the array of Expense objects and set it to the class variable
		do {
			let expenses = try PersistanceService.context.fetch(fetchRequest)
			self.allDefaultExpenses = expenses
		} catch {
			print("Cannot fetch Expenses")
		}
	}
}
//DataSource inherited extension
extension DefaultExpenseViewTable: UITableViewDataSource {
	//Only 1 section for the expenses
	func numberOfSections(in tableView: UITableView) ->Int{
		return 1
	}
	//number of cells is equal to the number of expenses in the array
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allDefaultExpenses.count
	}
	//setup the tableview cell
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		//create cell object
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DefaultExpenseTableCell
		let expense = allDefaultExpenses[indexPath.row]
		
		//set the labels on the cell and cellDelegate
		cell.nameOfExpense.text = expense.name
		let amountString = String(format: "$%.02f", expense.price)
		cell.priceOfExpense.text = amountString
		
		return cell
	}
}
