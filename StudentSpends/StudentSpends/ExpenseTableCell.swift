//
//  ExpenseTableCell.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 12/31/17.
//  Copyright © 2017 ribsthak. All rights reserved.
//

import UIKit
protocol ExpenseTableViewCellDelegate: class {
	func cellTapped(sender: ExpenseTableCell)
}
class ExpenseTableCell: UITableViewCell {
	
	
	@IBOutlet weak var priceOfExpense: UILabel!
	@IBOutlet weak var nameOfExpense: UILabel!
	
	weak var delegate: ExpenseTableViewCellDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	@IBAction func infoTapped() {
		delegate?.cellTapped(sender: self)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		priceOfExpense.text = ""
		nameOfExpense.text = ""
		delegate = nil
	}
}
