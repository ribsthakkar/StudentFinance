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
	var lockWeek = false
	var lockMonth = false
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
			
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
