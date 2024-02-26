//
//  Home.swift
//  SwiftUI YouTube Mini Player
//
//  Created by Hamed Majdi on 2/24/24.
//

import SwiftUI

struct Home: View {

    @State private var activeTab: Tab = .home
    @State private var config: PlayerConfig = .init()
    var body: some View {

        ZStack(alignment: .bottom){
            TabView(selection: $activeTab){
                HomeTabView()
                    .setupTab(.home)
                
                Text(Tab.short.rawValue)
                    .setupTab(.short)
                
                Text(Tab.subscrptions.rawValue)
                    .setupTab(.subscrptions)
                
                Text(Tab.you.rawValue)
                    .setupTab(.you)
                
                customTabBar()
            }
            .padding(.bottom, tabBarHeight)


            
            
            // Mini Player View
            GeometryReader{
                let size = $0.size
                if config.showMiniPlayer{
                    MiniPlayerView(size: size, config: $config) {
                        withAnimation(.easeInOut(duration: 0.3), completionCriteria: .logicallyComplete){
                            config.showMiniPlayer = false
                        } completion: {
                            config.resetPosition()
                            config.selectePlayerItem = nil
                        }
                    }
            }
        }
            
            /// now when the mini player expands, let's move out the tab bar from the screen and move in when the mini player is minimised again

            customTabBar()
                .offset(y: config.showMiniPlayer ? tabBarHeight - (config.progress * tabBarHeight) : 0)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    @ViewBuilder
    func HomeTabView() -> some View{
        NavigationStack{
            ScrollView(.vertical){
                LazyVStack(spacing: 15){
                    ForEach(items){ item in
                        PlayerItemCard(item: item){
                            config.selectePlayerItem = item
                            withAnimation(.easeInOut(duration: 0.3)){
                                config.showMiniPlayer = true
                            }
                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("YouTube")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.background, for: .navigationBar)
        }
    }
    
    /// Player Item Card View
    @ViewBuilder
    func PlayerItemCard(item: PlayerItem, onTap: @escaping () -> ()) -> some View{
        VStack(alignment: .leading, spacing: 6, content: {
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipShape(.rect(cornerRadius: 10))
                .contentShape(.rect)
                .onTapGesture(perform: onTap)
            
            HStack(spacing: 4){
                Image(systemName: "person.circle.fill")
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4, content: {
                    Text(item.title)
                        .font(.callout)
                    HStack(spacing: 6){
                        Text(item.author)
                        
                        Text(". 15 Hour Ago")
                        
                    }
                    .font(.caption)
                    .foregroundStyle(.gray)
                })
            }

        })
        .padding(.horizontal)
    }
    
    /// Custom Tab Bar
    @ViewBuilder
    func customTabBar() -> some View{
        HStack(spacing: 0){
            ForEach(Tab.allCases, id: \.rawValue){ tab in
                VStack(spacing: 4){
                    Image(systemName: tab.symbol)
                        .font(.title3)
                    Text(tab.rawValue)
                        .font(.caption2)
                }
                .foregroundStyle(activeTab == tab ? Color.primary : .gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(.rect)
                .onTapGesture(perform: {
                    activeTab = tab
                })
            }
        }
        .frame(height: 49)
        .overlay(alignment: .top){
            Divider()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(height: tabBarHeight)
        .background(.background)
    }
}

extension View{
    @ViewBuilder
    func setupTab(_ tab: Tab) -> some View{
        self.tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
    
    var safeArea: UIEdgeInsets{
        if let safeArea = (UIApplication.shared.connectedScenes
            .first as? UIWindowScene)?.keyWindow?.safeAreaInsets{
            return safeArea
        }
        
        return .zero
    }
    
    var tabBarHeight: CGFloat{
        return safeArea.bottom + 49
    }
}

#Preview {
    ContentView()
}
