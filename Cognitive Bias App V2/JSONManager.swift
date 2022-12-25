//
//  JSONManager.swift
//  JSONTesting
//
//  Created by user230876 on 12/22/22.
//

import Foundation



struct BiasData: Codable {
    var biases: [Biase]
    static let allBias: BiasData = Bundle.main.decode(file: "sample2.json")
}

struct Biase: Codable {
    var id: Int
    var name: String
    var related, tags: [String]
    var quote, description, question, overcome: String
    var resource: String
    var example: String
    var isFaved: Bool? = false
    
    
    //I created this to set isFaved to false
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.related = try container.decode([String].self, forKey: .related)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.quote = try container.decode(String.self, forKey: .quote)
        self.description = try container.decode(String.self, forKey: .description)
        self.question = try container.decode(String.self, forKey: .question)
        self.overcome = try container.decode(String.self, forKey: .overcome)
        self.resource = try container.decode(String.self, forKey: .resource)
        self.example = try container.decode(String.self, forKey: .example)
        self.isFaved = false
    }
}

/*
struct BiasData: Codable {
    var fruit, size, color: String
    
    static let allBias: BiasData = Bundle.main.decode(file: "sample2.json")
}*/

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        do{
            let loadedData = try decoder.decode(T.self, from: data)
            return loadedData
        }catch{
            print("This is the error: \(error)")
            fatalError("This is a fatal error")
        }
    }
}
