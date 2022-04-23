import UIKit

protocol HomeVCProtocol: AnyObject {
    
}

final class HomeVC: UIViewController, HomeVCProtocol {
    
    public var presenter: HomePresenterProtocol!
    
    let mainScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        return scroll
    }()

    let containerView = UIView()

    private let rickAndMortyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let textAttributes = [
            NSAttributedString.Key.strokeColor :
                UIColor(named: "mainLabelColor") ?? UIColor.label,
            NSAttributedString.Key.foregroundColor :
                UIColor(named: "backgroundColor") ?? UIColor.systemBackground,
            NSAttributedString.Key.strokeWidth : -1.0,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 72)
        ] as [NSAttributedString.Key : Any]
        label.textAlignment = .left
        label.attributedText = NSMutableAttributedString(string: "RICK\nAND\nMORTY", attributes: textAttributes)
        return label
    }()
    
    private let characterBookLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "CHARACTER\nBOOK"
        label.textColor = UIColor(named: "mainLabelColor")
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    var tilesCV: UICollectionView!
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        setupCollectionView()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainScrollView.contentSize = self.containerView.subviews.reduce(CGRect.zero, {
           return $0.union($1.frame)
        }).size
    }
    
    // MARK: - UI setup
    func setupUI() {
        let allObjects: [UIView] = [rickAndMortyLabel, characterBookLabel, mainScrollView]
        allObjects.forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
        }
    
        mainScrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tilesCV)
        tilesCV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rickAndMortyLabel.topAnchor.constraint(equalTo: super.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            rickAndMortyLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            rickAndMortyLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            rickAndMortyLabel.heightAnchor.constraint(equalToConstant: 260),
            
            characterBookLabel.topAnchor.constraint(equalTo: rickAndMortyLabel.bottomAnchor, constant: 24),
            characterBookLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            characterBookLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            characterBookLabel.heightAnchor.constraint(equalToConstant: 80),
            
            mainScrollView.topAnchor.constraint(equalTo: characterBookLabel.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            containerView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 10000),
    
            tilesCV.topAnchor.constraint(equalTo: containerView.topAnchor),
            tilesCV.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tilesCV.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tilesCV.heightAnchor.constraint(equalToConstant: 10000),
        ])
    }
    
    func setupCollectionView() {
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        tilesCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tilesCV.collectionViewLayout = layout
        tilesCV.backgroundColor = .clear
        tilesCV.showsVerticalScrollIndicator = false
        tilesCV.register(TileCell.self, forCellWithReuseIdentifier: TileCell.reuseIdentifier)
        tilesCV.delegate = self
        tilesCV.dataSource = self
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tilesCV.dequeueReusableCell(withReuseIdentifier: TileCell.reuseIdentifier, for: indexPath) as! TileCell
        cell.mainImage.image = UIImage(named: "MainPage1")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 1000, height: 1000)
    }
}
