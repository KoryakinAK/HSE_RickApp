import UIKit

protocol SearchResultCellProtocol {
    static var height: CGFloat { get }
    func configure(with character: CharacterModel)
}
class SearchResultCell: UITableViewCell, SearchResultCellProtocol {
    static let height: CGFloat = 199

    let characterName: UILabel = {
        let label = UILabel()
        let customFont = UIFont(name: CustomFonts.SFdisplayBlack.rawValue, size: 22) ?? UIFont.boldSystemFont(ofSize: 22)
        label.font = customFont
        label.textColor = UIColor(named: "mainLabelColor")
        label.textAlignment = .left
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85
        return label
    }()

    let speciesLabel: UILabel = {
        let label = UILabel()
        let customFont = UIFont(name: CustomFonts.SFtextSemiBold.rawValue, size: 17) ?? UIFont.boldSystemFont(ofSize: 17)
        label.font = customFont
        label.textColor = UIColor(named: "secondaryLabelColor")
        return label
    }()

    let characterIcon: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemRed
        image.layer.cornerRadius = 10
        image.clipsToBounds = true

        if UITraitCollection.current.userInterfaceStyle == .light {
            image.layer.borderWidth = 1
            image.layer.borderColor = UIColor(named: "mainLabelColor")?.cgColor
        }
        return image
    }()

    let separator: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(named: "mainLabelColor")
        return separatorView
    }()
//
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.backgroundColor = .clear
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .default
        self.backgroundColor =  UIColor(named: "backgroundColor")
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        stackView.addArrangedSubview(characterName)
        stackView.addArrangedSubview(speciesLabel)

        [characterIcon, stackView, separator].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            characterIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            characterIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            characterIcon.heightAnchor.constraint(equalToConstant: 160),
            characterIcon.widthAnchor.constraint(equalToConstant: 120),

            stackView.leadingAnchor.constraint(equalTo: characterIcon.trailingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.heightAnchor.constraint(equalToConstant: 94),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
    }

    // MARK: - SelfConfigurableCell conformance
    func configure(with character: CharacterModel) {
        characterName.text = character.name
        speciesLabel.text = character.species
        if let url = URL(string: character.image) {
            characterIcon.kf.setImage(with: url)
        }
    }
}
