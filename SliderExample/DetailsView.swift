//
//  DetailsView.swift
//  SliderExample
//
//  Created by Krys Welch on 11/30/22.
//

import SwiftUI
import UIKit

struct DetailsView: View {
    
    @State var shouldShowHomePage = false
    
    var body: some View {
        VStack {
            VStack {
                
                HStack{
                Button(action: {
                    shouldShowHomePage.toggle()
                   
                }) {
                    Label("Go Back", systemImage: "arrow.backward")
                    
                }
                .foregroundColor(.black)
                .padding()
                    Spacer()
            }
                
                //backdropPath
                    var imageUrl = URL(string: "https://image.tmdb.org/t/p/w1066_and_h600_bestv2/akYTfFvYkFGJReFxXM841NidlAa.jpg")
                    AsyncImage(url: imageUrl) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                
                
            }
            .padding(.top, 44)
            .frame(maxWidth: .infinity, maxHeight: 300, alignment: .top)
            .clipped()
        
            .mask {
                Rectangle()
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text("originalName")
                        .font(.system(size: 29, weight: .semibold, design: .default))
                    Spacer()
                    HStack(alignment: .firstTextBaseline, spacing: 3) {
                        Image(systemName: "star")
                            .foregroundColor(.orange)
                        Text("voteAverage")
                    }
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                }
                Text("originalLanguage ")
                    .font(.system(size: 15, weight: .light, design: .default))
                Text("overview")
                    .font(.system(size: 14, weight: .regular, design: .serif))
                    .padding(.top, 4)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            HStack() {
                Text("releaseDate")
                    .kerning(2.0)
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .foregroundColor(.secondary)
                    .padding(.vertical)
                Spacer()
            }
         
            .padding(24)
            .foregroundColor(.orange)
            Spacer()
            Spacer()
        }
        .frame(width: 390, height: 844)
        .clipped()
        .background(Color(.systemBackground))
        .mask { RoundedRectangle(cornerRadius: 43, style: .continuous) }
        .fullScreenCover(isPresented: $shouldShowHomePage, onDismiss: nil){
            MainView()
        }
    }
        
}


struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}
