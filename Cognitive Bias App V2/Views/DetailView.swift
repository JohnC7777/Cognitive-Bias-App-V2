//
//  DetailView.swift
//  Cognitive Bias App V2
//
//  Created by user230876 on 12/27/22.
//

import SwiftUI

struct DetailView: View {
    @Binding var thisBiase: Biase //Binding means that whatever calls this view has to pass in this var which has a type Biase. This is how I get the correct Bias data for this detail view
    
    @EnvironmentObject var vm : ViewModel //This is a global class (Because of @EnvironmentObject) so we can manipulate this data and it will be updated in the other views as well. The @StateObject is located in the @main struct of the app
    
    var body: some View {
        
        //Displays the tags above the list
        HStack{
            if(!thisBiase.tags.isEmpty){
                ScrollView(.horizontal){ //scroll horizontally in case there are too many tags to view on screen
                    HStack{
                        ForEach (0..<thisBiase.tags.count) {index in
                            Text("\(thisBiase.tags[index])")
                                .padding(5)
                                .background(Color(.systemGray6))
                                .fontWeight(.light)
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            Image(systemName: vm.contains(thisBiase) ? "heart.fill" : "heart")
                .frame(alignment: .trailing)
                .padding(10)
                .background(Color(.systemGray4))
                .cornerRadius(8)
                .onTapGesture {
                    vm.toggleFav(item: thisBiase)
                }
            
        }
        
        //The rest of the data is in this list
        List{
            
            //Display Description
            Section{
                Text("\(thisBiase.description)")
            }header:{
                Image(systemName: "text.justify.leading")
                Text("Description")
            }
            
            //Display Question(s)
            if(!thisBiase.question.isEmpty){
                    Section{
                        ForEach (0..<thisBiase.question.count) {index in
                            Text("\(thisBiase.question[index])")
                        }
                    }header:{
                        Image(systemName: "questionmark.bubble")
                        if(thisBiase.question.count>1){
                            Text("Thought Provoking Questions")
                        }else{
                            Text("Thought Provoking Question")
                        }
                    }
            }
            
            //Display How to Overcome
            if(thisBiase.overcome != ""){
                Section{
                    Text("\(thisBiase.overcome)")
                }header:{
                    Image(systemName: "figure.strengthtraining.traditional"/*"figure.mind.and.body"*/)
                    Text("How to Overcome")
                }
            }
            
            //Display Quote(s)
            if(!thisBiase.quote.isEmpty){
                    Section{
                        ForEach (0..<thisBiase.quote.count) {index in
                            Text("\(thisBiase.quote[index])")
                        }
                    }header:{
                        Image(systemName: "quote.opening")
                        if(thisBiase.quote.count>1){
                            Text("Related Quotes")
                        }else{
                            Text("Related Quote")
                        }
                    }
            }
            
            //Display Example(s)
            if(!thisBiase.example.isEmpty){
                    Section{
                        ForEach (0..<thisBiase.example.count) {index in
                            Text("\(thisBiase.example[index])")
                        }
                    }header:{
                        if(thisBiase.example.count>1){
                            Text("Examples")
                        }else{
                            Text("Example")
                        }
                    }
            }
            
            //Display Resource(s)
            if(!thisBiase.resource.isEmpty){
                    
                    Text("External Resources:")
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    ForEach (0..<thisBiase.resource.count) {index in
                        Link("Click here", destination: URL(string: "\(thisBiase.resource[index])")!)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
            }
        }
        .navigationTitle("\(thisBiase.name)")
        .listStyle(.sidebar)
        .cornerRadius(15)
    }
}

struct DetailView_Previews: PreviewProvider {
    @State static var BiasStruct: BiasData = BiasData.allBias
    static var previews: some View {
        DetailView(thisBiase: $BiasStruct.biases[1])
            .environmentObject(ViewModel())
    }
}

