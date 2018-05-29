//
//  UpdateDateRange.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 1/16/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit

protocol UpdateRangeDelegate: class {
	func update(with date: Date, range: MainGraphViewController.DateRange)
}

class UpdateWeekRange: UIViewController {

	@IBOutlet weak var dateUpdate: UIDatePicker!
	var allExpenses = [Expense]()
	weak var delegate: UpdateRangeDelegate?
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		//setup the earliest date for any expense
		if let earliestDate = allExpenses.last?.date {
			dateUpdate.minimumDate = earliestDate as Date
		}
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	@IBAction func done() {
		var timeInterval = DateComponents()
		timeInterval.day = 7
		let date = Calendar.current.date(byAdding: timeInterval, to: dateUpdate.date)!
		delegate?.update(with: date, range: MainGraphViewController.DateRange.Weekly)
		dismiss(animated: true, completion: nil)
	}


}
