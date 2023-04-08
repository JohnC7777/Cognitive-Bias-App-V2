//
//  Recent-ViewModel.swift
//  Cognitive Bias App V2
//
//  Created by user230876 on 3/2/23.
//

import Foundation
import SwiftUI

@MainActor final class RecentViewModel: ObservableObject{
    @Published var items = [Biase]()
    @Published var showingFavs = false
    @Published var savedItems: [Int] = [1, 7]
    
    // Filter saved items
    var filteredItems: [Biase]  {
        if showingFavs {
            return items.filter { savedItems.contains($0.id) }.sorted { savedItems.firstIndex(of: $0.id)! < savedItems.firstIndex(of: $1.id)! }
        }
        return items
        
    }
    
    private var BiasStruct: BiasData = BiasData.allBias
    private var db = RecentDatabase()
    
    init() {
        self.savedItems = db.load()
        self.items = BiasStruct.biases
    }
    
    func sortFavs(){
        withAnimation() {
            //showingFavs.toggle()
        }
    }
    
    func contains(_ item: Biase) -> Bool {
        savedItems.contains(item.id)
    }
    
    // Toggle saved items
    func addItem(item: Biase) {
        print("Attemping to add item : \(item.id)")
        if contains(item) {
            savedItems = savedItems.filter { $0 != item.id }
            savedItems.insert(item.id, at:0)
        } else {
            savedItems.insert(item.id, at: 0)
            if savedItems.count > 15 {
                savedItems.removeLast()
            }
        }
        db.save(items: savedItems)
        print("The array is : \(savedItems)")
        print("And the filtered list is : \(filteredItems)")
    }
}
