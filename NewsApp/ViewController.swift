import UIKit

class ViewController: UIViewController {
    
    let cellIdentifier = "NewsTableViewCell"
    var data: [Article] = []
    let networkManager = NetworkManager()
    
    var newsTableView = UITableView()
    var newsRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        view.addSubview(newsTableView)
        
        let xibCell = UINib(nibName: cellIdentifier, bundle: nil)
        newsTableView.register(xibCell, forCellReuseIdentifier: cellIdentifier)
        
        newsRefreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        newsTableView.refreshControl = self.newsRefreshControl

        networkManager.getArticles { result in
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        newsTableView.frame = view.bounds
    }
    
    @objc
    func refreshData(sender: UIRefreshControl) {
        networkManager.getArticles { result in
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
        self.newsRefreshControl.endRefreshing()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = DetailsViewController()
        destinationVC.article = data[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = data[indexPath.row].title
        let url = URL(string: data[indexPath.row].urlToImage!)
        networkManager.getPoster(from: url!) { image in
            DispatchQueue.main.async {
                cell.posterImageView.image = image
            }
        }
        return cell
    }
}
