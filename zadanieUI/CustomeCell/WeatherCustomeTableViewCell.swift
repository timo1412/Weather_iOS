//
//  WeatherCustomeTableViewCell.swift
//  zadanieUI
//
//  Created by Timotej Čery on 09/04/2022.
//

import UIKit

class WeatherCustomeTableViewCell: UITableViewCell {

//    MARK: static
    static var classString : String{ String(describing: WeatherCustomeTableViewCell.self) }
    
    
//    MARK: outlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
}

extension WeatherCustomeTableViewCell {
    
    func setupCell (with hour : Current){
        dayLabel.text = DateFormatter.timeDateFormarttet.string(from: hour.date)
        weatherIcon.image = hour.weather.first?.image?.withRenderingMode(.alwaysOriginal)
        rainLabel.text = hour.precipitationString
        tempLabel.text = hour.temperatureInCelzius
        
    }
}
