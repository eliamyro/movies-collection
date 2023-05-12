//
//  TrailerCell.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import UIKit
import WebKit

class TrailerCell: UITableViewCell, CustomElementCell {

    // MARK: - Views

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false

        return indicator
    }()

    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.navigationDelegate = self
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with elementModel: CustomElementModel) {
        guard let model = elementModel as? TrailerModel else {
            print("Unable to cast model as TrailerModel")
            return
        }

        configureUI()
        setup(model: model)
    }

    private func setup(model: TrailerModel) {
        let endpoint = MoviesEndpoint.youtube(key: model.trailerKey)
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path

        if let url = urlComponents.url {
            let request = URLRequest(url: url)
            activityIndicator.startAnimating()
            self.webView.load(request)
        }
    }
}

// MARK: - Setup Constraints

extension TrailerCell {
    func configureUI() {
        configureWebView()
        configureActivityIndicator()
    }

    private func configureWebView() {
        contentView.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: contentView.topAnchor),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    private func configureActivityIndicator() {
        contentView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: - WKNavigationDelegate

extension TrailerCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
