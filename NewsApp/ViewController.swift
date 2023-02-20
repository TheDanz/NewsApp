import UIKit

class ViewController: UIViewController {
    
    let cellIdentifier = "NewsTableViewCell"
    var data: [Article] = []
    let apiCaller = APICaller()
    
    var newsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        view.addSubview(newsTableView)
        
        let xibCell = UINib(nibName: cellIdentifier, bundle: nil)
        newsTableView.register(xibCell, forCellReuseIdentifier: cellIdentifier)
        
        apiCaller.dataRequest { articles in
            self.data = articles
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        newsTableView.frame = view.bounds
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = data[indexPath.row].title
        let url = URL(string: data[indexPath.row].urlToImage!)
        apiCaller.getPoster(from: url!) { image in
            DispatchQueue.main.async {
                cell.posterImageView.image = image
            }
        }
        return cell
    }
}
