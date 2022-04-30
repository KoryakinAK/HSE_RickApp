import UIKit

protocol SuggestedSectionCellProtocol {
    var mainImage: UIImageView { get }
    static var reuseIdentifier: String { get }
    func configure(with character: CharacterModel)
}

class SuggestedSectionCell: UICollectionViewCell, SuggestedSectionCellProtocol {
    let mainImage = UIImageView()
    static let reuseIdentifier = "RecenlySearchedCVCell"
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup view
    func setupUI() {
        contentView.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.backgroundColor = .cyan

        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    // MARK: - Cell self-configuration
    func configure(with character: CharacterModel) {
        if let url = URL(string: character.image) {
            self.mainImage.kf.setImage(with: url)
        }
    }
}
