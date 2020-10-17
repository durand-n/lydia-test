//
//  Constants.swift
//  lydia-test
//
//  Created by Benoît Durand on 16/10/2020.
//

import UIKit

struct Constants {
    
    static let PAGINATION_NUMBER = 10
    
    enum CachedItems: String {
        case lastPageLoaded
    }
}

struct Loader {
    static let contentView = UIView(backgroundColor: UIColor.black.withAlphaComponent(0.5))
    static let spinner = UIActivityIndicatorView(style: .large)
    
    static func show() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            window.addSubviews([contentView, spinner])
            spinner.startAnimating()
            contentView.snp.makeConstraints { cm in
                cm.edges.equalToSuperview()
            }
            spinner.snp.makeConstraints { cm in
                cm.center.equalToSuperview()
                cm.size.equalTo(80)
            }
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            spinner.stopAnimating()
            contentView.removeFromSuperview()
            spinner.removeFromSuperview()
        }
    }
}
