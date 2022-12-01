//
//  Model.swift
//  SliderExample
//
//  Created by Krys Welch on 11/30/22.
//

import Foundation

// MARK: - Movie
struct Movie: Codable {

    let page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Result: Codable, Identifiable {
    let adult: Bool?
    let backdropPath: String?
    let id: Int?
    let title: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview, posterPath: String?
    let mediaType: MediaType
    let genreIDS: [Int]
    let popularity: Double?
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let name, originalName, firstAirDate: String?
    let originCountry: [String]?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}

/*
class movieAPI: ObservableObject{
    
    @Published var movies: [Movie] = []
    @Published var extractedMovies: [Result] = []

    let apiKey = "bb062ca1a1471913abf6b680168fc5ca"

   /*
    func getMovies(onCompletion: @escaping ([Result]) -> ()){
        
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/all/day?api_key=\(apiKey)") else{
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
             
            do {
                let results = try JSONDecoder().decode(Movie.self, from: data)
                
                /*
                for result in results.results ?? [] {
                    DispatchQueue.main.async {
                        self?.extractedMovies.append(result)
                        print("extracted \(self?.extractedMovies)")
                    }
                }
                */
                
                
                results.results?.forEach{ response in
                    DispatchQueue.main.async {
                        self?.extractedMovies.append(response)
                    }
                    
                }
                print("extracted \(self?.extractedMovies)")
                
                onCompletion(self?.extractedMovies ?? [])
            }
            catch {
                print("Couldn't decode movie json \(error.localizedDescription)")
            }
        }
        dataTask.resume()
        }
    
    */
    func getMovies(onCompletion: @escaping ([Result]) -> ()){
        
        let url = URL(string: "https://api.themoviedb.org/3/trending/all/day?api_key=\(apiKey)")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler: { (data1, response1, error1) -> Void in
            
            guard let data = data1 else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Movie.self, from: data)
                
                for result in results.results ?? [] {
                    print(result.originalName)
                }
                
                DispatchQueue.main.async {
                    let tmp = results.results
                    print("movie model \(tmp)")
                    self.extractedMovies = tmp ?? []
                }
                
                onCompletion(self.extractedMovies)
                
            } catch {
                print("Couldn't decode movie json \(error.localizedDescription)")
            }
            
        })
        
        dataTask.resume()
        
    }
   
}
*/
