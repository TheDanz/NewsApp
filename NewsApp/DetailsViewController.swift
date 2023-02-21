import UIKit

class DetailsViewController: UIViewController {
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(descriptionLabel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        descriptionLabel.frame = view.bounds
    }
}
