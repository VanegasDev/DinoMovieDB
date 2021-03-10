//
//  ItemDetail.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/6/21.
//

import SwiftUI
import Kingfisher

struct ItemDetail: View {
    @ObservedObject private var viewModel: ItemDetailViewModel
    
    init(viewModel: ItemDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            KFImage(viewModel.imageUrl)
                .placeholder {
                    Image(systemName: "film")
                        .resizable()
                        .padding(EdgeInsets(top: 25, leading: 15, bottom: 25, trailing: 15))
                        .foregroundColor(Color(R.color.secondaryColor.name))
                        .aspectRatio(163/180, contentMode: .fit)
                }
                .resizable()
                .aspectRatio(163/180, contentMode: .fit)
            footer
        }
        .background(Color(R.color.primarySolid.name))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color(R.color.tmdbShadow.name), radius: 10, x: 0, y: 5)
    }
    
    var footer: some View {
        HStack {
            information
            Spacer()
            Text("\(viewModel.rate)")
                .frame(width: 36, height: 36)
                .font(.system(size: 13))
                .foregroundColor(Color(R.color.primarySolid.name))
                .background(Color(R.color.secondaryColor.name))
                .clipShape(Circle())
        }
        .padding()
    }
    
    var information: some View {
        VStack(alignment: .leading) {
            Text("\(viewModel.title)")
                .font(.system(size: 17))
                .fontWeight(.bold)
            Text("\(viewModel.releaseDate)")
                .font(.system(size: 13))
        }
        .foregroundColor(.white)
    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetail(viewModel: ItemDetailViewModel(title: "-", releaseDate: "-", rate: "0", imageUrl: nil))
            .previewLayout(.fixed(width: 163, height: 250))
    }
}
