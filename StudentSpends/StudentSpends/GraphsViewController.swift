//
//  LineChartViewController.swift
//  StudentSpends
//
//  Created by Rishabh Thakkar on 1/4/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit
import Charts

class GraphsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		updateLineGraph()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	var expensesByDate = [String: Double]()
	var expensesByCategory = [String: Double]()
	
    @IBOutlet weak var lineChart: LineChartView!

    func updateLineGraph(){
		var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
		let keys = Array(expensesByDate.keys)
		//here is the for loop
		for i in 0..<expensesByDate.count {
			let value = ChartDataEntry(x: Double(i), y: expensesByDate[keys[i]]!) // here we set the X and Y status in a data chart entry
			lineChartEntry.append(value) // here we add it to the data set
		}
		let line1 = LineChartDataSet(values: lineChartEntry, label: "Total Expenses") //Here we convert lineChartEntry to a LineChartDataSet
		line1.colors = [NSUIColor.blue] //Sets the colour to blue
		
		let data = LineChartData() //This is the object that will be added to the chart
		data.addDataSet(line1) //Adds the line to the dataSet
		
		lineChart.noDataText = "No data yet"
		lineChart.data = data //finally - it adds the chart data to the chart and causes an update
		lineChart.chartDescription?.text = "My Expenses" // Here we set the description for the graph
	}

    @IBAction func presentPieGraph(_ sender: Any) {
        performSegue(withIdentifier: "categorySegue", sender: expensesByCategory)
    }
    // MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
		if(segue.identifier == "categorySegue"){
			let dest = segue.destination as! SecondGraphsViewController
            dest.expensesByCategory = sender as! [String : Double]
		}
	}

}

