//
//  Chart.swift
//  zadanieUI
//
//  Created by Timotej Čery on 21/05/2022.
//

import Foundation
import Charts
import TinyConstraints

class myLineChart {
    
    var yValues = [ChartDataEntry]()
    var pomString = String()
    init(data: [ChartDataEntry]) {
        yValues = data
    }

    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBlue
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 10)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .black
        yAxis.axisLineWidth = 3
        yAxis.labelPosition = .outsideChart
        let xAxis = chartView.xAxis
//        pozicia x-ovej osi
        xAxis.labelPosition = .bottom
//        fond pisma na osi
        xAxis.labelFont = .boldSystemFont(ofSize:10)
//        pocet zobrazovanych hodnot na osi
        xAxis.setLabelCount(18, force: false)
//        farba hodnot na osi x
        xAxis.labelTextColor = .white
//        hrubka osi x
        xAxis.axisLineWidth = 3
//        farba osi x
        xAxis.axisLineColor = .black
//        xAxis.valueFormatter = self.lineChartView.xAxis.valueFormatter
        
        chartView.animate(xAxisDuration: 2.5)
//        xAxis.valueFormatter?.stringForValue(5.9, axis: xAxis)
        
        
        return chartView
    }()
        
    func setData1() {
        let set1 = LineChartDataSet(entries: yValues, label: "Title charts")
//        zaobli vrcholi grafu
        set1.mode = .cubicBezier
//        nebude pri vrcholoch kreslit kruhy
        set1.drawCirclesEnabled = false
//        hrubka grafu
        set1.lineWidth = 3
//        farba grafu
        set1.setColor(.red)
//        vyfarbi plochu pod grafom
        set1.fill = ColorFill(color: .white)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
//        odstranenie horizontalnej ciary ktora sa pohybuje s kurzorom
        set1.drawHorizontalHighlightIndicatorEnabled = false
//        zmeni farbu kurzorovej ciary
        set1.highlightColor = .systemRed
        let data1 = LineChartData(dataSet: set1)
//        pri vrcholoch nebude zobrazovat hodnoty
        data1.setDrawValues(false)
        lineChartView.data=data1
    }
    
    func naplnGrafDatami() {
//        let yValues = [ChartDataEntry]
        for i in 1...30 {
            yValues.append(ChartDataEntry(x: Double(i)+1.4, y: Double(i)+0.89))
        }
    }
}

//extension myLineChart : IndexAxisValueFormatter {
//
//}
