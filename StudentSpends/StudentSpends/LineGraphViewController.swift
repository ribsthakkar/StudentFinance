//
//  LineChartViewController.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 1/4/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit
import Charts

class LineGraphViewController: MainGraphViewController {
	
	//Setup storyboard connections and class variables
	@IBOutlet weak var lineChart: LineChartView!
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
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
		lineChart.chartDescription?.text = "My Expenses"
	}
	
//	//if button is pressed, the view will segue to the pie chart which shows expenses by category
//    @IBAction func presentPieGraph(_ sender: Any) {
//        performSegue(withIdentifier: "categorySegue", sender: expensesByCategory)
//    }
	
    // MARK: - Navigation
	
	@IBAction func done() {
		self.dismiss(animated: true, completion: nil)
	}

}
