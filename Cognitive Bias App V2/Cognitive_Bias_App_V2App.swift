//
//  Cognitive_Bias_App_V2App.swift
//  Cognitive Bias App V2
//
//  Created by user230876 on 12/23/22.
//



import SwiftUI



@main
struct Cognitive_Bias_App_V2App: App {
  // register app delegate for Firebase setup
    @StateObject var viewModel = FavoriteViewModel()
    @StateObject var viewModel1 = RecentViewModel()

  var body: some Scene {
    WindowGroup {
          ContentView()
              .environmentObject(viewModel)
              .environmentObject(viewModel1)
    }
  }
}
