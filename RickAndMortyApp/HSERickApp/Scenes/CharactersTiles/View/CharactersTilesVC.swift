import UIKit

protocol CharactersTilesViewControllerProtocol: AnyObject {

}

final class CharactersTilesVC: UIViewController, CharactersTilesViewControllerProtocol {

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
        return scroll
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "backgroundColor")
        button.alpha = 0.8
        button.layer.cornerRadius = 24
        return button
    }()

    private let buttomIcon: UIImageView = {
        let imageView = UIImageView()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        let largeBoldHeart = UIImage(systemName: "multiply", withConfiguration: largeConfig)
        imageView.image = largeBoldHeart
        imageView.isUserInteractionEnabled = false
        imageView.tintColor = UIColor(named: "mainLabelColor")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.mainScrollView.contentSize = self.characterTiles.frame.size
        setupTargetsAndDelegates()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        mainScrollView.setZoomScale(0.4, animated: false)
        mainScrollView.setContentOffset(CGPoint(x: 1000, y: 1000), animated: false)
    }

    func setupTargetsAndDelegates() {
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        mainScrollView.delegate = self
    }

    private func setupUI() {
        let allObjects: [UIView] = [mainScrollView, closeButton, buttomIcon]
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

            buttomIcon.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor),
            buttomIcon.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
    }

    @objc private func closeButtonPressed() {
        self.dismiss(animated: true)
    }
}

extension CharactersTilesVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.characterTiles
    }
}
