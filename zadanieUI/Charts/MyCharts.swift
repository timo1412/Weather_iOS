//
//  MyCharts.swift
//  zadanieUI
//
//  Created by Timotej Čery on 20/05/2022.
//
import Charts
import TinyConstraints

import Foundation
class MyCharts {
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBlue
        
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .black
        yAxis.axisLineWidth = 3
        yAxis.labelPosition = .outsideChart
        
        let xAxis = chartView.xAxis
//        pozicia x-ovej osi
        xAxis.labelPosition = .bottom
//        fond pisma na osi
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
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
    
    
    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 10.0),
        ChartDataEntry(x: 2.0, y: 5.0),
        ChartDataEntry(x: 3.0, y: 3.0),
        ChartDataEntry(x: 4.0, y: 12.0),
        ChartDataEntry(x: 5.0, y: 4.0),
        ChartDataEntry(x: 6.0, y: 20.0),
        ChartDataEntry(x: 7.0, y: 17.0),
        ChartDataEntry(x: 8.0, y: 9.0),
        ChartDataEntry(x: 9.0, y: 2.0),
        ChartDataEntry(x: 10.0, y: 3.0),
        ChartDataEntry(x: 11.0, y: 3.0),
        ChartDataEntry(x: 12.0, y: 5.0),
        ChartDataEntry(x: 13.0, y: 1.0),
        ChartDataEntry(x: 14.0, y: 6.0),
        ChartDataEntry(x: 15.0, y: 7.0),
        ChartDataEntry(x: 16.0, y: 5.0),
        ChartDataEntry(x: 17.0, y: 17.0),
        ChartDataEntry(x: 18.0, y: 14.0),
        ChartDataEntry(x: 19.0, y: 11.0),
        ChartDataEntry(x: 20.0, y: 4.0),
        ChartDataEntry(x: 21.0, y: 17.0),
        ChartDataEntry(x: 22.0, y: 20.0),
        ChartDataEntry(x: 23.0, y: 30.0),
        ChartDataEntry(x: 24.0, y: 18.0),
        ChartDataEntry(x: 25.0, y: 19.0),
        ChartDataEntry(x: 26.0, y: 23.0),
        ChartDataEntry(x: 27.0, y: 26.0),
        ChartDataEntry(x: 28.0, y: 1.0),
        ChartDataEntry(x: 29.0, y: 10.0),
        ChartDataEntry(x: 30.0, y: 10.0),
        ChartDataEntry(x: 31.0, y: 10.0),
        ChartDataEntry(x: 32.0, y: 5.0),
        ChartDataEntry(x: 33.0, y: 3.0),
        ChartDataEntry(x: 34.0, y: 12.0),
        ChartDataEntry(x: 35.0, y: 4.0),
        ChartDataEntry(x: 36.0, y: 20.0),
        ChartDataEntry(x: 37.0, y: 17.0),
        ChartDataEntry(x: 38.0, y: 9.0),
        ChartDataEntry(x: 39.0, y: 2.0),
        ChartDataEntry(x: 40.0, y: 3.0)
    ]
}
