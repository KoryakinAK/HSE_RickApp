import UIKit

class FavouritesVC: UIViewController {
    
    // MARK: - Properties
    let chararactersTableView: UITableView = {
       let tableView = UITableView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        return tableView
    }()
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        setupUI()
        setupTableView()
    }
    
    // MARK: - VC setup
    func setupUI() {
        [chararactersTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            chararactersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chararactersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chararactersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chararactersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        chararactersTableView.delegate = self
        chararactersTableView.dataSource = self
        chararactersTableView.register(CharacterCell.self, forCellReuseIdentifier: "CharacterCell")
    }
}

// MARK: - UITableView Protocol conformance
extension FavouritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chararactersTableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
                as? CharacterCell else {
            fatalError()
        }
        cell.configure(with: CharacterModel(name: "Pickle Rick", imageURL: "-"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CharacterCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(CharacterVC(), animated: true)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
}
