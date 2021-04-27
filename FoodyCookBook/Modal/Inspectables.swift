//
//  GlobalMethods.swift
//  Foody cookBook
//
//  Created by Siva Nagarajan on 26/04/21.
//

import Foundation
import UIKit
var favMealKey = "favMeal"
extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
extension UserDefaults {
    //MARK: Add New Data
    func appendFavourite(value: meals.meal) {
        var val = getFavourite()
        if val != nil {
            if val!.count == 10 {
                val!.removeFirst()
            }
            if !val!.contains(where: { (prod) -> Bool in
                return prod.idMeal == value.idMeal
            }) {
                val!.insert(value, at: 0)
            }
            set(try? PropertyListEncoder().encode(val!), forKey: favMealKey)
        } else {
            set(try? PropertyListEncoder().encode(value), forKey: favMealKey)
        }
    }
    //MARK: Remove current Data
    func removeFavourite(value: meals.meal) {
        var val = getFavourite()
        if val != nil {
            if val!.count == 10 {
                val!.removeFirst()
            }
            if val!.contains(where: { (prod) -> Bool in
                return prod.idMeal == value.idMeal
            }) {
                val!.removeAll(where: { (prod) -> Bool in
                    return prod.idMeal == value.idMeal
                })
            }
            set(try? PropertyListEncoder().encode(val!), forKey: favMealKey)
        } else {
            set(try? PropertyListEncoder().encode(value), forKey: favMealKey)
        }
    }
    
    //MARK: Retrieve User Data
    func getFavourite() -> [meals.meal]?{
        if let decode = value(forKey: favMealKey) as? Data {
            if let prod = try? PropertyListDecoder().decode([meals.meal].self, from: decode) {
                return prod
            } else if let prod = try? PropertyListDecoder().decode(meals.meal.self, from: decode) {
                return [prod]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    //MARK: Remove all Data
    func removeAll() {
        var val = getFavourite()
        if val != nil {
            val!.removeAll()
            set(try? PropertyListEncoder().encode(val!), forKey: favMealKey)
        }
    }
}
extension NSAttributedString {
    func uppercased() -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        result.enumerateAttributes(in: NSRange(location: 0, length: length), options: []) {_, range, _ in
            result.replaceCharacters(in: range, with: (string as NSString).substring(with: range).uppercased())
        }
        return result
    }
}
