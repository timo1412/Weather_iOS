//
//  ViewController.swift
//  zadanieUI
//
//  Created by Timotej Čery on 08/04/2022.
//

import UIKit
import CoreLocation
struct WeatherCell{
    let day : String
    let temp:String
    let rainPer: String
    
}


class ViewController: UIViewController {

    
//    MARK: outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temptLabel: UILabel!
    @IBOutlet weak var locatIcony: UIImageView!
    @IBOutlet weak var descWeatherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var feelTemptLabel: UILabel!
//    MARK: variables
    var weatherDays: [WeatherCell] {
        [WeatherCell(day: "Pondelok", temp: " 19°", rainPer:"20%"),
         WeatherCell(day: "Utorok  ", temp: " 19°", rainPer:"15%"),
         WeatherCell(day: "Streda  ", temp: " 19°", rainPer:"18%"),
         WeatherCell(day: "Štvrtok ", temp: " 11°", rainPer:"10%"),
         WeatherCell(day: "Piatok  ", temp: " 8° ", rainPer:" 9%"),
         WeatherCell(day: "Sobota  ", temp: " 15°", rainPer:"14%"),
         WeatherCell(day: "Nedela  ", temp: " 25°", rainPer:"25%")
        ]
    }
    

    
//    MARK: lifecycle
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: WeatherCustomeTableViewCell.classString, bundle: nil ), forCellReuseIdentifier: WeatherCustomeTableViewCell.classString)
        LocationManager.shered.getLocation{ [weak self] location , error in
            if let error = error {
                print("Tu je chyba")
            } else if let location = location {
                self?.locationLabel.text = location.city

            }
            
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController : UITableViewDataSource {
//    POČET SEKCII V TABLE VIEW KED MAM POČET SEKCII 2 a v jednej sekcii mam 7 dni tak mi vráti 14 riadkov
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    //    FUNKCIA KTORÁ VRÁTI POČET RIADKOV V TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDays.count
            //ZABEZPOECI ZOBRAZOVANIE IBA PRVÝCH 3 DNÍ
            //        if section == 0 {
            //            return 3
            //        } else {
            //            return weatherDays.count
            //        }
        }
//    FUNKCIA KTORÁ NAFORMÁTUJE JEDNOTLIVE CELLS AK MOJA weatherCell NIE JE JE AKO WeatherTableViewCell TAK VRÁTIM PRÁZDNU TABULKU
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: WeatherCustomeTableViewCell.classString, for: indexPath) as? WeatherCustomeTableViewCell else {
            return UITableViewCell()
        }
//        let weatherCell  = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let weatherDay = weatherDays[indexPath.row]
        weatherCell.setupView(day: weatherDay)
     
        return weatherCell
    }
}




