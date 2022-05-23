import UIKit

protocol CharactersTilesViewControllerProtocol: AnyObject {
    func prepareCloseButtonForAnimation()
    func finishCloseButtonAnimation()
    func configureScroll(with coordinates: CGPoint)
}

final class CharactersTilesVC: UIViewController, CharactersTilesViewControllerProtocol {
    func configureScroll(with coordinates: CGPoint) {
        mainScrollView.delegate = self
        self.mainScrollView.setZoomScale(0.45, animated: false)
        self.mainScrollView.setContentOffset(coordinates, animated: false)
    }

    public var presenter: CharactersTilesPresenterProtocol!

    private let characterTiles: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "MainPage1"))
        return imageView
    }()

    private let mainScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.minimumZoomScale = 0.3
        scroll.maximumZoomScale = 0.65
        scroll.setContentOffset(CGPoint(x: 1000, y: 1000), animated: false)
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.contentInset = UIEdgeInsets(top: -350, left: -150, bottom: -350, right: -150)
//        scroll.bounces = false
        return scroll
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "backgroundColor")
        button.alpha = 0.8
        button.layer.cornerRadius = 24
        return button
    }()

    private let buttonIcon: UIImageView = {
        let imageView = UIImageView()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        let largeBoldHeart = UIImage(systemName: "multiply", withConfiguration: largeConfig)
        imageView.image = largeBoldHeart
        imageView.isUserInteractionEnabled = false
        imageView.tintColor = UIColor(named: "mainLabelColor")
        return imageView
    }()

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.mainScrollView.contentSize = self.characterTiles.frame.size
        mainScrollView.setZoomScale(0.45, animated: false)
        mainScrollView.setContentOffset(CGPoint(x: 1000, y: 1000), animated: false)
        setupTargetsAndDelegates()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }

    // MARK: - VC Setup
    private func setupTargetsAndDelegates() {
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        mainScrollView.delegate = self
    }

    // MARK: - UI setup
    private func setupUI() {
        let allObjects: [UIView] = [mainScrollView, closeButton, buttonIcon]
        allObjects.forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
        }
        characterTiles.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(characterTiles)

        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            closeButton.widthAnchor.constraint(equalToConstant: 48),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 33),
            closeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),

            buttonIcon.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor),
            buttonIcon.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
    }

    @objc private func closeButtonPressed() {
        self.dismiss(animated: true)
    }

    // MARK: - Animation handling
    func prepareCloseButtonForAnimation() {
        self.closeButton.alpha = 0
        self.buttonIcon.alpha = 0
    }

    func finishCloseButtonAnimation() {
        self.closeButton.alpha = 0.8
        self.buttonIcon.alpha = 1
    }
}

extension CharactersTilesVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.characterTiles
    }
}
