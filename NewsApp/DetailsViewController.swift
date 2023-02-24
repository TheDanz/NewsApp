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
    
    let publicationDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        label.textAlignment = .right
        return label
    }()
    
    let sourceNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        label.textAlignment = .right
        return label
    }()

    var article: Article? {
        didSet {
            
            titleLabel.text = article?.title ?? "Title"
            descriptionLabel.text = article?.description ?? "Description"
            publicationDateLabel.text = article?.publishedAt ?? "Publication Date"
            sourceNameLabel.text = article?.source?.name ?? "Sourse"

            guard let urlToImage = article?.urlToImage,
                  let url = URL(string: urlToImage) else { return }
            
            let networkManager = NetworkManager()
            networkManager.getPoster(from: url) { image in
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
        view.addSubview(publicationDateLabel)
        view.addSubview(sourceNameLabel)
        
        activateTitleLabelConstraints()
        activatePosterImageViewConstraints()
        activateDescriptionLabelConstraints()
        activatePublicationDateLabelConstraints()
        activateSourceNameLabelConstraints()
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
    
    func activatePublicationDateLabelConstraints() {
        publicationDateLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        publicationDateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        publicationDateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 0).isActive = true
        publicationDateLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
    }
    
    func activateSourceNameLabelConstraints() {
        sourceNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        sourceNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        sourceNameLabel.topAnchor.constraint(equalTo: publicationDateLabel.bottomAnchor, constant: 0).isActive = true
        sourceNameLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
    }
}
