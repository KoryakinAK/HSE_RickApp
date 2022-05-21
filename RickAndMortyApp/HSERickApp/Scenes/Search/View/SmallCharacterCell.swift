import UIKit

protocol SmallCharacterCellProtocol {
    var mainImage: UIImageView { get }
    var currentCharacter: CharacterModel? { get }
    func configure(with character: CharacterModel)

}

class SmallCharacterCell: UICollectionViewCell, SmallCharacterCellProtocol {
    var currentCharacter: CharacterModel?

    let mainImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10

        // TODO: - Вынести в отдельный подкласс UIImageView с автообводкой в светлой теме
        if UITraitCollection.current.userInterfaceStyle == .light {
            image.layer.borderWidth = 1
            image.layer.borderColor = UIColor(named: "mainLabelColor")?.cgColor
        }

        return image
    }()

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
            mainImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    // MARK: - Cell self-configuration
    func configure(with character: CharacterModel) {
        self.currentCharacter = character
        if let url = URL(string: character.image) {
            self.mainImage.kf.setImage(with: url)
        }
    }
}
