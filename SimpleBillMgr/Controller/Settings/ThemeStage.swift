//
//  ThemeSettingsViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/3/17.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit

class ThemeSettingsViewController: UIViewController {

    var settingsViewController: SettingsViewController?
    
    @IBOutlet weak var pressButtonUsing: UIImageView!
    @IBOutlet weak var sideDownUsing: UIImageView!
    @IBOutlet weak var darkThemeButton: UIButton!
    @IBOutlet weak var classicThemeButton: UIButton!
    @IBOutlet weak var themeUsingClassic: UIImageView!
    @IBOutlet weak var themeUsingDark: UIImageView!
    @IBOutlet weak var addCostPressButton: UIButton!
    @IBOutlet weak var addCostSideDown: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if Config.getConfig("darkMode") == nil {
            _ = Config.insertConfig(Config(name: "darkMode", value: "false"))
            themeUsingDark.isHidden = true
        } else {
            let config = Config.getConfig("darkMode")
            if config!.value == "true" {
                themeUsingClassic.isHidden = true
            } else {
                themeUsingDark.isHidden = true
            }
        }
        
        if Config.getConfig("addCostType") == nil {
            _ = Config.insertConfig(Config(name: "addCostType", value: "pressButton"))
            sideDownUsing.isHidden = true
        } else {
            let config = Config.getConfig("addCostType")
            if config!.value == "sideDown" {
                pressButtonUsing.isHidden = true
            } else {
                sideDownUsing.isHidden = true
            }
        }
        
        
    }
    
    @IBAction func switchAddCostType(_ sender: Any) {
        let button = sender as! UIButton
        if button.tag == 1 {
            // 下滑
            _ = Config.updateConfig(Config(name: "addCostType", value: "sideDown"))
            pressButtonUsing.isHidden = true
            sideDownUsing.isHidden = false
            AppDelegate.addCostType = .sideDown
        } else {
            // 点按
            _ = Config.updateConfig(Config(name: "addCostType", value: "pressButton"))
            pressButtonUsing.isHidden = false
            sideDownUsing.isHidden = true
            AppDelegate.addCostType = .pressButton
        }
        
    }
    
    
    @IBAction func switchTheme(_ sender: Any) {
        let button = sender as! UIButton
        if button.tag == 1 {
            // 默认主题
            themeUsingClassic.isHidden = false
            themeUsingDark.isHidden = true
        } else {
            // 暗色主题
            themeUsingClassic.isHidden = true
            themeUsingDark.isHidden = false
        }
        
        let value = (button.tag == 2 ? "true" : "false")
        _ = Config.updateConfig(Config.init(name: "darkMode", value: value))
        if Config.getConfig("darkMode") == nil {
            _ = Config.insertConfig(Config(name: "darkMode", value: "false"))
        } else {
            let config = Config.getConfig("darkMode")
            if config!.value == "true" {
                AppDelegate.theme = .dark
            } else {
                AppDelegate.theme = .light
            }
        }
        
        let tC = self.tabBarController as! HomeTabBarViewController
        tC.updateTheme(animted: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        
        // self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .default
        
        // self.tabBarController?.tabBar.isHidden = false
    }
    
    
}
