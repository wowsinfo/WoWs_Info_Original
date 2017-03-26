//
//  ChartsController.swift
//  WoWs Info
//
//  Created by Henry Quan on 19/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import Charts

class ChartsController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var averageTierLabel: UILabel!
    @IBOutlet weak var tierBattleBarChart: BarChartView!
    @IBOutlet weak var typeBattlePieChart: PieChartView!
    @IBOutlet weak var mostPlayedBarChart: HorizontalBarChartView!
    @IBOutlet weak var recentBattleLineChart: LineChartView!
    @IBOutlet weak var recentWinrateLineChart: LineChartView!
    @IBOutlet weak var recentDamageLineChart: LineChartView!
    @IBOutlet weak var screenshotBtn: UIButton!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var pageView: UIScrollView!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    var data: Charts!
    var recentData: [[String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get data first
        data = Charts(data: PlayerShip.playerShipInfo)
        // Get recent data as well
        recentData = RecentData.getRecentDataString()
        print(recentData)
        
        // Set up tier battles chart
        tierBattleBarChart.delegate = self
        setupTierBarChart()
        
        // Set up type pie chart
        typeBattlePieChart.delegate = self
        setupTypePieChart()
        
        // Set up Most Played 5 ships
        mostPlayedBarChart.delegate = self
        setupMostPlayedBarChart()
        
        // Well, sometimes there is no recent data
        if recentData.count > 1 {
            // Set up recent charts
            recentBattleLineChart.delegate = self
            setupRecentBattleLineChart()
            
            recentDamageLineChart.delegate = self
            setupRecentDamageLineChart()
            
            recentWinrateLineChart.delegate = self
            setupRecentWinrateLineChart()
        }
        
        playerNameLabel.text = PlayerAccount.AccountName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func barChartOptimised(chart: BarChartView, labelCount: Int) {
        
        chart.noDataText = "No information >_<"
        chart.isUserInteractionEnabled = false
        chart.chartDescription?.text = ""
        
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.setLabelCount(labelCount, force: false)
        chart.xAxis.drawGridLinesEnabled = false
        
        chart.rightAxis.drawLabelsEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
        
        chart.leftAxis.drawLabelsEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        
    }
    
    // MARK: Setup charts
    func setupMostPlayedBarChart() {
        
        var mostPlayedInformation = data.getMostPlayedShipInformation()
        barChartOptimised(chart: mostPlayedBarChart, labelCount: 5)
        mostPlayedBarChart.rightAxis.drawLabelsEnabled = true
        mostPlayedBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: mostPlayedInformation.1)
        
        // For those who never played 4 ships
        if mostPlayedInformation.0.count > 4 {
            var dataEntries: [BarChartDataEntry] = []
            for i in 0...4 {
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(mostPlayedInformation.0[i]))
                dataEntries.append(dataEntry)
            }
            
            let chartDataSet = BarChartDataSet(values: dataEntries, label: NSLocalizedString("CHART_BATTLE", comment: "Chart battle label"))
            chartDataSet.colors = ChartColorTemplates.vordiplom()
            chartDataSet.valueFont = UIFont.systemFont(ofSize: 10)
            let chartData = BarChartData.init(dataSets: [chartDataSet])
            mostPlayedBarChart.data = chartData
        }
        
    }
    
    func setupTypePieChart() {
        
        let typeAxis = [NSLocalizedString("DD", comment: "Destoryer"), NSLocalizedString("CA", comment: "Cruiser"), NSLocalizedString("BB", comment: "Battleship"), NSLocalizedString("CV", comment: "Aircraft Carrier")]
        typeBattlePieChart.chartDescription?.text = ""
        typeBattlePieChart.drawEntryLabelsEnabled = false
        let typeInformation = data.getShipTypeInformation()
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0...3 {
            let dataEntry = PieChartDataEntry(value: Double(typeInformation[i]), label: typeAxis[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = ChartColorTemplates.material()
        chartDataSet.valueFont = UIFont.systemFont(ofSize: 12)
        let chartData = PieChartData.init(dataSets: [chartDataSet])
        typeBattlePieChart.data = chartData

    }
    
    func setupTierBarChart() {
        
        // Make it look better
        let tierAxis = ["I","II","III","IV","V","VI","VII","VIII","IX","X"]
        barChartOptimised(chart: tierBattleBarChart, labelCount: 10)
        tierBattleBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: tierAxis)
        
        let tierInformation = data.getTierInformation()
        
        // Set up average tier label
        averageTierLabel.text = NSLocalizedString("AVERAGE_TIER", comment: "Avergae tier label") + String.init(format: "%.2f", getAverageTier(data: tierInformation))
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0...9 {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(tierInformation[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: NSLocalizedString("CHART_BATTLE", comment: "Chart battle label"))
        chartDataSet.colors = ChartColorTemplates.joyful()
        chartDataSet.valueFont = UIFont.systemFont(ofSize: 12)
        let chartData = BarChartData.init(dataSets: [chartDataSet])
        tierBattleBarChart.data = chartData
        
    }
    
    func lineChartOptimised(chart: LineChartView) {
        
        chart.noDataText = "No recent infomation >_<"
        chart.isUserInteractionEnabled = false
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

    
    func setupRecentBattleLineChart() {
        lineChartOptimised(chart: recentBattleLineChart)
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
        recentBattleLineChart.data = chartData
        
        let avg = getRecentAverage(index: RecentData.dataIndex.battle)
        let average = ChartLimitLine(limit: avg, label: String(format: "%.1f", avg))
        average.labelPosition = .rightBottom
        average.lineWidth = 0.5
        average.lineColor = colour
        recentBattleLineChart.rightAxis.addLimitLine(average)
        
    }
    
    func setupRecentWinrateLineChart() {
        lineChartOptimised(chart: recentWinrateLineChart)
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
        recentWinrateLineChart.data = chartData
        
        let avg = getRecentAverage(index: RecentData.dataIndex.win)
        let average = ChartLimitLine(limit: avg, label: String(format: "%.1f", avg))
        average.labelPosition = .rightBottom
        average.lineWidth = 0.5
        average.lineColor = colour
        recentWinrateLineChart.rightAxis.addLimitLine(average)
        
    }
    
    func setupRecentDamageLineChart() {
        lineChartOptimised(chart: recentDamageLineChart)
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
        recentDamageLineChart.data = chartData
        
        let avg = getRecentAverage(index: RecentData.dataIndex.damage)
        let average = ChartLimitLine(limit: avg, label: String(format: "%.0f", avg))
        average.labelPosition = .rightBottom
        average.lineWidth = 0.5
        average.lineColor = colour
        recentDamageLineChart.rightAxis.addLimitLine(average)
        
    }
    
    // MARK: Average Tier
    func getAverageTier(data: [Int]) -> Double {
        
        // (Tier1 * Battle + Tier2 * Battle + ... + Tier10 * Battle)/Total Battles
        var totalTier = 0.0
        var totalBattle = 0.0
        var index = 0
        
        for tier in data {
            index += 1
            totalBattle += Double(tier)
            totalTier += Double(tier * index)
        }
        
        return totalTier / totalBattle
        
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
    
    // MARK: Screenshot
    @IBAction func screenshotBtnPressed(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(self.pageView.contentSize, true, UIScreen.main.scale)
        self.scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        self.screenshotBtn.isEnabled = false
    }
    

}
