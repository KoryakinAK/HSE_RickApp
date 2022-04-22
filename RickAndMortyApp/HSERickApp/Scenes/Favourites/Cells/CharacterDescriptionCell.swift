import UIKit

protocol SelfConfigurableDescriptionCell {
    func configure(with: CharacterDescriptionModel)
    func showSeparator()
    static var cellHeight: CGFloat { get }
}

class CharacterDescriptionCell: UITableViewCell, SelfConfigurableDescriptionCell {
    static let cellHeight: CGFloat = 28 * 2 + 8 + 16
    let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "secondaryLabelColor")
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 23)
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.85
        return label
    }()
    
    let value: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "mainLabelColor")
        label.font = .boldSystemFont(ofSize: 23)
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
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            title.heightAnchor.constraint(equalToConstant: 28),
            
            value.topAnchor.constraint(equalTo: title.bottomAnchor),
            value.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            value.heightAnchor.constraint(equalToConstant: 28),
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
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
