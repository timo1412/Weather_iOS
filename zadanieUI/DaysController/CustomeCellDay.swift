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
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    func setupTable(with weather: Daily) {
        dayLabel.text = DateFormatter.dayDateFormartter.string(from: weather.date)
        tempLabel.text = weather.temperatureString
        rainLabel.text = weather.precipitationStrin
        
    }
    
}
