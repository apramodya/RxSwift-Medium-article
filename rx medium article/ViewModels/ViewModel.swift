//
//  ViewModel.swift
//  rx medium article
//
//  Created by Pramodya Abeysinghe on 10/11/20.
//

import Foundation
import RxSwift
import RxCocoa

enum BreweryType: String {
    case Micro = "micro", Large = "larges", Contract = "contract"
}

class ViewModel {
    let session = URLSession.shared
    var selectedBreweryType = BehaviorRelay<BreweryType>(value: .Micro)
    var breweries = BehaviorRelay<[Brewery]>(value: [])
    
    func getBreweries(for type: String, completion: @escaping (_ status: Bool, _ message: String?) -> Void) {
        
        guard let url = getUrl(type) else { return }
        
        let task = session.dataTask(with: url) { [self] (data, response, error) in
            
            if error != nil {
                completion(false, error?.localizedDescription)
            }
            
            do {
                let json = try JSONDecoder().decode([Brewery].self, from: data!)
                breweries.accept(json)
                
                completion(true, "Success")
            } catch {
                completion(false, error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    private func getUrl(_ type: String) -> URL? {
        return URL(string: "https://api.openbrewerydb.org/breweries?by_type=\(type)")
    }
}
