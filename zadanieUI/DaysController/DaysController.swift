//
//  DaysController.swift
//  zadanieUI
//
//  Created by Timotej Čery on 22/05/2022.
//

import Foundation
import UIKit

class DaysController : UIViewController{
    
    @IBAction func reload(_ sender: Any) {
        loadData()
    }
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var weather = [DailyWeather]()
    var location : CurrentLocation?
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        
        LocationManager.shered.onAuthorizationChange { auhorize in
            if auhorize {
                self.updateLocation()
            }
        }
        
        if LocationManager.shered.denied {
            presentAlert()
        } else {
            updateLocation()
        }
        setupTableCells(weather: weather)
    }
}

extension DaysController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weatheDayCell = tableView.dequeueReusableCell(withIdentifier: CustomeCellDay.classString, for: indexPath) as? CustomeCellDay else {
            return UITableViewCell()
        }
        weatheDayCell.setupTable(with: weather[indexPath.row])
       
        return weatheDayCell
    }
}

extension DaysController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

private extension DaysController {
    func setupTableCells(weather : [DailyWeather] ) {
        tableView.isHidden = false
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: CustomeCellDay.self.classString, bundle: nil), forCellReuseIdentifier:CustomeCellDay.self.classString)
    }
}


extension DaysController {
    @objc func loadData() {
        guard let location = location else{
            return
        }
        RequestManager.shered.getWeatherData(for: location.coordinates) { response in
            self.tableView.isHidden = false
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            switch response {
            case .success(let weatherData):
                print("Succes")
                print(weatherData)
                self.weather = weatherData.daily
                self.setupTableCells(weather: weatherData.daily)
                self.tableView.reloadSections(IndexSet(integer: 0), with: .top)
            case .failure(let error):
                self.errorLabel.text=error.localizedDescription
                self.tableView.isHidden = true
                self.emptyView.isHidden = true
            }
        }
    }
    func presentAlert() {
        let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { action in
            print("OK")
        }
        let settings = UIAlertAction(title: "OK", style: .default) { action in
            guard let settingsUrl = URL(string:UIApplication.openSettingsURLString) , UIApplication.shared.canOpenURL(settingsUrl)  else {
                return
            }
            UIApplication.shared.open(settingsUrl , completionHandler:nil)
        }
        alert.addAction(okAction)
        alert.addAction(settings)
        present(alert, animated: true)
    }
    
    func updateLocation() {
        LocationManager.shered.getLocation { [weak self] location, error in
            guard let self = self else { return }
            
            if let error = error{
            
            } else {
                if let location = location {
                    self.location = location
                    self.loadData()
                }
            }
        }
    }


}


