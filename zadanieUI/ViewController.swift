//
//  ViewController.swift
//  zadanieUI
//
//  Created by Timotej Čery on 08/04/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temptLabel: UILabel!
    @IBOutlet weak var locatIcony: UIImageView!
    @IBOutlet weak var descWeatherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var feelTemptLabel: UILabel!
    
    var weatherDays: [String] {
        ["Monday" , "Thuesday","Wednesday","Thursday","Friday","Saturday" , "Sunday"]
    }
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.reloadData()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController : UITableViewDataSource {
//    POČET SEKCII V TABLE VIEW KED MAM POČET SEKCII 2 a v jednej sekcii mam 7 dni tak mi vráti 14 riadkov
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//    FUNKCIA KTORÁ NAFORMÁTUJE JEDNOTLIVE CELLS AK MOJA weatherCell NIE JE JE AKO WeatherTableViewCell TAK VRÁTIM PRÁZDNU TABULKU
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
//        let weatherCell  = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let day = weatherDays[indexPath.row]
        weatherCell.weatherTextLabel.text = day
        return weatherCell
    }
    
    
//    FUNKCIA KTORÁ VRÁTI POČET RIADKOV V TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//ZABEZPOECI ZOBRAZOVANIE IBA PRVÝCH 3 DNÍ
//        if section == 0 {
//            return 3
//        } else {
//            return weatherDays.count
//        }
        return weatherDays.count

    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Header in \(section) section "
    }
    
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Footer in \(section) section "
    }
}

