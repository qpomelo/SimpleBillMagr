//
//  BillCell.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/1/18.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit

class BillCell: UITableViewCell {

    @IBOutlet weak var iconBg: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var topSplit: UIView!
    @IBOutlet weak var bottomSplit: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
