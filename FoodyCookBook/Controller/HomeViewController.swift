//
//  ViewController.swift
//  Foody cookBook
//
//  Created by Siva Nagarajan on 26/04/21.
//

import UIKit
import SafariServices
class HomeViewController: UIViewController, favDelegate {
    @IBOutlet weak var showFavButton: buttonBadge!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var categoryLab: UILabel!
    @IBOutlet weak var AreaLab: UILabel!
    @IBOutlet weak var InstructionTextView: UITextView!
    @IBOutlet weak var YoutubeLinkButton: UIButton!
    @IBOutlet weak var getOnSiteButton: UIButton!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var searchLeading: NSLayoutConstraint!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var favButton: UIButton!
    //MARK: Variables
    var listOfFav: [meals.meal]?
    var titleImg: UIImage? {
        didSet {
            DispatchQueue.main.async { [self] in
                titleImage.image = titleImg
                loader.loadLoader(self.view, load: false)
            }
        }
    }
    var currentMeal: meals.meal? {
        didSet {
            DispatchQueue.main.async { [self] in
                titleLab.text = currentMeal?.strMeal ?? ""
                categoryLab.text = currentMeal?.strCategory ?? ""
                AreaLab.text = currentMeal?.strArea ?? ""
                InstructionTextView.text = currentMeal?.strInstructions ?? ""
                YoutubeLinkButton.isHidden = !(currentMeal?.strYoutube != nil)
                downloadImage(from: currentMeal?.strMealThumb ?? "")
                localReload()
            }
        }
    }
    var listOfMeals: meals? {
        didSet {
            DispatchQueue.main.async {
                self.searchTable.reloadData()
                if !(self.listOfMeals?.meals?.isEmpty ?? false) {
                    self.searchTable.isHidden = false
                } else {
                    self.searchTable.isHidden = true
                }
            }
        }
    }
    
    //MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        searchText.autocorrectionType = .no
        searchText.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FavouritesViewController {
            if let fav = segue.destination as? FavouritesViewController {
                fav.delegate = self
            }
        }
    }
    
    //MARK: Local methods
    func localReload() {
        listOfFav = UserDefaults.standard.getFavourite()
        if !(listOfFav?.isEmpty ?? false) {
            showFavButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
            showFavButton.badge = "\(listOfFav?.count ?? 0)"
        } else {
            showFavButton.badgeEdgeInsets = nil
            showFavButton.badge = nil
        }
        if let xx = listOfFav?.contains(where: {$0.idMeal == currentMeal?.idMeal}) {
            if xx {
                self.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                self.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        } else {
            self.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func initialLoad() {
        loader.loadLoader(self.view, load: true)
        WebService.getRandomMeals(completion: {
            meal, error in
            DispatchQueue.main.async {
                loader.loadLoader(self.view, load: false)
            }
            if error == nil {
                self.currentMeal = meal?.meals?[0]
            } else {
                
            }
        })
    }
    
    func downloadImage(from url: String) {
        loader.loadLoader(self.view, load: true)
        if let ur = URL(string: url) {
            WebService.getData(from: ur) { (_, _, image, error) in
                if error == nil {
                    self.titleImg = image
                }
            }
        }
    }
    
    //MARK: delegate methods
    func favSelected(meal: meals.meal) {
        self.currentMeal = meal
    }
    
    func reload() {
        localReload()
    }
    
    
    //MARK: IBActions
    @IBAction func showFavorites(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showFav", sender: self)
    }
    @IBAction func addToFavorite(_ sender: UIButton) {
        if let xx = listOfFav?.contains(where: {$0.idMeal == currentMeal?.idMeal}) {
            if xx {
                UserDefaults.standard.removeFavourite(value: currentMeal!)
            } else {
                UserDefaults.standard.appendFavourite(value: currentMeal!)
            }
            
        } else {
            UserDefaults.standard.appendFavourite(value: currentMeal!)
        }
        localReload()
    }
    
    @IBAction func clearearchText(_ sender: UIButton) {
        searchText.text = ""
        searchTable.isHidden = true
        dismissKeyboard()
    }
    
    @IBAction func gotoYoutube(_ sender: UIButton) {
        if let url = URL(string: currentMeal?.strYoutube ?? "") {
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func gotoSite(_ sender: UIButton) {
        if let url = URL(string: currentMeal?.strSource ?? "") {
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
}

//MARK: TableView delegate & datasource Extension
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfMeals?.meals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: searchCell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath) as! searchCell
        cell.update(catTitle: listOfMeals?.meals?[indexPath.row].strCategory ?? "", prodTitle: listOfMeals?.meals?[indexPath.row].strMeal ?? "" , productImg: listOfMeals?.meals?[indexPath.row].strMealThumb ?? "", searchText: searchText.text ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchText.text = ""
        self.dismissKeyboard()
        self.searchTable.isHidden = true
        currentMeal = listOfMeals?.meals?[indexPath.row]
    }
}

//MARK: TextField delegate extensions
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let searchText = textField.text!
        if searchText.count >= 1 {
            self.dismissKeyboard()
            WebService.getRandomMeals(searchKeyword: searchText) { (meals, error) in
                if error == nil {
                    self.listOfMeals = meals
                }
            }
        } else {
            searchTable.isHidden = true
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = textField.text! + string
        if searchText.count >= 1 {
            print(searchText)
            WebService.getRandomMeals(searchKeyword: searchText) { (meals, error) in
                if error == nil {
                    self.listOfMeals = meals
                }
            }
        } else {
            searchTable.isHidden = true
        }
        if textField == self.searchText {
            if string == "" {
                textField.deleteBackward()
            } else {
                textField.insertText(string)
            }
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.clearButton.isEnabled = true
            self.searchImage.image = #imageLiteral(resourceName: "cross-1")
            self.searchLeading.constant = 44
            self.searchView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.count == 0 {
            UIView.animate(withDuration: 0.3) {
                self.clearButton.isEnabled = false
                self.searchImage.image = #imageLiteral(resourceName: "Search-1")
                self.searchLeading.constant = 28
                self.searchView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        }
    }
}
//MARK: SearchCell Class
class searchCell: UITableViewCell {
    @IBOutlet weak var categView: UIView!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var categTitle: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    
    func update(catTitle: String = "", prodTitle: String = "", productImg: String = "", searchText: String) {
        categTitle.attributedText = setAttributedText(main: catTitle, sub: searchText, size: 16.0).uppercased()
        if let ur = URL(string: productImg) {
            WebService.getData(from: ur) { (_, _, image, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        self.productImage.image = image
                    }
                }
            }
        }
        productTitle.text = prodTitle.capitalized
    }
    
    func setAttributedText(main: String, sub: String, color: UIColor? = #colorLiteral(red: 0.1490007639, green: 0.149033159, blue: 0.1575876474, alpha: 1), size: CGFloat = 17.0) -> NSAttributedString {
        let range = (main.lowercased() as NSString).range(of: sub.lowercased())
        let attribute = NSMutableAttributedString.init(string: main)
        attribute.addAttribute(.font, value: UIFont(name: "DIN Condensed Bold", size: size)!, range: range)
        return attribute
    }
}
