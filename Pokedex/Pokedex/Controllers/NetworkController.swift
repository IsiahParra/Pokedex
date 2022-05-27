//
//  NetworkController.swift
//  Pokedex
//
//  Created by Isiah Parra on 5/26/22.
//

import Foundation
import UIKit

class NetworkController {
    //MARK: PROPERTIES
    private static let baseURLString = "https://pokeapi.co/api/v2"
    // CRUD
   static func fetchPokemon(searchTerms: String, completion: @escaping (Pokemon?) -> Void) {
        //constructing URL
        guard let baseURL = URL(string: baseURLString) else {completion(nil)
            return
        }
       let searchPokemonURL = baseURL.appendingPathComponent("pokemon/\(searchTerms.lowercased())")
        print(searchPokemonURL)
        
       URLSession.shared.dataTask(with: searchPokemonURL) { taskData, _, error in
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
    static func fetchImage(pokemon: Pokemon, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: pokemon.spritePath ) else {return}
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("There was an error fetching the data the url is \(baseURLString) the error is", error.localizedDescription)
                completion(nil)
            }
            guard let data = data else {return}
            let pokemonImage = UIImage(data: data)
            completion(pokemonImage)
        }.resume()
    }
  
} // end of class


