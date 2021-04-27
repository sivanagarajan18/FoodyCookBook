//
//  WebService.swift
//  Foody cookBook
//
//  Created by Siva Nagarajan on 26/04/21.
//

import Foundation
import UIKit
class WebService{
    //
    // MARK: - Random Meals
    //
    
    static func getRandomMeals(searchKeyword: String? = "" , completion: @escaping (meals?, Error?) -> ()) {
        var url = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php")!
        
        if searchKeyword != "" {
            url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(searchKeyword ?? "")")!
        }

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let data = data {
                do {
                    let resp = try JSONDecoder().decode(meals.self, from: data)
                    completion(resp, nil)
                } catch {
                    print(error)
                    completion(nil, error)
                }
            } else {
                completion(nil, nil)
            }
        }
        task.resume()
    }
    
    // MARK: - to get Data
    
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, UIImage?, Error?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            completion(data, response, UIImage(data: data), error)
        }
        task.resume()
    }
}
