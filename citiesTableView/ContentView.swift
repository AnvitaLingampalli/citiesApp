//
//  ContentView.swift
//  citiesTableView
//
//  Created by Anvita Lingampalli on 3/4/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var cityModel = cityViewModel()
    @State var toInsertView = false
    @State var cityName = String()
    @State var cityDescription = String()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(cityModel.data, id: \.id) { city in
                    NavigationLink(destination: DetailView(lat: 0.0, lon: 0.0, city: city.name, cityDescription: city.des, image: city.image, cModel: cityModel)) {
                         HStack{
                             Image(city.image)
                                 .resizable()
                                 .scaledToFit()
                                 .frame(height:50)
                                 .cornerRadius(20)
                             VStack (alignment: .leading, spacing: 5){
                                 
                                 Text(city.name)
                                     .fontWeight(.semibold)
                                     .minimumScaleFactor(0.5)
                             }
                         }
                     }
                }.onDelete(perform: {IndexSet in
                    cityModel.data.remove(atOffsets: IndexSet)
                })
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Cities")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        toInsertView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }.alert("Insert", isPresented: $toInsertView, actions: {
                
                TextField("City", text: $cityName)
                TextField("Description", text: $cityDescription)

                Button("Insert", action: {
                    let c = City(name: cityName, image: "default", des: cityDescription)
                    cityModel.add(city: c)
                })
                Button("Cancel", role: .cancel, action: {
                    toInsertView = false
                })
            }, message: {
                Text("Please Enter City to Insert")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
