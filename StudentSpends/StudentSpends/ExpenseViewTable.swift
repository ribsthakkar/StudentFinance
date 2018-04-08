//
//  ExpenseViewTable.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 12/31/17.
//  Copyright © 2017 ribsthak. All rights reserved.
//

import UIKit
import CoreData
protocol DidDataUpdateDelegate: class {
	func updated(yes: Bool)
}
class ExpenseViewTable: UIViewController, ExpenseTableViewCellDelegate, UpdateExpenseTableDelegate {
	
	func update(with expense: Expense) {
		allExpenses.append(expense)
		expenseTable.reloadData()
		changed = true
	}
	func remove(with expense: Expense) {
		allExpenses.remove(at: allExpenses.index(of: expense)!)
		expenseTable.reloadData()
		changed = true
	}
	//instantiate class variables (table for expenses) and array of expenses
	@IBOutlet weak var expenseTable: UITableView!
	private let cellId = "expenseCell"
	var allExpenses = [Expense]()
	var changed:Bool = false
	weak var delegate: DidDataUpdateDelegate?

	override func viewDidLoad() {
        super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		//apply nib for expense table cell
		expenseTable.register(UINib(nibName: "ExpenseTableCell", bundle: .main), forCellReuseIdentifier: cellId)
		expenseTable.allowsSelection = false;
		expenseTable.reloadData()
    }
	
	//prepare for segue to look at further details about a specific expense
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		if segue.identifier == "detailExpenseSegue" {
			//pass the expense object to the destination segue
			let dest = segue.destination as! ExpenseDetails
			let expense = sender as! Expense
			dest.expenseObject = expense
			dest.delegate = self
		}
		if segue.identifier == "addExpenseSegue" {
			let dest = segue.destination as! AddExpenseView
			dest.delegate = self
		}
	}
	//function called to perfom segue with a specific cell is tapped
	func cellTapped(sender: ExpenseTableCell) {
		if let indexPath = expenseTable.indexPath(for: sender) {
			performSegue(withIdentifier: "detailExpenseSegue", sender: allExpenses[indexPath.row])
		}
	}
	@IBAction func done() {
		delegate?.updated(yes: changed)
		changed = false
		self.dismiss(animated: true, completion: nil)
	}
}

//DataSource inherited extension
extension ExpenseViewTable: UITableViewDataSource {
	//Only 1 section for the expenses
	func numberOfSections(in tableView: UITableView) ->Int{
		return 1
	}
	//number of cells is equal to the number of expenses in the array
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allExpenses.count
	}
	//setup the tableview cell
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		//create cell object
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ExpenseTableCell
		let expense = allExpenses[indexPath.row]
		
		//set the labels on the cell and cellDelegate
		cell.nameOfExpense.text = expense.name
		let dFormatter = DateFormatter()
		dFormatter.dateFormat = "MM/dd/yyyy"
		cell.dateOfExpense.text = dFormatter.string(from: expense.date! as Date)
		cell.delegate = self
		return cell
	}
}

