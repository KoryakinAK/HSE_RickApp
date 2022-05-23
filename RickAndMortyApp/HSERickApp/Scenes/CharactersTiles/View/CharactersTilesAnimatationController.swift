import UIKit

class CharactersTilesAnimatationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let originFrame: CGRect
    private var position: CGPoint
    private let statusBarHeight: CGFloat = {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }()

    init(originFrame: CGRect, position: CGPoint) {
        self.originFrame = originFrame
        self.position = position
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: .to)
        else {
            return
        }

        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)

        toVC.view.isHidden = true
        containerView.addSubview(toVC.view)

        let duration = transitionDuration(using: transitionContext)

        // Обойтись снепшотом toVC не получилось:
        // Снепшот захватывает UIScrollView до изменения setZoom
        let destinationCopyVC = CharactersTilesBuilder.build()
        destinationCopyVC.prepareCloseButtonForAnimation()
        destinationCopyVC.view.clipsToBounds = true
        destinationCopyVC.view.frame = originFrame
        position.y += statusBarHeight
        containerView.addSubview(destinationCopyVC.view)
        destinationCopyVC.configureScroll(with: position)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [],
            animations: {
                destinationCopyVC.view.frame = finalFrame
                destinationCopyVC.finishCloseButtonAnimation()
            },
            completion: { [self] _ in
                if let toVC = toVC as? CharactersTilesVC {
                    self.position.y -= statusBarHeight
                    toVC.configureScroll(with: self.position)
                }
                toVC.view.isHidden = false
                destinationCopyVC.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
}
