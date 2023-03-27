//
//  News.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.02.2022.
//

import Foundation
import UIKit

protocol TopHeadline {
    var author: String? { get }
    var title: String { get }
    var description: String? { get }
    var imageUrl: String? { get }
}

struct Source: Codable {
    let id: String?
    let name: String
}

struct Article: Codable, TopHeadline, Equatable, Hashable, Identifiable {
    
    var source: Source
    var author: String?
    var title: String
    var description: String?
    var url: String?
    var imageUrl: String?
    var publishedAt: String?
    var content: String?
    
    var id: String {
        title
    }
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, publishedAt, content
        case imageUrl = "urlToImage"
    }
    
    init(author: String, title: String, description: String) {
        self.source = Source(id: "1", name: "")
        self.author = author
        self.title = title
        self.description = description
        self.url = ""
        self.imageUrl = ""
        self.publishedAt = ""
        self.content = ""
    }
    
    var urlToImage: URL? {
        guard let url = imageUrl else { return URL(string: "")}
        return URL(string: url)
    }
    
    // appareantly source is not a unique key for every article, hence we will consider the title of the article as being part of source.name
    var mockedSourceName: String {
        return source.name+"#"+title
    }
    
    init() {
        source = Source(id: nil, name: "")
        self.title = ""
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.source.id == rhs.source.id &&
        lhs.author == rhs.author &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.url == rhs.url &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.publishedAt == rhs.publishedAt &&
        lhs.content == rhs.content
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    var longDescription: String {
        guard let description else {
            return "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
        }
        
        var desc = description
        for i in 0..<5 {
            desc += "\n" + description
        }
        return desc
    }
}

struct News: Codable {
    let totalResults: Int
    let articles: [Article]
}

struct NewsErrorResponse: Codable {
    let code: String
    let message: String
}
