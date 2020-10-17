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
    private let spinner = UIActivityIndicatorView(style: .medium)
    private var emptyView = EmptyView()
    
    init(viewModel: ContactsListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.onInsert = self.didInsert
        self.viewModel.onDataLoaded = self.didLoad
        self.viewModel.onShowError = { [weak self] message in
            DispatchQueue.main.async {
                self?.tableView.tableFooterView = nil
            }
            self?.showError(message: message)
        }
        self.emptyView.onRetry = viewModel.startFetchingUsers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubviews([emptyView, tableView])
        
        emptyView.snp.makeConstraints { cm in
            cm.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { cm in
            cm.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        viewModel.startFetchingUsers()
    }
    
    func scrollListToTop() {
        
    }
    
}

extension ContactsListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.userCount
        if count == 0 {
            tableView.fadeOut()
            emptyView.play()
        } else {
            tableView.fadeIn()
            emptyView.stop()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.dataFor(row: indexPath.row)
        let cell = UITableViewCell()
        cell.textLabel?.text = data?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.userCount - 1 {
            spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 70)
            spinner.startAnimating()

            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
            #warning("remove before commit")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.viewModel.fetchNextUsers()
            }
        }
    }
    
    func didLoad() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didInsert(_ rowCount: Int) {
        guard rowCount > 0 else { return }
        DispatchQueue.main.async {
            let startIndex = self.tableView.numberOfRows(inSection: 0)
            var indexs = [IndexPath]()
            for index in startIndex...(startIndex+rowCount - 1) {
                indexs.append(IndexPath(row: index, section: 0))
            }
            self.tableView.insertRows(at: indexs, with: .automatic)
            self.tableView.tableFooterView = nil
        }
    }
    
}
