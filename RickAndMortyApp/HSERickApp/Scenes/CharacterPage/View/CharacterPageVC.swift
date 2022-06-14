import UIKit
import Kingfisher

protocol CharacterPageViewControllerProtocol: AnyObject {
    func setupCharacterNameAndIcon(for character: CharacterModel)
    var characterInfoTableView: UITableView { get }
}

final class CharacterPageViewController: UIViewController, CharacterPageViewControllerProtocol {
    public var presenter: CharacterPagePresenterProtocol!

    private let mainScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.alwaysBounceVertical = true
        scroll.alwaysBounceHorizontal = false
        scroll.backgroundColor = .clear
        return scroll
    }()

    private let containerView: UIView = {
        let newView = UIView()
        newView.backgroundColor = .clear
        return newView
    }()

    private let characterImage: UIImageView = {
        let image = UIImageView(image: UIImage())
        image.backgroundColor = .cyan
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        if UITraitCollection.current.userInterfaceStyle == .light {
            image.layer.borderWidth = 1
            image.layer.borderColor = UIColor(named: "mainLabelColor")?.cgColor
        }
        return image
    }()

    private let characterName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFonts.SFdisplayBold.rawValue, size: 34)
        label.textAlignment = .left
        return label
    }()

    private lazy var favButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = self.favButtonColor
        button.layer.cornerRadius = 24
        return button
    }()

    private var favButtonColor: UIColor {
        if presenter.isCurrentCharFavourited {
            return UIColor(named: "mainLabelColor") ?? .label
        } else {
            return UIColor(named: "unselectedFavButton") ?? .secondaryLabel
        }
    }

    private let favButtonIcon: UIImageView = {
        let imageView = UIImageView()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        let largeBoldHeart = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)
        imageView.image = largeBoldHeart
        imageView.isUserInteractionEnabled = false
        return imageView
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
        presenter.presentCurrentCharacter()
        setupUI()
        setupTableView()
        setupButtonActions()
    }

    // MARK: - Setup VC
    func setupUI() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Characters".localized()
        self.view.backgroundColor = UIColor(named: "backgroundColor")

        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(containerView)

        [characterImage, characterName, favButton, favButtonIcon, characterInfoTableView].forEach {
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
            containerView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),

            characterImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            characterImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 38),
            characterImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -38),
            characterImage.heightAnchor.constraint(equalTo: characterImage.widthAnchor),

            characterName.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 35),
            characterName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            characterName.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.75),

            favButton.centerYAnchor.constraint(equalTo: characterName.centerYAnchor),
            favButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            favButton.widthAnchor.constraint(equalToConstant: 48),
            favButton.heightAnchor.constraint(equalToConstant: 48),

            favButtonIcon.centerXAnchor.constraint(equalTo: favButton.centerXAnchor),
            favButtonIcon.centerYAnchor.constraint(equalTo: favButton.centerYAnchor),

            characterInfoTableView.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 20),
            characterInfoTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            characterInfoTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            characterInfoTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            // Пока что единственный рабочий метод, который я нашел
            // Если задать только bottomAnchor - таблица будет иметь 0 высоту
            // Если задать только heightAnchor - будет некорректный размер контейнера,
            // и кнопки внутри него не будут получать касаний
            characterInfoTableView.heightAnchor.constraint(
                greaterThanOrEqualToConstant: CharacterDescriptionCell.cellHeight * CGFloat(presenter.currentCharacterInfo.count)
            )
        ])
    }

    func setupTableView() {
        characterInfoTableView.delegate = self
        characterInfoTableView.dataSource = self
        characterInfoTableView.isScrollEnabled = false
        characterInfoTableView.register(
            CharacterDescriptionCell.self,
            forCellReuseIdentifier: CharacterDescriptionCell.defaultReuseIdentifier
        )
    }

    func setupButtonActions() {
        favButton.addTarget(self, action: #selector(favButtonPressed), for: .touchUpInside)
    }

    // MARK: - Button actions
    @objc func favButtonPressed(sender: UIButton!) {
        presenter.flipFavouriteStatus()
        self.favButton.backgroundColor = self.favButtonColor
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
