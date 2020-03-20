//
//  SelectCurrency.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/2/9.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit
import SnapKit

class SelectCurrency: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var currencies: [Currency] = []
    var delegate: SelectCurrencyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipeFrom))
        recognizer.direction = [.right]
        self.view.addGestureRecognizer(recognizer)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "CurrencyListCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
        self.tableView.tableFooterView = self.tableView.tableHeaderView
        self.tableView.tableHeaderView = nil
        
        
        updateDatas()
    }
    
    @objc func handleSwipeFrom(recognizer: UISwipeGestureRecognizer) {
        if(recognizer.direction == .right) {
            onHide(recognizer)
        }
    }

    @IBAction func onHide(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 设置 Cell 高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0;//Choose your custom row height
    }
    
    func updateDatas() {
        currencies = Currency.getCurrencies()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        let currency = currencies[indexPath.row]
        cell.emojiLabel.text = currency.emoji
        cell.codeLabel.text = currency.name
        cell.symbolLabel.text = currency.symbol
        cell.nameLabel.text = NSLocale.current.localizedString(forCurrencyCode: currency.name) ?? "未知货币"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.onSelected(currency: currencies[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    var isAllScreen: Bool {
        if #available(iOS 11.0, *) {
            if self.view.safeAreaInsets.bottom != 0 {
                return true
            }
        }
        return false
    }
    
    
}
