//
//  DefaultExpenseTableCell.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 4/8/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit

class DefaultExpenseTableCell: UITableViewCell {
	
	//Define all of the connections to nib and setup class variables
	
	@IBOutlet weak var priceOfExpense: UILabel!
	@IBOutlet weak var nameOfExpense: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		// Configure the view for the selected state
		//delegate.cellTapped(sender: self)
	}
	//clear out labels and delegate for the reused table cells
	override func prepareForReuse() {
		super.prepareForReuse()
		
		priceOfExpense.text = ""
		nameOfExpense.text = ""
	}
}
