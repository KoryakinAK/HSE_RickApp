import UIKit

protocol HomeVCProtocol: AnyObject {

}

final class HomeVC: UIViewController, HomeVCProtocol {
    public var presenter: HomePresenterProtocol!

    private var interactionController: UIPercentDrivenInteractiveTransition?

    // MARK: - UI Properties
    private let rickAndMortyLabel: UILabel = {
        let label = UILabel()
        let customFont = UIFont(name: CustomFonts.SFdisplayBlack.rawValue, size: 72) ?? UIFont.boldSystemFont(ofSize: 72)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.numberOfLines = 0
        let textAttributes = [
            NSAttributedString.Key.strokeColor:
                UIColor(named: "mainLabelColor") ?? UIColor.label,
            NSAttributedString.Key.foregroundColor:
                UIColor(named: "backgroundColor") ?? UIColor.systemBackground,
            NSAttributedString.Key.strokeWidth: -1.0,
            NSAttributedString.Key.font: customFont
        ] as [NSAttributedString.Key: Any]
        label.attributedText = NSMutableAttributedString(string: "RICK\nAND\nMORTY", attributes: textAttributes)
        return label
    }()

    private let characterBookLabel: UILabel = {
        let label = UILabel()
        let customFont = UIFont(name: CustomFonts.SFdisplayBlack.rawValue, size: 32) ?? UIFont.boldSystemFont(ofSize: 32)
        // TODO: - Вынести в презентер
        label.attributedText = NSMutableAttributedString(string: "CHARACTER\nBOOK", attributes: [NSAttributedString.Key.kern: 3])
        label.numberOfLines = 0
        label.textColor = UIColor(named: "mainLabelColor")
        label.font = customFont
        return label
    }()

    private let mainScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        return scroll
    }()

    private let characterTiles: UIImageView = {
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

    override func viewDidAppear(_ animated: Bool) {
        // TODO: - Константы куда-то перенести
        self.mainScrollView.contentOffset = CGPoint(x: 800, y: 550)
        UIView.animate(withDuration: 0.7,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 3.0,
                       options: .curveEaseInOut,
                       animations: {
            self.mainScrollView.contentOffset = CGPoint(x: 2520/2, y: 1394)
            self.mainScrollView.setZoomScale(0.45, animated: false)
        })
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

            mainScrollView.topAnchor.constraint(equalTo: characterBookLabel.bottomAnchor, constant: 45),
            mainScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setupScrollView() {
        mainScrollView.minimumZoomScale = 0.35
        mainScrollView.maximumZoomScale = 0.65
        mainScrollView.delegate = self
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
         mainScrollView.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Animation handling
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        let destination = CharactersTilesBuilder.build()
        destination.transitioningDelegate = self
        destination.modalPresentationStyle = .custom

//        self.show(destination, sender: self)
//        self.present(destination, animated: true)
        self.navigationController?.present(destination, animated: true)
    }
}

// MARK: - ScrollView Delegate
extension HomeVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return characterTiles
    }
}

extension HomeVC: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CharactersTilesAnimatationController(originFrame: self.mainScrollView.frame, position: self.mainScrollView.contentOffset)
    }
}
