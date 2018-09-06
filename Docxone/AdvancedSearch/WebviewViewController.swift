//
//  WebviewViewController.swift
//  Docxone
//
//  Created by Apple on 17/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import WebKit

class WebviewViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

     // MARK: - IBOutlet and Variables
    var urlString = String()
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
     // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(urlString)
        self.webView.addSubview(self.Activity)
        self.Activity.startAnimating()
        self.webView.navigationDelegate = self
        self.Activity.hidesWhenStopped = true
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     // MARK: - WebView Delegate Method
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Activity.stopAnimating()
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
