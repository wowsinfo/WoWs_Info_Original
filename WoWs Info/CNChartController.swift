//
//  CNChartController.swift
//  WoWs Info
//
//  Created by Henry Quan on 17/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import Charts

class CNChartController: UITableViewController, ChartViewDelegate {

    @IBOutlet weak var battleLineChart: LineChartView!
    @IBOutlet weak var winrateLineChart: LineChartView!
    @IBOutlet weak var damageLineChart: LineChartView!
    var recentData = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Charts
        showAnimation()
        battleLineChart.delegate = self
        setupBattleLineChart()
        winrateLineChart.delegate = self
        setupWinrateLineChart()
        damageLineChart.delegate = self
        setupDamageLineChart()
        
        tableView.separatorColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Line Chart
    func setupBattleLineChart() {
        lineChartOptimised(chart: battleLineChart)
        let colour = UIColor(red: 35/255, green: 135/255, blue: 255/255, alpha: 1.0)
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<recentData.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(recentData[i][RecentData.dataIndex.battle])!)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: NSLocalizedString("CHART_BATTLE", comment: "Chart battle label"))
        chartDataSet.setColor(colour)
        chartDataSet.setCircleColor(colour)
        chartDataSet.circleRadius = 3.0
        chartDataSet.drawValuesEnabled = false
        let chartData = LineChartData.init(dataSets: [chartDataSet])
        battleLineChart.data = chartData
        
        let avg = getRecentAverage(index: RecentData.dataIndex.battle)
        let average = ChartLimitLine(limit: avg, label: String(format: "%.1f", avg))
        average.labelPosition = .rightBottom
        average.lineWidth = 0.5
        average.lineColor = colour
        battleLineChart.rightAxis.addLimitLine(average)
        
    }
    
    func setupWinrateLineChart() {
        lineChartOptimised(chart: winrateLineChart)
        let colour = UIColor(red: 77/255, green: 167/255, blue: 77/255, alpha: 1.0)
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<recentData.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(recentData[i][RecentData.dataIndex.win])!)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: NSLocalizedString("WIN_RATE", comment: "Chart battle label"))
        chartDataSet.setColor(colour)
        chartDataSet.setCircleColor(colour)
        chartDataSet.circleRadius = 3.0
        chartDataSet.drawValuesEnabled = false
        let chartData = LineChartData.init(dataSets: [chartDataSet])
        winrateLineChart.data = chartData
        
        let avg = getRecentAverage(index: RecentData.dataIndex.win)
        let average = ChartLimitLine(limit: avg, label: String(format: "%.1f", avg))
        average.labelPosition = .rightBottom
        average.lineWidth = 0.5
        average.lineColor = colour
        winrateLineChart.rightAxis.addLimitLine(average)
        
    }
    
    func setupDamageLineChart() {
        lineChartOptimised(chart: damageLineChart)
        let colour = UIColor(red: 201/255, green: 74/255, blue: 74/255, alpha: 1.0)
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<recentData.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(recentData[i][RecentData.dataIndex.damage])!)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: NSLocalizedString("AVG_DAMAGE", comment: "Chart battle label"))
        chartDataSet.setColor(colour)
        chartDataSet.setCircleColor(colour)
        chartDataSet.circleRadius = 3.0
        chartDataSet.drawValuesEnabled = false
        let chartData = LineChartData.init(dataSets: [chartDataSet])
        damageLineChart.data = chartData
        
        let avg = getRecentAverage(index: RecentData.dataIndex.damage)
        let average = ChartLimitLine(limit: avg, label: String(format: "%.0f", avg))
        average.labelPosition = .rightBottom
        average.lineWidth = 0.5
        average.lineColor = colour
        damageLineChart.rightAxis.addLimitLine(average)
        
    }
    
    func lineChartOptimised(chart: LineChartView) {
        chart.noDataText = "NO_INFORMATION".localised()
        chart.chartDescription?.text = ""
        
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.setLabelCount(recentData.count, force: false)
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawLabelsEnabled = false
        
        chart.rightAxis.drawLabelsEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
        
        chart.leftAxis.drawLabelsEnabled = true
        chart.leftAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawAxisLineEnabled = true
    }
    
    // MARK: Animation
    func showAnimation() {
        winrateLineChart.animate(xAxisDuration: 0.5)
        battleLineChart.animate(xAxisDuration: 0.5)
        damageLineChart.animate(xAxisDuration: 0.5)
    }
    
    // MARK: Recent Average
    func getRecentAverage(index: Int) -> Double {
        var sum = 0.0
        for data in recentData {
            sum += Double(data[index])!
        }
        
        // Calculate average
        return sum/Double(recentData.count)
    }
    
}
