import UIKit
import Kingfisher

protocol CharacterPageViewControllerProtocol: AnyObject {
    func setupCharacterNameAndIcon(for character: CharacterModel)
    var characterInfoTableView: UITableView { get }
}

final class CharacterPageViewController: UIViewController, CharacterPageViewControllerProtocol {
    // MARK: - Properties
    public var presenter: CharacterPagePresenterProtocol!

    let mainScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        return scroll
    }()
    
    let containerView: UIView = {
        let newView = UIView()
        return newView
    }()
    
    let characterImage: UIImageView = {
        let image = UIImageView(image: UIImage())
        image.backgroundColor = .cyan
        image.layer.cornerRadius = 10
        return image
    }()
    
    let characterName: UILabel = {
        let label = UILabel()
        label.text = "Pickle Rick"
        label.font = .boldSystemFont(ofSize: 36)
        label.textAlignment = .left
        return label
    }()
    
    let characterInfoTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.clipsToBounds = true
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        return tableView
    }()
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Characters"
        presenter.retrieveCharacterInformation()
        setupUI()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainScrollView.contentSize = self.containerView.subviews.reduce(CGRect.zero, {
           return $0.union($1.frame)
        }).size
    }
    
    // MARK: - Setup VC
    func setupUI() {
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(containerView)
        
        [characterImage, characterName, characterInfoTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.containerView.addSubview($0)
        }
        self.view.addSubview(mainScrollView)
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
    
            characterImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            characterImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 38),
            characterImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -37),
            characterImage.heightAnchor.constraint(equalTo: characterImage.widthAnchor),

            characterName.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 35),
            characterName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),

            characterInfoTableView.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 20),
            characterInfoTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            characterInfoTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            characterInfoTableView.heightAnchor.constraint(equalToConstant: CharacterDescriptionCell.cellHeight * 4)
            // Если не указывать высоту, то высота будет 0
            // Если привязать к contentView.bottomAnchor, то тоже
        ])
    }
    
    func setupTableView() {
        characterInfoTableView.delegate = self
        characterInfoTableView.dataSource = self
        characterInfoTableView.register(CharacterDescriptionCell.self, forCellReuseIdentifier: "CharacterDescriptionCell")
    }
    
    // MARK: - Presenter interaction
    func setupCharacterNameAndIcon(for character: CharacterModel) {
        characterName.text = character.name
        if let url = URL(string: character.imageURL) {
            characterImage.kf.setImage(with: url)
        }
    }

}

extension CharacterPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.characterInfo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = characterInfoTableView.dequeueReusableCell(withIdentifier: "CharacterDescriptionCell", for: indexPath)
                as? CharacterDescriptionCell else {
            fatalError()
        }
        guard let info = presenter.characterInfo?[indexPath.row] else { fatalError() }
        cell.configure(with: info)
        if indexPath.row < 3 {
            cell.showSeparator()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CharacterDescriptionCell.cellHeight
    }
}