//
//  ExpenseTableCell.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 12/31/17.
//  Copyright © 2017 ribsthak. All rights reserved.
//

import UIKit
class ExpenseTableCell: UITableViewCell {
	
	//Define all of the connections to nib and setup class variables
	
	@IBOutlet weak var dateOfExpense: UILabel!
	@IBOutlet weak var nameOfExpense: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	//clear out labels and delegate for the reused table cells
	override func prepareForReuse() {
		super.prepareForReuse()
		
		dateOfExpense.text = ""
		nameOfExpense.text = ""
	}
}
