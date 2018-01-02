//
//  ExpenseDetails.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 1/2/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit

class ExpenseDetails: UIViewController {

	@IBOutlet weak var expensePhoto: UIImageView!
	@IBOutlet weak var expenseName: UILabel!
	@IBOutlet weak var expenseCost: UILabel!
	@IBOutlet weak var expenseType: UILabel!
	@IBOutlet weak var expenseDate: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	 override func viewDidDisappear(_ animated: Bool) {
		expensePhoto.image = nil
		expenseName.text = ""
		expenseDate.text = ""
		expenseCost.text = ""
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
