
import UIKit

class SimpleTableViewHeader: UITableViewHeaderFooterView {
    
    // MARK: - UI
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Class
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        self.backgroundColor = .clear
    }
    
    // MARK: - Methods
    
    func setValue(text: String, textColor: UIColor? = nil, isLargeFont: Bool = false, alignment: NSTextAlignment = .center) {
        titleLabel.text = text
        if let color = textColor { titleLabel.textColor = color }
        if isLargeFont {
            titleLabel.font = UIFont(name: "MavenPro-Bold", size: 24)
        }
        titleLabel.textAlignment = alignment
    }
    
}
