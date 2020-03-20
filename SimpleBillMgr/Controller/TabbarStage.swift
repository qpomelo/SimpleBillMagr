//
//  HomeTabBarViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/1/18.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController {

    var bgView: UIView!
    var addCostButton: UIButton!
    
    var addCostDelegate: AddCostQuest?
    var addCostTip: UIImageView!
    
    var needShowAddCostTipAnimate: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView = UIView()
        tabBar.insertSubview(bgView, at: 0)
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        // self.tabBar.shadowImage = UIImage(color: UIColor(white: 1, alpha: 0))
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        
        addCostButton = UIButton()
        addCostButton.setImage(UIImage(named: "TabBarAddCost"), for: .normal)
        tabBar.addSubview(addCostButton)
        addCostButton.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-6)
            make.height.equalTo(36)
            make.width.equalTo(36)
        })
        addCostButton.addTarget(self, action: #selector(addCostButtonPressed), for: .touchUpInside)
        
        addCostTip = UIImageView()
        addCostTip.image = UIImage(named: "AddCostTip")
        view.addSubview(addCostTip)
        addCostTip.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(4)
            make.bottom.equalTo(-50)
            make.width.equalTo(187)
            make.height.equalTo(53)
        }
        
        updateTheme()
        self.selectedIndex = 1
        
    }
    
    func tipDown() {
        UIView.animate(withDuration: 1, animations: {
            self.addCostTip.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.isAllScreen ? -84 : -50)
            }
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            if self.needShowAddCostTipAnimate {
                self.tipUp()
            }
        })
    }
    
    func tipUp() {
        UIView.animate(withDuration: 1, animations: {
            self.addCostTip.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.isAllScreen ? -96 : -62)
            }
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            if self.needShowAddCostTipAnimate {
                self.tipDown()
            }
        })
    }
    
    @objc func addCostButtonPressed() {
        self.needShowAddCostTipAnimate = false
        self.addCostTip.isHidden = true
        self.addCostDelegate?.addCost()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        addCostButton.snp.updateConstraints { (make) in
            make.bottom.equalTo(isAllScreen ? -40 : -6)
        }
        addCostTip.snp.updateConstraints { (make) in
            make.bottom.equalTo(isAllScreen ? -84 : -50)
        }
        self.view.layoutIfNeeded()
        if AppDelegate.addCostType == .pressButton {
            if selectedIndex == 1 {
                tipUp()
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if tabBar.items?.firstIndex(of: item) != 1 {
            addCostButton.isHidden = true
            if needShowAddCostTipAnimate {
                addCostTip.isHidden = true
            }
        } else {
            if AppDelegate.addCostType == .pressButton {
                addCostButton.isHidden = false
                if needShowAddCostTipAnimate {
                    addCostTip.isHidden = true
                }
            }
        }
    }
    
    var isAllScreen: Bool {
        if #available(iOS 11.0, *) {
            if self.view.safeAreaInsets.bottom != 0 {
                return true
            }
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {

        
        
    }
    
    
    func updateTheme(animted: Bool = false) {
        self.tabBar.shadowImage = UIImage()
        
        UIView.animate(withDuration: (animted ? 0.5 : 0), animations: {
            self.tabBar.tintColor = (AppDelegate.theme == .dark ? .white : .black)
            if AppDelegate.theme == .dark {
                self.tabBar.backgroundImage = UIImage()//color: .black)
                self.tabBar.backgroundColor = .black
                self.tabBar.barStyle = .black
                self.bgView.backgroundColor = .black
            } else {
                self.tabBar.backgroundImage = UIImage()//color: .white)
                self.tabBar.backgroundColor = .white
                self.tabBar.barStyle = .default
                self.bgView.backgroundColor = .white
            }
            self.addCostTip.image = UIImage(named: "AddCostTip\(AppDelegate.theme == .dark ? "Dark" : "")")
            
            if self.selectedIndex == 1 {
                if AppDelegate.addCostType == .sideDown {
                    self.addCostTip.isHidden = true
                    self.addCostButton.isHidden = true
                } else {
                    if self.needShowAddCostTipAnimate {
                        self.addCostTip.isHidden = false
                    }
                    self.addCostButton.isHidden = false
                }
            }
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (AppDelegate.theme == .dark ? .lightContent : .default)
    }
    
}

protocol AddCostQuest {
    func addCost()
}
