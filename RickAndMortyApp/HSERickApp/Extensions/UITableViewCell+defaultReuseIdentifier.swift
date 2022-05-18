import UIKit

extension UITableViewCell {
    static var defaultReuseIdentifier: String {
        return String(describing: Self.self)
    }
}
