//
//  SearchViewController.swift
//  zadanieUI
//
//  Created by Timotej Čery on 15/04/2022.
//

import UIKit

class SearchViewController: UIViewController {

//    MARK: - outlets

    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchManager = SearchManager()
    
    private var places = [Place]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    func setupSearchController(){
//        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.searchBar.delegate = self
    }
}


extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchManager.getLocalSearchResult(from: searchText) { places in
            self.places = places
            self.tableView.reloadData()
        }
    }
}


extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        let place = places[indexPath.row]
        searchCell.textLabel?.text = place.city
        searchCell.detailTextLabel?.text = place.country
        return searchCell
    }
}

extension SearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places [indexPath.row]
        presentWeatherDetail(with: place)
    }
    
    func presentWeatherDetail(with place: Place){
        let storyboard = UIStoryboard(name: "DetailViewController", bundle: nil)
        if let weatherViewControloer = storyboard.instantiateViewController(withIdentifier: "WeatherDetail") as? ViewController {
            weatherViewControloer.place = place
            navigationController?.pushViewController(weatherViewControloer, animated: true)
        }
    }
}

