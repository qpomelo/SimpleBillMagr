
//
//  ChartViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/3/9.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BudgetCell", bundle: nil), forCellReuseIdentifier: "BudgetCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
}

extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BudgetCell") as! BudgetCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    
}
