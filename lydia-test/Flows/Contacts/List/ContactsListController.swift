//
//  ContactsListController.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import UIKit

protocol ContactsListView: BaseView {
    func scrollListToTop()
    
    var onShowDetails: (() -> Void)? { get set }
}

class ContactsListController: UIViewController, ContactsListView {
    var onShowDetails: (() -> Void)?
    
    private var viewModel: ContactsListViewModelType
    private var tableView = UITableView()
    
    init(viewModel: ContactsListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.didInsert = self.didInsert
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let users = DataManager.shared.users {
            print(users.count)
        }
        view.addSubviews([tableView])
        tableView.snp.makeConstraints { cm in
            cm.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //viewModel.fetchNextUsers()
    }
    
    func scrollListToTop() {
        
    }
    
}

extension ContactsListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.dataFor(row: indexPath.row)
        let cell = UITableViewCell()
        cell.textLabel?.text = data?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.userCount - 1 {
            viewModel.fetchNextUsers()
        }
    }
    
    func didInsert(_ rowCount: Int) {
        DispatchQueue.main.async {
            let startIndex = self.tableView.numberOfRows(inSection: 0)
            var indexs = [IndexPath]()
            for index in startIndex...(startIndex+rowCount - 1) {
                indexs.append(IndexPath(row: index, section: 0))
            }
            self.tableView.insertRows(at: indexs, with: .automatic)
        }
        
    }
    
}
