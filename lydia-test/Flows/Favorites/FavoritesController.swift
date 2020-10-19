//
//  FavoritesController.swift
//  lydia-test
//
//  Created by Benoît Durand on 19/10/2020.
//

import UIKit

protocol FavoritesView: BaseView {
    var onShowDetails: ((User) -> Void)? { get set }
}

class FavoritesController: UICollectionViewController, FavoritesView {
    private var viewModel: FavoritesViewModelType
    private var layout = UICollectionViewFlowLayout()
    private var emptyView = EmptyView(title: "Vous n'avez pas encore de favoris", showButton: false)
    var onShowDetails: ((User) -> Void)?
    
    init(viewModel: FavoritesViewModelType) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: layout)
        collectionView.registerCellClass(FavoritesCell.self)
        self.title = "Favoris"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refresh()
        collectionView.reloadWithAnimation()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.userCount
        if count == 0 {
            collectionView.backgroundView = emptyView
            emptyView.play()
        } else {
            collectionView.backgroundView = nil
            emptyView.stop()
        }
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FavoritesCell.self, indexPath: indexPath)
        if let data = viewModel.dataFor(row: indexPath.row) {
            cell.setContent(representable: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = viewModel.userFor(row: indexPath.row) else { return }
        onShowDetails?(user)
    }
}

extension FavoritesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 2, height: 200)
    }
}

class FavoritesCell: UICollectionViewCell {
    private let contactImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    private let contactNameLabel = UILabel(title: "this is a test", type: .bold, color: .label, size: 16, lines: 1, alignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let container = UIView(backgroundColor: .systemFill)
        contentView.addSubview(container)
        
        
        container.addSubviews([contactImageView, contactNameLabel])
        container.snp.makeConstraints { cm in
            cm.edges.equalToSuperview().inset(16)
            
            container.cornerRadius = 24
            
            contactImageView.snp.makeConstraints { cm in
                cm.centerX.equalToSuperview()
                cm.top.equalToSuperview().offset(16)
                cm.size.equalTo(100)
                contactImageView.cornerRadius = 50
            }
            
            contactNameLabel.snp.makeConstraints { cm in
                cm.height.equalTo(20)
                cm.bottom.left.right.equalToSuperview().inset(8)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(representable: FavoriteItemRepresentable) {
        if let url = representable.thumb {
            contactImageView.load(url: url)
        }
        contactNameLabel.text = representable.name
    }
}
