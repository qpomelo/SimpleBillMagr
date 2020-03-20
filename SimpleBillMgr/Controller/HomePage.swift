//
//  HomeSwitchPageViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/2/9.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit

class HomeSwitchPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var selectVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        self.view.backgroundColor = .white  //UIColor.init(hexString: "#33363A")
        
        let miraiCantAdd = UILabel.init()
        miraiCantAdd.text = "未\n来\n是\n无\n法\n预\n测\n的"
        miraiCantAdd.numberOfLines = 0
        miraiCantAdd.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        // self.view.addSubview(miraiCantAdd)
        self.view.insertSubview(miraiCantAdd, at: 0)
        miraiCantAdd.snp.makeConstraints { (make) in
            make.height.equalTo(400)
            make.width.equalTo(20)
            make.right.equalTo(self.view.snp.right).offset(-8)
            make.centerY.equalTo(self.view.snp.centerY)
        }
        
        
        let homeVC = getViewController(indentifier: "HomeStage") as! HomeViewController
        homeVC.dateTimestamp = TimeTool.getTodayMorningTimestamp()
        allViewControllers.append(homeVC)
        selectVC = homeVC
        self.setViewControllers([homeVC], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    // 前一个 View Controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let newVC = getViewController(indentifier: "HomeStage") as! HomeViewController
        newVC.dateTimestamp = (viewController as! HomeViewController).dateTimestamp - 86400
        selectVC = newVC
        return newVC
    }
    
    // 后一个 View Controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if ((viewController as! HomeViewController).dateTimestamp + 86400) >= TimeTool.getTodayEveningTimestamp() {
            // 不允许查看未来的账本
            return nil
        }
        let newVC = getViewController(indentifier: "HomeStage") as! HomeViewController
        newVC.dateTimestamp = (viewController as! HomeViewController).dateTimestamp + 86400
        selectVC = newVC
        return newVC
    }
    
    func findIndex(_ viewController: HomeViewController) -> Int {
        var index = 0
        for vc in allViewControllers {
            if vc.dateTimestamp == viewController.dateTimestamp {
                return index
            }
            index += 1
        }
        return -1
    }
    

    var allViewControllers: [HomeViewController] = []
    
    private func getViewController(indentifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(indentifier)")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (AppDelegate.theme == .dark ? .lightContent : .default)
    }

}
