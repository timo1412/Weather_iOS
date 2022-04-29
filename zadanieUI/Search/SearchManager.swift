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
    //    nadstavenie searchCompletera typ vyhladavania aj to pomocou akých dat vyhladavame v tomto pripade query = string
    func getLocalSearchResult(from query : String, completion: @escaping LocalSearchCompletionHandler){
        self.searchCompletion = completion
        
        if query.isEmpty {
            completion([])
        }
        searchCompleter.queryFragment = query
       
    }
    
}

struct Place {
    let city : String
    let country : String
}

//z completer result dostaneme ako objekty vyhladane miesta , place.title vypisuje ako string Nazov mesta a štátu okresy kraje ATD.
extension SearchManager: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        //        prechadza to čo nam vrati completer ersult pozrie sa či nie je prazdny ak nie je tak jeho componenty rozdely podla čiarky , a ak je počet komponentov väčší ako jeden tak z čoho vyplýva že to bude mesto zo štátom tak vytvori Place s mestom a daným štátom
        let places = completer.results
            .filter{ !$0.title.isEmpty }
            .map{$0.title.components(separatedBy: ",")}
            .filter{$0.count>1}
            .map{ Place( city : $0[0], country : $0[1]) }
        searchCompletion?(places)
        print(places)
    }
}





