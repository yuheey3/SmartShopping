//
//  AllStoreCell.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-05-21.
//

import UIKit

class AllStoreCell: UITableViewCell {
    
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblAddress : UILabel!
//    @IBOutlet var lblCountry : UILabel!
//    @IBOutlet var lblProvince : UILabel!
//    @IBOutlet var lblPostalCode : UILabel!
//    @IBOutlet var lblStreetAddress : UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
