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
class ExpenseViewTable: UIViewController, UITableViewDelegate, UpdateExpenseTableDelegate, UISearchBarDelegate {
	
	func update(with expense: Expense) {
		allExpenses.append(expense)
		filterTable()
		changed = true
	}
	func remove(with expense: Expense) {
		allExpenses.remove(at: allExpenses.index(of: expense)!)
		filterTable()
		changed = true
	}

	//instantiate class variables (table for expenses) and array of expenses
	@IBOutlet weak var expenseTable: UITableView!
	@IBOutlet var searchBar: UISearchBar!
	private let cellId = "expenseCell"
	var allExpenses = [Expense]()
	var showExpenses = [Expense]()
	var types = ["Food", "Travel", "Leisure", "Supplies", "Other"];
	var changed:Bool = false
	weak var delegate: DidDataUpdateDelegate?

	override func viewDidLoad() {
        super.viewDidLoad()
		// Do any additional setup after loading the view.
		expenseTable.delegate = self
		searchBar.delegate = self
		//apply nib for expense table cell
		expenseTable.register(UINib(nibName: "ExpenseTableCell", bundle: .main), forCellReuseIdentifier: cellId)
		
		let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
		let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
		let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ExpenseViewTable.doneButtonAction))
		toolbar.setItems([flexSpace, doneBtn], animated: false)
		toolbar.sizeToFit()
		searchBar.inputAccessoryView = toolbar
    }
	@objc func doneButtonAction() {
		self.view.endEditing(true)
	}
	// Search Bar
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		guard !searchText.isEmpty else {
			showExpenses = allExpenses.filter({ (exp) -> Bool in
				if searchBar.selectedScopeButtonIndex == 0 {
					return true
				} else {
					return exp.type! == types[searchBar.selectedScopeButtonIndex - 1]
				}
			})
			expenseTable.reloadData()
			return
		}
		showExpenses = allExpenses.filter({ (exp) -> Bool in
			guard let text = searchBar.text else {return false}
			if searchBar.selectedScopeButtonIndex == 0 {
				return exp.name!.lowercased().contains(text.lowercased())
			} else {
			return exp.name!.lowercased().contains(text.lowercased()) &&
			exp.type! == types[searchBar.selectedScopeButtonIndex - 1]
			}
		})
		expenseTable.reloadData()
	}
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		filterTable()
	}
	
	//Filtering Table
	func filterTable() {
		guard let searchText = searchBar.text else {
			showExpenses = allExpenses.filter({ (exp) -> Bool in
				if searchBar.selectedScopeButtonIndex == 0 {
					return true
				} else {
					return exp.type! == types[searchBar.selectedScopeButtonIndex - 1]
				}
			})
			expenseTable.reloadData()
			return
		}
		guard !searchText.isEmpty else {
			showExpenses = allExpenses.filter({ (exp) -> Bool in
				if searchBar.selectedScopeButtonIndex == 0 {
					return true
				} else {
					return exp.type! == types[searchBar.selectedScopeButtonIndex - 1]
				}
			})
			expenseTable.reloadData()
			return
		}
		showExpenses = allExpenses.filter({ (exp) -> Bool in
			guard let text = searchBar.text else {return false}
			if searchBar.selectedScopeButtonIndex == 0 {
				return exp.name!.lowercased().contains(text.lowercased())
			} else {
				return exp.name!.lowercased().contains(text.lowercased()) &&
					exp.type! == types[searchBar.selectedScopeButtonIndex - 1]
			}
		})
		expenseTable.reloadData()
	}
	
	// Navigation
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
		filterTable()
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
	
	
	// TableView
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "detailExpenseSegue", sender: showExpenses.reversed()[indexPath.row])
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
		return showExpenses.count
	}
	//setup the tableview cell
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		//create cell object
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ExpenseTableCell
		let expense = showExpenses[showExpenses.count - 1 - indexPath.row]
		
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
