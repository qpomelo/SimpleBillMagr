//
//  AddBillViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/1/18.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit
import Intents
import AudioToolbox

class AddBillViewController: UIViewController, KeyboardInput, SelectCostTypeDelegate, SelectCurrencyDelegate {

    var lastPageScreenshot: UIImage!
    
    static var singleMode: Bool = false
    
    @IBOutlet weak var lastPageScreenshotView: UIImageView!
    @IBOutlet weak var modalWindowBg: UIView!
    @IBOutlet weak var modalWindowBgHeightC: NSLayoutConstraint!
    @IBOutlet weak var modalWindowBgBottomC: NSLayoutConstraint!
    @IBOutlet weak var closeButtonTopC: NSLayoutConstraint!
    @IBOutlet weak var inTabTopC: NSLayoutConstraint!
    @IBOutlet weak var outTabTopC: NSLayoutConstraint!
    @IBOutlet weak var displayValue: UILabel!
    @IBOutlet weak var spendTab: UIButton!
    @IBOutlet weak var incomeTab: UIButton!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var sideBtn: UIView!
    @IBOutlet weak var currencyButton: UIButton!
    var descriptionStr: String = "备注"
    
    @IBOutlet weak var costTypeBtn: UIButton!
    @IBOutlet weak var costTypeLabel: UILabel!
    
    var selectCostType: CostType!
    var selectCurrency: Currency = Currency.getCurrency(id: 1)!
    var delegate: AddCostDoneDelegate!
    
    var isSpend: Bool = true
    var isEdit: Bool = false
    var editCost: Cost!
    var numberKeyboard: NumberKeyboard!
    var homebarBg: UIView!
    var isJumpBack: Bool = false
    var inputValue: String = ""
    
    var customTime: Int64 = 0
    
    var swipeDownStartPoint: CGPoint?
    var isClosing: Bool = false
    
    override func viewDidLoad() {
        if AddBillViewController.singleMode {
            self.dismiss(animated: false, completion: nil)
            return
        }
        
        super.viewDidLoad()
        AddBillViewController.singleMode = true
        
        self.lastPageScreenshotView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        // lastPageScreenshotView.image = lastPageScreenshot
        
        self.view.backgroundColor = .clear
        
        
        /*let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleSwipeFrom))
        recognizer.minimumPressDuration = 0
        sideBtn.addGestureRecognizer(recognizer)*/
        
        currencyButton.setTitle(selectCurrency.symbol, for: .normal)
        
        if isEdit && editCost == nil {
            // self.dismiss(animated: true, completion: )
            // playAnimateAndDismiss()
        }
        
        
        // 编辑模式下加载原有数据
        if isEdit {
            self.isSpend = editCost.isOutlay
            self.selectCurrency = editCost.currency
            self.selectCostType = editCost.type
            self.currencyButton.setTitle(editCost.currency.symbol, for: .normal)
            self.inputValue = String(editCost.cost)
            self.displayValue.text = inputValue
            self.descriptionStr = editCost.description
            self.descriptionInput.text = editCost.description
            self.costTypeLabel.text = editCost.type.title
            self.costTypeBtn.setImage(editCost.type.getIcon(), for: .normal)
            self.costTypeBtn.setBackgroundImage(UIImage.init(color: editCost.type.color), for: .normal)
            if !isSpend {
                self.spendTab.setTitle("收入", for: .normal)
                self.isSpend = false
            } else {
                self.spendTab.setTitle("支出", for: .normal)
                self.isSpend = true
            }
            self.incomeTab.isHidden = true
            
        }
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        isJumpBack = true
        let ge = UIImpactFeedbackGenerator(style: .light)
        ge.prepare()
        ge.impactOccurred()
        if segue.identifier == "showBillTypeSelector" {
            let newBillVC = segue.destination as! SelectBillTypeViewController
            newBillVC.delegate = self
            newBillVC.isOutlay = self.isSpend
        } else if segue.identifier == "selectCurrency" {
            let newBillVC = segue.destination as! SelectCurrency
            newBillVC.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.view.backgroundColor = .clear
        
        
        // HomeBar 背景
        homebarBg = UIView()
        homebarBg.backgroundColor = .white
        self.view.addSubview(homebarBg)
        homebarBg.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        })

        /*if AppDelegate.theme == .dark {
            homebarBg.backgroundColor = UIColor(hexString: "#32373D")
            modalWindowBg.backgroundColor = UIColor(hexString: "#3A4757")
            displayValue.textColor = UIColor(hexString: "#FFFFFF")
            let dark = "Dark"
            self.spendTab.setTitleColor(UIColor.init(named: "TabTextActive\(dark)"), for: .normal)
            self.incomeTab.setTitleColor(UIColor.init(named: "TabText\(dark)"), for: .normal)
            descriptionInput.keyboardAppearance = .dark
        }*/
        
        // 自定义的小键盘
        numberKeyboard = Bundle.main.loadNibNamed("NumberKeyboard", owner: nil, options: nil)?.last as? NumberKeyboard
        self.view.addSubview(numberKeyboard)
        numberKeyboard.delegate = self
        numberKeyboard.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(30)
            make.height.equalTo(380)
        }
        
        /*self.lastPageScreenshotView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.modalWindowBgBottomC.constant = -674 // 整个 modal 都在屏幕外，然后动画弹出
        if !isAllScreen {
            modalWindowBg.layer.cornerRadius = 15 // 非全面屏 iPhone 机型使用更小的圆角
        }
        self.view.layoutIfNeeded()
        
        if 0 == 1 && self.view.frame.height < 667 {
            // 针对 iPhone SE 或其他小尺寸 iPhone，将 modal 拓展至全屏幕
            modalWindowBgHeightC.constant = self.view.frame.height + 34
            // closeButtonTopC.constant += 24
            outTabTopC.constant += 24
            // inTabTopC.constant += 24
            modalWindowBg.layer.cornerRadius = 0
            modalWindowBg.snp.makeConstraints { (make) in
                make.top.equalTo(-12)
            }
        }
        
        let animateTime = (isJumpBack ? 0 : 0.3)
        UIView.animate(withDuration: animateTime, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.lastPageScreenshotView.frame = CGRect.init(x: 20, y: 50, width: self.view.frame.width - 40, height: self.view.frame.height - 50)
            self.lastPageScreenshotView.layer.cornerRadius = 10
            self.lastPageScreenshotView.layer.masksToBounds = true
            self.lastPageScreenshotView.alpha = 0.6
            self.homebarBg.snp.updateConstraints({ (make) in
                if self.isAllScreen {
                    make.height.equalTo(34)
                }
            })
            self.modalWindowBgBottomC.constant = -34
            self.view.layoutIfNeeded()
        }, completion: { (bool) in
            self.isJumpBack = false
        })
        UIView.animate(withDuration: (isJumpBack ? 0 : 0.32), animations: {
            self.numberKeyboard.snp.updateConstraints({ (make) in
                make.height.equalTo(264)
            })
            self.view.layoutIfNeeded()
        })*/
    }
    
    var isAllScreen: Bool {
        if #available(iOS 11.0, *) {
            if self.view.safeAreaInsets.bottom != 0 {
                return true
            }
        }
        return false
    }
    
    
    @IBAction func switchBillType(_ sender: Any) {
        if isEdit {
            return
        }
        let button: UIButton = sender as! UIButton
        var spend = true
        if button.tag == 1 {
            spend = false
        }
        switchBillTypeInternal(isSpend: spend)
    }
    
    func switchBillTypeInternal(isSpend: Bool) {
        if self.isSpend != isSpend {
            costTypeBtn.setBackgroundImage(UIImage.init(color: UIColor.init(named: "KeyboardDoneButtonBackground")!), for: .normal)
            costTypeBtn.setImage(nil, for: .normal)
            costTypeLabel.text = "请选择类型"
            self.selectCostType = nil
        }
        let ge = UIImpactFeedbackGenerator(style: .light)
        ge.prepare()
        ge.impactOccurred()
        let dark = (AppDelegate.theme == .dark ? "Dark" : "")
        if isSpend {
            // 切换到支出
            UIView.animate(withDuration: 0.3, animations: {
                self.spendTab.setTitleColor(UIColor.init(named: "TabTextActive\(dark)"), for: .normal)
                self.incomeTab.setTitleColor(UIColor.init(named: "TabText\(dark)"), for: .normal)
                self.isSpend = true
            })
        } else {
            // 切换到收入
            UIView.animate(withDuration: 0.3, animations: {
                self.spendTab.setTitleColor(UIColor.init(named: "TabText\(dark)"), for: .normal)
                self.incomeTab.setTitleColor(UIColor.init(named: "TabTextActive\(dark)"), for: .normal)
                self.isSpend = false
            })
        }
    }
    
    func refreshFont() {
        if inputValue.count >= 9 {
            displayValue.font = UIFont(name: "PingFangSC-Semibold", size: 38)
        } else if inputValue.count >= 8 {
            displayValue.font = UIFont(name: "PingFangSC-Semibold", size: 58)
        } else {
            displayValue.font = UIFont(name: "PingFangSC-Semibold", size: 72)
        }
    }
    
    func checkPoint(cost: String) -> Bool {
        var pointRight = ""
        let splitCost = cost.split(separator: ".")
        if splitCost.count <= 1 {
            return true
        }
        pointRight = String(splitCost[1])
        if pointRight.count >= 2 {
            return false
        }
        return true
    }
    
    
    func inputKey(keyNumber: String) {
        if !checkPoint(cost: inputValue) || inputValue.exists(".") && keyNumber == "." || (inputValue == "" && keyNumber == ".") {
            return
        }
        if ((keyNumber == "0" || keyNumber == "00") && inputValue == "") ||  Double((inputValue == "" ? "0" : inputValue))! >= 999999999.99 {
            return
        }
        inputValue = "\(inputValue)\(keyNumber)"
        displayValue.text = inputValue
        refreshFont()
        // UIDevice.current.playInputClick()
        
        print(inputValue)
    }
    
    func pressToolButton(buttonId: KeyboardToolButton) {
        if buttonId == .clear {
            inputValue = ""
            displayValue.text = "0.00"
        } else if buttonId == .backspace {
            // TODO 新版本把这里优化一下，可以水一次更新
            if inputValue.count == 0 {
                displayValue.text = "0.00"
                return
            }
            inputValue = inputValue.subString(start: 0, length: inputValue.count - 1)
            displayValue.text = inputValue
            if inputValue.count == 0 {
                displayValue.text = "0.00"
            }
        } else if buttonId == .done {
            // 完成保存
            if selectCostType == nil {
                // 未选择收支类别
                let alert = UIAlertController.init(title: "∑(ﾟДﾟ)", message: "你还没有选择收支类别", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "知道了", style: .default, handler: {
                    (ac) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if Double(inputValue) ?? 0.00 == 0.00 {
                // 未输入金额
                let alert = UIAlertController.init(title: "∑(ﾟДﾟ)", message: "你还没有输入金额", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "知道了", style: .default, handler: {
                    (ac) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            
            if descriptionInput.text != nil && descriptionInput.text != "" {
                // 输入备注
                descriptionStr = descriptionInput.text ?? ""
            } else {
                descriptionStr = selectCostType.title
            }
            
            let localZone = NSTimeZone.local
            var secs: Int64 = 0
            if localZone.secondsFromGMT().seconds.second != nil {
                secs = Int64(localZone.secondsFromGMT().seconds.second!)
            }
            var times: Int64 = 0
            if customTime == 0 {
                times = TimeTool.nowTimestamp()
            } else {
                times = customTime
            }
            times = times + secs
            
            let costObj: Cost = Cost.init(id: 0, time: times, currency: selectCurrency, type: selectCostType, description: descriptionStr, isOutlay: isSpend, cost: Double(inputValue) ?? 0.00)
            if isEdit {
                costObj.id = editCost.id
                if Cost.updateCost(costObj) {
                    self.delegate.edited(cost: costObj)
                } else {
                    let alert = UIAlertController.init(title: "失败", message: "更新账单数据失败", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "好", style: .default, handler: { (ac) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            } else {
                let costObjO = Cost.insertCost(costObj)
                print("Add cost id: \((costObjO == nil ? "Faild" : String(costObjO!.id!)))")
                self.delegate.added(cost: costObjO!)
            }
            
            if #available(iOS 12.0, *) {
                let intent = AddCostIntent()
                intent.amount = INCurrencyAmount(amount: NSDecimalNumber.init(value: costObj.cost), currencyCode: costObj.currency.name)//costObj.cost
                
                intent.type = (costObj.isOutlay ? "支出" : "收入")
                intent.use = costObj.description
                let interaction = INInteraction(intent: intent, response: nil)
                interaction.donate {
                    error in
                }
            } else {
                // Fallback on earlier versions
            }
            
            // playAnimateAndDismiss()
            self.dismiss(animated: true, completion: nil)
            
        }
        refreshFont()
    }
    
    func onSelected(costType: CostType) {
        costTypeBtn.setBackgroundImage(UIImage(color: costType.color), for: .normal)
        costTypeBtn.setImage(costType.getIcon(), for: .normal)
        costTypeLabel.text = costType.title
        self.selectCostType = costType
        let ge = UIImpactFeedbackGenerator(style: .light)
        ge.prepare()
        ge.impactOccurred()
    }
    
    func onSelected(currency: Currency) {
        selectCurrency = currency
        currencyButton.setTitle(selectCurrency.symbol, for: .normal)
        let ge = UIImpactFeedbackGenerator(style: .light)
        ge.prepare()
        ge.impactOccurred()
    }
    
    
}

extension String {
    //根据开始位置和长度截取字符串
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
    // 子串是否存在
    func exists(_ str: String) -> Bool {
        return (self.range(of: str) != nil)
    }
}

protocol SelectCostTypeDelegate {
    
    func onSelected(costType: CostType)
    
}

protocol SelectCurrencyDelegate {
    func onSelected(currency: Currency)
}
