//
//  ViewController.swift
//  zadanieUI
//
//  Created by Timotej Čery on 08/04/2022.
//

import UIKit

struct WeatherCell{
    let day : String
    let temp:String
    let feelsTemp: String
    
}


class ViewController: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temptLabel: UILabel!
    @IBOutlet weak var locatIcony: UIImageView!
    @IBOutlet weak var descWeatherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var feelTemptLabel: UILabel!
    
    var weatherDays: [WeatherCell] {
        [WeatherCell(day: "Pondelok", temp: "20", feelsTemp:"19"),
         WeatherCell(day: "Utorok", temp: "15", feelsTemp:"19"),
         WeatherCell(day: "Streda", temp: "18", feelsTemp:"19"),
         WeatherCell(day: "Štvrtok", temp: "10", feelsTemp:"11"),
         WeatherCell(day: "Piatok", temp: "9", feelsTemp:"8"),
         WeatherCell(day: "Sobota", temp: "14", feelsTemp:"15"),
         WeatherCell(day: "Nedela", temp: "25", feelsTemp:"25")
        ]
    }
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WeatherCustomeTableViewCell", bundle: nil ), forCellReuseIdentifier: "WeatherCustomeTableViewCell")
        
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
        
        guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCustomeTableViewCell", for: indexPath) as? WeatherCustomeTableViewCell else {
            return UITableViewCell()
        }
//        let weatherCell  = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let weatherDay = weatherDays[indexPath.row]
        weatherCell.dayLabel.text = weatherDay.day
        weatherCell.tempLabel.text = weatherDay.temp
        weatherCell.rainLabel.text = weatherDay.feelsTemp
     
        return weatherCell
    }
}

