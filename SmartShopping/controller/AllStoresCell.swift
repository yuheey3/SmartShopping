//
//  AllStoresCell.swift
//  SmartShopping
//
//  Created by Yuki Waka on 2021-04-30.
//

import UIKit

class AllStoresCell: UITableViewCell {
    
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblCity : UILabel!
    @IBOutlet var lblCountry : UILabel!
    @IBOutlet var lblProvince : UILabel!
    @IBOutlet var lblPostalCode : UILabel!
    @IBOutlet var lblStreetAddress : UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
