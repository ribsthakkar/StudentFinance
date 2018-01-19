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
    

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if(segue.identifier == "returnWithUpdatedMonth"){
			let dest = segue.destination as! LineGraphViewController
			//setup neccessary data
			dest.month = true
			dest.allExpenses = allExpenses
			//set the date to the last day of specified month in LineGraphViewController
			let month = monthYearOptions.selectedRow(inComponent: 0)  + 1
			let year = pickerDataSource[1][monthYearOptions.selectedRow(inComponent: 1)]
			let when = "01/" + String(month) + "/" + String(year)
			let dFormatter = DateFormatter()
			dFormatter.dateFormat = "dd/MM/yyyy"
			if let updatedDate = dFormatter.date(from: when) {
				var timeInterval = DateComponents()
				timeInterval.day = -1
				timeInterval.month = 1
				dest.month = true
				dest.date = Calendar.current.date(byAdding: timeInterval, to: updatedDate)!
			}
		}
		
    }


}
