//
//  TestViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/3/24.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initListViewLongPress()
        // Do any additional setup after loading the view.
    }
    
    func initListViewLongPress() {
        let longPressReger = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress))
        longPressReger.minimumPressDuration = 0
        self.view.addGestureRecognizer(longPressReger)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let ge = UIImpactFeedbackGenerator(style: .light)
            ge.prepare()
            ge.impactOccurred()
        } else if gestureRecognizer.state == .ended {
            let ge = UIImpactFeedbackGenerator(style: .heavy)
            ge.prepare()
            ge.impactOccurred()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
