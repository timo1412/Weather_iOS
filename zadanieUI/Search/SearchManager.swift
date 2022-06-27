//
//  SearchManager.swift
//  zadanieUI
//
//  Created by Timotej Čery on 23/04/2022.
//

import Foundation
import MapKit
typealias LocalSearchCompletionHandler = (([Place]) -> Void)


class SearchManager : NSObject {
//    MARK: - Constants
    private let searchCompleter = MKLocalSearchCompleter()
//    MARK: - Variables
    private var searchCompletion:LocalSearchCompletionHandler?
    
    override init() {
        super.init()
        
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }

    func getLocalSearchResult(from query : String, completion: @escaping LocalSearchCompletionHandler){
        self.searchCompletion = completion
        
        if query.isEmpty {
            completion([])
        }
        searchCompleter.queryFragment = query
       
    }
    
}

struct Place {
    var city : String
    var country : String
}

extension SearchManager: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {

        let places = completer.results
            .filter{ !$0.title.isEmpty }
            .map{$0.title.components(separatedBy: ",")}
            .filter{$0.count>1}
            .map{ Place( city : $0[0], country : $0[1]) }
        searchCompletion?(places)
    }
}





