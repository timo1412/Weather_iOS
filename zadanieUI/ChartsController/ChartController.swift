//
//  ChartController.swift
//  zadanieUI
//
//  Created by Timotej Čery on 22/05/2022.
//

import Foundation
import UIKit
import Charts


class ChartController: UIViewController{
//    MARK: Outlets
    @IBOutlet weak var tempCharLabel: UILabel!
    @IBOutlet weak var rainChartLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
//    MARK: Variables
    var location: CurrentLocation?
    var dataChart = [Current]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.onAuthorizationChange { auhorize in
            if auhorize {
                self.updateLocation()
            }
        }
        
        if LocationManager.shared.denied {
            print("Denied permission")
        } else {
            updateLocation()
        }
    }
    
    func setupChartView(with weatherData: HourlyResponse) {
        rainChartLabel.text = "Chart for rain precipitation"
        tempCharLabel.text = "Chart for temperature"
        let tempData = self.pripravTeplotuPreGraf(data: weatherData)
        let rainData = self.pripravDazdPreGraf(data: weatherData)
        self.drawLineChart(data: tempData,poradie: 1)
        self.drawLineChart(data: rainData,poradie: 2)
    }
    
    func drawLineChart(data: [ChartDataEntry] , poradie:Int) {
        if poradie == 1 {
            let firstChart = myLineChart(data: data,
                                         titleChart: "Temperature",
                                         colorForGraph: .red,
                                         colorForFillGraph: .clear)
            
            topView.addSubview(firstChart.lineChartView)
            firstChart.setData1()
            firstChart.lineChartView.center(in: topView)
            firstChart.lineChartView.width(to: topView)
            firstChart.lineChartView.height(250)
        } else {
            let seccondCharts = myLineChart(data: data,
                                            titleChart: "Rain precipitation",
                                            colorForGraph: .blue,
                                            colorForFillGraph: .systemBlue)
            
            bottomView.addSubview(seccondCharts.lineChartView)
            seccondCharts.setData1()
            seccondCharts.lineChartView.center(in: bottomView)
            seccondCharts.lineChartView.width(to: bottomView)
            seccondCharts.lineChartView.height(250)
        }
    }
}

//MARK: Priprava dat pre grafy 
extension ChartController {
    func pripravTeplotuPreGraf(data:HourlyResponse)->[ChartDataEntry] {
        var tempChartData = [ChartDataEntry]()
        
        data.hourly.forEach {
            tempChartData.append(ChartDataEntry(
                x: $0.date.timeIntervalSince1970,
                y: $0.temperature))
        }
        return tempChartData
    }
    
    func pripravDazdPreGraf(data:HourlyResponse)->[ChartDataEntry] {
        var rainChartData = [ChartDataEntry]()
        
        data.hourly.forEach{
            rainChartData.append(ChartDataEntry(x: $0.date.timeIntervalSince1970,
                                                y: $0.precipitation ?? 0.0))
        }
        
        return rainChartData
    }
}
//MARK: Request & Location
extension ChartController {
    @objc func loadData() {
        guard let location = location else{
            return
        }
        
        RequestManager.shered.getHourlyWeather(for: location.coordinates) { response in
            switch response {
            case .success(let weatherData):
                print("Succes")
                self.setupChartView(with: weatherData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func updateLocation() {
        LocationManager.shared.getLocation { [weak self] location, error in
            guard let self = self else { return }
            
            if let error = error{
            
            } else {
                if let location = location {
                    self.location = location
                    self.loadData()
                }
            }
        }
    }
}















//
//[
//    ChartDataEntry(x: 0.0, y: 10.0),
//    ChartDataEntry(x: 2.0, y: 5.0),
//    ChartDataEntry(x: 3.0, y: 3.0),
//    ChartDataEntry(x: 4.0, y: 12.0),
//    ChartDataEntry(x: 5.0, y: 4.0),
//    ChartDataEntry(x: 6.0, y: 20.0),
//    ChartDataEntry(x: 7.0, y: 17.0),
//    ChartDataEntry(x: 8.0, y: 9.0),
//    ChartDataEntry(x: 9.0, y: 2.0),
//    ChartDataEntry(x: 10.0, y: 3.0),
//    ChartDataEntry(x: 11.0, y: 3.0),
//    ChartDataEntry(x: 12.0, y: 5.0),
//    ChartDataEntry(x: 13.0, y: 1.0),
//    ChartDataEntry(x: 14.0, y: 6.0),
//    ChartDataEntry(x: 15.0, y: 7.0),
//    ChartDataEntry(x: 16.0, y: 5.0),
//    ChartDataEntry(x: 17.0, y: 17.0),
//    ChartDataEntry(x: 18.0, y: 14.0),
//    ChartDataEntry(x: 19.0, y: 11.0),
//    ChartDataEntry(x: 20.0, y: 4.0),
//    ChartDataEntry(x: 21.0, y: 17.0),
//    ChartDataEntry(x: 22.0, y: 20.0),
//    ChartDataEntry(x: 23.0, y: 30.0),
//    ChartDataEntry(x: 24.0, y: 18.0),
//    ChartDataEntry(x: 25.0, y: 19.0),
//    ChartDataEntry(x: 26.0, y: 23.0),
//    ChartDataEntry(x: 27.0, y: 26.0),
//    ChartDataEntry(x: 28.0, y: 1.0),
//    ChartDataEntry(x: 29.0, y: 10.0),
//    ChartDataEntry(x: 30.0, y: 10.0),
//    ChartDataEntry(x: 31.0, y: 10.0),
//    ChartDataEntry(x: 32.0, y: 5.0),
//    ChartDataEntry(x: 33.0, y: 3.0),
//    ChartDataEntry(x: 34.0, y: 12.0),
//    ChartDataEntry(x: 35.0, y: 4.0),
//    ChartDataEntry(x: 36.0, y: 20.0),
//    ChartDataEntry(x: 37.0, y: 17.0),
//    ChartDataEntry(x: 38.0, y: 9.0),
//    ChartDataEntry(x: 39.0, y: 2.0),
//    ChartDataEntry(x: 40.0, y: 3.0)
//]
