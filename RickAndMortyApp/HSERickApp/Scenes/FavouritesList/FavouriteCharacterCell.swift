import UIKit

protocol SelfConfigurableCharacterCell {
    func configure(with: CharacterModel)
    func showSeparator()
    static var cellHeight: CGFloat { get }
}

class FavouriteCharacterCell: UITableViewCell, SelfConfigurableCharacterCell {
    static let cellHeight: CGFloat = 139

    let characterName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "mainLabelColor")
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 22)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85
        return label
    }()
    
    let characterIcon: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemRed
        image.layer.cornerRadius = 10
        return image
    }()
    
    let separator: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(named: "mainLabelColor")
        return separatorView
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
        [characterName, characterIcon, separator].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            characterIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            characterIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            characterIcon.heightAnchor.constraint(equalToConstant: 100),
            characterIcon.widthAnchor.constraint(equalToConstant: 100),
            
            characterName.leadingAnchor.constraint(equalTo: characterIcon.trailingAnchor, constant: 24),
            characterName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            characterName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
    }
    
    // MARK: -SelfConfigurableCell conformance
    func configure(with data: CharacterModel) {
        characterName.text = data.name
    }

    func showSeparator() {
        contentView.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        ])
    }
}
