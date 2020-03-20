//
//  UserGuideViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/6/24.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit

class UserGuideViewController: UIViewController {

    @IBOutlet weak var guideImage: UIImageView!
    @IBOutlet weak var guideTitle: UILabel!
    @IBOutlet weak var guideText: UILabel!
    @IBOutlet weak var guideDescription: UILabel!
    @IBOutlet weak var guideNextButton: UIButton!
    @IBOutlet weak var skipGuideButton: UIButton!
    
    
    let guideImages = ["UserGuide_Welcome", "UserGuide_NewCost", "UserGuide_SwitchDate", "UserGuide_SetCurrencyAndType", "UserGuide_DeleteCost", "UserGuide_CustomCostType", "UserGuide_TestFlight", "UserGuide_UserGroup"]
    let guideTitles = ["", "新建一笔账单", "查看过往账单", "使账单更精确", "删除账单", "自定义记账类别", "您当前正在体验 Beta 版本", "加入用户群组"]
    let guideTexts = ["", "在主页面点击 \"+\" 按钮", "在主界面左右滑动", "选择货币和账单类型", "短按任意账单并将其拖入垃圾桶", "根据您的需求添加自定义的账单类型", "此版本可能包含潜在的程序错误，因此导致的任何数据丢失问题开发者概不负责\r\n\r\n您随时可以通过 TestFlight 退出测试", "您可以在这里与其他用户交流，向开发者建议新功能、反馈 bugs…"]
    let guideDescriptions = ["您正在使用 Beta 版本，此版本尚未完成，其功能不代表最终品质" ,"", "", "", "", "您稍后可以在 \"设置\" > \"开支类别管理\" 自定义", "其实没有丢数据那么严重啦ヾ(｡>﹏<｡)ﾉﾞ✧*。", "Telegram 需要国际互联网连接，部分国家需要使用代理方可连接"]
    var guideIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        updateGuide()
    }

    @IBAction func skipUserGuide(_ sender: Any) {
        if guideIndex == 0 || guideIndex == 7 {
            return
        }
        else if guideIndex == 8 {
            self.doneGuide()
            return
        }
        let alert = UIAlertController(title: "跳过教程", message: "你确定要跳过教程吗？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.guideIndex = 6
            self.nextGuide(self)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nextGuide(_ sender: Any) {
        if guideIndex == 8 {
            let url = URL(string: "tg://qpomeloCostBook")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        if guideIndex == guideImages.count {
            doneGuide()
        } else {
            updateGuide()
        }
    }
    
    func doneGuide() {
        self.dismiss(animated: true, completion: nil)
        _ = Config.insertConfig(Config(name: "isFinishUserGuide", value: "true"))
    }
    
    
    func updateGuide() {
        if guideIndex == 0 || guideIndex == 6 {
            // “欢迎使用 柚子记账” 和 “您正在体验 Beta 版本”
            self.skipGuideButton.isHidden = true
        } else {
            self.skipGuideButton.isHidden = false
        }
        print("index: \(guideIndex), count: \(guideImages.count)")
        guideImage.image = UIImage(named: guideImages[guideIndex])
        guideTitle.text = guideTitles[guideIndex]
        guideText.text = guideTexts[guideIndex]
        guideDescription.text = guideDescriptions[guideIndex]
        if guideIndex == guideImages.count - 1 {
            guideNextButton.setTitle("完成", for: .normal)
        }
        guideIndex = guideIndex + 1
    }
    
}
