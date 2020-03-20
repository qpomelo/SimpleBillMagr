//
//  AddBillNavigationViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/6/24.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit

class AddBillNavigationViewController: UINavigationController {

    var lastPageScreenshot: UIImage!
    var isSpend: Bool = true
    var isEdit: Bool = false
    var editCost: Cost!
    var customTime: Int64 = 0
    var addDelegate: AddCostDoneDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
