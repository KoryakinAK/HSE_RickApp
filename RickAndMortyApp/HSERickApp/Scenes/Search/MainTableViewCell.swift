import UIKit

protocol MainTableViewCellProtocol {
    static var reuseIdentifier: String { get }
    static var height: CGFloat { get }
}

class MainTableViewCell: UITableViewCell, MainTableViewCellProtocol {
    let mainImage = UIImageView()
    static let height: CGFloat = 160
    static let reuseIdentifier = "MainTableViewCell"
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup view
    func setupUI() {
        self.backgroundColor = .red
//        NSLayoutConstraint.activate([
//        mainImage.topAnchor.constraint(equalTo: contentView.topAnchor),
//        mainImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//        mainImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//        mainImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//        ])
    }
}
