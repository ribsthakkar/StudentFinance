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
	
	//Define all of the connections to nib and setup class variables
	@IBOutlet weak var priceOfExpense: UILabel!
	@IBOutlet weak var nameOfExpense: UILabel!
    @IBOutlet weak var moreInfo: UIButton!
	weak var delegate: ExpenseTableViewCellDelegate!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        //delegate.cellTapped(sender: self)
    }
	
	//call the cellTapped fucntion when the moreInfo button is tapped
	@IBAction func infoTapped() {
		delegate.cellTapped(sender: self)
	}
	
	//clear out labels and delegate for the reused table cells
	override func prepareForReuse() {
		super.prepareForReuse()
		
		priceOfExpense.text = ""
		nameOfExpense.text = ""
		delegate = nil
	}
}
