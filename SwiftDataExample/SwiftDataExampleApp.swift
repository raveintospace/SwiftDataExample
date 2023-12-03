//
//  SwiftDataExampleApp.swift
//  SwiftDataExample
//  https://youtu.be/KSsF6e9-8dc?si=vK3BVPkZ7sVCfJ6c - lesson 2, custom model containers & sql
//  Created by Uri on 26/11/23.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataExampleApp: App {
    
    // custom model container
    let container: ModelContainer = {
        let container: ModelContainer!
        
        let config = ModelConfiguration(url: URL.documentsDirectory.appending(path: "CustomCountryModel.store"))
        
        do {
            container = try ModelContainer(for: CountryModel.self, configurations: config)
        } catch {
            fatalError("Error creating custom model container")
        }
        return container
    }()
    
    // custom model container with schema
    let containerWithSchema: ModelContainer  = {
        let container: ModelContainer!
        
        let schema = Schema([CountryModel.self])
        
        let config = ModelConfiguration("CountryModelSchema",
                                        schema: schema,
                                        isStoredInMemoryOnly: false,
                                        allowsSave: true)
        
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Error creating custom model container")
        }
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //.modelContainer(for: CountryModel.self) // lesson 1
        .modelContainer(containerWithSchema)
    }
    
    // database location
    init() {
        /* /Users/oriolangelet/Library/Developer/CoreSimulator/Devices/2622A403-A222-454D-8217-C08DD4F363C1/data/Containers/Data/Application/208FA77C-8FD8-46C9-9428-F90F1826C681/Library/Application Support/
         */
        // debugPrint(URL.applicationSupportDirectory.path(percentEncoded: false)) // -> default
        
        /*
         /Users/oriolangelet/Library/Developer/CoreSimulator/Devices/2622A403-A222-454D-8217-C08DD4F363C1/data/Containers/Data/Application/66141691-2A83-4635-BF59-9BD63E64D941/Documents/
         */
        // debugPrint(URL.documentsDirectory.path(percentEncoded: false)) // -> custom
        
        /*
         /Users/oriolangelet/Library/Developer/CoreSimulator/Devices/2622A403-A222-454D-8217-C08DD4F363C1/data/Containers/Data/Application/B2EB5970-5C1A-49FB-A9C8-B9A4054C9738/Library/Application Support/
         */
        debugPrint(URL.applicationSupportDirectory.path(percentEncoded: false)) // -> schema
    }
}
