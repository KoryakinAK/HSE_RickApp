import UIKit

extension UICollectionViewCell {
    static var defaultReuseIdentifier: String {
        return String(describing: Self.self)
    }
}
