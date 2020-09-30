//
//  ShowsManager.swift
//
//
//  Created by Sergio Arizaga
//

import Foundation

// A simple struct for downloading show data
struct ShowsManager {
    let showsURL = "http://api.tvmaze.com/shows"
        
    func fetchData(completion: @escaping ([Dictionary<String, Any>]?, Error?) -> Void) {
        let url = URL(string: showsURL)!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Dictionary<String, Any>]{
                        completion(array, nil)
                    }
                } catch {
                    print(error)
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    
}


