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
class ExpenseViewTable: UIViewController, UITableViewDelegate, UpdateExpenseTableDelegate {
	
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
		expenseTable.delegate = self
		//apply nib for expense table cell
		expenseTable.register(UINib(nibName: "ExpenseTableCell", bundle: .main), forCellReuseIdentifier: cellId)
		expenseTable.reloadData()
    }
	
	override func willMove(toParentViewController parent: UIViewController?) {
		super.willMove(toParentViewController: parent)
		done()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if changed {
			allExpenses.sort(by: {
				let date0 = $0.date! as Date
				let date1 = $1.date! as Date
				return date0 < date1
			})
		}
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
			let dest = segue.destination as! UINavigationController
			let realDest = dest.viewControllers[0] as! AddExpenseView
			realDest.delegate = self
		}
	}	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "detailExpenseSegue", sender: allExpenses[allExpenses.count - 1 - indexPath.row])
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func done() {
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
		let expense = allExpenses[allExpenses.count - 1 - indexPath.row]
		
		//set the labels on the cell and cellDelegate
		cell.nameOfExpense.text = expense.name
		let dFormatter = DateFormatter()
		dFormatter.dateFormat = "MM/dd/yyyy"
		if let date = expense.date {
			cell.dateOfExpense.text = dFormatter.string(from: date as Date)
		}
		return cell
	}
}
