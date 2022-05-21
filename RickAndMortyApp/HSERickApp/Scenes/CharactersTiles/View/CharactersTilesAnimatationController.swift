import UIKit

class CharactersTilesAnimatationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let originFrame: CGRect

    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
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
        containerView.addSubview(destinationCopyVC.view)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [],
            animations: {
                destinationCopyVC.view.frame = finalFrame
                destinationCopyVC.finishCloseButtonAnimation()
            },
            completion: { _ in
                toVC.view.isHidden = false
                destinationCopyVC.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
}
