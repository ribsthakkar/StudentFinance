//
//  ExpenseViewTable.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 12/31/17.
//  Copyright © 2017 ribsthak. All rights reserved.
//

import UIKit
import CoreData

class ExpenseViewTable: UIViewController, ExpenseTableViewCellDelegate {
	
	
	@IBOutlet weak var expenseTable: UITableView!
	
	private let cellId = "expenseCell"
	var allExpenses = [Expense]()
	override func viewDidLoad() {
        super.viewDidLoad()
		expenseTable.register(UINib(nibName: "ExpenseTableCell", bundle: .main), forCellReuseIdentifier: cellId)
		let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
		do{
			let expenses = try PersistanceService.context.fetch(fetchRequest)
			self.allExpenses = expenses
		} catch{}
		expenseTable.allowsSelection = false;
		expenseTable.reloadData()
        // Do any additional setup after loading the view.
    }
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		if segue.identifier == "detailExpenseSegue" {
			//Initial your second view data control
			let dest = segue.destination as! ExpenseDetails
			let expense = sender as! Expense
			dest.expenseObject = expense
		}
	}
	func cellTapped(sender: ExpenseTableCell) {
		if let indexPath = expenseTable.indexPath(for: sender) {
			performSegue(withIdentifier: "detailExpenseSegue", sender: allExpenses[indexPath.row])
		}
	}
}
extension ExpenseViewTable: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) ->Int{
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allExpenses.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ExpenseTableCell
		let expense = allExpenses[indexPath.row]
		cell.nameOfExpense.text = expense.name
		cell.priceOfExpense.text = String(format: "$%.02f", expense.price)
		cell.delegate = self
		return cell
	}
}

