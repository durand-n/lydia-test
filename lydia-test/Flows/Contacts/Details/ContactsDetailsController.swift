//
//  ContactsDetailsController.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import UIKit
import ContactsUI

protocol ContactsDetailsView: BaseView {
    var onPhone: ((String) -> Void)? { get set }
    var onAdd: ((CNMutableContact) -> Void)? { get set }
}

class ContactsDetailsController: UIViewController, ContactsDetailsView {
    var onAdd: ((CNMutableContact) -> Void)?
    var onPhone: ((String) -> Void)?
    
    private var viewModel: ContactsDetailsViewModelType
    private var tableView = UITableView()
    private var addButton: UIBarButtonItem?
    private var likeButton: UIBarButtonItem?
    
    init(viewModel: ContactsDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Infos"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        addButton = UIBarButtonItem(image:  UIImage(systemName: "person.crop.circle.badge.plus"), style: .plain, target: self, action: #selector(addToContacts))
        likeButton = UIBarButtonItem(image: UIImage(systemName: viewModel.isFavorite ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(setAsFavorite))

        if let like = likeButton, let add = addButton {
            navigationItem.rightBarButtonItems = [add, like]
        }

        for cellType in ContactsDetailsCellType.allCases {
            tableView.registerCellClass(cellType.type)
        }
        
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { cm in
            cm.edges.equalToSuperview()
        }
    }
    
    @objc func addToContacts() {
        let contact = viewModel.getContact()
        self.onAdd?(contact)
    }
    
    @objc func setAsFavorite() {
        viewModel.setAsFavorite(!viewModel.isFavorite)
        likeButton?.image = UIImage(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
    }
}

extension ContactsDetailsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ContactsDetailsCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contactCell = ContactsDetailsCellType(rawValue: indexPath.row) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withClass: contactCell.type)
        switch contactCell {
        case .contactIdentityCell:
            (cell as? ContactIdentityCell)?.setContent(data: viewModel.getData())
        case .contactSocialCell:
            (cell as? ContactSocialCell)?.setContent(data: viewModel.getData())
            (cell as? ContactSocialCell)?.onCellularCall = { [weak self] in
                guard let self = self else { return }
                self.onPhone?(self.viewModel.cellularNumber)
            }
            (cell as? ContactSocialCell)?.onPhoneCall = { [weak self] in
                guard let self = self else { return }
                self.onPhone?(self.viewModel.phoneNumber)
            }
            (cell as? ContactSocialCell)?.onMailPushed = { [weak self] in
                guard let self = self else { return }
                self.sendEmail(self.viewModel.email)
            }
        case .contactLocationCell:
            (cell as? ContactsLocationCell)?.setContent(data: viewModel.getData())
        }
        
        return cell
    }
}

enum ContactsDetailsCellType: Int, CaseIterable {
    case contactIdentityCell = 0
    case contactSocialCell
    case contactLocationCell
    
    var type: UITableViewCell.Type {
        switch self {
        case .contactIdentityCell:
            return ContactIdentityCell.self
        case .contactSocialCell:
            return ContactSocialCell.self
        case .contactLocationCell:
            return ContactsLocationCell.self
        }
    }
    
    var representableType: ContactsDetailsRepresentable.Type {
        switch self {
        case .contactIdentityCell:
            return ContactIdentityRepresentable.self
        case .contactLocationCell:
            return ContactLocationRepresentable.self
        case .contactSocialCell:
            return ContactSocialRepresentable.self
        }
    }
}
