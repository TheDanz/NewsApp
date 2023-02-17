class NewsList: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

class Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let description: String?
}

class Source: Codable {
    let id: String?
    let name: String?
}
