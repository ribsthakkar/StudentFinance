//
//  UpdateMonthRange.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 1/18/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit

class UpdateMonthRange: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	var pickerDataSource:[[String]] = [["January","February","March","April","May","June","July","August","Septemeber","October","November","December"],[]]
	weak var delegate: UpdateRangeDelegate?
	// The number of rows of data
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerDataSource[component].count
	}
	
	// The data to return for the row and component (column) that's being passed in
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerDataSource[component][row]
	}
	//number of columns in data
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 2
	}
	@IBOutlet weak var monthYearOptions: UIPickerView!
	var allExpenses = [Expense]()
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		
		//Find all existing years in data source and add to picker list
		for exp in allExpenses{
			let year = DateFormatter()
			year.dateFormat = "yyyy"
			let when = year.string(from: exp.date! as Date)
			if(pickerDataSource[1].contains(when) == false){
				pickerDataSource[1].append(when)
			}
		}
		monthYearOptions.delegate = self
		monthYearOptions.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	@IBAction func done() {
		let month = monthYearOptions.selectedRow(inComponent: 0)  + 1
		let year = pickerDataSource[1][monthYearOptions.selectedRow(inComponent: 1)]
		let when = "01/" + String(month) + "/" + String(year)
		let dFormatter = DateFormatter()
		dFormatter.dateFormat = "dd/MM/yyyy"
		if let updatedDate = dFormatter.date(from: when) {
			var timeInterval = DateComponents()
			timeInterval.day = -1
			timeInterval.month = 1
			let date = Calendar.current.date(byAdding: timeInterval, to: updatedDate)!
			delegate?.update(with: date, range: LineGraphViewController.DateRange.Monthly)
		}
		dismiss(animated: true, completion: nil)
	}
}
