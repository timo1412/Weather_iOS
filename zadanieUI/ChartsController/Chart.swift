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
//    MARK: Variables
    var valuesChart = [ChartDataEntry]()
    var title = String()
    var graphColor : NSUIColor
    var fillGraphColor : NSUIColor
    
//    MARK: Initialisation
    init(data: [ChartDataEntry] , titleChart: String , colorForGraph: NSUIColor , colorForFillGraph: NSUIColor) {
        valuesChart = data
        title = titleChart
        graphColor = colorForGraph
        fillGraphColor = colorForFillGraph
    }

//    MARK: Setup LineChartView
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .darkGray
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 10)
        yAxis.setLabelCount(8, force: false)
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
        
        xAxis.valueFormatter = DateValueFormatter()
        
        chartView.animate(xAxisDuration: 2.5)

        
        
        return chartView
    }()
//    MARK: Format chart
    func setData1() {
        let set1 = LineChartDataSet(entries: valuesChart, label: title)
//        zaobli vrcholi grafu
        set1.mode = .cubicBezier
//        nebude pri vrcholoch kreslit kruhy
        set1.drawCirclesEnabled = false
//        hrubka grafu
        set1.lineWidth = 3
//        farba grafu
        set1.setColor(graphColor)
//        vyfarbi plochu pod grafom
        set1.fill = ColorFill(color: fillGraphColor)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
//        odstranenie horizontalnej ciary ktora sa pohybuje s kurzorom
        set1.drawHorizontalHighlightIndicatorEnabled = false
//        zmeni farbu kurzorovej ciary
        set1.highlightColor = .magenta
        let data1 = LineChartData(dataSet: set1)
//        pri vrcholoch nebude zobrazovat hodnoty
        data1.setDrawValues(false)
        lineChartView.data=data1
    }
}
