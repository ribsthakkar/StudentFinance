//
//  ExpenseViewTable.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 12/31/17.
//  Copyright © 2017 ribsthak. All rights reserved.
//

import UIKit
import CoreData

class ExpenseViewTable: UIViewController {
	
	
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
		expenseTable.reloadData()
        // Do any additional setup after loading the view.
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
		return cell
	}
}

