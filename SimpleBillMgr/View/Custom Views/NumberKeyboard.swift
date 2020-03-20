//
//  NumberKeyboard.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/1/29.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit
import AudioToolbox

class NumberKeyboard: UIView {

    @IBOutlet weak var pad: UIView!
    @IBOutlet weak var splitView: UIView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var backspaceButton: UIButton!
    
    var delegate: KeyboardInput?
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        if AppDelegate.theme == .dark {
            pad.backgroundColor = UIColor(hexString: "#232425")
            splitView.backgroundColor = UIColor(hexString: "#232425")
            clearButton.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
            backspaceButton.setImage(UIImage(named: "KeyboardIconBackspaceDark"), for: .normal)
            let views = pad.subviews
            for view in views {
                if view.isKind(of: UIButton.self) && (view as! UIButton).tag != 20 {
                    let button = (view as! UIButton)
                    button.backgroundColor = UIColor(hexString: "#32373D")
                    button.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
                } else if view.isKind(of: UIButton.self) && (view as! UIButton).tag == 20 {
                    let button = (view as! UIButton)
                    button.backgroundColor = UIColor(hexString: "#3F5C7D")
                }
            }
    }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func onKey(_ sender: Any) {
        AudioServicesPlaySystemSound(1123)
        let button: UIButton = sender as! UIButton
        let inputNumStr: String = button.titleLabel?.text! ?? ""
        self.delegate?.inputKey(keyNumber: inputNumStr)
        let ge = UIImpactFeedbackGenerator(style: .light)
        ge.prepare()
        ge.impactOccurred()
    }
    
    @IBAction func onBackspace(_ sender: Any) {
        AudioServicesPlaySystemSound(1155)
        self.delegate?.pressToolButton(buttonId: .backspace)
        let ge = UIImpactFeedbackGenerator(style: .medium)
        ge.prepare()
        ge.impactOccurred()
    }
    
    @IBAction func onClear(_ sender: Any) {
        AudioServicesPlaySystemSound(1155)
        self.delegate?.pressToolButton(buttonId: .clear)
        let ge = UIImpactFeedbackGenerator(style: .heavy)
        ge.prepare()
        ge.impactOccurred()
    }
    
    @IBAction func onDone(_ sender: Any) {
        AudioServicesPlaySystemSound(1123)
        self.delegate?.pressToolButton(buttonId: .done)
        let ge = UIImpactFeedbackGenerator(style: .heavy)
        ge.prepare()
        ge.impactOccurred()
    }
    
}

protocol KeyboardInput {
    func inputKey(keyNumber: String)
    func pressToolButton(buttonId: KeyboardToolButton)
}

enum KeyboardToolButton {
    case backspace
    case clear
    case done
}
