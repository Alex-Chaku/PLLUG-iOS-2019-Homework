        //
        //  ViewController.swift
        //  WeatherPllug
        //
        //  Created by Nazar Kovalik on 6/13/19.
        //  Copyright © 2019 Nazar Kovalik. All rights reserved.
        //
        import Foundation
        import UIKit
        import Alamofire
        import SwiftyJSON
        import NVActivityIndicatorView
       


        struct Hourly {
            let tempdt: Int
            let datedt : String
            let iconName :  UIImage!

        }

        struct Days {
            let day: String
            let tampmax : Int
            let tampmin: Int
            let daysImg: UIImage!
        }


        class ViewController: UIViewController{
            @IBOutlet weak var collectionView: UICollectionView!
            @IBOutlet weak var tbTableView: UITableView!
            @IBOutlet weak var tableViewDays: UITableView!
            @IBOutlet weak var tableView: UITableView!
            @IBOutlet weak var daystableView: UITableView!
            var days = [Days]()
            var hour = String()
            var jsonName = String()
            var templabel = String()
            var jsonDescription = String()
            var tempmax = String()
            var tempmin = String()
            var apiKey = String()
            var lat = Double()
            var long = Double()
            
            var masHourly = [Hourly]()
            var mainTableViewCell = MainTableViewCell()
            @IBOutlet weak var LabelLocation: UILabel!
            @IBOutlet weak var LabelDecription: UILabel!
            @IBOutlet weak var LabelTemp: UILabel!
            @IBOutlet weak var LabelTempMax: UILabel!
            @IBOutlet weak var LabelTempMin: UILabel!

            var change = Int()
            var activityIndicator: NVActivityIndicatorView!
          
         
            override func viewDidLoad() {
                super.viewDidLoad()
                Occasionally()
                let indicatorSize: CGFloat = 70
                let indicatorFrame = CGRect( x:(view.frame.width-indicatorSize)/2 , y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
                activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
                view.addSubview(activityIndicator)
                
                activityIndicator.startAnimating()
              
               hourlyWeather()
               Occasionally ()
                
                
            }
            
            
            
        }

        extension ViewController: UITableViewDataSource,UITableViewDelegate{
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                if tableView.tag == 100{
                    return 3
                }
                else {
                    
                    return days.count
                }
                
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                if tableView.tag == 100{
                    
                    let row = indexPath.row
                    
                    if row == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2")
                        
                        
                        let mainid = cell?.viewWithTag(3) as! UILabel
                        mainid.text = templabel
                        let maintempmax = cell?.viewWithTag(4) as! UILabel
                        maintempmax.text = tempmax
                        let maintempmin = cell?.viewWithTag(5) as! UILabel
                        maintempmin.text = tempmin
                        
                        return cell!
                        
                    }else  if row == 1 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell
                        cell?.registerCollectionView(datasource: self)
                        return cell!
                        
                    }
                    else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
                    
                        return cell
                        
                    }
                }
                else{
                  
                    let cell = tableView.dequeueReusableCell(withIdentifier: "InsideTableViewCell") as! InsideTableViewCell
                    
                    let maintemp = cell.viewWithTag(10) as! UILabel
                    maintemp.text = days[indexPath.row].day
                    let daysdt = cell.viewWithTag(11) as! UILabel
                    daysdt.text = "\(String(days[indexPath.row].tampmin - change))°"
                    let daysTempmin = cell.viewWithTag(12) as! UILabel
                    daysTempmin.text = "\(String(days[indexPath.row].tampmax - change))°"
                    let daysImg = cell.viewWithTag(15) as! UIImageView
                    daysImg.image = days[indexPath.row].daysImg
                    
                    return cell
                }
            }
            
        }
        
        
        

        extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
            
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                
                return masHourly.count
            }
            
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for:indexPath) as? CollectionViewCell
                
                let maintemp = cell!.viewWithTag(8) as! UILabel
                maintemp.text = "\(String(masHourly[indexPath.row].tempdt - change))°"
                let maindt = cell!.viewWithTag(7) as! UILabel
                maindt.text = masHourly[indexPath.row].datedt
                let mainimg = cell!.viewWithTag(6) as! UIImageView
                mainimg.image = masHourly[indexPath.row].iconName
                
                
                
                return cell!
            }
            }

