import UIKit

protocol SuggestionContainerCellProtocol {
    static var height: CGFloat { get }
    func configure(with: SearchPresenterProtocol, for: CharacterCategory)
}

class SuggestionContainerCell: UITableViewCell, SuggestionContainerCellProtocol {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    var recentlySearchedCV: UICollectionView!
    var cellCategory: CharacterCategory!
    var presenter: SearchPresenterProtocol!

    static let height: CGFloat = 160

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup view
    func setupUI() {
        self.backgroundColor = .clear
        recentlySearchedCV.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(recentlySearchedCV)
        NSLayoutConstraint.activate([
            recentlySearchedCV.topAnchor.constraint(equalTo: contentView.topAnchor),
            recentlySearchedCV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recentlySearchedCV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            recentlySearchedCV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func setupCollectionView() {
        layout.scrollDirection = .horizontal
        recentlySearchedCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        recentlySearchedCV.collectionViewLayout = layout
        recentlySearchedCV.backgroundColor = .clear
        recentlySearchedCV.showsVerticalScrollIndicator = false
        recentlySearchedCV.showsHorizontalScrollIndicator = false
        recentlySearchedCV.register(SmallCharacterCell.self,
                                    forCellWithReuseIdentifier: SmallCharacterCell.defaultReuseIdentifier)
        recentlySearchedCV.delegate = self
        recentlySearchedCV.dataSource = self
    }

    func configure(with presenter: SearchPresenterProtocol, for category: CharacterCategory) {
        self.presenter = presenter
        self.cellCategory = category
    }
}

extension SuggestionContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getNumberOfRows(in: self.cellCategory)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        presenter.didSelectSearchResultAt(row: indexPath.row, in: self.cellCategory)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SmallCharacterCell.defaultReuseIdentifier,
            for: indexPath)
                as? SmallCharacterCell else { fatalError() }
        guard let character = presenter.getCharacterFor(row: indexPath.row, in: self.cellCategory) else { return cell }
        cell.configure(with: character)
        return cell
    }
}

extension SuggestionContainerCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {_ in
            let action = UIAction(title: "Add to favourites", image: UIImage(systemName: "heart.fill")) {_ in
//                self.presenter.flipFavouriteStatus()
            }
            let menu = UIMenu(title: "Rick Sanchez", image: nil, identifier: nil, options: [], children: [action])
            return menu
        }
        return config
    }
}
