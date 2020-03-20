//
//  OpensourceInfoViewController.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/1/29.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit
import WebKit

class OpensourceInfoViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loading.startAnimating()
        self.webView.load(URLRequest(url: URL(string: "https://github.com/WatanabeQPomelo/QPomeloCostBook/blob/master/opensourceprojectlicense.md")!))
        
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        loading.stopAnimating()
        super.dismiss(animated: flag, completion: completion)
    }
    
    
}
