import UIKit
import SwiftUI

protocol SearchViewControllerProtocol: AnyObject {

}

final class SearchViewController: UIViewController, SearchViewControllerProtocol {

    public var presenter: SearchPresenterProtocol!

    let searchScreenTableView = UITableView()

    // MARK: - VC lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        setupMainTableView()
        setupUI()
    }

    // MARK: - Setup UI
    func setupUI() {
        let allObjects: [UIView] = [searchScreenTableView]
        allObjects.forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            searchScreenTableView.topAnchor.constraint(equalTo: super.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchScreenTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            searchScreenTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            searchScreenTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }

    func setupMainTableView() {
        searchScreenTableView.backgroundColor = .clear
        searchScreenTableView.delegate = self
        searchScreenTableView.dataSource = self
        searchScreenTableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
    }
}

// MARK: - UITableView Protocol conformance
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getNumberOfSections()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchScreenTableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath)
                as? MainTableViewCell else {
            fatalError()
        }
        let category = UserDefaultsManager.DataCategory.allCases[indexPath.section]
        let charactersIDs = UserDefaultsManager.sharedInstance().getCharacterIDsIn(category: category)
        cell.configure(with: presenter.getCharactersArray(with: charactersIDs))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MainTableViewCell.height
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        label.text = "Гамарджоба"
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = UIColor(named: "mainLabelColor")

        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
