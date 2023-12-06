//
//  CityView.swift
//  SwiftDataExample
//
//  Created by Uri on 6/12/23.
//

import SwiftUI
import SwiftData

struct CityView: View {
    
    @Environment (\.modelContext) private var context
    @Query var cities: [CityModel]
    
    let country: CountryModel
    
    @State var countryName = ""
    
    // only show cities related to that country
    init(country: CountryModel) {
        let countryId = country.id
        self._cities = Query(filter: #Predicate { $0.country?.id == countryId },
                             sort: \CityModel.name,
                             order: .forward,
                             transaction: Transaction(animation: .easeIn)
        )
        self.country = country
    }
    
    var body: some View {
        VStack {
            Form {
                Section("Country Selected") {
                    HStack {
                        TextField("Country Name", text: $countryName)
                            .autocorrectionDisabled()
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 1)
                        
                        Button(action: {
                            // Update country
                            country.name = countryName
                            
                            do {
                                try context.save()
                            } catch {
                                debugPrint(error)
                            }
                            
                        }, label: {
                            Image(systemName: "tray.and.arrow.down.fill")
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        })
                    }
                }
                Section("Cities") {
                    List{
                        ForEach(cities) { city in
                            VStack(alignment: .leading){
                                Text("\(city.name)")
                            }
                        }.onDelete { indexSet in
                            // Delete Cities
                            guard let index = indexSet.first else { return }
                            let city = cities[index]
                            context.delete(city)
                        }
                    }
                }
            }
            .toolbar {
                Button(action: {
                    let city = CityModel.getRandomCity()
                    city.country = country
                    context.insert(city)
                    /*
                     En caso que autoSave=false, se debe usar así
                     do{
                     try context.save()
                     }catch{
                     print("\(error.localizedDescription)")
                     }
                     */
                    
                }, label: {
                    Image(systemName: "plus.square.fill")
                        .foregroundStyle(.blue)
                })
            }
            .onAppear{
                self.countryName = self.country.name
            }
            .navigationTitle("Cities")
        }
        
    }
}


#Preview {
    let example = CountryModel.getRandomCountry()
    return CityView(country: example)
}
