//
//  Content-ViewModel.swift
//  Cognitive Bias App V2
//
//  Created by user230876 on 12/25/22.
//

import Foundation
import SwiftUI

@MainActor final class ViewModel: ObservableObject{
    @Published var items = [Biase]()
    @Published var showingFavs = false
    @Published var savedItems: Set<Int> = [1, 7]
    
    // Filter saved items
    var filteredItems: [Biase]  {
        if showingFavs {
            return items.filter { savedItems.contains($0.id) }
        }
        return items
    }
    
    private var BiasStruct: BiasData = BiasData.allBias
    private var db = Database()
    
    init() {
        self.savedItems = db.load()
        self.items = BiasStruct.biases
    }
    
    func sortFavs(){
        withAnimation() {
            showingFavs.toggle()
        }
    }
    
    func contains(_ item: Biase) -> Bool {
        savedItems.contains(item.id)
    }
    
    // Toggle saved items
    func toggleFav(item: Biase) {
        if contains(item) {
            savedItems.remove(item.id)
        } else {
            savedItems.insert(item.id)
        }
        db.save(items: savedItems)
    }
}
