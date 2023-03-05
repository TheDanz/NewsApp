import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.layer.cornerRadius = 12
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .red
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    var data: Article? {
        didSet {
            
            guard let data = data else { fatalError("Data error") }
            
            titleLabel.text = data.title

            if let urlToImage = data.urlToImage {
                if let url = URL(string: urlToImage) {
                    let networkManager = NetworkManager()
                    networkManager.getPoster(from: url) { image in
                        DispatchQueue.main.async {
                            self.posterImageView.image = image
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
            } else {
                posterImageView.image = UIImage(systemName: "newspaper")
                activityIndicator.stopAnimating()
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setImageViewConstraints()
        setTitleLabelConstraints()
        setActivityIndicatorConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setImageViewConstraints() {
        contentView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4).isActive = true
    }
    
    func setTitleLabelConstraints() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.55).isActive = true
    }
    
    func setActivityIndicatorConstraints() {
        contentView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor).isActive = true
    }
}
