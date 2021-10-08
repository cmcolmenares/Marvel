
import UIKit

class MainTabViewController: ViewController<MainTabPresenter>, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:  UI
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: Class
    
    private let itemIds = [
        String(describing: MarvelCharacterCell.self)
    ]
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerNIB()
    }
    
    // MARK: - Private methods
    
    private func registerNIB() {
        itemIds.forEach { itemId in
            let nib = UINib(nibName: itemId, bundle: Bundle(for: type(of: self)))
            nib.instantiate(withOwner: self, options: nil)
            
            collectionView.register(nib, forCellWithReuseIdentifier: itemId)
        }
    }
    
    private func setupUI() {
        navigationController?.navigationBar.tintColor = UIColor.appColor(.barFontColor)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.imperialRed)
        navigationController?.navigationBar.backgroundColor = UIColor.appColor(.imperialRed)

        statusBarColorChange(color: UIColor.appColor(.imperialRed) ?? .red)
        
        addNavigationTitle()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.view.backgroundColor = UIColor.appColor(.lightBackground)
        
    }
    
    private func addNavigationTitle() {
        let logo = UIImage(named: "marvel")
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        let imageView = UIImageView(image: logo)
        imageView.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height)
        imageView.contentMode = .scaleAspectFit
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
    }
    
    private func content(at indexPath: IndexPath) -> String {
        let item = presenter.model[indexPath.section].items[indexPath.row]
        switch item.type {
        case .infoCell:
            return String(describing: MarvelCharacterCell.self)
        }
    }
    
    private func setupCell(_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> UICollectionViewCell {
        let item = presenter.model[indexPath.section].items[indexPath.row]
        let characterModel = item.characterResponse
        let type = item.type
        switch type {
            case .infoCell:
                if let characterCell = cell as? MarvelCharacterCell {
                    characterCell.set(imageUrl: characterModel?.thumbnail?.url, characterName: characterModel?.name ?? "", review: "\(characterModel?.id ?? 0)" )
                    
                    return characterCell
                }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.model[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: content(at: indexPath), for: indexPath)
        
        return setupCell(cell, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.userDidSelectItem(indexPath)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = CGFloat(260)
        let itemWidth = UIScreen.main.bounds.width / 2
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - View methods
    
    func reloadView() {
        collectionView.reloadData()
    }
}
