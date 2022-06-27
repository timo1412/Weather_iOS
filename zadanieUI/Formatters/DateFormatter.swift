//
//  DateFormatter.swift
//  zadanieUI
//
//  Created by Timotej Čery on 26/04/2022.
//

import Foundation

extension DateFormatter {
    static let dayDateFormartter: DateFormatter = {
        let dateFormartter = DateFormatter()
        dateFormartter.dateFormat = "EEEE"
        
        return dateFormartter
    }()
    
    static let timeDateFormarttet: DateFormatter = {
        let timeFormartter = DateFormatter()
        timeFormartter.dateFormat = "E:HH:mm"
        return timeFormartter
    }()
    
    static let mediumDateFormartter: DateFormatter = {
        let dateFormartter = DateFormatter()
        dateFormartter.dateStyle = .full
        
        return dateFormartter
    }()
    
    
}


