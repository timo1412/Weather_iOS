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
//MARK: STRUCT
struct savingFavouriteLocation : Codable {
    var country :String
    var city :String
}

struct WeatherCell{
    let day : String
    let temp:String
    let rainPer: String
    
}
//MARK: ENUM
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
    var arrayOfFavouriteLocation = [savingFavouriteLocation]()
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
        
        if place != nil {
            setupTableView()
            self.updateWithPlace(place: place!)
            locationLabel.text = place?.city
        }
        else {
            
            activityIndicator.startAnimating()
            updateLocation()
            setupTableView()
            
            LocationManager.shared.onAuthorizationChange { authorized in
                if authorized {
                    self.updateLocation()
                }
            }

            if LocationManager.shared.denied {
                self.presentAlert()
            } else {
                updateLocation()
            }
            
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
        tableView.dataSource = self
        tableView.register(UINib(nibName: WeatherCustomeTableViewCell.classString, bundle: nil ),
                           forCellReuseIdentifier: WeatherCustomeTableViewCell.classString)
        tableView.isHidden = true
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }

    func setupView(with currentWeather: HourlyResponse) {
        temptLabel.text = currentWeather.current.temperatureInCelzius
        feelTemptLabel.text = currentWeather.current.feelsLikeString
        descWeatherLabel.text = currentWeather.current.weather[0].description
        dateLabel.text = DateFormatter.mediumDateFormartter.string(from: currentWeather.current.date)
    }
    
    func setupFavouriteMenu() {
        favMenu = SideMenuNavigationController(rootViewController: FavouriteSideMenu())
        favMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = favMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Something went wrong", message: "Please check settings", preferredStyle: .alert)
        
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
    
    
    func reloadState() {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            tableView.isHidden = true
            emptyView.isHidden = true
        case .error(let message):
            errorLabel.text = message
            self.emptyView.isHidden = false
            refreshControl.endRefreshing()
            activityIndicator.stopAnimating()
            tableView.isHidden = true
        case .success(let weatherData):
            refreshControl.endRefreshing()
            activityIndicator.stopAnimating()
            setupView(with: weatherData)
            hours = weatherData.hourly
            tableView.reloadSections(IndexSet(integer: 0), with: .fade )
            tableView.isHidden = false
            emptyView.isHidden = true
            setupFavouriteMenu()
        }
    }
}



//MARK: - REQUEST & LOCATION

private extension ViewController {
    @objc func loadData() {
        guard let location = location else{
            return
        }
        state = .loading
        RequestManager.shered.getHourlyWeather(for: location.coordinates) { [weak self] response in
            guard let self = self else {return}

            switch response {
            case .success(let weatherData):
                self.state = .success(weatherData)
            case .failure(let error):
                self.state = .error(error.localizedDescription )
                
            }
        }
        self.locationLabel.text = location.city
    }
    
    func updateWithPlace(place: Place) {
        LocationManager.shared.getPlaceLocation(where: place) { [weak self] location, error in
            guard let self = self else { return }
            if let error = error {
                self.state = .error(error.localizedDescription)
            } else {
                self.location = location
                self.loadData()
            }
        }
    }
    func updateLocation() {
        LocationManager.shared.getLocation{ [weak self] location , error in
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
        let savingLocation = savingFavouriteLocation(
            country: place?.country ?? "",
            city: place?.city ?? "")
        
        arrayOfFavouriteLocation = self.citajPole(key: "FavouriteLocationTest4")
        arrayOfFavouriteLocation.append(savingLocation)

        zapisPole(data: arrayOfFavouriteLocation)
    }
    
    func citajPole(key: String) -> [savingFavouriteLocation] {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let notes = try decoder.decode([savingFavouriteLocation].self, from: data)
                return notes
            } catch {
                print("Unable to decode Notes \(error)")
            }
        }
        return []
    }
    
    func zapisPole(data : [savingFavouriteLocation]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(data)
            UserDefaults.standard.set(data , forKey: "FavouriteLocationTest4")
        } catch {
            print("Unable to Encode Array of Notes")
        }
    }
}

//MARK: TABLE VIERW DATA SOURCE
extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let weatherDayCell = tableView.dequeueReusableCell(
            withIdentifier: WeatherCustomeTableViewCell.classString,
            for: indexPath) as? WeatherCustomeTableViewCell else {
            
            return UITableViewCell()
        }
        weatherDayCell.setupCell(with: hours[indexPath.row])
        
        return weatherDayCell
    }
}
