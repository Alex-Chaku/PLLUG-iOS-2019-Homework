//
//  MainTableViewCell.swift
//  WeatherPllug
//
//  Created by Nazar Kovalik on 6/26/19.
//  Copyright © 2019 Nazar Kovalik. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var tblInsideTableView: UITableView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        tblInsideTableView.reloadData()
        // Configure the view for the selected state
    }
    


}


extension MainTableViewCell{
    func setTableViewDataSourceDelegate
        <D:UITableViewDelegate & UITableViewDataSource>
        (_ dataSourceDelegate: D, forRow row: Int)
    {
    tblInsideTableView.delegate = dataSourceDelegate
    tblInsideTableView.dataSource = dataSourceDelegate
     
        tblInsideTableView.reloadData()
    }
}
