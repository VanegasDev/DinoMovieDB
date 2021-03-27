//
//  ItemDetail.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/6/21.
//

import SwiftUI
import Kingfisher

enum ItemDetailOptionType {
    case addToMyFavorites
    case removeFromMyFavorites
    case addToMyWatchlist
    case removeFromMyWatchlist
    
    var information: (title: String, iconName: String) {
        switch self {
        case .addToMyFavorites:
            return (R.string.localization.detail_item_add_to_favorites(), "heart")
        case .addToMyWatchlist:
            return (R.string.localization.detail_item_add_to_watchlist(), "eye")
        case .removeFromMyFavorites:
            return (R.string.localization.detail_item_remove_from_favorites(), "heart.slash")
        case .removeFromMyWatchlist:
            return (R.string.localization.detail_item_remove_from_watchlist(), "eye.slash")
        }
    }
}

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
                .fixedSize(horizontal: false, vertical: true)
            footer
        }
        .background(Color(R.color.primarySolid.name))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color(R.color.tmdbShadow.name), radius: 10, x: 0, y: 5)
        .contextMenu {
            ItemDetailOption(type: viewModel.isMarkedAsFavorite ? .removeFromMyFavorites : .addToMyFavorites, action: viewModel.markAsFavorite)
                .disabled(!viewModel.isFavoriteButtonEnabled)
            ItemDetailOption(type: viewModel.isOnWatchlist ? .removeFromMyWatchlist : .addToMyWatchlist, action: viewModel.addToWatchlist)
                .disabled(!viewModel.isWatchlistButtonEnabled)
        }
        .onAppear(perform: viewModel.fetchItemState)
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

struct ItemDetailOption: View {
    let type: ItemDetailOptionType
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 0) {
                Text(type.information.title)
                Image(systemName: type.information.iconName)
            }
        }
    }
}
