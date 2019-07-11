    //
    //  SearchBarViewController.swift
    //  WeatherPllug
    //
    //  Created by Nazar Kovalik on 7/3/19.
    //  Copyright © 2019 Nazar Kovalik. All rights reserved.
    //

    import UIKit
    import Alamofire
    import SwiftyJSON
    import CoreData

    struct Search {
        let searchName: String
        let tempSearchName: Int
        let mainSerch: String
        let tempmaxSerch: Int
        let tempminSerch: Int
        let lonSerch: Double
        let latSerch: Double
    }

    class SearchBarViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating {
        @IBOutlet weak var detailTextLabel: UILabel!
        var tableViewController = TableViewController()
        var jsonSearch = [Search]()
        var people = [City]()
        @IBOutlet weak var tableViewCity: UITableView!
        let search = UISearchController(searchResultsController: nil)
        var searchURL = String()
        var nameCoreData = String()
        var tempCoreData = Int()
        func updateSearchResults(for searchController: UISearchController) {
            jsonSearch.removeAll()
            guard let text = searchController.searchBar.text
                else { return }
            let keywords = text
            let finalKeywords = keywords.replacingOccurrences(of: " ", with: "+")
            searchURL = "http://api.openweathermap.org/data/2.5/weather?q=\(finalKeywords)&appid=f23e9fefec26a337e0a58ad0502bed89"
            tableViewCity.reloadData()
            Alamofire.request(searchURL).responseJSON { response in
                if let responseStr = response.result.value {
                    let jsonResponse = JSON(responseStr)
                    let jsonWeather = jsonResponse["name"].stringValue
                    let jsonWeatherDays = jsonResponse["main"]
                    let tempSearchName = jsonWeatherDays["temp"].intValue
                    let tempminSearch = jsonWeatherDays["temp_min"].intValue
                    let tempmaxSerch = jsonWeatherDays["temp_max"].intValue
                    let weatherSerch = jsonResponse["weather"]
                    let mainSerch = weatherSerch["main"].stringValue
                    let coordSerch = jsonResponse["coord"]
                    let lonSerch = coordSerch["lon"].doubleValue
                    let latSerch = coordSerch["lat"].doubleValue
                    self.jsonSearch.append(Search.init(searchName: jsonWeather,
                    tempSearchName: tempSearchName, mainSerch: mainSerch, tempmaxSerch: tempmaxSerch, tempminSerch: tempminSearch, lonSerch: lonSerch, latSerch: latSerch))
                    self.tableViewCity.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.tableViewCity.reloadData()
            }
        }
        override func viewDidLoad() {
            super.viewDidLoad()
             tableViewCity.reloadData()
            setupNavigationBar()
            DispatchQueue.main.async {
                self.tableViewCity.reloadData()
            }
        }
        func setupNavigationBar() {
            search.searchResultsUpdater = self
            search.obscuresBackgroundDuringPresentation = false
            search.searchBar.placeholder = "Enter the city"
            navigationItem.searchController = search
            navigationItem.hidesSearchBarWhenScrolling = false
            search.searchResultsUpdater = self
            search.dimsBackgroundDuringPresentation = false
            definesPresentationContext = true
        }

    }

    extension SearchBarViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return jsonSearch.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          //  let cell = tableViewCity.dequeueReusableCell(withIdentifier: "Search")
            let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Search")
            let nameLabel = cell?.viewWithTag(21) as! UILabel
            nameLabel.text = jsonSearch[indexPath.row].searchName
            return cell!
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

      }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "NewCity" {
                let indexPath = self.tableViewCity.indexPathForSelectedRow?.row
                let vc = segue.destination as! TableViewController
                vc.searchName = jsonSearch[indexPath!].searchName
                vc.tempSearchName = jsonSearch[indexPath!].tempSearchName
                vc.mainSerch = jsonSearch[indexPath!].mainSerch
                vc.tempmaxSerch = jsonSearch[indexPath!].tempmaxSerch
                vc.tempminSerch = jsonSearch[indexPath!].tempminSerch
                vc.long = jsonSearch[indexPath!].lonSerch
                vc.lat = jsonSearch[indexPath!].latSerch
            }
        }
    }
