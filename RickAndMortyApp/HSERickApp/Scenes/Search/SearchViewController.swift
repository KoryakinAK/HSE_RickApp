import UIKit
import SwiftUI

protocol SearchViewControllerProtocol: AnyObject {

}

final class SearchViewController: UIViewController, SearchViewControllerProtocol {

    public var presenter: SearchPresenterProtocol!

    // MARK: - Search UI elements
    let searchTextField: UITextField = {
        let textField = UITextField()
        let customFont = UIFont(name: "SFUIDisplay-Black", size: 17) ?? UIFont.boldSystemFont(ofSize: 17)
        textField.textColor = UIColor(named: "mainLabelColor")
        textField.font = customFont
        return textField
    }()

    let searchFieldOutline: UILabel = {
        let label = UILabel()
        label.layer.borderWidth = 2.0
        label.layer.borderColor = UIColor(named: "mainLabelColor")?.cgColor
        label.layer.cornerRadius = 11
        return label
    }()

    let searchIcon: UIImageView = {
        let imageView = UIImageView()
        let searchIcomConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .medium)
        imageView.image = UIImage(systemName: "magnifyingglass",
                                  withConfiguration: searchIcomConfig)
        return imageView
    }()

    // MARK: - Other UI elements
    let suggestionsTableView = UITableView()
    let separatorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(named: "secondaryLabelColor")
        label.layer.cornerRadius = 1
        label.clipsToBounds = true
        return label
    }()

    // MARK: - VC lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        setupMainTableView()
        setupUI()
    }

    // MARK: - Setup UI
    func setupUI() {
        let allObjects: [UIView] = [separatorLabel, searchIcon, searchFieldOutline, searchTextField, suggestionsTableView]
        allObjects.forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            separatorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 7),
            separatorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            separatorLabel.heightAnchor.constraint(equalToConstant: 3),
            separatorLabel.widthAnchor.constraint(equalToConstant: 56),

            searchFieldOutline.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            searchFieldOutline.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchFieldOutline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchFieldOutline.heightAnchor.constraint(equalToConstant: 55),

            searchIcon.leadingAnchor.constraint(equalTo: searchFieldOutline.leadingAnchor, constant: 17.62),
            searchIcon.centerYAnchor.constraint(equalTo: searchFieldOutline.centerYAnchor),

            searchTextField.topAnchor.constraint(equalTo: searchFieldOutline.topAnchor, constant: 13),
            searchTextField.leadingAnchor.constraint(equalTo: searchFieldOutline.leadingAnchor, constant: 46),
            searchTextField.trailingAnchor.constraint(equalTo: searchFieldOutline.trailingAnchor, constant: -13),
            searchTextField.bottomAnchor.constraint(equalTo: searchFieldOutline.bottomAnchor, constant: -13),

            suggestionsTableView.topAnchor.constraint(equalTo: searchFieldOutline.bottomAnchor, constant: 16),
            suggestionsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            suggestionsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            suggestionsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }

    func setupMainTableView() {
        suggestionsTableView.backgroundColor = .clear
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        suggestionsTableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
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
        guard let cell = suggestionsTableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath)
                as? MainTableViewCell else {
            fatalError()
        }
        let category = CharacterCategory.allCases[indexPath.section]
        let charactersIDs = UserDefaultsManager.sharedInstance().getCharacterIDsIn(category: category)
        cell.configure(with: presenter, for: category)
//        cell.configure(with: presenter.getCharactersArray(with: charactersIDs))
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
