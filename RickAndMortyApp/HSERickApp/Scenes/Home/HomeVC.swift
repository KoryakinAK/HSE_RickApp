import UIKit

protocol HomeVCProtocol: AnyObject {
    
}

final class HomeVC: UIViewController, HomeVCProtocol {
    
    public var presenter: HomePresenterProtocol!

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
        label.text = "CHARACTER\nBOOK" // TODO: - Вынести в презентер
        label.textColor = UIColor(named: "mainLabelColor")
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    let mainScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        return scroll
    }()
    
    let characterTiles: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "MainPage1"))
        return imageView
    }()

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        setupUI()
        setupScrollView()
    }
    
    // MARK: - UI setup
    func setupUI() {
        let allObjects: [UIView] = [rickAndMortyLabel, characterBookLabel, mainScrollView]
        allObjects.forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
        }
    
        mainScrollView.addSubview(characterTiles)
        characterTiles.translatesAutoresizingMaskIntoConstraints = false
        
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
        ])
    }
    
    func setupScrollView() {
        mainScrollView.minimumZoomScale = 0.5
        mainScrollView.maximumZoomScale = 1.5
        mainScrollView.delegate = self
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false
    }
}

// MARK: - ScrollView Delegate
extension HomeVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return characterTiles
    }
}
