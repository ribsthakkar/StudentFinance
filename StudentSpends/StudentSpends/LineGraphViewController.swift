//
//  LineChartViewController.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 1/4/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit
import Charts

class LineGraphViewController: UIViewController {
	
	//Setup storyboard connections and class variables
	@IBOutlet weak var lineChart: LineChartView!
    var expensesByDate = [String: Double]()
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	override func viewWillAppear(_ animated: Bool) {
		updateLineGraph()
	}
    func updateLineGraph(){
		//create ChartDataEntry object to hold the entries
		var lineChartEntry  = [ChartDataEntry]()
		//Access array of sorted keys from dictionary
		var keys = Array(expensesByDate.keys).sorted()
		//Format x-axis with the sorted keys
		lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: keys.sorted())
		
		//if keys are listed by month then format the x-axis by the given array of months
		if let _ = expensesByDate["01Jan"]{
			let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
			lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
		}
		//loop through the expenses and add them to the LineChartEntry array
		for i in 0..<expensesByDate.count {
			let value = ChartDataEntry(x: Double(i), y: expensesByDate[keys[i]]!)
			lineChartEntry.append(value)
		}
		//Create LineChartDataSet object
		let line1 = LineChartDataSet(values: lineChartEntry, label: "Total Expenses")
		line1.colors = [NSUIColor.blue] //Sets the colour to blue
		
		//Set the data and other descriptors for the lineChart
		let data = LineChartData()
		data.addDataSet(line1)
		lineChart.xAxis.granularityEnabled = true
		lineChart.xAxis.granularity = 1
		lineChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
		lineChart.noDataText = "No data yet"
		lineChart.data = data
		lineChart.data?.setValueFormatter(YAxisValueFormatter())
		lineChart.chartDescription?.text = "My Expenses"
	}

}
class YAxisValueFormatter: NSObject, IValueFormatter {
	
	func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
		return numFormatter.string(from: NSNumber(floatLiteral: value))!

	}
	
	
	let numFormatter: NumberFormatter
	
	override init() {
		numFormatter = NumberFormatter()
		numFormatter.minimumFractionDigits = 2
		numFormatter.maximumFractionDigits = 2
		
		// if number is less than 1 add 0 before decimal
		numFormatter.minimumIntegerDigits = 1 // how many digits do want before decimal
		numFormatter.paddingPosition = .beforePrefix
		numFormatter.paddingCharacter = "0"
	}
	
	/// Called when a value from an axis is formatted before being drawn.
	///
	/// For performance reasons, avoid excessive calculations and memory allocations inside this method.
	///
	/// - returns: The customized label that is drawn on the axis.
	/// - parameter value:           the value that is currently being drawn
	/// - parameter axis:            the axis that the value belongs to
	///
	

}
