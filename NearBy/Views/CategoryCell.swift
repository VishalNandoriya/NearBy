//
//  CategoryCell.swift
//  NearBy
//
//  Created by Mac-Vishal on 21/04/17.
//  Copyright © 2017 Vishal. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var titleLabel :UILabel!
    @IBOutlet weak var addressLable :UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
