//
//  AuthViewController.swift
//  Music App
//
//  Created by Sơn Nguyễn on 09/07/2022.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    // MARK: - Init using webkit
    private let webView : WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    // MARK: - pass data using closure
    public var completionHandler: ((Bool) -> Void)?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - set vc
        title = "Đăng nhập"
        view.backgroundColor = .systemBlue
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        // MARK: - redirect
        guard let url = AuthManager.shared.signInURL else { return }
        webView.load(URLRequest(url: url))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    

}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = self.webView.url else { return }
        // MARK: - exchange code for access token
        // MARK: - create urlComponent
        guard let code = URLComponents(url: url,
                                       resolvingAgainstBaseURL: true
        )?.queryItems?.first(where: {$0.name == "code"})?.value
        else { return }
        webView.isHidden = true
        
        print("code: \(code)")
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
                self?.completionHandler?(success)
            }
            
        }
        
    }
}


