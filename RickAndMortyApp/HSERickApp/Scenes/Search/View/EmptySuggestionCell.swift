import UIKit

protocol EmptySuggestionCellProtocol {
}

class EmptySuggestionCell: UITableViewCell, EmptySuggestionCellProtocol {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var cellCategory: CharacterCategory!

    static let height: CGFloat = 160
    private var emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing to see here...yet".localized()
        let customFont = UIFont(name: CustomFonts.SFtextSemiBold.rawValue, size: 26) ?? UIFont.systemFont(ofSize: 26)
        label.textColor = UIColor(named: "secondaryLabelColor")
        label.font = customFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup view
    func setupUI() {
        self.backgroundColor = .clear
        self.contentView.addSubview(emptyMessageLabel)
        NSLayoutConstraint.activate([
            emptyMessageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyMessageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}
