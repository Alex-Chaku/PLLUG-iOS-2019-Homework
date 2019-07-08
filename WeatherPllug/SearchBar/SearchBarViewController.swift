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



    struct Search {
        let SearchName: String
        let tempSearchName: Int
        let mainSerch: String
        let tempmaxSerch: Int
        let tempminSerch: Int
    }

    class SearchBarViewController: UIViewController, UISearchBarDelegate,  UISearchResultsUpdating {
        @IBOutlet weak var detailTextLabel: UILabel!
        var tableViewController = TableViewController()
        var jsonSearch = [Search]()
        
        @IBOutlet weak var tableViewCity: UITableView!
        let search = UISearchController(searchResultsController: nil)
         var searchURL = String()
        
     
        
        func updateSearchResults(for searchController: UISearchController) {
            jsonSearch.removeAll()
            guard let text = searchController.searchBar.text else
            { return }
          
            
            let keywords = text
            let finalKeywords = keywords.replacingOccurrences(of: " ", with: "+")
            searchURL = "http://api.openweathermap.org/data/2.5/weather?q=\(finalKeywords)&appid=36ecf583695b7d218c1194e3d584ba91"
            tableViewCity.reloadData()
            
            Alamofire.request(searchURL).responseJSON {
                response in
                
                if let responseStr = response.result.value {
                    let jsonResponse = JSON(responseStr)
                    let jsonWeather = jsonResponse["name"].stringValue
                    let jsonWeatherDays = jsonResponse["main"]
                    let tempSearchName = jsonWeatherDays["temp"].intValue
                    let tempminSearch = jsonWeatherDays["temp_min"].intValue
                    let tempmaxSerch = jsonWeatherDays["temp_max"].intValue
                    
                    let weatherSerch = jsonResponse["weather"]
                    
                    let mainSerch = weatherSerch["main"].stringValue
                    
                    self.jsonSearch.append(Search.init(SearchName:jsonWeather, tempSearchName: tempSearchName, mainSerch: mainSerch, tempmaxSerch: tempmaxSerch, tempminSerch: tempminSearch))
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

        func setupNavigationBar()  {
          
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

    extension SearchBarViewController:  UITableViewDataSource,UITableViewDelegate{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
            return jsonSearch.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          //  let cell = tableViewCity.dequeueReusableCell(withIdentifier: "Search")
            let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Search")
            let nameLabel = cell?.viewWithTag(21) as! UILabel
            nameLabel.text = jsonSearch[indexPath.row].SearchName
            
            return cell!
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
    //        print(jsonSearch[indexPath.row].SearchName)
    //          print(jsonSearch[indexPath.row].tempSearchName)
    //           print(jsonSearch[indexPath.row].mainSerch)
    //
            
            
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if (segue.identifier == "NewCity") {
               
                let indexPath = self.tableViewCity.indexPathForSelectedRow?.row
                let vc = segue.destination as! TableViewController
                vc.SearchName = jsonSearch[indexPath!].SearchName
                vc.tempSearchName = jsonSearch[indexPath!].tempSearchName
                vc.mainSerch = jsonSearch[indexPath!].mainSerch
                vc.tempmaxSerch = jsonSearch[indexPath!].tempmaxSerch
                vc.tempminSerch = jsonSearch[indexPath!].tempminSerch
               
            }
        }
    }
    
    

