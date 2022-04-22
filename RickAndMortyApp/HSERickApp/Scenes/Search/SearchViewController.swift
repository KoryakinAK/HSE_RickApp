import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    
}

final class SearchViewController: UIViewController, SearchViewControllerProtocol {
    
    public var presenter: SearchPresenterProtocol!
    
    override public func viewDidLoad() -> () {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
    }
}
