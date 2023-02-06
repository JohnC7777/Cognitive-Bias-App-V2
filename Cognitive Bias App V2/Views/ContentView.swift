//
//  ContentView.swift
//  Cognitive Bias App V2
//
//  Created by user230876 on 12/23/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm : ViewModel //This is a global class (Because of @EnvironmentObject) so we can manipulate this data and it will be updated in the other views as well. The @StateObject is located in the @main struct of the app
    @State private var BiasStruct: BiasData = BiasData.allBias
    @State var searchText = ""
    @State var filterSearchText = ""
    @State var isListStyle = true
    @State var selected = 1 //By default this is set to all Biases
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum:150))
    ]
    
    var body: some View {
        
        VStack{
            NavigationStack{
                HStack{
                    Picker("Hello", selection: $selected, content: {
                        Text("All Biases").tag(1)
                        Text("Favorites").tag(2)
                        Text("Recents").tag(3)
                    })
                    .onChange(of: selected) { tag in //When selected is changed, sort the Favs list and reset search text
                        vm.sortFavs()
                        searchText = ""
                        filterSearchText = ""
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Picker("View Style", selection: $isListStyle, content: {
                        Image(systemName: "list.dash").tag(true)
                            .foregroundColor(.black)
                        Image(systemName: "photo.stack").tag(false)
                            .foregroundColor(.black)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: 100)
                }
                ScrollView{
                    LazyVGrid(columns: isListStyle ? [GridItem(.adaptive(minimum: .infinity))] : adaptiveColumn, spacing: 10){
                        ForEach((selected == 1) ? (searchText == "" ? BiasStruct.biases : BiasStruct.biases.filter({
                            $0.name.lowercased().contains(searchText.lowercased())
                        })) : (filterSearchText == "" ? vm.filteredItems : vm.filteredItems.filter({
                            $0.name.lowercased().contains(filterSearchText.lowercased())
                        })), id: \.self){ entry in
                            NavigationLink(value: entry){
                                HStack{
                                    VStack{
                                        if !isListStyle{
                                            Image(systemName: "questionmark")
                                                .foregroundColor(.black)
                                                .frame(width: 150, height: 100)
                                                .background(.blue)
                                        }
                                        Text("\(entry.name)")
                                            .foregroundColor(.black)
                                            .font(isListStyle ? .headline : .subheadline)
                                    }
                                    if isListStyle {
                                        Image(systemName: vm.contains(entry) ? "heart.fill" : "heart")
                                        
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                                            .foregroundColor(.black)
                                            .onTapGesture {
                                                vm.toggleFav(item: entry)
                                            }
                                    }
                                }
                                .padding()
                                .background(Color(uiColor: .systemGray5))
                                .cornerRadius(15)
                            }
                            
                        }
                        .cornerRadius(15)
                    }
                }
                .navigationTitle("Biases")
                //.navigationBarTitleDisplayMode(.inline)
                /*toolbar { // <2>
                    ToolbarItem(placement: .principal) { // <3>
                        HStack {
                            Text("Biases")
                                .font(.title)
                                .fontWeight(.bold)
                            Image(systemName: isListStyle ? "photo.stack" : "list.dash")
                                .onTapGesture {
                                    isListStyle.toggle()
                                }
                        }
                    }
                }*/
                .searchable(text: $searchText)
                .navigationDestination(for: Biase.self){ bias in
                    DetailView(bias: bias)
                }
                
            }
            .padding(8)
        }
    }
}


//StackOverflow said I needed to add this to have the onChange work for what I was using it for.
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}



    /*
     NavigationLink(destination: DetailView( thisBiase: $BiasStruct.biases[entry.id-1]), label: {
     Text("\(entry.name)")
     Image(systemName: vm.contains(entry) ? "heart.fill" : "heart")
     .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
     .onTapGesture {
     vm.toggleFav(item: entry)
     }
     
     })*/
