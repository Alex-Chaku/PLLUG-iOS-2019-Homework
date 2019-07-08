    //
    //  TableViewController.swift
    //  WeatherPllug
    //
    //  Created by Nazar Kovalik on 6/21/19.
    //  Copyright © 2019 Nazar Kovalik. All rights reserved.
    //

    import Foundation
    import UIKit
    import Alamofire
    import SwiftyJSON
    import NVActivityIndicatorView
    import CoreLocation



    struct Course {
        let jsonName: String
        let temp: Int
        let jsonDescription: String
        let tempmax: Int
        let tempmin: Int
    }

    class TableViewController: UITableViewController, CLLocationManagerDelegate {
        var SearchName = String()
        var tempSearchName = Int()
        var mainSerch = String()
        var tempmaxSerch = Int()
        var tempminSerch = Int()
        var degree = 273
        
        @IBOutlet var tebleView: UITableView!
        let apiKey = "1c8dd02cb7ac88cdd7bc741c4ebc3945"
        var lat = Double()
        var long = Double()
        var activityIndicator: NVActivityIndicatorView!
        let locationManager = CLLocationManager()
         var posts = [Course]()
        override func viewDidLoad() {
            super.viewDidLoad()
            let indicatorSize: CGFloat = 70
            let indicatorFrame = CGRect( x:(view.frame.width-indicatorSize)/2 , y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
            activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
            view.addSubview(activityIndicator)
            locationManager.requestWhenInUseAuthorization()
            activityIndicator.startAnimating()
            
            if (CLLocationManager.locationServicesEnabled()) {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
            
           
            self.tableView.reloadData()
            
        }
        
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations[0]
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            
            
            //MARK: Json Parser
            Alamofire.request("https://samples.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)").responseJSON {
                response in
                self.activityIndicator.stopAnimating()
                if let responseStr = response.result.value {
                    let jsonResponse = JSON(responseStr)
                    let jsonWeather = jsonResponse["weather"].array![0]
                    let jsonDescription = jsonWeather["description"].stringValue
                    let jsonName = jsonResponse["name"].stringValue
                    let jsonTemp = jsonResponse["main"]
                    let temp = jsonTemp["temp"].intValue
                    let tempmax = jsonTemp["temp_max"].intValue
                    let tempmin = jsonTemp["temp_min"].intValue
                    
                    

                    
                    self.posts.append(Course.init(jsonName: jsonName, temp: temp, jsonDescription: jsonDescription,  tempmax:tempmax, tempmin: tempmin))
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                   
                   
                }
                
            }
            self.locationManager.stopUpdatingLocation()
        }
        
        
//        override func didReceiveMemoryWarning() {
//             super.didReceiveMemoryWarning()
//            self.posts.append(Course.init(jsonName: self.SearchName, temp: self.tempSearchName, jsonDescription: self.mainSerch, tempmax: self.tempmaxSerch, tempmin: self.tempminSerch))
//
//        }
        
        
       //MARK: PORTABLE DATACHANGE ON TSELSI
        @IBAction func  tselisi(_ sender: Any) {
            degree = 273
            self.tableView.reloadData()
        }
        
        //MARK: PORTABLE DATACHANGE ON KELVIN
        @IBAction func kelvin(_ sender: Any) {
            degree = 0
            self.tableView.reloadData()
            
        }
        
        //MARK: TABLE VIEW
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return  posts.count
        }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

            let mainid = cell?.viewWithTag(1) as! UILabel
            mainid.text = "\(String(posts[indexPath.row].temp - degree))°"
            let maintitle = cell?.viewWithTag(2) as! UILabel
            maintitle.text = posts[indexPath.row].jsonName
            
            return cell!
        }

        
        
        
        //MARK: PORTABLE DATA ON VIEW CONTROLLER
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if (segue.identifier == "View") {
                let indexPath = self.tableView.indexPathForSelectedRow?.row
                let vc = segue.destination as! ViewController
                vc.jsonName = posts[indexPath!].jsonName
                vc.templabel = "\(String(posts[indexPath!].temp - degree))°"
                vc.tempmax = "\(String(posts[indexPath!].tempmax - degree))°"
                vc.tempmin = "\(String(posts[indexPath!].tempmin - degree))°"
                vc.jsonDescription = posts[indexPath!].jsonDescription
                vc.change = degree
                vc.apiKey = apiKey
                vc.lat = lat
                vc.long = long
            }
        }
    }

    
    

