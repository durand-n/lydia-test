//
//  EmptyView.swift
//  lydia-test
//
//  Created by Benoît Durand on 17/10/2020.
//

import UIKit
import Lottie

class EmptyView: UIView {
    private var titleLabel: UILabel
    private var sadAnim: AnimationView
    private var retryButton = UIButton(title: "Réessayer", font: .bold, fontSize: 14, textColor: .secondary, backgroundColor: .primary)
    var onRetry: (() -> Void)?
    
    init(title: String, showButton: Bool = true) {
        titleLabel = UILabel(title: title, type: .bold, color: .label, size: 16, lines: 0, alignment: .center)
        retryButton.isHidden = !showButton
        sadAnim = AnimationView(animation: Animation.named("sad-anim", bundle: Bundle.main))
        super.init(frame: .zero)
        let container = UIView(backgroundColor: .clear)
        container.addSubviews([titleLabel, sadAnim, retryButton])
        self.addSubviews([container])
        sadAnim.loopMode = .repeatBackwards(2)
        retryButton.setSideInset()
        retryButton.cornerRadius = 20
        retryButton.addTarget(self, action: #selector(retryPushed), for: .touchUpInside)
        
        sadAnim.snp.makeConstraints { cm in
            cm.size.equalTo(100)
            cm.top.equalToSuperview()
            cm.left.greaterThanOrEqualToSuperview()
            cm.right.lessThanOrEqualToSuperview()
            cm.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { cm in
            cm.left.right.equalToSuperview().inset(16)
            cm.top.equalTo(self.sadAnim.snp.bottom).offset(16)
        }
        
        retryButton.snp.makeConstraints { cm in
            cm.top.equalTo(titleLabel.snp.bottom).offset(16)
            cm.height.equalTo(40)
            cm.left.greaterThanOrEqualToSuperview()
            cm.right.lessThanOrEqualToSuperview()
            cm.centerX.equalToSuperview()
            cm.bottom.equalToSuperview()
        }
        
        container.snp.makeConstraints { cm in
            cm.center.equalToSuperview()
            cm.left.top.greaterThanOrEqualToSuperview()
            cm.right.bottom.lessThanOrEqualToSuperview()
        }
        

    }
    
    func play() {
        sadAnim.play()
    }
    
    func stop() {
        sadAnim.stop()
    }
    
    @objc func retryPushed() {
        self.onRetry?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
