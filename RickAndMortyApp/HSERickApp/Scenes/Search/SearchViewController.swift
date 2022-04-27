import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    
}

final class SearchViewController: UIViewController, SearchViewControllerProtocol {
    
    public var presenter: SearchPresenterProtocol!
    
    let mainTableView = UITableView()
    
    var recentlySearchedCV: UICollectionView!
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    // MARK: - VC lifecycle
    override public func viewDidLoad() -> () {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        setupCollectionView()
        setupMainTableView()
        setupUI()
    }
    
    // MARK: - Setup UI
    func setupUI() {
        let allObjects: [UIView] = [mainTableView]
        allObjects.forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
        }
    
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: super.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            mainTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            mainTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
    func setupMainTableView() {
        mainTableView.backgroundColor = .clear
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
    }
    
    func setupCollectionView() {
//        layout.scrollDirection = .horizontal
//
//        recentlySearchedCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        recentlySearchedCV.collectionViewLayout = layout
//        recentlySearchedCV.backgroundColor = .clear
//        recentlySearchedCV.showsVerticalScrollIndicator = false
//        recentlySearchedCV.showsHorizontalScrollIndicator = false
//        recentlySearchedCV.register(TileCell.self, forCellWithReuseIdentifier: TileCell.reuseIdentifier)
//        recentlySearchedCV.delegate = self
//        recentlySearchedCV.dataSource = self
    }
}
            
// MARK: - UITableView Protocol conformance
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath)
                as? MainTableViewCell else {
            fatalError()
        }
//        cell.configure(with: character)
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
