//
//  APICALLER.swift
//  NewsApp
//
//  Created by Lalu Iman Abdullah on 14/03/24.
//

import Foundation

final class APICALLER{
    static let shared = APICALLER()
    
    struct Constans {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=b3d827442cc0480185e0da89bf8a7b28")
        static let searchURLString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=b3d827442cc0480185e0da89bf8a7b28&q="
    }
    
    private init() {}
    
    
    public func getTopStroies(compeletion: @escaping (Result<[Article], Error>)-> Void){
        guard let url = Constans.topHeadlinesURL else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                compeletion(.failure(error))
            }
            else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    compeletion(.success(result.articles))
                }
                catch{
                    compeletion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    public func search(with query: String ,compeletion: @escaping (Result<[Article], Error>)-> Void){
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        let urlString = Constans.searchURLString + query
        guard let url = URL(string: urlString) else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                compeletion(.failure(error))
            }
            else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    compeletion(.success(result.articles))
                }
                catch{
                    compeletion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

// modelnya

struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable{
    let name: String
}
