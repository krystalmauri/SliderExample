//
//  ContentView.swift
//  SliderExample
//
//  Created by Krys Welch on 11/30/22.
//

import SwiftUI

class MainViewModel: ObservableObject{
    
    @Published var movieList = [Movie]()

    
    init() {
        movieAPI().getMovies(onCompletion: { (fetchedCity: Movie) in
            DispatchQueue.main.async {
                self.movieList = [fetchedCity]
                
            }
        })
    }
    
    

}

struct MainView: View {
    @ObservedObject private var vm = MainViewModel()

    @State var shouldShowDetailsPage = false
    
    let descriptionText = "This shows a list of the top 20 trending movies for the day. All data is brought in by themoviedb. You can view the details by clicking on either the image or `See more`."

    
    var body: some View {
        VStack {
            
            Text("Trending Movies")
                .font(.title)
            Divider()
            VStack{
                Text("\(descriptionText)")
                    .multilineTextAlignment(.center)
                Text("Estimated Completion Date: 11.30.2022")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
            }
            GeometryReader{ proxy in
                TabView{
                    
                    ForEach(0..<20){ num in
                        if vm.movieList.indices.contains(0) {
                            VStack {
                                Button(action: {
                                    shouldShowDetailsPage.toggle()
                                }) {
                                    VStack{
                                        var imageUrl = URL(string: "https://image.tmdb.org/t/p/w1066_and_h600_bestv2\(vm.movieList[0].results?[num].posterPath ?? "Image")")
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
 
                                
                            }
                                Group{
                                    VStack{
                                        HStack{
                                            if vm.movieList[0].results?[num].originalTitle != nil{
                                                Text("\(vm.movieList[0].results?[num].originalTitle ?? "No Title Found")")
                                                    .font(.title)
                                                    .minimumScaleFactor(0.5)
                                                    .multilineTextAlignment(.leading)
                                                    .lineLimit(2)
                                            }
                                            else{
                                                Text("\(vm.movieList[0].results?[num].originalName ?? "No Title Found")")
                                                    .font(.title)
                                                    .multilineTextAlignment(.leading)
                                                
                                            }
                                            Spacer()
                                        }
                                        
                                        Text("\(vm.movieList[0].results?[num].overview ?? "No overview found")")
                                        
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
                                    
                                    .multilineTextAlignment(.leading)
                                    .padding()
                                    
                                }
                                
                                .frame(width: 300, height: 200)
                                .background(Rectangle().fill(Color("Grey")).shadow(radius: 1))
                            }
                        }
                    }
                    
                }.tabViewStyle(PageTabViewStyle())
                    .padding()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                
                
            }
            //  Decided not to use this but did want you to know I was aware of the lifecycle
            .onAppear {
                /*
                movieAPI().getMovies(onCompletion: { (fetchedCity: Movie) in
                    DispatchQueue.main.async {
                        self.movieList = [fetchedCity]
                        
                    }
                })
                
                */
            }
            Link(destination: URL(string: "https://www.krystalmauri.com")!) {
                VStack {
                    Image(systemName: "network")
                        .font(.largeTitle)
                    Text("Why Not?")
                }
                .foregroundColor(.black)
            }
        }
        .padding()
        .fullScreenCover(isPresented: $shouldShowDetailsPage, onDismiss: nil){
            DetailsView()
        }
       
}
   
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
