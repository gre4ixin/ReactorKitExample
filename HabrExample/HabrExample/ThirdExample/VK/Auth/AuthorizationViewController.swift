//
//  AuthorizationViewController.swift
//  SpasiboRx
//
//  Created by Pavel Grechikhin on 15/10/2018.
//  Copyright © 2018 Pavel Grechikhin. All rights reserved.
//

import UIKit
import WebKit

class AuthorizationViewController: UIViewController, WKNavigationDelegate {
    
    var urlString: String!
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        bind()
    }
    
    func bind() {
        let urlString = "https://oauth.vk.com/authorize?client_id=6439743&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=friends,photos&response_type=token&v=5.85"
        
        let request = URLRequest(url: URL(string: urlString)!)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if (navigationAction.request.url?.absoluteString.contains("access_token"))! {
            if let token = navigationAction.request.url!.absoluteString.sliceToken(from: "access_token=", to: "&") {
                let _ = DataStorage.sharedInstance.token = token
                let vc = UIStoryboard(name: "FindStoryboard", bundle: nil).instantiateViewController(withIdentifier: "FindPeopleViewController") as! FindPeopleViewController
                vc.reactor = FindPeopleReactor()
                guard (UIApplication.shared.keyWindow?.rootViewController) != nil else { fatalError() }
                UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: vc)
                decisionHandler(.cancel)
                return 
            }
        }
        decisionHandler(.allow)
    }
    
}
