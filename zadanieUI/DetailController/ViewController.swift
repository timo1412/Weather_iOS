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
    
    var place: Place?
    
    var refreshControl = UIRefreshControl()
    
    var days = [DailyWeather]()

    
    @IBAction func search(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchViewControler", bundle: nil)
        if let navigationControloer = storyboard.instantiateInitialViewController() {
            present(navigationControloer, animated: true)
        }
    }
    
    //    MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let currentDate = Date()
        dateLabel.text = formatter.string(from: currentDate)
        
        locationLabel.text = place?.city
        
        LocationManager.shered.getLocation{ [weak self] location , error in
            guard let self = self else { return }
            if let error = error {
                print("Tu je chyba")
            } else if let location = location {
                RequestManager.shered.getWeatherData(for: location.coordinates) { response in
                    
                    switch response {
                    case .success(let weatherData):
                        
                        self.setupView(with: weatherData.current)
                        self.days = weatherData.days
                        self.tableView.reloadData()
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                self.locationLabel.text = location.city
            }
        }
        tableView.dataSource = self
        tableView.register(UINib(nibName: WeatherCustomeTableViewCell.classString, bundle: nil ), forCellReuseIdentifier: WeatherCustomeTableViewCell.classString)
    }
    
    func setupView(with currentWeather: CurrentWeather) {
        temptLabel.text = currentWeather.temperatureWithCelsius
        feelTemptLabel.text = currentWeather.fellsLikeWithCelsius
        descWeatherLabel.text = currentWeather.weather.first?.description
    }

}

extension ViewController : UITableViewDataSource {
//    POČET SEKCII V TABLE VIEW KED MAM POČET SEKCII 2 a v jednej sekcii mam 7 dni tak mi vráti 14 riadkov
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    //    FUNKCIA KTORÁ VRÁTI POČET RIADKOV V TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
            //ZABEZPOECI ZOBRAZOVANIE IBA PRVÝCH 3 DNÍ
            //        if section == 0 {
            //            return 3
            //        } else {
            //            return weatherDays.count
            //        }
        }
//    FUNKCIA KTORÁ NAFORMÁTUJE JEDNOTLIVE CELLS AK MOJA weatherCell NIE JE JE AKO WeatherTableViewCell TAK VRÁTIM PRÁZDNU TABULKU
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let weatherDayCell = tableView.dequeueReusableCell(withIdentifier: WeatherCustomeTableViewCell.classString, for: indexPath) as? WeatherCustomeTableViewCell else {
            return UITableViewCell()
        }
//        let weatherCell  = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
//        let weatherDay = weatherDays[indexPath.row]
        weatherDayCell.setupCell(with: days[indexPath.row])
        return weatherDayCell
    }
}




