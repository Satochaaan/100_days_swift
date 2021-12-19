//
//  DetailViewController.swift
//  Project16
//
//  Created by 川野智史 on 2021/12/19.
//  Copyright © 2021 Hacking with Swift. All rights reserved.
//

import WebKit
import UIKit

class DetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    var webUrl: String?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard webUrl != nil else { return }
        
        let url = URL(string: webUrl!)
        let request = URLRequest(url: url!)
        
        webView.load(request)
    }

}
