//
//  AddCostTypeViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/4/30.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit
import EFColorPicker

class AddCostTypeViewController: UIViewController, EFColorSelectionViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker: UIImagePickerController!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameInput: UITextField!
    
    
    var isEdit: Bool = false
    var isCost: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        
        // 判断是否输入类别名称
        if nameInput.text == nil || nameInput.text == "" {
            showAlert(title: "提示", text: "请输入类别名称")
            return
        }
        
        // 判断是否选择图标
        if iconImage.image == nil {
            showAlert(title: "提示", text: "请选择图标")
            return
        }
        
        let imageSaveName = "CustomIcon-\(UUID().uuidString)"
        // e.g CustomIcon-C9C7EF7A-C142-42E0-8FE4-3A2AAD37C7A7
        
        if saveImage(imageName: imageSaveName, image: iconImage.image!) {
            // 成功
            let costType = CostType(id: 0, color: self.view.backgroundColor!, icon: imageSaveName, title: nameInput.text!, isOutlay: isCost)
            if CostType.insertCostType(costType) == nil {
                showAlert(title: "十分抱歉", text: "保存失败了 (Database insert error)")
                return
            } else {
                //self.dismiss(animated: true, completion: nil) // 自(wo guan)闭（
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            // 失败
            showAlert(title: "十分抱歉", text: "保存失败了 (Save picture error)")
            return
        }
    }
    
    func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好", style: .destructive, handler: {
            (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveImage(imageName: String, image: UIImage) -> Bool {
        
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.pngData() else { return false }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
            return false
        }
        
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        iconImage.image = image
        
        print(image.size)
    }
    
    @IBAction func selectIcon(_ sender: Any) {
        let alert = UIAlertController(title: "选择图标", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "系统相册", style: .default, handler: {
            (action) in
            
            let selectImageAlert = UIAlertController(title: "提示", message: "建议您选择一张长宽为 72 像素或更大的白色图片作为图标\n您可以在 icons8.com 等网站下载 png 格式的图片作为图标", preferredStyle: .alert)
            selectImageAlert.addAction(UIAlertAction(title: "好", style: .default, handler: {
                (selectAction) in
                selectImageAlert.dismiss(animated: true, completion: nil)
                if self.imagePicker != nil {
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }))
            self.present(selectImageAlert, animated: true, completion: nil)
            
        }))
        /*alert.addAction(UIAlertAction(title: "图标库", style: .default, handler: {
            (action) in
        }))*/
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {
            (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        if self.imagePicker == nil{
            self.imagePicker = UIImagePickerController()
        }
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
    }
    
    @IBAction func selectColor(_ sender: Any) {
        let colorSelectionController = EFColorSelectionViewController()
        
        
        colorSelectionController.delegate = self
        colorSelectionController.color = self.view.backgroundColor ?? UIColor.white
        
        /*if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
            let doneBtn: UIBarButtonItem = UIBarButtonItem(
                title: NSLocalizedString("Done", comment: ""),
                style: .done,
                target: self,
                action: #selector(ef_dismissViewController(sender:))
            )
            colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
        }*/
        self.navigationController?.pushViewController(colorSelectionController, animated: true)
        
    }
    
    // MARK:- EFColorSelectionViewControllerDelegate
    func colorViewController(_ colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        self.view.backgroundColor = color
        
        // TODO: You can do something here when color changed.
        print("New color: " + color.debugDescription)
    }
    

}
