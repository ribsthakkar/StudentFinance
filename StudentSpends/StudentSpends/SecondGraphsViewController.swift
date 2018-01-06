//
//  SecondGraphsViewController.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 1/4/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit
import Charts

class SecondGraphsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		updatePieGraph()
        // Do any additional setup after loading the view.
    }
	override func viewDidAppear(_ animated: Bool) {
		updatePieGraph()
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	var expensesByCategory = [String: Double]()
	@IBOutlet weak var pieChart: PieChartView!

	func updatePieGraph() {
		
		let keys = Array(expensesByCategory.keys)
		var entries = [PieChartDataEntry]()
		
		for i in 0..<expensesByCategory.count {
			let dataEntry1 = PieChartDataEntry(value: expensesByCategory[keys[i]]!, label: keys[i])
			entries.append(dataEntry1) // here we add it to the data set
		}
		
		// 3. chart setup
		let set = PieChartDataSet( values: entries.reversed(), label: "Expenses")
		// this is custom extension method. Download the code for more details.
		var colors: [UIColor] = []
		
		for _ in 0..<keys.count {
			let red = Double(arc4random_uniform(256))
			let green = Double(arc4random_uniform(256))
			let blue = Double(arc4random_uniform(256))
			let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
			colors.append(color)
		}
		set.colors = colors
		let data = PieChartData(dataSet: set)
		pieChart.data = data
		pieChart.chartDescription?.text = "Expenses by type"
		pieChart.noDataText = "No data available"
		pieChart.holeRadiusPercent = 0.2
		pieChart.transparentCircleColor = UIColor.clear
	}
}
