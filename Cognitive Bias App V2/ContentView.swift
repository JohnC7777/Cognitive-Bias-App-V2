//
//  ContentView.swift
//  Cognitive Bias App V2
//
//  Created by user230876 on 12/23/22.
//

import SwiftUI

struct ContentView: View {
    @State private var BiasStruct: BiasData = BiasData.allBias
    @State var searchText = ""
    
    var body: some View {
        
        NavigationView{
            List{
                
                
                ForEach(searchText == "" ? BiasStruct.biases : BiasStruct.biases.filter({
                    $0.name.lowercased().contains(searchText.lowercased())
                }), id: \.id){ entry in
                    HStack{
                        NavigationLink(destination: DetailView( thisBiase: $BiasStruct.biases[entry.id-1]), label: {
                            Text("\(entry.name)")
                        })
                        
                        //Circle() //Image placeholder
                        /*NavigationLink("\(entry.name)".capitalized, destination:Text("Detail view for\(entry.name)"))*/
                        
                    }
                    
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Biases")
        }
        .padding()/*
        .onAppear(){
            for thing in BiasStruct.biases{
                print(thing)
            }
        }*/
    }
}

struct DetailView: View {
    //private var BiasStruct: BiasData = BiasData.allBias
    @Binding var thisBiase: Biase
    
    var body: some View {
        
        NavigationView{
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
            }
            .navigationTitle("\(thisBiase.name)")
        }/*
        .onAppear(){
            for thing in BiasStruct.biases{
                print(thing)
            }
        }*/
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
