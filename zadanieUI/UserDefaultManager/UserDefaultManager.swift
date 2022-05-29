//
//  UserDefaultManager.swift
//  zadanieUI
//
//  Created by Timotej Čery on 29/05/2022.
//

import Foundation


class UserDefaultManager {
    static let shered = UserDefaultManager()
    
    let defaults = UserDefaults(suiteName: "com.test.saved.data")!
    
}
