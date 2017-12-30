//
//  AddExpenseView.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 12/30/17.
//  Copyright © 2017 ribsthak. All rights reserved.
//

import UIKit
import CoreData

class AddExpenseView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBOutlet var expenseName: UITextField!
	@IBOutlet var expensePrice: UITextField!
	@IBOutlet var expenseDate: UIDatePicker!
	@IBOutlet var expenseType: UIPickerView!
	
	@IBAction func buttonSave(){
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
