//
//  TableViewCell.swift
//  WeatherPllug
//
//  Created by Nazar Kovalik on 6/24/19.
//  Copyright © 2019 Nazar Kovalik. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
       
            
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func registerCollectionView<DataSourse:UICollectionViewDataSource>(datasource:DataSourse) {
        self.collectionView.dataSource = datasource
        collectionView.reloadData()
    }
    
    

}
