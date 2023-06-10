//
//  cityViewModel.swift
//  citiesTableView
//
//  Created by Anvita Lingampalli on 3/4/23.
//

import Foundation

struct City: Identifiable{
    var id = UUID()
    var name = String()
    var image = String()
    var des = String()
}

public class cityViewModel:ObservableObject
{
    @Published var data = [City(name:"Phoenix", image:"phoenix", des: "Phoenix is the capital and most populous city of the U.S. state of Arizona"),
                           City(name:"London",image:"london",  des: "London, city, capital of the United Kingdom. It is among the oldest of the world's great cities"),
                           City(name:"Dubai",image:"dubai",  des: "Dubai is a city and emirate in the United Arab Emirates known for luxury shopping, ultramodern architecture and a lively nightlife scene"),
                           City(name:"Paris",image:"paris",  des: "Paris is the capital and most populous city of France"),
                           City(name:"Tokyo",image:"tokyo",  des: "Tokyo officially the Tokyo Metropolis, is the capital and most populous city of Japan. ")]
    
    
    var count:Int{
        data.count
    }
    
    func getCity(at index: Int) -> City {
        return data[index]
    }
    
    func add(city: City) {
        data.append(city)
    }
    
    func removeCity(at index: Int) {
       data.remove(at: index)
    }
    
    func findCity(city: String) -> Int{
        var loc:Int = 0
        print(city)
        for c in data
        {
            if c.name == city
            {
                break;
              
            }
            loc = loc + 1
        }
        return loc
    }
}
