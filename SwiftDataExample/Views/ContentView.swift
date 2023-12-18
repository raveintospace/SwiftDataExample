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
    
    @State private var searchText: String = ""
    
    @State private var filteredBy = SortDescriptor(\CountryModel.name, order: .forward)
    
    var body: some View {
        NavigationView {
            VStack {
                CountryListView(search: searchText, sort: filteredBy)
            }
            .navigationTitle("Countries")
            .toolbar {
                deleteButton
                addCountryButton
                sortMenu
            }
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
    
    private var sort: SortDescriptor<CountryModel>
    
    // search logic
    init(search: String, sort: SortDescriptor<CountryModel>) {
        if !search.isEmpty {
            self._countries = Query(filter: #Predicate { $0.name.localizedStandardContains(search) },
                                    sort: [sort],
                                    transaction: Transaction(animation: .easeIn))
        } else {
            self._countries = Query(sort: [sort],
                                    transaction: Transaction(animation: .easeIn))
        }
        
        self.sort = sort
    }
    
    var body: some View {
        List {
            ForEach(countries) { country in
                NavigationLink(destination: CityView(country: country)) {
                    VStack(alignment: .leading) {
                        Text("\(country.code) - \(country.name)")
                        Text("Date: \(country.date, format: .dateTime.month().year().day().hour().minute().second())")
                            .foregroundColor(.gray)
                    }
                }
            }
            .onDelete(perform: { indexSet in
                let countryToDelete = countries[indexSet.first!]
                context.delete(countryToDelete)
            })
        }
    }
}

extension ContentView {
    
    private var deleteButton: some View {
        Button(action: {
            countries.forEach { country in
                context.delete(country)
            }
        }, label: {
            Image(systemName: "trash.fill")
                .foregroundColor(.red)
        })
    }
    
    private var addCountryButton: some View {
        Button(action: {
            context.insert(CountryModel.getRandomCountry())
        }, label: {
            Image(systemName: "plus.square.fill")
        })
    }
    
    private var sortMenu: some View {
        Menu("Sort", systemImage: "slider.horizontal.3") {
            Picker("Sort", selection: $filteredBy) {
                Text("Name").tag(SortDescriptor(\CountryModel.name))
                Text("Code").tag(SortDescriptor(\CountryModel.code))
                Text("Date").tag(SortDescriptor(\CountryModel.date))
            }
        }
    }
}
