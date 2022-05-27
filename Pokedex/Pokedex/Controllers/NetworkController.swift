//
//  NetworkController.swift
//  Pokedex
//
//  Created by Isiah Parra on 5/26/22.
//

import Foundation

class NetworkController {
    //MARK: PROPERTIES
    private static let baseURLString = "https://pokeapi.co/api/v2"
    // CRUD
   static func fetchPokemon(searchTerms: String, completion: @escaping (Pokemon?) -> Void) {
        //constructing URL
        guard let baseURL = URL(string: baseURLString) else {completion(nil)
            return
        }
       let searchPokeonURL = baseURL.appendingPathComponent("pokemon/\(searchTerms.lowercased())")
        print(searchPokeonURL)
        
       URLSession.shared.dataTask(with: baseURL) { taskData, _, error in
           if let error = error {
               print("There was an error fetching the data. the url is \(baseURL) the error is", error.localizedDescription)
               completion(nil)
           }
           guard let pokemonData = taskData else {completion(nil);
               return
           }
           do {
               if let topLevelDictionary = try JSONSerialization.jsonObject(with: pokemonData, options: .fragmentsAllowed) as? [String:Any] {
                let pokemon = Pokemon(dictionary: topLevelDictionary)
                   completion(pokemon)
               }
           }catch {
               print("Encpuntered error when decoding the data", error.localizedDescription)
               completion(nil)
           }

       }.resume()
    }
}


