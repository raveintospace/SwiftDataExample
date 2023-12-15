//
//  ContentView.swift
//  SwiftDataExample
//  https://youtu.be/e0WorWOu2HY?si=Sev_CmqMO5l51xd8
//  Created by Uri on 26/11/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment (\.modelContext) private var context
    @Query(sort: \CountryModel.name, order: .forward) var countries: [CountryModel]
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                CountryListView(search: searchText)
            }
            .navigationTitle("Countries")
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: Text(""))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [CountryModel.self, CityModel.self], inMemory: true)
}

struct CountryListView: View {
    
    @Environment (\.modelContext) private var context
    @Query(sort: \CountryModel.name, order: .forward) var countries: [CountryModel]
    
    // search logic
    init(search: String) {
        if !search.isEmpty {
            self._countries = Query(filter: #Predicate { $0.name.localizedStandardContains(search) })
        } else {
            self._countries = Query()
        }
    }
    
    var body: some View {
        List {
            ForEach(countries) { country in
                NavigationLink(destination: CityView(country: country)) {
                    Text("\(country.code) - \(country.name)")
                }
            }
            .onDelete(perform: { indexSet in
                let countryToDelete = countries[indexSet.first!]
                context.delete(countryToDelete)
            })
        }
        .toolbar {
            Button(action: {
                countries.forEach { country in
                    context.delete(country)
                }
            }, label: {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
            })
            
            Button(action: {
                context.insert(CountryModel.getRandomCountry())
            }, label: {
                Image(systemName: "plus.square.fill")
            })
        }
    }
}
