//
//  GuestViewController.swift
//  VTaKDPhi
//
//  Created by Zuri Wong on 9/16/18.
//  Copyright © 2018 Zuri Wong. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class GuestViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        
        webView.navigationDelegate = self
        let url = URL(string: "http://www.akdphi.org.vt.edu")
        let request = URLRequest(url: url!)
        webView.load(request)
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
