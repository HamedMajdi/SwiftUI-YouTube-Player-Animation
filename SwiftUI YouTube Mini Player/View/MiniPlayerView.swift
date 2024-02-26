//
//  MiniPlayerView.swift
//  SwiftUI YouTube Mini Player
//
//  Created by Hamed Majdi on 2/26/24.
//

import SwiftUI

struct MiniPlayerView: View {
    var size: CGSize
    @Binding var config: PlayerConfig
    var close: () -> ()
    
    ///Player Configuration
    let miniPlaterHeight: CGFloat = 50
    let playerHeight: CGFloat = 200
    
    var body: some View {
        let progress = config.progress > 0.7 ? (config.progress - 0.7) / 0.3 : 0
        VStack(spacing: 0){
            ZStack(alignment: .top){
                GeometryReader{
                    let size = $0.size
                    let width = size.width - 12
                    let height = size.height
                    
                    videoPlayerView()
                        .frame(
                            width: 120 + (width - (width * progress)),
                            height: height
                        )
                }
                .zIndex(1)
                
                playerMinifieContent()
                    .padding(.leading, 130)
                    .padding(.trailing, 15)
                    .foregroundStyle(Color.primary)
                    .opacity(progress)
            }
            .frame(minHeight: miniPlaterHeight, maxHeight: playerHeight)
            .zIndex(1)
            
            ScrollView(.vertical){
                if let playerItem = config.selectePlayerItem{
                    playerExpandedContent(playerItem)
                }
            }
            .opacity(1.0 - (config.progress * 1.6))
        }
            .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .top)
            .background(.background)
            .clipped()
            .contentShape(.rect)
            .offset(y: config.progress * -tabBarHeight)
            .frame(height: size.height - config.position, alignment: .top)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .gesture(
                DragGesture()
                    .onChanged{ value in
                        let start = value.startLocation.y
                        guard start < playerHeight || start > (size.height - (tabBarHeight + miniPlaterHeight))else {return}
                        let height = value.translation.height
                        config.position = min(height, (size.height-miniPlaterHeight))
                    }
                    .onEnded{ value in
                        
                            let start = value.startLocation.y
                        guard start < playerHeight || start > (size.height - (tabBarHeight + miniPlaterHeight))else {return}
                        
                        let velocity = value.velocity.height * 5
                        withAnimation(.smooth(duration: 0.3)){
                            if (config.position + velocity) > (size.height * 0.65){
                                config.position = size.height - miniPlaterHeight
                                config.lastPosision = config.position
                                config.progress = 1
                            } else {
                                config.resetPosition()
                            }
                            
                        }
                    } .simultaneously(with: TapGesture().onEnded{ _ in //this handles the when the mini player is tapped
                        withAnimation(.smooth(duration: 0.3)){
                            config.resetPosition()
                        }
                    })
            )
            // Sliding in/out
            .transition(.offset(y: config.progress == 1 ? tabBarHeight : size.height))
            .onChange(of: config.selectePlayerItem, initial: false) {oldValue, newValue in
                withAnimation(.smooth(duration: 0.3)){
                    config.resetPosition()
                }
                
            }
    }
    
    ///Video Player View
    @ViewBuilder
    func videoPlayerView() -> some View{
        GeometryReader{
            let size = $0.size
            Rectangle()
                .fill(.black)
            
            if let playerItem = config.selectePlayerItem{
                Image(playerItem.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
            }
        }
    }
    
    ///Player minified Content View
    @ViewBuilder
    func playerMinifieContent() -> some View{
        if let playerItem = config.selectePlayerItem{
            HStack(spacing: 10){
                VStack(alignment: .leading, spacing: 3, content: {
                    Text(playerItem.title)
                        .font(.callout)
                        .textScale(.secondary)
                        .lineLimit(1)
                    
                    Text(playerItem.author)
                        .font(.caption)
                        .foregroundColor(.gray)
                })
                .frame(maxHeight: .infinity)
                .frame(maxHeight: miniPlaterHeight)
                    Spacer(minLength: 0)
                    
                Button(action: {}, label: {
                        Image(systemName: "pause.fill")
                            .font(.title2)
                            .frame(width: 35, height: 35)
                            .contentShape(.rect)
                    })
                    
                    Button(action: close, label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .frame(width: 35, height: 35)
                            .contentShape(.rect)
                    })
                
            }
        }
        
    }
    
    @ViewBuilder
    func playerExpandedContent(_ item: PlayerItem) -> some View{
        VStack(alignment: .leading, spacing: 15, content: {
            Text(item.title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(item.description)
                .font(.callout)
        })
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .padding(.top, 10)
    }
    
    /// The function below truns the drag location into a sequence of progresses ranging from 0 to 1,
    /// so that we can over time move the mini player over the tab bar when is it being dragged down.
    func generateProgress(){
        let progress = max(min(config.position / (size.height - miniPlaterHeight), 1.0), .zero)
        config.progress = progress
    }
    
}

#Preview {
    ContentView()
}

