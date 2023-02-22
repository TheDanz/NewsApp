import UIKit
import Foundation

class NetworkManager {
    
    let APIKey = "8be4ff77f9294f22a4ab354b89de632c"
    let session = URLSession.shared
    
    func getArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        
        guard let URL = URL(string: "https://newsapi.org/v2/everything?q=apple&from=2023-02-01&language=en&pageSize=20&apiKey=\(APIKey)") else {
            return
        }
        
        let task = session.dataTask(with: URL) { data, response, error in
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil else {
                return
            }
            
            if let articles = self.parseJSON(dataToDecode: data) {
                DispatchQueue.main.async {
                    completion(.success(articles))
                }
            }
        }
        task.resume()
    }
    
    func getPoster(from url: URL, completion: @escaping (UIImage) -> Void) {
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil else {
                
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            completion(image)
        }
        task.resume()
    }
    
    private func parseJSON(dataToDecode: Data) -> [Article]? {
        let parser = JSONDecoder()
        let newsList = try? parser.decode(NewsList.self, from: dataToDecode)
        let articles = newsList?.articles
        return articles
    }
}
