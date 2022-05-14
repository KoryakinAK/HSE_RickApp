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
        scroll.alwaysBounceVertical = true
        scroll.alwaysBounceHorizontal = false
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
        image.clipsToBounds = true
        return image
    }()

    let characterName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 36)
        label.textAlignment = .left
        return label
    }()

    let favButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "heart.circle.fill", withConfiguration: largeConfig)
        button.setImage(largeBoldDoc, for: .normal)
        return button
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
        setupUI()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let calculatedSize = self.containerView.subviews.reduce(CGRect.zero, {
                        return $0.union($1.frame)
                    }).size
        self.mainScrollView.contentSize = CGSize(width: view.frame.width, height: calculatedSize.height)
    }

    // MARK: - Setup VC
    func setupUI() {
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(containerView)

        [characterImage, characterName, favButton, characterInfoTableView].forEach {
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
            containerView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),

            characterImage.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 20),
            characterImage.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 38),
            characterImage.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -38),
            characterImage.heightAnchor.constraint(equalTo: characterImage.widthAnchor),

            characterName.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 35),
            characterName.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 16),
            characterName.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor, multiplier: 0.75),

            favButton.centerYAnchor.constraint(equalTo: characterName.centerYAnchor),
            favButton.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -50),
//            favButton.widthAnchor.constraint(equalToConstant: 18),

            characterInfoTableView.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 20),
            characterInfoTableView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 16),
            characterInfoTableView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -16),
            // Пока что единственный рабочий метод, который я нашел
            // Без contentView не взлетает, с ним или без и привязкой к bottomAnchor - тоже не работает
            characterInfoTableView.heightAnchor.constraint(
                equalToConstant: CharacterDescriptionCell.cellHeight * CGFloat(presenter.currentCharacterInfo.count)
            )

        ])
    }

    func setupTableView() {
        characterInfoTableView.delegate = self
        characterInfoTableView.dataSource = self
        characterInfoTableView.isScrollEnabled = false
        characterInfoTableView.register(CharacterDescriptionCell.self, forCellReuseIdentifier: "CharacterDescriptionCell")
    }

    // MARK: - Presenter interaction
    func setupCharacterNameAndIcon(for character: CharacterModel) {
        characterName.text = character.name
        if let url = URL(string: character.image) {
            characterImage.kf.setImage(with: url)
        }
    }
}

extension CharacterPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.currentCharacterInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = characterInfoTableView.dequeueReusableCell(withIdentifier: "CharacterDescriptionCell", for: indexPath)
                as? CharacterDescriptionCell else {
            fatalError()
        }
        let info = presenter.currentCharacterInfo[indexPath.row]
        cell.configure(with: info)
        if indexPath.row < (presenter.currentCharacterInfo.count - 1) {
            cell.showSeparator()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CharacterDescriptionCell.cellHeight
    }
}
