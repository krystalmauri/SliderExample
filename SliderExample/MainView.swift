//
//  ContentView.swift
//  SliderExample
//
//  Created by Krys Welch on 11/30/22.
//

import SwiftUI

class MainViewModel: ObservableObject{
    
    @Published var movies: [Movie] = []
    @Published var extractedMovies: [Result] = []

    func getMovies(){
        
        let apiKey = "bb062ca1a1471913abf6b680168fc5ca"
        let url = URL(string: "https://api.themoviedb.org/3/trending/all/day?api_key=\(apiKey)")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url){ data, _, error in
            guard let data = data, error == nil else {
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
                    self.extractedMovies = results.results ?? []
                }
                
                
            } catch {
                print("Couldn't decode movie json \(error.localizedDescription)")
            }
            
        }
        
        dataTask.resume()
        
    }
    
}

struct MainView: View {
    @StateObject var vm = MainViewModel()
    
    @State var shouldShowDetailsPage = false
    
    let descriptionText = "This shows a list of the top 20 trending movies for the day. All data is brought in by themoviedb. You can view the details by clicking the item."
    
    
    var body: some View {
        
        NavigationView{
            
            VStack {
                
                info

                GeometryReader{ proxy in
                    TabView{
                        if vm.extractedMovies.indices.contains(0) {
                            
                            ForEach(0..<20){ num in
                                
                                NavigationLink(destination: DetailsView(movie: vm.extractedMovies[num]), label: {
                                    
                                VStack {
                                    
                                        VStack{
                                            var imageUrl = URL(string: "https://image.tmdb.org/t/p/w1066_and_h600_bestv2\(vm.extractedMovies[num].posterPath ?? "Image")")
                                            AsyncImage(url: imageUrl) { image in
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 300, height: 200)
                                            .scaledToFit()
                                            .clipped()
                                    
                                        }

                                    Group{
                                        VStack{
                                            HStack{
                                                if vm.extractedMovies[num].originalName != nil{
                                                    Text("\(vm.extractedMovies[num].originalName  ?? "No Title Found")")
                                                        .font(.title)
                                                        .minimumScaleFactor(0.3)
                                                        .multilineTextAlignment(.leading)
                                                        .lineLimit(2)
                                                }
                                                else{
                                                    Text("\(vm.extractedMovies[num].originalTitle  ?? "No Title Found")")
                                                        .font(.title2)
                                                        .multilineTextAlignment(.leading)
                                                        .lineLimit(2)
                                                        .minimumScaleFactor(0.3)

                                                }
                                                Spacer()
                                            }
                                            Text("\(vm.extractedMovies[num].overview ?? "No overview found")")
                                            
                                            HStack{
                                                Spacer()
                                                Button {
                                                    shouldShowDetailsPage.toggle()
                                                } label: {
                                                    Text("See more")
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                        .lineLimit(nil)
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .minimumScaleFactor(0.8)
                                        .multilineTextAlignment(.leading)
                                        
                                    }
                                    
                                    .frame(width: 300, height: 150)
                                    .background(Rectangle().fill(Color("Grey")).shadow(radius: 1))
                                } })
                            }
                                               
                        }
                    }.tabViewStyle(PageTabViewStyle())
                        .padding()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .foregroundColor(.black)
                        .onAppear {
                            setupAppearance()
                        }
                }
                linkToSite
            }
            .padding()
            .onAppear{
                vm.getMovies()
            }
            
        }
    }
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    private var linkToSite: some View{
        Link(destination: URL(string: "https://www.krystalmauri.com")!) {
            VStack {
                Image(systemName: "network")
                    .font(.largeTitle)
                Text("Why Not?")
            }
            .foregroundColor(.black)
        }
    }
    private var info: some View{
        VStack{
            Text("Trending Movies")
                .font(.title)
            Divider()
            VStack{
                Text("\(descriptionText)")
                    .multilineTextAlignment(.center)
                
            }
            
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
