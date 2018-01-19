//
//  UpdateDateRange.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 1/16/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit

class UpdateWeekRange: UIViewController {

	@IBOutlet weak var dateUpdate: UIDatePicker!
	var allExpenses = [Expense]()
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
    

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if(segue.identifier! == "returnWithUpdatedWeek"){
			let dest = segue.destination as! LineGraphViewController
			//setup neccessary data
			dest.week = true
			dest.allExpenses = allExpenses
			//set the date in the LineChartViewController to that of one week after desired date
			var timeInterval = DateComponents()
			timeInterval.day = 7
			dest.date = Calendar.current.date(byAdding: timeInterval, to: dateUpdate.date)!
		}
    }


}
