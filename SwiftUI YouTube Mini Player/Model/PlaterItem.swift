//
//  PlaterItem.swift
//  SwiftUI YouTube Mini Player
//
//  Created by Hamed Majdi on 2/24/24.
//

import SwiftUI

let dummyDescription: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."

struct PlayerItem: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var author: String
    var image: String
    var description: String = dummyDescription
}

var items: [PlayerItem] = [
    .init(title: "Apple Vision Pro - Unboxing, Review and demos!", author: "MKBHD", image: "pic1"),
    .init(title: "What is the Real Experience of Vision Pro", author: "CNBNews", image: "pic2"),
    .init(title: "First Impressions on Samsung Galaxy S24 Ultra!", author: "MKBHD", image: "pic3"),
    .init(title: "The Best Android Phone of 2024", author: "GSMArena", image: "pic4"),
    .init(title: "2023 - Winners and Losers of Foldables", author: "Mark Gurman", image: "pic5"),
]
