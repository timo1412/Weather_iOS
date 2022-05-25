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
    
    var yValues: [ChartDataEntry]
    var data: [Double]
    
    init(data:[Double]) {
        self.data = data
        yValues = [
            ChartDataEntry(x: 0.0, y: 1.0),
            ChartDataEntry(x: 2.0, y: 2.0),
            ChartDataEntry(x: 3.0, y: 3.0),
            ChartDataEntry(x: 4.0, y: 4.0)
        ]
    }
    
    func pripravData() {
        
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
        
        xAxis.setLabelCount(10, force: false)
//        farba hodnot na osi x
        xAxis.labelTextColor = .white
//        hrubka osi x
        xAxis.axisLineWidth = 3
//        farba osi x
        xAxis.axisLineColor = .black

        chartView.animate(xAxisDuration: 2.5)

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
    
     
}

