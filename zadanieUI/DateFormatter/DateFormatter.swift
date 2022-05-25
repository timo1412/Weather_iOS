//
//  DateFormatter.swift
//  zadanieUI
//
//  Created by Timotej Čery on 26/04/2022.
//

import Foundation

extension DateFormatter {
//    toto sa vytvori iba raz a vždy ked to zavolam tak sa zavola to vytvorene nevytvára sa dalšie 
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


