import UIKit

protocol FavouritesListVCProtocol: AnyObject {
    var chararactersTableView: UITableView { get }
    var emptyLabel: UILabel { get }
}

final class FavouritesListVC: UIViewController, FavouritesListVCProtocol {
    // MARK: - Properties
    public var presenter: FavouritesListPresenterProtocol!

    let chararactersTableView: UITableView = {
       let tableView = UITableView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        return tableView
    }()

    let emptyLabel: UILabel = {
        let label = UILabel()
        let customFont = UIFont(name: CustomFonts.SFtextSemiBold.rawValue, size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = customFont
        label.textColor = UIColor(named: "secondaryLabelColor")
        label.text = "Nothing to see here...yet".localized()
        return label
    }()

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonDisplayMode = .generic
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        presenter.updateFavCharacters()
        setupUI()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.presenter.updateFavCharacters()
    }

    // MARK: - VC setup
    func setupUI() {
        emptyLabel.isHidden = true
        [chararactersTableView, emptyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            chararactersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chararactersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chararactersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chararactersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupTableView() {
        chararactersTableView.delegate = self
        chararactersTableView.dataSource = self
        chararactersTableView.register(FavouriteCharacterCell.self, forCellReuseIdentifier: FavouriteCharacterCell.defaultReuseIdentifier)
    }
}

// MARK: - UITableView Protocol conformance
extension FavouritesListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.favCharactersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chararactersTableView.dequeueReusableCell(withIdentifier: "FavouriteCharacterCell", for: indexPath)
                as? FavouriteCharacterCell else {
            fatalError()
        }
        let character = presenter.favCharactersList[indexPath.row]
        cell.configure(with: character)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FavouriteCharacterCell.height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelect(row: indexPath.row)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
