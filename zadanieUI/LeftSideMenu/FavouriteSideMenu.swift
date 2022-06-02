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
        favLocation = self.citajPole(key: "FavouriteLocationTest2")
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
        print(favLocation[indexPath.row].country)
        
        let place = Place(city: favLocation[indexPath.row].city, country: favLocation[indexPath.row].country)
        self.presentWeatherDetail(with: place)
    }
    
    func presentWeatherDetail(with place: Place){
        let storyboard = UIStoryboard(name: "DetailViewController", bundle: nil)
        if let weatherViewControloer = storyboard.instantiateViewController(withIdentifier: "WeatherDetail") as? ViewController {
            weatherViewControloer.place = place
            navigationController?.pushViewController(weatherViewControloer, animated: true)
        }
    }

}

extension FavouriteSideMenu {
    func citajPole(key: String) -> [savingFavouriteLocation]{
        if let data = UserDefaults.standard.data(forKey: key) {
            do{
                let decoder = JSONDecoder()
                let arrayFavourite = try decoder.decode([savingFavouriteLocation].self, from: data)
                return arrayFavourite
            } catch {
                print("Unable to decode Notes \(error)")
            }
        }
        return []
    }

}
