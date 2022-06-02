//
//  FavouriteSideMenu.swift
//  zadanieUI
//
//  Created by Timotej Čery on 30/05/2022.
//

import Foundation
import UIKit

class FavouriteSideMenu : UITableViewController {
    var favLocation = [savingFavouriteLocation]()
    let darkColor = UIColor(red: 33/255.0,
                            green: 33/255.0,
                            blue: 33/255.0,
                            alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favLocation = self.citajPole(key: "FavouriteLocationTest")
        tableView.backgroundColor = darkColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favLocation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)
        cell.textLabel?.text = favLocation[indexPath.row].city
        cell.textLabel?.textColor = .white
        cell.backgroundColor = darkColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(favLocation[indexPath.row].city)
        print(favLocation[indexPath.row].lat)
    }
}

extension FavouriteSideMenu {
    func citajPole(key: String) -> [savingFavouriteLocation]{
        if let data = UserDefaults.standard.data(forKey: key) {
            do{
                let decoder = JSONDecoder()
                let notes = try decoder.decode([savingFavouriteLocation].self, from: data)
                return notes
            } catch {
                print("Unable to decode Notes \(error)")
            }
        }
        return []
    }

}
