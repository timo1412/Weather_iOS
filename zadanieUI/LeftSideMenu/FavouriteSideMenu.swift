//
//  FavouriteSideMenu.swift
//  zadanieUI
//
//  Created by Timotej Čery on 30/05/2022.
//

import Foundation
import UIKit

class FavouriteSideMenu : UITableViewController {
    var items = ["Prievidza","Žilina"]
    let darkColor = UIColor(red: 33/255.0,
                            green: 33/255.0,
                            blue: 33/255.0,
                            alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = darkColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = darkColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
    }
}

