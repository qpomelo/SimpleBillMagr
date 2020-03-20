//
//  BudgetCell.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/3/17.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit

class BudgetCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        bgView.layer.masksToBounds = true
        let bg = UIImageView(image: UIImage(named: "LinearBgBlue"))
        bgView.insertSubview(bg, at: 0)
        bg.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
