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
                .resizable()
                .aspectRatio(163/180, contentMode: .fit)
            footer
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    var footer: some View {
        HStack {
            information
            Spacer()
            Text("\(viewModel.rate)")
                .frame(width: 36, height: 36)
                .font(.system(size: 13))
                .foregroundColor(Color.primarySolid)
                .background(Color.secondaryColor)
                .clipShape(Circle())
        }
        .padding()
        .background(Color.primarySolid)
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
        ItemDetail(viewModel: ItemDetailViewModel())
            .previewLayout(.fixed(width: 163, height: 250))
    }
}
