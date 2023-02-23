import UIKit

class DetailsViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var networkManager = NetworkManager()
    var article: Article? {
        didSet {
            titleLabel.text = article?.title
            descriptionLabel.text = article?.description
            networkManager.getPoster(from: URL(string: (article?.urlToImage)!)!) { image in
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(posterImageView)
        view.addSubview(descriptionLabel)
        
        activateTitleLabelConstraints()
        activatePosterImageViewConstraints()
        activateDescriptionLabelConstraints()
    }
    
    func activateTitleLabelConstraints() {
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func activatePosterImageViewConstraints() {
        posterImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        posterImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        posterImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        posterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
    }
    
    func activateDescriptionLabelConstraints() {
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 0).isActive = true
        descriptionLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
}
