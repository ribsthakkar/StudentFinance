//
//  ChartRangeView.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 7/3/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit


class ChartRangeView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		switch currentRange {
		case .Monthly:
			return 2
		default:
			return 1
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch currentRange {
		case .Monthly:
			return pickerDataSource[component].count
		default:
			return pickerDataSource[0].count
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
			return pickerDataSource[component][row]
	}
	
	@IBOutlet weak var navBar: UINavigationBar?
	weak var delegate: UpdateRangeDelegate?
	var currentRange:MainGraphViewController.DateRange = .Weekly
	var pickerDataSource: [[String]] = [[]]
//	var weekPicker:UIDatePicker? = nil
//	var otherPicker:UIPickerView? = nil
	var rangePicker:UIView? = nil
	var allExpenses = [Expense]()
	let dFormatter = DateFormatter()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		switch currentRange {
		case .Weekly:
			rangePicker = WeekPicker()
			let picker = rangePicker as! WeekPicker
			picker.weekPicker.datePickerMode = .date
			if let earliestDate = allExpenses.last?.date {
				picker.weekPicker.minimumDate = earliestDate as Date
			}
			if let latestDate = allExpenses.first?.date {
				picker.weekPicker.maximumDate = latestDate as Date
			}
		case .Monthly:
			rangePicker = OtherPicker()
			let picker = rangePicker as! OtherPicker
			picker.otherPicker.delegate = self
			picker.otherPicker.dataSource = self
			setupPickerData()
		case .Yearly:
			rangePicker = OtherPicker()
			let picker = rangePicker as! OtherPicker
			picker.otherPicker.delegate = self
			picker.otherPicker.dataSource = self
			setupPickerData()
		}
		if let pickerToDisplay = rangePicker {
			view.addSubview(pickerToDisplay)
			pickerToDisplay.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				pickerToDisplay.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
				pickerToDisplay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				pickerToDisplay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			])
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func setupPickerData() {
		switch currentRange {
		case .Monthly:
			pickerDataSource = [["January","February","March","April","May","June","July","August","Septemeber","October","November","December"],[]]
			for exp in allExpenses{
				dFormatter.dateFormat = "yyyy"
				let when = dFormatter.string(from: exp.date! as Date)
				if(pickerDataSource[1].contains(when) == false){
					pickerDataSource[1].append(when)
				}
			}
		default:
			for exp in allExpenses{
				dFormatter.dateFormat = "yyyy"
				let when = dFormatter.string(from: exp.date! as Date)
				if(pickerDataSource[0].contains(when) == false){
					print(when)
					pickerDataSource[0].append(when)
				}
			}
		}
	}
	
	@IBAction func done() {
		switch currentRange {
		case .Weekly:
			let picker = rangePicker as! WeekPicker
			var timeInterval = DateComponents()
			timeInterval.day = 7
			let date = Calendar.current.date(byAdding: timeInterval, to: picker.weekPicker.date)!
			delegate?.update(with: date, range: MainGraphViewController.DateRange.Weekly)
			dismiss(animated: true, completion: nil)
			print("Completed Week Range set")
		case .Monthly:
			if(pickerDataSource[1].count == 0) {
				delegate?.update(with: Date(), range: MainGraphViewController.DateRange.Monthly)
			} else {
				let picker = rangePicker as! OtherPicker
				let month = picker.otherPicker.selectedRow(inComponent: 0)  + 1
				let year = pickerDataSource[1][picker.otherPicker.selectedRow(inComponent: 1)]
				let when = "01/" + String(month) + "/" + String(year)
				dFormatter.dateFormat = "dd/MM/yyyy"
				if let updatedDate = dFormatter.date(from: when) {
					var timeInterval = DateComponents()
					timeInterval.day = -1
					timeInterval.month = 1
					let date = Calendar.current.date(byAdding: timeInterval, to: updatedDate)!
					delegate?.update(with: date, range: MainGraphViewController.DateRange.Monthly)
				}
			}
			print("Completed Month Range set")
			dismiss(animated: true, completion: nil)
		case .Yearly:
			let picker = rangePicker as! OtherPicker
			if(pickerDataSource.count == 0) {
				delegate?.update(with: Date(), range: MainGraphViewController.DateRange.Yearly)
			} else {
				let year = pickerDataSource[0][picker.otherPicker.selectedRow(inComponent: 0)]
				let when = "01/" + "01/" + year
				dFormatter.dateFormat = "dd/MM/yyyy"
				if let setDate = dFormatter.date(from: when){
					delegate?.update(with: setDate, range: MainGraphViewController.DateRange.Yearly)
				}
			}
			dismiss(animated: true, completion: nil)
			print("Completed Year Range set")
		}
	}

}

class WeekPicker: UIView {
	
	let weekPicker:UIDatePicker = {
		let weekPicker = UIDatePicker(frame: .zero)
		weekPicker.translatesAutoresizingMaskIntoConstraints = false
			return weekPicker
	} ()
	
	init() {
		super.init(frame: .zero)
		addSubview(weekPicker)
		constrainUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		return nil
	}
	
	private func constrainUI() {
	NSLayoutConstraint.activate([
	weekPicker.topAnchor.constraint(equalTo: topAnchor),
	weekPicker.leadingAnchor.constraint(equalTo: leadingAnchor),
	weekPicker.trailingAnchor.constraint(equalTo: trailingAnchor),
	weekPicker.bottomAnchor.constraint(equalTo: bottomAnchor),
	])
	}
}

class OtherPicker: UIView {
	
	let otherPicker:UIPickerView = {
		let otherPicker = UIPickerView(frame: .zero)
		otherPicker.translatesAutoresizingMaskIntoConstraints = false
		return otherPicker
	} ()
	
	init() {
		super.init(frame: .zero)
		addSubview(otherPicker)
		constrainUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		return nil
	}
	
	private func constrainUI() {
		NSLayoutConstraint.activate([
			otherPicker.topAnchor.constraint(equalTo: topAnchor),
			otherPicker.leadingAnchor.constraint(equalTo: leadingAnchor),
			otherPicker.trailingAnchor.constraint(equalTo: trailingAnchor),
			otherPicker.bottomAnchor.constraint(equalTo: bottomAnchor),
			])
	}
}
