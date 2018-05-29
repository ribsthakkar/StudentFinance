//
//  UpdateYearRange.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 1/18/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit

class UpdateYearRange: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	weak var delegate: UpdateRangeDelegate?
	var pickerDataSource:[String] = []
	// The number of rows of data
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerDataSource.count
	}
	
	// The data to return for the row and component (column) that's being passed in
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerDataSource[row]
	}
	//number of columns in data
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	
	var allExpenses = [Expense]()

	@IBOutlet weak var yearOptions: UIPickerView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		//Find all existing years in expense list and add to picker list
		for exp in allExpenses{
			let year = DateFormatter()
			year.dateFormat = "yyyy"
			let when = year.string(from: exp.date! as Date)
			if(pickerDataSource.contains(when) == false){
				print(when)
				pickerDataSource.append(when)
			}
		}
		yearOptions.delegate = self
		yearOptions.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func done() {
		//send the first of the specified year to LineGraphViewController
		if(pickerDataSource.count == 0) {
			delegate?.update(with: Date(), range: MainGraphViewController.DateRange.Yearly)
		} else {
			let year = pickerDataSource[yearOptions.selectedRow(inComponent: 0)]
			let when = "01/" + "01/" + String(year)
			let dFormatter = DateFormatter()
			dFormatter.dateFormat = "dd/MM/yyyy"
			if let setDate = dFormatter.date(from: when){
				delegate?.update(with: setDate, range: MainGraphViewController.DateRange.Yearly)
			}
		}
		dismiss(animated: true, completion: nil)
	}

}
