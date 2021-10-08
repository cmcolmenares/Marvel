
import UIKit

class DetailViewController: ViewController<DetailPresenter> {
    
    // MARK: - UI
    
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var characterNameLabel: UILabel!
    @IBOutlet private weak var characterDescriptionLabel: UILabel!
    @IBOutlet private weak var idCharacterLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.tintColor = UIColor.appColor(.barFontColor)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.imperialRed)
        
        self.view.backgroundColor = UIColor.appColor(.lightBackground)
        addNavigationTitle()
        characterImageView.image = UIImage(named: "characterImageView")
        
        characterNameLabel.adjustsFontSizeToFitWidth = true
        characterDescriptionLabel.numberOfLines = 0
        characterDescriptionLabel.lineBreakMode = .byWordWrapping
        idCharacterLabel.adjustsFontSizeToFitWidth = true
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
    
    func setValue(for item: MainTabItemModel) {
        guard let model = item.characterResponse else { return }
        
        if let imageUrl = model.thumbnail?.url {
            characterImageView.downloaded(from: imageUrl)
        }
        characterNameLabel.text = model.name
        characterDescriptionLabel.text = ((model.description == nil) || (model.description?.isEmpty ?? false)) ? "No Description" : model.description // TODO: localized string
        idCharacterLabel.text = "id: \(model.id ?? 0)"
    }
    
    
}
