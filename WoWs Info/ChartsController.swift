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
    
    var data: Charts!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get data first
        data = Charts(data: PlayerShip.playerShipInfo)
        
        // Set up tier battles chart
        tierBattleBarChart.delegate = self
        setupTierBarChart()
        
        // Set up type pie chart
        typeBattlePieChart.delegate = self
        setupTypePieChart()
        
        // Set up Most Played 5 ships
        mostPlayedBarChart.delegate = self
        setupMostPlayedBarChart()
        
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

}
