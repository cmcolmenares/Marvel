
import UIKit

class MarvelCharacterCell: UICollectionViewCell {
    
    // MARK: - UI
    
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var characterNameLabel: UILabel!
    @IBOutlet private weak var reviewLabel: UILabel!
    
    // MARK: - AwakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        characterNameLabel.adjustsFontSizeToFitWidth = true
        reviewLabel.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - Methods
    
    func set(imageUrl: URL?, backgroundColor: UIColor? = UIColor.appColor(.lightBackground), characterName: String, review: String) {
        
        if let imageUrl = imageUrl {
            characterImageView.downloaded(from: imageUrl)
        }

        characterNameLabel.text = characterName
        reviewLabel.text = "id: \(review)"
        if let backgroundColor = backgroundColor { contentView.backgroundColor = backgroundColor }
    }
}
