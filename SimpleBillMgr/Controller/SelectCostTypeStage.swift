//
//  SelectBillTypeViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/1/29.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit

class SelectBillTypeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var types: [CostType] = []
    var delegate: SelectCostTypeDelegate?
    var isOutlay: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 左滑返回
        let recognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipeFrom))
        recognizer.direction = [.right]
        self.view.addGestureRecognizer(recognizer)
        
        // UICollectionView 布局
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize.init(width: 52, height: 90)
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "CostTypeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CostTypeCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        updateDatas()
    }
    
    func updateDatas() {
        types = CostType.getCostTypes(isOutlay: self.isOutlay)
        self.collectionView.reloadData()
    }
    
    @IBAction func onHide(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSwipeFrom(recognizer: UISwipeGestureRecognizer) {
        if(recognizer.direction == .right) {
            onHide(recognizer)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CostTypeCell", for: indexPath) as! CostTypeCollectionCell
        cell.btn.setImage(types[indexPath.row].getIcon(), for: .normal)
        cell.btn.setBackgroundImage(createImageWithColor(types[indexPath.row].color), for: .normal)
        cell.btn.layer.masksToBounds = true
        cell.label.text = types[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onSelected(costType: types[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func createImageWithColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
}
