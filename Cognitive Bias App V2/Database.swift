//
//  Database.swift
//  Cognitive Bias App V2
//
//  Created by user230876 on 12/25/22.
//

import Foundation


final class Database {
    private let FAV_KEY = "fav_key"
    
    func save(items: Set<Int>) {
        let array = Array(items)
        UserDefaults.standard.set(array, forKey: FAV_KEY)
    }
    
    func load() -> Set<Int> {
        let array = UserDefaults.standard.array(forKey: FAV_KEY) as? [Int] ?? [Int]()
        return Set(array)
        
    }
}

final class RecentDatabase {
    private let REC_KEY = "rec_key"
    
    func save(items: [Int]) {
        let array = Array(items)
        UserDefaults.standard.set(array, forKey: REC_KEY)
    }
    
    func load() -> [Int] {
        let array = UserDefaults.standard.array(forKey: REC_KEY) as? [Int] ?? [Int]()
        return array
        
    }
}
