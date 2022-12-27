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
    
    @State var selected = 1 //By default this is set to all Biases
    
    var body: some View {
        
        NavigationView{
            VStack{
                Picker("Hello", selection: $selected, content: {
                    Text("All Biases").tag(1)
                    Text("Favorites").tag(2)
                })
                .onChange(of: selected) { tag in //When selected is changed, sort the Favs list and reset search text
                    vm.sortFavs()
                    searchText = ""
                    filterSearchText = ""
                }
                .pickerStyle(SegmentedPickerStyle())
                
                //If the picker is on 'All Biases'
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
                    .cornerRadius(15)
                    
                }else if (selected == 2){ //If the picker is on 'Favorites'
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
                    .cornerRadius(15)
                }
            }
        }
        .padding(8)
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
