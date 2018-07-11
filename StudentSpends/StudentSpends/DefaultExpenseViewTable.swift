//
//  DefaultExpenseView.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 3/12/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit
import CoreData

protocol InsertDefaultInfoDelegate: class {
	func insertDefaults(sender: ExpenseDefault)
}
class DefaultExpenseViewTable: UIViewController, UITableViewDelegate {
	//instantiate class variables (table for expenses) and array of expenses
	@IBOutlet weak var expenseTable: UITableView!
	private let cellId = "defaultExpenseCell"
	var allDefaultExpenses = [ExpenseDefault]()
	weak var delegate: AddExpenseView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		//apply nib for expense table cell
		expenseTable.register(UINib(nibName: "DefaultExpenseTableCell", bundle: .main), forCellReuseIdentifier: cellId)
		expenseTable.dataSource = self
		expenseTable.reloadData()
		expenseTable.delegate = self
	}
	override func viewWillAppear(_ animated: Bool) {
		getData()
		expenseTable.reloadData()
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let index = indexPath.row
		delegate?.insertDefaults(sender: allDefaultExpenses[index])
		tableView.deselectRow(at: indexPath, animated: true)
		done()
	}
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") {
			(action, indexPath) in
			let removeDefault = self.allDefaultExpenses[indexPath.row]
			self.allDefaultExpenses.remove(at: indexPath.row)
			PersistanceService.context.delete(removeDefault)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
		return [deleteAction]
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
