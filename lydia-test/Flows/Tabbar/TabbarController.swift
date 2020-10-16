//
//  TabbarController.swift
//  lydia-test
//
//  Created by Benoît Durand on 15/10/2020.
//

import UIKit

protocol TabbarView: BaseView {
    var onContactsClick: ((UINavigationController) -> Void)? { get set }
    var onContactsDoubleClick: ((UINavigationController) -> Void)? { get set }
    var onFavoritesClick: ((UINavigationController) -> Void)? { get set }
    var onFavoritesDoubleClick: ((UINavigationController) -> Void)? { get set }
    var selectedIndex: Int { get }
    
    // switch Tab bar to new index
    func setNewIndex(index: TabbarController.Index)
    func triggerCleaning()
}

class TabbarController: UITabBarController, TabbarView {

    // MARK: protocol
    var onContactsClick: ((UINavigationController) -> Void)?
    var onContactsDoubleClick: ((UINavigationController) -> Void)?
    var onFavoritesClick: ((UINavigationController) -> Void)?
    var onFavoritesDoubleClick: ((UINavigationController) -> Void)?
    
    enum Index: Int {
        case contacts = 0
        case favorites = 1
    }
    
    private var isFirstViewWillAppear = true
    private var networkConnectedBannerView: NetworkStatusBannerView?
    private var networkDisconnectedBannerView: NetworkStatusBannerView?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.initNetworkStatusViews()
        }
        
        self.tabBar.accessibilityLabel = "tabBar"
        self.view.backgroundColor = .white
        let contactsNavigationController = UINavigationController()
        contactsNavigationController.interactivePopGestureRecognizer?.isEnabled = true
        contactsNavigationController.tabBarItem = UITabBarItem(title: "contacts", image: nil, tag: Index.contacts.rawValue)
        
        let favoritesNavigationController = UINavigationController()
        favoritesNavigationController.interactivePopGestureRecognizer?.isEnabled = true
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "favoris", image: nil, tag: Index.favorites.rawValue)
        
        
        tabBar.tintColor = .secondary
        
        viewControllers = [contactsNavigationController, favoritesNavigationController]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // start on the contacts flow
        if isFirstViewWillAppear {
            guard let navigationController = viewControllers?[Index.contacts.rawValue] as? UINavigationController else { return }
            selectedIndex = 0
            onContactsClick?(navigationController)
            isFirstViewWillAppear = false
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            guard let navigationController = viewControllers?[Index.contacts.rawValue] as? UINavigationController else { return }
            self.onContactsClick?(navigationController)
            if selectedIndex == 0 {
                onContactsDoubleClick?(navigationController)
            }
        case 1:
            guard let navigationController = viewControllers?[Index.favorites.rawValue] as? UINavigationController else { return }
            self.onFavoritesClick?(navigationController)
            if selectedIndex == 1 {
                onFavoritesDoubleClick?(navigationController)
            }
        default:
            break
        }
    }
    
    // MARK: protocol compliance
    func triggerCleaning() {
        guard let navigationController = viewControllers?[Index.contacts.rawValue] as? UINavigationController else { return }
        selectedIndex = 0
        onContactsClick?(navigationController)
    }
    
    func setNewIndex(index: TabbarController.Index) {
        selectedIndex = index.rawValue
        guard let navigationController = viewControllers?[selectedIndex] as? UINavigationController else { return }
        switch index {
        case .contacts:
            self.onContactsClick?(navigationController)
        case .favorites:
            self.onFavoritesClick?(navigationController)
        }
    }
    
    // MARK: Network banners
    private func initNetworkStatusViews() {
        networkConnectedBannerView = NetworkStatusBannerView(title: "connecté", color: .green, image: UIImage())
        networkDisconnectedBannerView = NetworkStatusBannerView(title: "déconnecté", color: .red, image: UIImage())
        
        NotificationCenter.default.addObserver(self, selector: #selector(didDisconnect), name: .showOffline, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didConnect), name: .hideOffline, object: nil)
        
        view.addSubviews([networkConnectedBannerView!, networkDisconnectedBannerView!])
        
        networkDisconnectedBannerView?.snp.makeConstraints { cm in
            cm.left.right.equalToSuperview()
            cm.bottom.equalTo(tabBar.snp.top)
        }
        
        networkConnectedBannerView?.snp.makeConstraints { cm in
            cm.left.right.equalToSuperview()
            cm.bottom.equalTo(tabBar.snp.top)
        }
        
        networkConnectedBannerView?.isHidden = true
        networkDisconnectedBannerView?.isHidden = true
        
    }
    
    @objc private func didConnect() {
        print("connect")
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.main.async {
            self.networkDisconnectedBannerView?.fadeOut()
            self.networkConnectedBannerView?.fadeIn()
            group.leave()
        }
        
        group.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.networkConnectedBannerView?.fadeOut()
            group.leave()
        }
    }
    
    @objc private func didDisconnect() {
        print("logout")
        DispatchQueue.main.async {
            self.networkConnectedBannerView?.fadeOut()
            self.networkDisconnectedBannerView?.fadeIn()
        }
    }
}

class NetworkStatusBannerView: UIView {
    init(title: String, color: UIColor, image: UIImage) {
        super.init(frame: .zero)
        
        let titleLabel = UILabel(title: title, type: .semiBold, color: .white, size: 13, lines: 0, alignment: .left)
        let imageView = UIImageView(image: image, contentMode: .scaleAspectFit)
        imageView.tintColor = .white
        
        addSubviews([titleLabel, imageView])
        backgroundColor = color
        
        titleLabel.snp.makeConstraints { cm in
            cm.left.top.bottom.equalToSuperview().inset(8)
        }
        imageView.snp.makeConstraints { cm in
            cm.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(16)
            cm.right.equalToSuperview().inset(8)
            cm.centerY.equalToSuperview()
            cm.size.equalTo(17)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
