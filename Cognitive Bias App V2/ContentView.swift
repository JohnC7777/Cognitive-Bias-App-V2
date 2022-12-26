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
                }
                
            }
        }
        .padding()
    }
}

struct DetailView: View {
    //private var BiasStruct: BiasData = BiasData.allBias
    
    //Binding means that whatever calls this view has to pass in this var which has a type Biase. This is how I get the correct Bias data for this detail view
    @Binding var thisBiase: Biase
    
    var body: some View {
        
        List{
            Section{
                Text("\(thisBiase.description)")
            }header:{
                Image(systemName: "text.justify.leading")
                Text("Description")
            }
            
            if(thisBiase.question != ""){
                Section {
                    Text("\(thisBiase.question)")
                }header:{
                    Image(systemName: "questionmark.bubble")
                    Text("Thought Provoking Question")
                }
            }
            if(thisBiase.overcome != ""){
                Section{
                    Text("\(thisBiase.overcome)")
                }header:{
                    Image(systemName: "figure.mind.and.body")
                    Text("How to Overcome")
                }
            }
            if(thisBiase.quote != ""){
                Section{
                    Text("\(thisBiase.quote)")
                }header:{
                    /*"text.justify.leading"*/
                    Image(systemName: "quote.opening")
                    Image(systemName: "quote.close")
                    Text("Related Quote")
                }
            }
            if(thisBiase.example != ""){
                Section(header: Text("Example")) {
                    Text("\(thisBiase.example)")
                }
            }
            
            if(!thisBiase.resource.isEmpty){
                if(thisBiase.resource[0] != ""){
                    
                    Text("External Resources:")
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    ForEach (0..<thisBiase.resource.count) {index in
                        //Text("\(index)")
                        Link("Click here", destination: URL(string: "\(thisBiase.resource[index])")!)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        
                    }
                }
            }
        }
        .navigationTitle("\(thisBiase.name)")
        .listStyle(.sidebar)
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
    }
}
