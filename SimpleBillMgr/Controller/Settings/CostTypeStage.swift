//
//  CustomCostTypeStage.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/3/13.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit
import EFColorPicker

class CustomCostTypeStage: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var outTab: UIButton!
    @IBOutlet weak var inTab: UIButton!
    @IBOutlet weak var tabLineLeft: NSLayoutConstraint!
    @IBOutlet weak var tabLineWidth: NSLayoutConstraint!
    @IBOutlet weak var navigationBarBg: UIView!
    
    
    var costTypes: [CostType] = []
    var editingCostType: CostType?
    var selectTabIsCost: Bool = true
    
    
    override func viewWillAppear(_ animated: Bool) {
        editingCostType = nil
        updateDatas()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "CustomCostTypeCell", bundle: nil), forCellReuseIdentifier: "typeCell")
        // self.tableView.setEditing(true, animated: true)
        
        tabLineWidth.constant = self.view.frame.width / 2
        self.view.layoutIfNeeded()
        updateDatas()
        updateTheme()
    }
    
    func updateDatas() {
        let allCostTypes = CostType.getCostTypes()
        
        costTypes = []
        for cType in allCostTypes {
            if cType.isOutlay != selectTabIsCost || cType.icon == "BillTypeOther" {
                continue
            }
            costTypes.append(cType)
        }
        self.tableView.reloadData()
    }
    
    func updateTheme() {
        if AppDelegate.theme == .dark {
            view.backgroundColor = .black
            self.tableView.backgroundColor = .black
            navigationBarBg.isHidden = true
        } else {
            view.backgroundColor = .white
            self.tableView.backgroundColor = .white
            navigationBarBg.isHidden = false
        }
        // inTab.titleLabel!.textColor = UIColor(hexString: "858585")
        self.tableView.reloadData()
    }
    
    @IBAction func switchCostType(_ sender: Any) {
        let button = sender as! UIButton
        if button.tag == 0 {
            // out
            selectTabIsCost = true
            UIView.animate(withDuration: 0.2, animations: {
                self.tabLineLeft.constant = 0
                self.view.layoutIfNeeded()
            })
        } else if button.tag == 1 {
            // in
            UIView.animate(withDuration: 0.2, animations: {
                self.tabLineLeft.constant = self.view.frame.width / 2
                self.view.layoutIfNeeded()
            })
            selectTabIsCost = false
        }
        updateDatas()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showAddCostTypeVC":
            let addCostTypeVC = segue.destination as! AddCostTypeViewController
            addCostTypeVC.hidesBottomBarWhenPushed = true
            break
        default: break
        }
    }
    
}

extension CustomCostTypeStage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return costTypes.count
    }
    
   

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(
                withIdentifier: "typeCell", for: indexPath) as! CustomCostTypeCell
        
        cell.backgroundColor = .clear
        cell.icon.image = costTypes[indexPath.row].getIcon()// UIImage(named: costTypes[indexPath.row].icon)
        cell.iconBackground.backgroundColor = costTypes[indexPath.row].color
        
        cell.selectionStyle = .none
        
        cell.titleButton.setTitle(costTypes[indexPath.row].title, for: .normal)
        if AppDelegate.theme == .dark {
            cell.titleButton.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        }
        
        cell.costType = costTypes[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if costTypes[indexPath.row].icon.subString(start: 0, length: 4) == "Bill" {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO 删除
            if costTypes[indexPath.row].icon.subString(start: 0, length: 4) == "Bill" {
                let cannotDeleteTypeAlert = UIAlertController(title: "提示", message: "内置类别无法删除", preferredStyle: .alert)
                cannotDeleteTypeAlert.addAction(UIAlertAction(title: "好", style: .default, handler: {
                    (selectAction) in
                    cannotDeleteTypeAlert.dismiss(animated: true, completion: nil)
                }))
                self.present(cannotDeleteTypeAlert, animated: true, completion: nil)
                return
            } else {
                if !CostType.deleteCostType(costTypes[indexPath.row]) {
                    showAlert(title: "删除失败", text: nil)
                }
                updateDatas()
            }
            
        }
    }
    
    func showAlert(title: String, text: String?) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好", style: .destructive, handler: {
            (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
