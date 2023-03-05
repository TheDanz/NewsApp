import UIKit
import Foundation

class NetworkManager {
    
    private let APIKey = "8be4ff77f9294f22a4ab354b89de632c"
    private let session = URLSession.shared
    
    func getArticles(query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        
        guard let url = getURL(query: query) else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil else { return }
            
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
    
    private func getURL(query: String) -> URL? {
        
        guard var urlComponent = URLComponents(string: "https://newsapi.org") else { return nil }
        urlComponent.path = "/v2/everything"
        let queryURLQueryItem = URLQueryItem(name: "q", value: query)
        let languageURLQueryItem = URLQueryItem(name: "language", value: "en")
        let apiKeyURLQueryItem = URLQueryItem(name: "apiKey", value: APIKey)
        urlComponent.queryItems = [queryURLQueryItem, languageURLQueryItem, apiKeyURLQueryItem]
        guard let url = urlComponent.url else { return nil }
        return url
    }
}
