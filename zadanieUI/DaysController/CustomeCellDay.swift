//
//  CustomeCellDay.swift
//  zadanieUI
//
//  Created by Timotej Čery on 22/05/2022.
//

import UIKit

class CustomeCellDay: UITableViewCell {

    static var classString: String {
        String(describing: CustomeCellDay.self)
    }
//    MARK: OUTLETS
    @IBOutlet weak var feelsTempLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dayIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    func setupCell(with weather: Daily) {
        dayLabel.text = DateFormatter.dayDateFormartter.string(from: weather.date)
        tempLabel.text = weather.temperatureString
        rainLabel.text = weather.precipitationStrin
        dayIcon.image = weather.weather.first?.image?.withRenderingMode(.alwaysOriginal)
        descLabel.text = weather.weather[0].weatherDescription
        feelsTempLabel.text = weather.feelsLikeStrin
        
    }
}
