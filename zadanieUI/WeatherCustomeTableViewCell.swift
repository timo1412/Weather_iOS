//
//  WeatherCustomeTableViewCell.swift
//  zadanieUI
//
//  Created by Timotej Čery on 09/04/2022.
//

import UIKit

class WeatherCustomeTableViewCell: UITableViewCell {

    static var classString : String{
        String(describing: WeatherCustomeTableViewCell.self)
    }
    
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    func setupView (day: WeatherCell){
        dayLabel.text = day.day
        tempLabel.text = day.temp
        rainLabel.text = day.rainPer
    }
}
