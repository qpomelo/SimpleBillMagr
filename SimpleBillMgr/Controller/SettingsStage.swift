//
//  SettingsViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/1/29.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit
import SafariServices

class SettingsViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var nb: UIView!
    @IBOutlet weak var nbBg: UIView!
    @IBOutlet weak var nbTitle: UILabel!
    
    let normalSettingsImgs = ["settings_icon_sync", "settings_icon_type_manage", "settings_icon_theme", "settings_icon_alarm_siri_shortcut", "settings_icon_lock"]
    let aboutSettingsImgs = ["starIcon", "settings_icon_about"]
    
    let normalSettingsTitles = ["备份与导出", "收支类别管理", "主题与背景", "提醒与 Siri 捷径", "安全性与隐私"]
    let aboutSettingsTitles = ["去 App Store 评分", "关于"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
        updateTheme(isDarkMode: AppDelegate.theme, animated: false)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
            self.navigationController?.delegate = nil
            /* if self.navigationController?.delegate != nil && self.isKind(of: self.navigationController?.delegate) {
                self.navigationController?.delegate = nil
            } */
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.bounces = false
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
        
        let fView = tableView.tableFooterView
        tableView.tableFooterView = nil
        tableView.tableHeaderView = fView
        tableView.separatorColor = UIColor.init(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        
        
        updateTheme(isDarkMode: AppDelegate.theme, animated: false)
    }

    func updateTheme(isDarkMode: Theme, animated: Bool = true) {
        
        UIView.animate(withDuration: (animated ? 1.0 : 0.0), animations: {
            let bgImage = UIImage(color: (isDarkMode == .dark ? .black : .white))
            self.navigationController?.navigationBar.setBackgroundImage(bgImage, for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor(hexString: (isDarkMode == .dark ? "#FFFFFF" : "#000000"))
            self.navigationController?.navigationBar.isTranslucent = false
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.isTranslucent = true
            if isDarkMode == .dark {
                self.navigationController?.navigationBar.barStyle = .black
            } else {
                self.navigationController?.navigationBar.barStyle = .default
            }
            self.view.backgroundColor = (isDarkMode == .dark ? .black : .white)
            self.nb.backgroundColor = (isDarkMode == .dark ? .black : .white)
            self.nbBg.backgroundColor = (isDarkMode == .dark ? .black : .white)
            self.nbTitle.textColor = UIColor(hexString: (isDarkMode == .dark ? "#FFFFFF" : "#000000"))
            self.tableView.backgroundColor = (isDarkMode == .dark ? UIColor(hexString: "#000000") : UIColor(red: 1, green: 1, blue: 1, alpha: 0.01))
            
            
        })
        
        self.tableView.separatorStyle = .none
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        
        self.tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (AppDelegate.theme == .dark ? .lightContent : .default)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAbout" {
            segue.destination.hidesBottomBarWhenPushed = true
        }
        
        switch segue.identifier {
        case "themeStore":
            let themeStoreVC = segue.destination as! ThemeSettingsViewController
            themeStoreVC.settingsViewController = self
            break
        default:
            break
        }
    }
    
}



extension SettingsViewController: UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 1 {
            if scrollView.contentOffset.y <= 100 {
                navigationBar.alpha = ((scrollView.contentOffset.y - 0) * 0.01)
            } else {
                navigationBar.alpha = 1
            }
        } else {
            navigationBar.alpha = 0
        }
    }

    // 设置 Cell 高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
    
    // 返回 Cell 实例
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var imgs: [String] = []
        var titles: [String] = []
        if indexPath.section == 0 {
            imgs = normalSettingsImgs
            titles = normalSettingsTitles
        } else if indexPath.section == 1 {
            imgs = aboutSettingsImgs
            titles = aboutSettingsTitles
        }
        
        let cell =
            self.tableView.dequeueReusableCell(
                withIdentifier: "SettingCell", for: indexPath) as! SettingTableViewCell
        cell.iconImageView.image = UIImage(named: imgs[indexPath.row])
        cell.titleLabel.text = String(titles[indexPath.row])
        if AppDelegate.theme == .dark {
            cell.backgroundColor = UIColor(hexString: "#252525")
            cell.titleLabel.textColor = UIColor(hexString: "#FFFFFF")
            self.tableView.separatorStyle = .none
        } else {
            cell.backgroundColor = UIColor(hexString: "#FFFFFF")
            cell.titleLabel.textColor = UIColor(hexString: "#000000")
            self.tableView.separatorStyle = .singleLine
        }
        
        return cell
    }
    
    
    // Table View 分组数量
    /*func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if section == 0 {
            rows = 5
        } else if section == 1 {
            rows = 2
        }
        return rows
    }
    
    //cell点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            // 通用
            let rowOfSegueIdentifier = ["exportOrSync", "costTypeMgr", "themeStore"]
            if indexPath.row >= rowOfSegueIdentifier.count { return }
            self.performSegue(withIdentifier: rowOfSegueIdentifier[indexPath.row], sender: nil)
        } else if indexPath.section == 1 {
            // 开放源代码许可和关于
            /*if indexPath.row == 0 {
                // 开放源代码许可
                // self.performSegue(withIdentifier: "showOpensourceLis", sender: nil)
                let lincensePageURL = URL(string: "https://github.com/WatanabeQPomelo/QPomeloCostBook/blob/master/opensourceprojectlicense.md")!
                let safariVC = SFSafariViewController(url: lincensePageURL)
                safariVC.delegate = self
                self.present(safariVC, animated: true, completion: nil)
            } else */
            if indexPath.row == 0 {
                // 去 App Store 评分
                // AppID 1450912559
                let nsStringToOpen = String.init(format: "itms-apps://itunes.apple.com/app/id%@?action=write-review", "1450912559");//替换为对应的APPID
                UIApplication.shared.open(URL(string: nsStringToOpen)!)
            } else if indexPath.row == 1 {
                // 关于
                self.performSegue(withIdentifier: "showAbout", sender: nil)
            }
        }
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}


public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
