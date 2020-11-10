//
//  OrderListTableViewCell.swift
//  Order_Afternoon_Tea
//
//  Created by Cooper on 2020/11/5.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sweetnessLabel: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    @IBOutlet weak var tapiocaLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var drinkPic: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
