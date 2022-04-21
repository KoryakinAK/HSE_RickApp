import UIKit

protocol SelfConfigurableDescriptionCell {
    func configure(with: CharacterDescriptionModel)
    func showSeparator()
    static var cellHeight: CGFloat { get }
}

class CharacterDescriptionCell: UITableViewCell, SelfConfigurableDescriptionCell {
    static let cellHeight: CGFloat = 90
    let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "secondaryLabelColor")
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 22)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85
        return label
    }()
    
    let value: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "mainLabelColor")
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    let separator = UIView(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor(named: "backgroundColor")
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        [title, value].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            title.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            title.heightAnchor.constraint(equalToConstant: FavouriteCell.cellHeight / 2),
            
            value.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            value.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            value.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            value.heightAnchor.constraint(equalToConstant: FavouriteCell.cellHeight / 2),
            ])
    }
    
    // MARK: -SelfConfigurableCell conformance
    func configure(with data: CharacterDescriptionModel) {
        title.text = data.characteristic
        value.text = data.value
    }

    func showSeparator() {
        contentView.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor(named: "mainLabelColor")
        NSLayoutConstraint.activate([
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
