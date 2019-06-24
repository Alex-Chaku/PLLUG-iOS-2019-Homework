//
//  CitiesTableViewController.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/9/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import UIKit

class CitiesTableViewController: UITableViewController {
    
    let searchCitiesId = "SearchCities"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        
        return cell
    }

    @IBAction func addCityTapped(_ sender: UIButton) {
        performSegue(withIdentifier: searchCitiesId, sender: nil)
    }
    
}
