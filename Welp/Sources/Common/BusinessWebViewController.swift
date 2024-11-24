//
//  WebViewController.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import UIKit
import WebKit

// MARK: - BusinessWebViewController

final class BusinessWebViewController: UIViewController {

    // MARK: Dependencies

    private var business: Business?

    // MARK: Views

    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.backgroundColor = StyleGuide.Colors.WelpGrey
        return webView
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: Lifecycle

    init(business: Business?) {
        self.business = business
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpLayout()
        loadUrl()
    }

    // MARK: Private Interface

    private func setUpView() {
        view.backgroundColor = StyleGuide.Colors.WelpGrey
        navigationItem.backButtonDisplayMode = .minimal
        webView.frame = self.view.bounds
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.addSubview(loadingIndicator)
        view.addSubview(placeholderImageView)
    }

    private func setUpLayout() {
        let padding = view.bounds.width * 0.25
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            placeholderImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            placeholderImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            placeholderImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            placeholderImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding)
        ])
    }

    private func loadUrl() {
        if let business, let url = URL(string: business.url) {
            navigationController?.setNavigationBarHidden(false, animated: false)
            title = business.name
            placeholderImageView.isHidden = true
            loadingIndicator.startAnimating()
            
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: false)
            webView.isHidden = true
            placeholderImageView.isHidden = false
        }
    }
}

// MARK: - WKNavigationDelegate

extension BusinessWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
    }
}
