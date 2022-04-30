import UIKit

protocol TileCellProtocol {
    var mainImage: UIImageView { get }
    static var reuseIdentifier: String { get }
}

class TileCell: UICollectionViewCell, TileCellProtocol {
    let mainImage = UIImageView()
    static let reuseIdentifier = "TileCell"

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

        NSLayoutConstraint.activate([
        mainImage.topAnchor.constraint(equalTo: contentView.topAnchor),
        mainImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        mainImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        mainImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
