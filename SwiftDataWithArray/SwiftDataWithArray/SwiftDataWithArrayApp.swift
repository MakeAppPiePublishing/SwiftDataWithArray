//
//  SwiftDataWithArrayApp.swift
//  SwiftDataWithArray
//
//  Created by Steven Lipton on 9/26/23.
//

import SwiftUI
import SwiftData
@main
struct SwiftDataWithArrayApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Notice the lack of the submodel. you dont declare it here. 
        .modelContainer(for: [ModelA.self, SubModel.self])
    }
}
