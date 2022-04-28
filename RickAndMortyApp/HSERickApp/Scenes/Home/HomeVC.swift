import UIKit

protocol HomeVCProtocol: AnyObject {
    
}

final class HomeVC: UIViewController, HomeVCProtocol {
    
    public var presenter: HomePresenterProtocol!
    
    // MARK: - UI Properties
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
        scroll.setZoomScale(0.35, animated: false)
        return scroll
    }()
    
    let characterTiles: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "MainPage1"))
        return imageView
    }()
    
    // MARK: - Animation handling properties
    var animationProgressWhenInterrupted: CGFloat = 0
    var runningAnimations = [UIViewPropertyAnimator]()
    var visualEffectView: UIVisualEffectView!
    
    // Tiles anchors to be animated
    lazy var topAnchorCollapsed = mainScrollView.topAnchor.constraint(equalTo: characterBookLabel.bottomAnchor)
    lazy var topAnchorExpanded = mainScrollView.topAnchor.constraint(equalTo: view.topAnchor)
    
    enum TilesImageState {
        case expanded
        case collapsed
    }

    var tilesExpanded = false

    var nextState: TilesImageState {
        return tilesExpanded ? .collapsed : .expanded
    }

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        setupEffectsLayer()
        setupUI()
        setupScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // TODO: - Константы куда-то перенести
        self.mainScrollView.contentOffset = CGPoint(x: 800, y: 550)
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3.0, options: .curveEaseIn, animations: {
            self.mainScrollView.contentOffset = CGPoint(x: 2520/2, y: 1394)
            self.mainScrollView.setZoomScale(0.55, animated: false)
        })
    }
    
    // MARK: - UI setup
    func setupEffectsLayer() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.frame = self.view.frame
    }

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

            topAnchorCollapsed,
            mainScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])

        self.view.insertSubview(visualEffectView, belowSubview: mainScrollView)
    }
    
    func setupScrollView() {
        mainScrollView.minimumZoomScale = 0.35
        mainScrollView.maximumZoomScale = 0.8
        mainScrollView.delegate = self
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(self.handleCardPan(recognizer:)))
        mainScrollView.addGestureRecognizer(panGestureRecognizer)
    }

   
    // MARK: -Animation handling
    @objc func handleCardPan (recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.mainScrollView)
            var fractionComplete = translation.y /  mainScrollView.frame.height
            fractionComplete = tilesExpanded ? fractionComplete : -fractionComplete
            for animator in runningAnimations {
                animator.fractionComplete = fractionComplete + animationProgressWhenInterrupted
            }
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }

    func animateTransitionIfNeeded (state: TilesImageState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.mainScrollView.setZoomScale(0.35, animated: false)
                    self.topAnchorCollapsed.isActive = false
                    self.topAnchorExpanded.isActive = true
                    self.view.layoutIfNeeded()
                case .collapsed:
                    self.mainScrollView.setZoomScale(0.55, animated: false)
                    self.topAnchorExpanded.isActive = false
                    self.topAnchorCollapsed.isActive = true
                    self.view.layoutIfNeeded()
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.tilesExpanded = !self.tilesExpanded
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)

            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.mainScrollView.layer.cornerRadius = 25
                case .collapsed:
                    self.mainScrollView.layer.cornerRadius = 0
                }
            }

            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
        }
    }

    func startInteractiveTransition(state: TilesImageState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func continueInteractiveTransition () {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
}

// MARK: - ScrollView Delegate
extension HomeVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return characterTiles
    }
}
