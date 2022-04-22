import UIKit

class HomeVC: UIViewController {
    
    private let rickAndMortyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let textAttributes = [
            NSAttributedString.Key.strokeColor :
                UIColor(named: "mainLabelColor") ?? UIColor.label,
            NSAttributedString.Key.foregroundColor :
                UIColor(named: "backgroundColor") ?? UIColor.systemBackground,
            NSAttributedString.Key.strokeWidth : -1.0,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 72)
        ] as [NSAttributedString.Key : Any]
        label.textAlignment = .left
        label.attributedText = NSMutableAttributedString(string: "RICK\nAND\nMORTY", attributes: textAttributes)
        return label
    }()
    
    private let characterBookLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "CHARACTER\nBOOK"
        label.textColor = UIColor(named: "mainLabelColor")
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        setupLabels()
    }
    
    func setupLabels() {
        [rickAndMortyLabel, characterBookLabel].forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            rickAndMortyLabel.topAnchor.constraint(equalTo: super.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            rickAndMortyLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            rickAndMortyLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            rickAndMortyLabel.heightAnchor.constraint(equalToConstant: 260),
            
            characterBookLabel.topAnchor.constraint(equalTo: rickAndMortyLabel.bottomAnchor, constant: 24),
            characterBookLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            characterBookLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            characterBookLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}

