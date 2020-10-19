//
//  ContactsDetailsController.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import UIKit

protocol ContactsDetailsView: BaseView {
    var onPhone: ((String) -> Void)? { get set }
}

class ContactsDetailsController: UIViewController, ContactsDetailsView {
    var onPhone: ((String) -> Void)?
    
    private var viewModel: ContactsDetailsViewModelType
    private var tableView = UITableView()
    
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
        for cellType in ContactsDetailsCellType.allCases {
            tableView.registerCellClass(cellType.type)
        }
        
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { cm in
            cm.edges.equalToSuperview()
        }
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
