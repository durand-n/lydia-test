//
//  ContactsListCell.swift
//  lydia-test
//
//  Created by Benoît Durand on 18/10/2020.
//

import UIKit

class ContactsListCell: UITableViewCell {
    var onCall: (() -> Void)?
    var onEmail: (() -> Void)?
    
    private var userImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    private var userNameLabel = UILabel(title: "", type: .bold, color: .label, size: 16, lines: 1, alignment: .left)
    private var userLocationLabel = UILabel(title: "San Francisco", type: .medium, color: .secondaryLabel, size: 14, lines: 1, alignment: .left)
    private var emailButton = UIButton(illu: UIImage(systemName: "envelope.fill") ?? UIImage(), contentMode: .scaleAspectFit)
    private var phoneButton = UIButton(illu: UIImage(systemName: "phone.fill") ?? UIImage(), contentMode: .scaleAspectFit)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let infoContainer = UIView(backgroundColor: .clear)
        infoContainer.addSubviews([userNameLabel, userLocationLabel])
        selectionStyle = .none
        contentView.addSubviews([userImageView, infoContainer, emailButton, phoneButton])
        
        backgroundColor = .clear
        userImageView.cornerRadius = 25
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.borderColor = UIColor.random.cgColor
        emailButton.tintColor = .gray
        emailButton.addTarget(self, action: #selector(emailPushed), for: .touchUpInside)
        phoneButton.tintColor = .gray
        phoneButton.addTarget(self, action: #selector(callPushed), for: .touchUpInside)
        
        userImageView.snp.makeConstraints { cm in
            cm.left.equalToSuperview().offset(16)
            cm.size.equalTo(50)
            cm.centerY.equalToSuperview()
            cm.top.greaterThanOrEqualToSuperview().offset(16)
            cm.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
        
        infoContainer.snp.makeConstraints { cm in
            cm.left.equalTo(userImageView.snp.right).offset(16)
            cm.centerY.equalToSuperview()
            
            userNameLabel.snp.makeConstraints { cm in
                cm.top.left.right.equalToSuperview()
            }
            
            userLocationLabel.snp.makeConstraints { cm in
                cm.top.equalTo(self.userNameLabel.snp.bottom)
                cm.bottom.left.right.equalToSuperview()
            }
        }
        
        emailButton.snp.makeConstraints { cm in
            cm.left.greaterThanOrEqualTo(infoContainer.snp.right).offset(16)
            cm.size.equalTo(44)
            cm.right.equalTo(phoneButton.snp.left)
            cm.centerY.equalToSuperview()
        }
        
        phoneButton.snp.makeConstraints { cm in
            cm.size.equalTo(44)
            cm.right.equalToSuperview().offset(-16)
            cm.centerY.equalToSuperview()
        }
        
    }
    
    @objc func callPushed() {
        self.onCall?()
    }
    
    @objc func emailPushed() {
        self.onEmail?()
    }
    
    func setContent(data: ContactItemRepresentable) {
        self.userNameLabel.text = data.name
        self.userLocationLabel.text = data.location
        if let thumb = data.thumb {
            self.userImageView.load(url: thumb)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
