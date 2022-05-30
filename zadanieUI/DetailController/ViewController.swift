//
//  ViewController.swift
//  zadanieUI
//
//  Created by Timotej Čery on 08/04/2022.
//

import UIKit
import CoreLocation
import MapKit
import SideMenu

struct WeatherCell{
    let day : String
    let temp:String
    let rainPer: String
    
}

enum State{
    case loading
    case error(String)
    case success(HourlyResponse)
}

class ViewController: UIViewController {

    //    MARK: OUTLETS

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temptLabel: UILabel!
    @IBOutlet weak var locatIcony: UIImageView!
    @IBOutlet weak var descWeatherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var feelTemptLabel: UILabel!
    
//    MARK: VARIABLES
    var favMenu: SideMenuNavigationController?
    var place: Place?
    var refreshControl = UIRefreshControl()
    var hours = [Current]()
    var location : CurrentLocation?
    var state: State = .loading {
        didSet{
            reloadState()
        }
    }
    var favouriteLocation = [CurrentLocation]()
    
//    MARK: BUTTON
    
    @IBAction func favouriteButton(_ sender: Any) {
        present(favMenu!, animated: true)
    }
    
    @IBAction func search(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchViewControler", bundle: nil)
        if let navigationControloer = storyboard.instantiateInitialViewController() {
            present(navigationControloer, animated: true)
        }
    }
    
    @IBAction func saveFavButton(_ sender: Any) {
        savingFavLocation(location: location!)
    }

    //    MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        setupTableView()
        updateLocation()
        LocationManager.shered.onAuthorizationChange { authorized in
            if authorized {
                self.updateLocation()
            }
        }

        if LocationManager.shered.denied {
            self.presentAlert()
        } else {
            updateLocation()
        }


    }
    
}

//MARK: ACTION
private extension ViewController {
    @IBAction func reload(_ sender: Any) {
        loadData()
    }
}



//MARK: - SETUP
private extension ViewController {
    func setupTableView() {
//        registgrujem si cellu v detail view
        tableView.dataSource = self
        tableView.register(UINib(nibName: WeatherCustomeTableViewCell.classString, bundle: nil ), forCellReuseIdentifier: WeatherCustomeTableViewCell.classString)
        
//        nadstavim si refresh controll
        tableView.isHidden = true
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
//    nadstavenie hlavicky detail view
    func setupView(with currentWeather: HourlyResponse) {
        temptLabel.text = currentWeather.current.temperatureInCelzius
        feelTemptLabel.text = currentWeather.current.feelsLikeString
        descWeatherLabel.text = currentWeather.current.weather[0].description
        print(currentWeather.current.weather.description)
        dateLabel.text = DateFormatter.mediumDateFormartter.string(from: currentWeather.current.date)
    }
    
    func setupFavouriteMenu() {
        favMenu = SideMenuNavigationController(rootViewController: FavouriteSideMenu())
        favMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = favMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "toto je title", message: "toto je message", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style:.cancel)
        let setingAction = UIAlertAction(title: "Setting", style: .default) { action  in
            guard let settingsUrl = URL(string:UIApplication.openSettingsURLString) , UIApplication.shared.canOpenURL(settingsUrl)  else {
                return
            }
            UIApplication.shared.open(settingsUrl , completionHandler:nil)
        }
         
        alertController.addAction(okAction)
        alertController.addAction(setingAction)
        
        present(alertController, animated: true)
    }
    
    func savingLocation(with: CLLocation) {
        
    }
    
    func reloadState() {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            tableView.isHidden = true
            emptyView.isHidden = true
        case .error(let message):
            errorLabel.text = message
            refreshControl.endRefreshing()
            activityIndicator.stopAnimating()
            tableView.isHidden = true
        case .success(let weatherData):
            refreshControl.endRefreshing()
            activityIndicator.stopAnimating()
            setupView(with: weatherData)
            setupFavouriteMenu()
            hours = weatherData.hourly
            tableView.isHidden = false
            emptyView.isHidden = true
            tableView.reloadSections(IndexSet(integer: 0), with: .fade )
        }
    }
}



//MARK: - REQUEST & LOCATION

private extension ViewController {
    @objc func loadData() {
//        testovanie ci mam lokaciu ked chcem data
        guard let location = location else{
            return
        }
        
        state = .loading
        
        RequestManager.shered.getHourlyWeather(for: location.coordinates) { [weak self] response in
//            keby som tento guard nemal tak kazdy jeden self mi zahuci že nie je option týmto zabezpečim že vzdy bude existovať
            guard let self = self else {return}

            switch response {
            case .success(let weatherData):
//                print(response)
                self.state = .success(weatherData)
            case .failure(let error):
                print(response)
                self.state = .error(error.localizedDescription )
                
            }
        }

        self.locationLabel.text = location.city
        
    }
    
    func updateLocation() {
        LocationManager.shered.getLocation{ [weak self] location , error in
            guard let self = self else { return }
            
            if let error = error{
                self.state = .error(error.localizedDescription)
            } else if let location = location {
                self.location = location
                self.loadData()
            }
        }
    }
    
}
//MARK: User default
extension ViewController {
    func savingFavLocation(location: CurrentLocation) {
        UserDefaultManager.shered.defaults.setValue(location, forKey: "String")
    }
}

//MARK: TABLE VIERW DATA SOURCE
extension ViewController : UITableViewDataSource {
    //    POČET SEKCII V TABLE VIEW KED MAM POČET SEKCII 2 a v jednej sekcii mam 7 dni tak mi vráti 14 riadkov
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 2
    //    }
    //    FUNKCIA KTORÁ VRÁTI POČET RIADKOV V TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count
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
        weatherDayCell.setupCell(with: hours[indexPath.row])
        return weatherDayCell
    }
}
