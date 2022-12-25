//
//  ContentView.swift
//  Cognitive Bias App V2
//
//  Created by user230876 on 12/23/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ViewModel()
    @State private var BiasStruct: BiasData = BiasData.allBias
    @State var searchText = ""
    @State var filterSearchText = ""
    
    @State var selected = 1
    
    var body: some View {
        
        NavigationView{
            VStack{
                Picker("Hello", selection: $selected, content: {
                    Text("All Biases").tag(1)
                    Text("Favorites").tag(2)
                })
                .onChange(of: selected) { tag in
                    vm.sortFavs()
                    searchText = ""
                    filterSearchText = ""
                }
                .pickerStyle(SegmentedPickerStyle())
                
                
                if (selected == 1){
                    
                    List{
                        
                        ForEach(searchText == "" ? BiasStruct.biases : BiasStruct.biases.filter({
                            $0.name.lowercased().contains(searchText.lowercased())
                        }), id: \.id){ entry in
                            HStack{
                                NavigationLink(destination: DetailView( thisBiase: $BiasStruct.biases[entry.id-1]), label: {
                                    Text("\(entry.name)")
                                    Image(systemName: vm.contains(entry) ? "heart.fill" : "heart")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                                        .onTapGesture {
                                            vm.toggleFav(item: entry)
                                        }
                                })
                                
                                //Circle() //Image placeholder
                                
                            }
                            
                        }
                    }
                    .searchable(text: $searchText)
                    .navigationTitle("Biases")
                }else if (selected == 2){
                    List{
                        
                        ForEach(filterSearchText == "" ? vm.filteredItems : vm.filteredItems.filter({
                            $0.name.lowercased().contains(filterSearchText.lowercased())
                        }), id: \.id){ entry in
                            HStack{
                                NavigationLink(destination: DetailView( thisBiase: $BiasStruct.biases[entry.id-1]), label: {
                                    Text("\(entry.name)")
                                    Image(systemName: vm.contains(entry) ? "heart.fill" : "heart")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                                        .onTapGesture {
                                            vm.toggleFav(item: entry)
                                        }
                                })
                                
                                //Circle() //Image placeholder
                                
                            }
                            
                        }
                    }
                    .searchable(text: $filterSearchText)
                    .navigationTitle("Favorites")
                }
                
            }
        }
        .padding()
    }
}

struct DetailView: View {
    //private var BiasStruct: BiasData = BiasData.allBias
    @Binding var thisBiase: Biase
    
    var body: some View {
        
        List{
            Section(header: Text("Description")) {
                Text("\(thisBiase.description)")
            }
            Section(header: Text("Thought Provoking Question")) {
                Text("\(thisBiase.question)")
            }
            Section(header: Text("How to Overcome")) {
                Text("\(thisBiase.overcome)")
            }
            Section(header: Text("Related Quote")) {
                Text("\(thisBiase.quote)")
            }
            Section(header: Text("Example")) {
                Text("\(thisBiase.example)")
            }
            Section(header: Text("isFaved")) {
                Text("\(String(thisBiase.isFaved!))")
            }
            
        }
        .navigationTitle("\(thisBiase.name)")
        .listStyle(.sidebar)
        /*
        .onAppear(){
            for thing in BiasStruct.biases{
                print(thing)
            }
        }*/
    }
}

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
    }
}
