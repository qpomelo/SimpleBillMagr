//
//  CustomCostTypeCell.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/3/13.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit

class CustomCostTypeCell: UITableViewCell {

    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var iconBackground: UIView!
    @IBOutlet weak var icon: UIImageView!
    var iconColor: UIColor!
    
    var delegate: CustomCostTypeDelegate?
    var costType: CostType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconBackground.backgroundColor = iconColor
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pressedImageButton(_ sender: Any) {
        self.delegate?.onImageButton(self)
    }
    
    @IBAction func pressedTitleButton(_ sender: Any) {
        self.delegate?.onTitleButton(self)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.1, animations: {
            self.contentView.backgroundColor = (highlighted ? (AppDelegate.theme == .dark ? UIColor(white: 1, alpha: 0.4) : UIColor(white: 0, alpha: 0.4)) : .clear)
        })
    }
    
}

protocol CustomCostTypeDelegate {
    
    func onImageButton(_ sender: CustomCostTypeCell)
    func onTitleButton(_ sender: CustomCostTypeCell)
    
}
