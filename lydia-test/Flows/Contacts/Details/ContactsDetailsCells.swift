//
//  ContactsDetailsCells.swift
//  lydia-test
//
//  Created by Benoît Durand on 18/10/2020.
//

import UIKit
import MapKit

class ContactIdentityCell: UITableViewCell {
    private var userImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    private var nameLabel = UILabel(title: "Scarlett Jones", type: .bold, color: .text, size: 22, lines: 1, alignment: .center)
    private var bdLabel = UILabel(title: "29 ans - né(e) le 10/03/1991", type: .medium, color: .gray, size: 16, lines: 1, alignment: .center)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        let userImageContainer = UIView(backgroundColor: .clear)
        userImageContainer.addSubview(userImageView)
        contentView.addSubviews([userImageContainer,  nameLabel, bdLabel])
        
        
        userImageContainer.layer.borderColor = UIColor.random.cgColor
        userImageContainer.layer.borderWidth = 3.0
        userImageContainer.cornerRadius = 70
        
        userImageContainer.snp.makeConstraints { cm in
            cm.size.equalTo(140)
            cm.centerX.equalToSuperview()
            cm.top.equalToSuperview().offset(42)
            
            
            userImageView.snp.makeConstraints { cm in
                cm.size.equalTo(130)
                cm.edges.equalToSuperview().inset(5)
                
                self.userImageView.cornerRadius = 67
            }
        }
        
        nameLabel.snp.makeConstraints { cm in
            cm.top.equalTo(userImageContainer.snp.bottom).offset(42)
            cm.left.right.equalToSuperview().inset(30)
        }
        
        bdLabel.snp.makeConstraints { cm in
            cm.top.equalTo(nameLabel.snp.bottom).offset(8)
            cm.left.right.equalToSuperview().inset(30)
            cm.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(data: ContactIdentityRepresentable) {
        if let url = data.pictureUrl {
            userImageView.load(url: url)
        }
        nameLabel.text = data.name
        bdLabel.text = data.birthDate
    }
}

class ContactSocialCell: UITableViewCell {
    private var phoneButton = UIButton(title: "", font: .regular, fontSize: 18, textColor: .link, backgroundColor: .clear)
    private var cellularButton = UIButton(title: "", font: .regular, fontSize: 18, textColor: .link, backgroundColor: .clear)
    private var emailButton = UIButton(title: "", font: .regular, fontSize: 18, textColor: .link, backgroundColor: .clear)
    var onCellularCall: (() -> Void)?
    var onPhoneCall: (() -> Void)?
    var onMailPushed: (() -> Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        let container = UIView(backgroundColor: .systemFill)
        container.cornerRadius = 8
        contentView.addSubviews([container])
        contentView.backgroundColor = .clear
        phoneButton.addTarget(self, action: #selector(phonePushed), for: .touchUpInside)
        phoneButton.contentHorizontalAlignment = .left
        cellularButton.addTarget(self, action: #selector(cellularPushed), for: .touchUpInside)
        cellularButton.contentHorizontalAlignment = .left
        emailButton.addTarget(self, action: #selector(emailPushed), for: .touchUpInside)
        emailButton.contentHorizontalAlignment = .left
        
        let phoneTitleLabel = UILabel(title: "Téléphone", type: .medium, color: .secondaryLabel, size: 12, lines: 1, alignment: .left)
        let cellularTitleLabel = UILabel(title: "Mobile", type: .medium, color: .secondaryLabel, size: 12, lines: 1, alignment: .left)
        let emailTitleLabel = UILabel(title: "E-Mail", type: .medium, color: .secondaryLabel, size: 12, lines: 1, alignment: .left)
        
        container.addSubviews([phoneTitleLabel, phoneButton, cellularTitleLabel, cellularButton, emailTitleLabel, emailButton])
        
        container.snp.makeConstraints { cm in
            cm.left.right.equalToSuperview().inset(16)
            cm.top.bottom.equalToSuperview().inset(8)
            
            phoneTitleLabel.snp.makeConstraints { cm in
                cm.top.left.right.equalToSuperview().inset(8)
            }
            
            phoneButton.snp.makeConstraints { cm in
                cm.top.equalTo(phoneTitleLabel.snp.bottom)
                cm.height.equalTo(44)
                cm.left.right.equalToSuperview().inset(8)
            }
            
            cellularTitleLabel.snp.makeConstraints { cm in
                cm.top.equalTo(phoneButton.snp.bottom).offset(8)
                cm.left.right.equalToSuperview().inset(8)
            }
            
            cellularButton.snp.makeConstraints { cm in
                cm.top.equalTo(cellularTitleLabel.snp.bottom)
                cm.height.equalTo(44)
                cm.left.right.equalToSuperview().inset(8)
            }
            
            emailTitleLabel.snp.makeConstraints { cm in
                cm.top.equalTo(cellularButton.snp.bottom).offset(8)
                cm.left.right.equalToSuperview().inset(8)
            }
            
            emailButton.snp.makeConstraints { cm in
                cm.top.equalTo(emailTitleLabel.snp.bottom)
                cm.height.equalTo(44)
                cm.left.right.bottom.equalToSuperview().inset(8)
            }
        }
        
        container.addShadow(offset: CGSize(width: 0, height: -0.5), color: .black, opacity: 0.1, radius: 0)
        
    }
    
    @objc func cellularPushed() {
        self.onCellularCall?()
    }
    
    @objc func phonePushed() {
        self.onPhoneCall?()
    }
    
    @objc func emailPushed() {
        self.onMailPushed?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(data: ContactSocialRepresentable) {
        phoneButton.setTitle(data.phone, for: .normal)
        cellularButton.setTitle(data.cellular, for: .normal)
        emailButton.setTitle(data.email, for: .normal)
    }
}

class ContactsLocationCell: UITableViewCell {
    private var addressValue = UILabel(title: "", type: .regular, color: .label, size: 18, lines: 0, alignment: .left)
    private var map = MKMapView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        let container = UIView(backgroundColor: .systemFill)
        let mapContainer = UIView(backgroundColor: .systemFill)
        container.cornerRadius = 8
        contentView.addSubviews([container, mapContainer])
        contentView.backgroundColor = .clear
        
        let addressTitle = UILabel(title: "Adresse", type: .medium, color: .secondaryLabel, size: 12, lines: 1, alignment: .left)
        container.addSubviews([addressTitle, addressValue])
        container.snp.makeConstraints { cm in
            cm.left.right.equalToSuperview().inset(16)
            cm.top.equalToSuperview().inset(8)
            
            addressTitle.snp.makeConstraints { cm in
                cm.top.left.right.equalToSuperview().inset(8)
            }
            
            addressValue.snp.makeConstraints { cm in
                cm.top.equalTo(addressTitle.snp.bottom)
                cm.bottom.left.right.equalToSuperview().inset(8)
            }
        }
        
        map.cornerRadius = 8
        mapContainer.cornerRadius = 8
        mapContainer.addSubview(map)
        mapContainer.snp.makeConstraints { cm in
            cm.height.equalTo(200)
            cm.top.equalTo(container.snp.bottom).offset(24)
            cm.left.right.bottom.equalToSuperview().inset(16)
            
            map.snp.makeConstraints { cm in
                cm.edges.equalToSuperview().inset(8)
            }
        }
        
        container.addShadow(offset: CGSize(width: 0, height: -0.5), color: .black, opacity: 0.1, radius: 0)
        mapContainer.addShadow(offset: CGSize(width: 0, height: -0.5), color: .black, opacity: 0.1, radius: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(data: ContactLocationRepresentable) {
        addressValue.text = data.street + "\n" + data.city
        if let coordinate = data.location {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            map.setCenter(coordinate, animated: false)
            map.addAnnotation(annotation)
        }
    }
}
