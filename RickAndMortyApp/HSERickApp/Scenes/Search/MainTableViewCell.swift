import UIKit

protocol MainTableViewCellProtocol {
    static var reuseIdentifier: String { get }
    static var height: CGFloat { get }
}

class MainTableViewCell: UITableViewCell, MainTableViewCellProtocol {
    var recentlySearchedCV: UICollectionView!
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    static let height: CGFloat = 160
    static let reuseIdentifier = "MainTableViewCell"
    
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
        self.backgroundColor = .red
        recentlySearchedCV.translatesAutoresizingMaskIntoConstraints = false 
        self.contentView.addSubview(recentlySearchedCV)
        NSLayoutConstraint.activate([
            recentlySearchedCV.topAnchor.constraint(equalTo: contentView.topAnchor),
            recentlySearchedCV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recentlySearchedCV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            recentlySearchedCV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func setupCollectionView() {
        layout.scrollDirection = .horizontal

        recentlySearchedCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        recentlySearchedCV.collectionViewLayout = layout
        recentlySearchedCV.backgroundColor = .clear
        recentlySearchedCV.showsVerticalScrollIndicator = false
        recentlySearchedCV.showsHorizontalScrollIndicator = false
        recentlySearchedCV.register(RecenlySearchedCVCell.self, forCellWithReuseIdentifier: RecenlySearchedCVCell.reuseIdentifier)
        recentlySearchedCV.delegate = self
        recentlySearchedCV.dataSource = self
    }
}

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecenlySearchedCVCell.reuseIdentifier, for: indexPath) as? RecenlySearchedCVCell else { fatalError() }
        return cell
    }
}


extension MainTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
}
