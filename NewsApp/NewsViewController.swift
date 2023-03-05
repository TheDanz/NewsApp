import UIKit

class NewsViewController: UIViewController {
    
    var queryText = ""
    var data: [Article] = []
    let networkManager = NetworkManager()
    
    var newsTableView = UITableView()
    
    var newsSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        return searchBar
    }()
    
    
    var requestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Request", for: .normal)
        button.titleLabel!.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 12
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        newsSearchBar.delegate = self
        
        requestButton.addTarget(self, action: #selector(requestButtonClick(_:)), for: .touchUpInside)
        
        newsTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        
        setSearchBarConstraints()
        setNewsTableViewConstraints()
        setRequestButtonConstraints()
    }
    
    @objc
    func requestButtonClick(_ sender: Any) {
        networkManager.getArticles(query: queryText) { result in
            switch result {
            case .success(let articles):
                self.data = articles
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
    
    func setSearchBarConstraints() {
        view.addSubview(newsSearchBar)
        newsSearchBar.translatesAutoresizingMaskIntoConstraints = false
        newsSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        newsSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        newsSearchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    }
    
    func setNewsTableViewConstraints() {
        view.addSubview(newsTableView)
        newsTableView.translatesAutoresizingMaskIntoConstraints = false
        newsTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        newsTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        newsTableView.topAnchor.constraint(equalTo: newsSearchBar.bottomAnchor, constant: 0).isActive = true
        newsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func setRequestButtonConstraints() {
        view.addSubview(requestButton)
        requestButton.translatesAutoresizingMaskIntoConstraints = false
        requestButton.leftAnchor.constraint(equalTo: newsSearchBar.rightAnchor, constant: 0).isActive = true
        requestButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7).isActive = true
        requestButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.27).isActive = true
    }
}

// MARK: - Table View Methods

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = DetailsViewController()
        destinationVC.article = data[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = data[indexPath.row].title
        let url = URL(string: data[indexPath.row].urlToImage!)
        networkManager.getPoster(from: url!) { image in
            DispatchQueue.main.async {
                cell.posterImageView.image = image
                cell.activityIndicator.stopAnimating()
            }
        }
        return cell
    }
}

// MARK: - Search Bar Methods

extension NewsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            self.queryText = searchText
        }
    }
}
