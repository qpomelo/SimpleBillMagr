//
//  SettingsAboutViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/1/29.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit
import StoreKit

class SettingsAboutViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func goAppStore(_ sender: Any) {
        let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
        if isTestFlight {
            let tfAlert = UIAlertController(title: "无法评分", message: "通过 Test Flight 安装的版本不支持去 App Store 评分", preferredStyle: .alert)
            tfAlert.addAction(UIAlertAction.init(title: "好", style: .default, handler: { (action) in
                tfAlert.dismiss(animated: true, completion: nil)
            }))
            self.present(tfAlert, animated: true, completion: nil)
            return
        }
        // AppID 1450912559
        let nsStringToOpen = String.init(format: "itms-apps://itunes.apple.com/app/id%@?action=write-review", "1450912559");//替换为对应的APPID
        UIApplication.shared.open(URL(string: nsStringToOpen)!)
    }
    
    @IBAction func joinReportGroup(_ sender: Any) {
        let url = URL(string: "https://t.me/qpomeloCostBook")!
        UIApplication.shared.open(url)
    }
}

