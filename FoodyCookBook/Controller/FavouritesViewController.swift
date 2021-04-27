//
//  FavouritesViewController.swift
//  Foody cookBook
//
//  Created by Siva Nagarajan on 26/04/21.
//

import UIKit
//MARK: favDelegate
protocol favDelegate: class {
    func favSelected(meal: meals.meal)
    func reload()
}

class FavouritesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLab: UILabel!
    //MARK: Variables
    weak open var delegate: favDelegate?
    var listOfMeals: [meals.meal]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if !(self.listOfMeals?.isEmpty ?? false) {
                    self.emptyLab.isHidden = true
                    self.tableView.isHidden = false
                } else {
                    self.emptyLab.isHidden = false
                    self.tableView.isHidden = true
                }
            }
        }
    }
    
    //MARK: override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfMeals = UserDefaults.standard.getFavourite()
    }
    
    //MARK: deinit
    deinit {
        self.delegate?.reload()
    }
}

//MARK: TableView delegate & datasource Extension
extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfMeals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: searchCell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath) as! searchCell
        cell.update(catTitle: listOfMeals?[indexPath.row].strCategory ?? "", prodTitle: listOfMeals?[indexPath.row].strMeal ?? "" , productImg: listOfMeals?[indexPath.row].strMealThumb ?? "", searchText:  "")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.favSelected(meal: (listOfMeals?[indexPath.row])!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var config: UISwipeActionsConfiguration!
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
            UserDefaults.standard.removeFavourite(value: (self.listOfMeals?[indexPath.row])!)
            self.listOfMeals = UserDefaults.standard.getFavourite()
        }
        deleteAction.image = #imageLiteral(resourceName: "Trash_icon-1")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.2235294118, blue: 0.2078431373, alpha: 1)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        config = configuration
    return config

    }
    
}
