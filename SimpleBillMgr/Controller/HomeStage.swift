//
//  ViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/1/18.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit
import SnapKit
import SwiftDate

class HomeViewController: UIViewController, AddCostDoneDelegate {
    
    @IBOutlet weak var headerViewBg: UIView!
    @IBOutlet weak var headerViewBgHeihtConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var navigationBarTitle: UILabel!
    @IBOutlet weak var navigationBarSubTitle: UILabel!
    @IBOutlet weak var navigationBarSD: UIButton!
    
    @IBOutlet weak var navigationBarSmall: UIView!
    @IBOutlet weak var navigationBarSmallTitle: UILabel!
    @IBOutlet weak var navigationBarSmallSubTitle: UILabel!
    @IBOutlet weak var navigationBarSmallAdd: UIButton!
    @IBOutlet weak var navigationBarSmallSD: UIButton!
    
    @IBOutlet weak var sidedownToAddBillIcon: UIButton!
    @IBOutlet weak var sidedownToAddBillTip: UILabel!
    @IBOutlet weak var listView: UITableView!
    
    var noItemIcon: UIImageView!
    var noItemIconTip: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteButtonBottomC: NSLayoutConstraint!
    @IBOutlet weak var swipeIcon: UIImageView!
    @IBOutlet weak var swipeBg: UIView!
    
    var isSwiping: Bool = false
    var lastSwipeCanDelete = false
    var swipingCost: Cost!
    var dateTimestamp: Int64!
    var sideLength: CGFloat = 0.01
    var costs: [Cost] = []
    var editCost: Cost!
    
    var selfImage: UIImage?
    
    func initListViewLongPress() {
        let longPressReger = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress))
        longPressReger.minimumPressDuration = 0.2
        self.view.addGestureRecognizer(longPressReger)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let point: CGPoint = gestureRecognizer.location(in: view)
        var cost: Cost?
        
        if !isSwiping {
            let fixedPosPoint = CGPoint(x: point.x, y: point.y + listView.contentOffset.y)
            let indexPath = listView.indexPathForRow(at: fixedPosPoint)
            if indexPath == nil { return /* 所长按之处无 Cell */ }
            cost = costs[(indexPath?.row)!]
            swipingCost = cost
        } else {
            cost = swipingCost
        }
        
        if isSwiping {
            swipeBg.frame = CGRect.init(x: point.x - 21, y: point.y - 21, width: swipeBg.frame.width, height: swipeBg.frame.height)
            
            let deleteArea = deleteButton.frame
            
            if point.x > deleteArea.minX && point.x < deleteArea.maxX && point.y > deleteArea.minY && point.y < deleteArea.maxY {
                if !lastSwipeCanDelete {
                    let ge = UIImpactFeedbackGenerator(style: .medium)
                    ge.prepare()
                    ge.impactOccurred()
                }
                if gestureRecognizer.state == .ended {
                    // Delete
                    let deleteAlert = UIAlertController.init(title: cost?.description ?? "记账", message: "你确定要删除这笔 \(cost?.currency.symbol ?? "$")\(cost?.cost ?? 0.0) 的记账吗？", preferredStyle: .actionSheet)
                    deleteAlert.addAction(UIAlertAction.init(title: "删除", style: .destructive, handler: { (action) in
                        deleteAlert.dismiss(animated: true, completion: nil)
                        if cost == nil { return }
                        let result = Cost.deleteCost(cost!)
                        if result {
                            self.updateDatas()
                            print("delete \(String(describing: cost!.id))")
                        } else {
                            let deleteFaildAlert = UIAlertController.init(title: "删除失败", message: "暂时无法删除", preferredStyle: .alert)
                            deleteFaildAlert.addAction(UIAlertAction.init(title: "好", style: .default, handler: ({ (actionFaild) in
                                deleteFaildAlert.dismiss(animated: true, completion: nil)
                            })))
                            self.present(deleteFaildAlert, animated: true, completion: nil)
                        }
                    }))
                    deleteAlert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                        deleteAlert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(deleteAlert, animated: true, completion: nil)
                }
                lastSwipeCanDelete = true
                deleteButton.setImage(UIImage(named: "deleteIconOpen"), for: .normal)
                deleteButton.backgroundColor = UIColor(hexString: "#B21F31")
            } else {
                deleteButton.setImage(UIImage(named: "deleteIcon"), for: .normal)
                deleteButton.backgroundColor = UIColor(hexString: "#FF5166")
                lastSwipeCanDelete = false
            }
        }
        
        
        
        if gestureRecognizer.state == .ended {
            swipeBg.isHidden = true
            isSwiping = false
            self.swipeBg.frame = CGRect.init(x: -50, y: -50, width: swipeBg.frame.width, height: swipeBg.frame.height)
            UIView.animate(withDuration: 0.6, animations: {
                self.deleteButtonBottomC.constant = -72
                self.updateViewConstraints()
            })
            let ge = UIImpactFeedbackGenerator(style: .light)
            ge.prepare()
            ge.impactOccurred()
        }
        
        
        
        if gestureRecognizer.state == .began {
            swipeBg.isHidden = false
            isSwiping = true
            UIView.animate(withDuration: 0.6, animations: {
                self.deleteButtonBottomC.constant = 18
                self.updateViewConstraints()
            })
            
            if cost != nil {
                swipeBg.backgroundColor = cost!.type.color
                swipeIcon.image = UIImage.init(named: cost!.type.icon)
            }
            
            let ge = UIImpactFeedbackGenerator(style: .heavy)
            ge.prepare()
            ge.impactOccurred()
            
            
        } else if gestureRecognizer.state == .changed {
            // print("changed")
        }
        
        
        
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        /*if let image = selfImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            imageView.image = image
            self.view.addSubview(imageView)
            UIView.animate(withDuration: 0.5, animations: {
                imageView.alpha = 0
            }, completion: { (bool) in
                imageView.removeFromSuperview()
                self.selfImage = UIApplication.shared.keyWindow!.asImage()
            })
        }*/
        updateTheme(isDarkMode: AppDelegate.theme, animated: false)
        updateDatas()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listView.tableHeaderView = self.navigationBar
        self.listView.delegate = self
        self.listView.dataSource = self
        self.listView.register(UINib(nibName: "HomeBillListCell", bundle: nil), forCellReuseIdentifier: "billCell")
        self.listView.separatorStyle = .none
        self.listView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.01)
        self.swipeBg.frame = CGRect.init(x: -50, y: -50, width: swipeBg.frame.width, height: swipeBg.frame.height)
        self.navigationController?.delegate = self
        
        self.transitioningDelegate = self
        
        
        self.noItemIcon = UIImageView()
        noItemIcon.image = UIImage(named: "inboxNoItem")
        noItemIcon.isHidden = true
        self.view.addSubview(noItemIcon)
        noItemIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(96)
            make.width.equalTo(96)
        }
        self.noItemIconTip = UILabel()
        noItemIconTip.text = "没有账单"
        noItemIconTip.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 80/255)
        noItemIconTip.font = UIFont.init(name: "PingFangSC-Semibold", size: 18)
        noItemIconTip.isHidden = false
        self.view.addSubview(noItemIconTip)
        noItemIconTip.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(noItemIcon.snp.bottom).offset(6)
        })
        
        // List Table View 内容延展出 Safe Area
        self.extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 11.0, *) {
            self.listView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 显示时间
        let dateTime = TimeTool.timestamp2DateTime(dateTimestamp)
        navigationBarSmallTitle.text = "\(dateTime.month)月\(dateTime.day)日"
        navigationBarTitle.text = "\(dateTime.month)月\(dateTime.day)日"
        
        updateDatas()
    
        initListViewLongPress()
        updateTheme(isDarkMode: AppDelegate.theme, animated: false)
        
    }
    
    func updateDatas() {
        if AppDelegate.addCostType == .sideDown {
        } else {
            listView.tableFooterView?.isHidden = true
        }
        
        self.costs = Cost.getCosts(startTime: dateTimestamp, endTime: dateTimestamp + 86399)
        
        var incomeCount: Double = 0.00
        var costCount: Double = 0.00
        
        for cost in self.costs {
            if cost.currency.id != AppDelegate.preferredCurrencyId {
                continue
            }
            if cost.isOutlay {
                costCount += cost.cost
            } else {
                incomeCount += cost.cost
            }
        }
        
        let costCountDisplay: String = String(format: "%.2f", costCount) // 某些情况下浮点数会挂、故取两位小数处理
        let incomeCountDisplay: String = String(format: "%.2f", incomeCount) // e.g 0.1 + 0.2 = 0.300...4
        
        navigationBarSubTitle.text = "支出 ¥\(costCountDisplay) 收入 ¥\(incomeCountDisplay)"
        navigationBarSmallSubTitle.text = navigationBarSubTitle.text
        
        if costs.count != 0 {
            // 有账单
            listView.tableFooterView?.isHidden = true
            self.noItemIcon.isHidden = true
            self.noItemIconTip.isHidden = true
        } else {
            // 无账单
            if AppDelegate.addCostType == .sideDown {
                listView.tableFooterView?.isHidden = false
            } else {
                self.noItemIcon.isHidden = false
                self.noItemIconTip.isHidden = false
            }
            
        }
        
        self.listView.reloadData()
    }
    
    func updateTheme(isDarkMode: Theme, animated: Bool = true) {
        
        UIView.animate(withDuration: (animated ? 1.0 : 0.00), animations: {
            self.view.backgroundColor = (isDarkMode == .dark ? UIColor(hexString: "#000000") : UIColor(hexString: "#FFFFFF"))
            self.headerViewBg.backgroundColor = self.view.backgroundColor
            self.navigationBar.backgroundColor = self.view.backgroundColor
            self.navigationBarSmall.backgroundColor = (isDarkMode == .dark ? UIColor(hexString: "#000000") : UIColor(hexString: "#FFFFFF"))
            self.navigationBarTitle.textColor = (isDarkMode == .dark ? UIColor(hexString: "#FFFFFF") : UIColor(hexString: "#000000"))
            self.navigationBarSmallTitle.textColor = (isDarkMode == .dark ? UIColor(hexString: "#FFFFFF") : UIColor(hexString: "#000000"))
            self.listView.backgroundColor = (isDarkMode == .dark ? UIColor(hexString: "#000000") : UIColor(red: 1, green: 1, blue: 1, alpha: 0.01))
        })
        
        let dark = (isDarkMode == .dark ? "Dark" : "")
        navigationBarSD.setImage(UIImage(named: "NavigationBarIconSwitchDate\(dark)"), for: .normal)
        navigationBarSmallSD.setImage(UIImage(named: "NavigationBarIconSwitchDate\(dark)"), for: .normal)
        navigationBarSmallAdd.setImage(UIImage(named: "NavigationBarIconAddBill\(dark)"), for: .normal)
        
        let tabVC = self.tabBarController as! HomeTabBarViewController
        tabVC.addCostDelegate = self
        
        self.noItemIcon.image = UIImage(named: "inboxNoItem\(dark)")
        self.noItemIconTip.textColor = (AppDelegate.theme == .dark ? UIColor(red: 1, green: 1, blue: 1, alpha: 80/255) : UIColor(red: 0, green: 0, blue: 0, alpha: 80/255))
        
        if Config.getConfig("addCostType")?.value == "pressButton" {
            AppDelegate.addCostType = .pressButton
            self.listView.bounces = false
            noItemIconTip.isHidden = false
            noItemIcon.isHidden = false
        } else {
            AppDelegate.addCostType = .sideDown
            self.listView.bounces = true
            noItemIconTip.isHidden = true
            noItemIcon.isHidden = true
        }
        
        updateDatas()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "newBill":
            let newBillVC = segue.destination as! AddBillViewController
            if AddBillViewController.singleMode {
                newBillVC.dismiss(animated: false, completion: nil)
                return
            }
            
            if dateTimestamp < TimeTool.getTodayMorningTimestamp() {
                newBillVC.customTime = dateTimestamp
            }
            newBillVC.delegate = self
            newBillVC.lastPageScreenshot = UIApplication.shared.keyWindow!.asImage()
            self.selfImage = newBillVC.lastPageScreenshot
            if editCost != nil {
                newBillVC.isEdit = true
                newBillVC.editCost = editCost
                self.editCost = nil
            }
            break
        default:
            break
        }
    }
    // 跳转到添加新账单页面
    @IBAction func addBillTip(_ sender: Any) {
        self.performSegue(withIdentifier: "newBill", sender: self)
    }
    // 切换日期
    @IBAction func switchDate(_ sender: Any) {
        
    }
    
    // 用户添加新开销 更新数据
    func added(cost: Cost) {
        updateDatas()
    }
    
    // 用户编辑开销 更新数据
    func edited(cost: Cost) {
        updateDatas()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (AppDelegate.theme == .dark ? .lightContent : .default)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, AddCostQuest {
    
    // 打开添加账单页面 (被父 TabBar 调用)
    func addCost() {
        self.performSegue(withIdentifier: "newBill", sender: self)
        let ge = UIImpactFeedbackGenerator(style: .heavy)
        ge.prepare()
        ge.impactOccurred()
    }
    
    // 设置导航栏是否显示
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
            /* if self.navigationController?.delegate != nil && self.isKind(of: self.navigationController?.delegate) {
             self.navigationController?.delegate = nil
             } */
        }
    }
    
    // Table View 被下滑
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 拉长顶部空白区域
        if scrollView.contentOffset.y < 0 {
            headerViewBgHeihtConstraint.constant = 50 - scrollView.contentOffset.y
        }else{
            headerViewBgHeihtConstraint.constant = 50
        }
        // 更新小导航栏的大小
        if scrollView.contentOffset.y >= 1 {
            if scrollView.contentOffset.y <= 100 {
                navigationBarSmall.alpha = ((scrollView.contentOffset.y - 0) * 0.01)
            } else {
                navigationBarSmall.alpha = 1
            }
        } else {
            navigationBarSmall.alpha = 0
        }
        // 超过一定距离打开添加账单面板
        if -scrollView.contentOffset.y >= sideLength && AppDelegate.addCostType == .sideDown {
            self.performSegue(withIdentifier: "newBill", sender: self)
            let ge = UIImpactFeedbackGenerator(style: .heavy)
            ge.prepare()
            ge.impactOccurred()
        }
    }
    
    // Table View 被选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cost = costs[indexPath.row]
        self.editCost = cost
        self.performSegue(withIdentifier: "newBill", sender: nil)
    }
    
    // Table View 下滑之后松手
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // UIImageWriteToSavedPhotosAlbum(UIApplication.shared.keyWindow!.asImage(), nil, nil, nil)
    }
    
    // 返回列表长度
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return costs.count
    }
    
    // 设置 Cell 高度
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 64.0
    }*/
    
    // 生成 Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            self.listView.dequeueReusableCell(
                withIdentifier: "billCell", for: indexPath) as! BillCell
        cell.backgroundColor = .clear
        
        let cost = costs[indexPath.row]
        cell.costLabel.text = "\((cost.isOutlay ? "-" : "+")) \(cost.currency.symbol ?? "?") \(cost.cost ?? 0.00)"
        cell.descriptionLabel.text = cost.description
        cell.iconBg.backgroundColor = cost.type.color
        cell.icon.image = cost.type.getIcon()
        cell.selectionStyle = .none
        if indexPath.row == 0 { cell.topSplit.isHidden = true }
        if indexPath.row == costs.count - 1 { cell.bottomSplit.isHidden = true }
        if AppDelegate.theme == .dark {
            cell.costLabel.textColor = UIColor(hexString: "#FFFFFF")
            cell.descriptionLabel.textColor = UIColor(hexString: "#939393")
        } else {
            cell.costLabel.textColor = UIColor(hexString: "#000000")
            cell.descriptionLabel.textColor = UIColor(hexString: "#939393")
        }
        
        return cell
    }
    
    // 是否是全面屏
    // 不能在 viewDidLoad() 里面用
    var isAllScreen: Bool {
        if #available(iOS 11.0, *) {
            if self.view.safeAreaInsets.bottom != 0 {
                return true
            }
        }
        return false
    }
    
}

extension UIView {
    
    //将当前视图转为UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

protocol AddCostDoneDelegate {
    func added(cost: Cost)
    func edited(cost: Cost)
}
