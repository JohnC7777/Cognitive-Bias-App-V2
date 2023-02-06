//
//  DetailView.swift
//  Cognitive Bias App V2
//
//  Created by user230876 on 12/27/22.
//

import SwiftUI

struct DetailView: View {
    //@Binding var thisBiase: Biase //Binding means that whatever calls this view has to pass in this var which has a type Biase. This is how I get the correct Bias data for this detail view
    let bias: Biase
    
    @EnvironmentObject var vm : ViewModel //This is a global class (Because of @EnvironmentObject) so we can manipulate this data and it will be updated in the other views as well. The @StateObject is located in the @main struct of the app
    
    var body: some View {

        
        //Displays the tags above the list
        HStack{
            if(!bias.tags.isEmpty){
                ScrollView(.horizontal){ //scroll horizontally in case there are too many tags to view on screen
                    HStack{
                        ForEach (0..<bias.tags.count) {index in
                            Text("\(bias.tags[index])")
                                .padding(5)
                                .background(Color(.systemGray6))
                                .fontWeight(.light)
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onAppear(){
                        print("This is what bias is... \(bias.name)")

                    }
                }
            }
            Image(systemName: vm.contains(bias) ? "heart.fill" : "heart")
                .frame(alignment: .trailing)
                .padding(10)
                .background(Color(.systemGray4))
                .cornerRadius(8)
                .onTapGesture {
                    vm.toggleFav(item: bias)
                }
            
        }
        
        //The rest of the data is in this list
        List{
            
            //Display Question(s)
            if(!bias.question.isEmpty){
                    Section{
                        ForEach (0..<bias.question.count) {index in
                            Text("\(bias.question[index])")
                        }
                    }header:{
                        Image(systemName: "questionmark.bubble")
                        if(bias.question.count>1){
                            Text("Thought Provoking Questions")
                        }else{
                            Text("Thought Provoking Question")
                        }
                    }
            }
            
            //Display Description
            Section{
                Text("\(bias.description)")
            }header:{
                Image(systemName: "text.justify.leading")
                Text("Description")
            }
            
            //Display How to Overcome
            if(bias.overcome != ""){
                Section{
                    Text("\(bias.overcome)")
                }header:{
                    Image(systemName: "figure.strengthtraining.traditional"/*"figure.mind.and.body"*/)
                    Text("How to Overcome")
                }
            }
            
            //Display Quote(s)
            if(!bias.quote.isEmpty){
                    Section{
                        ForEach (0..<bias.quote.count) {index in
                            Text("\(bias.quote[index])")
                        }
                    }header:{
                        Image(systemName: "quote.opening")
                        if(bias.quote.count>1){
                            Text("Related Quotes")
                        }else{
                            Text("Related Quote")
                        }
                    }
            }
            
            //Display Example(s)
            if(!bias.example.isEmpty){
                    Section{
                        ForEach (0..<bias.example.count) {index in
                            Text("\(bias.example[index])")
                        }
                    }header:{
                        if(bias.example.count>1){
                            Text("Examples")
                        }else{
                            Text("Example")
                        }
                    }
            }
            
            //Display Resource(s)
            if(!bias.resource.isEmpty){
                    
                    Text("External Resources:")
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    ForEach (0..<bias.resource.count) {index in
                        Link("\(bias.resourceName[index])", destination: URL(string: "\(bias.resource[index])")!)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
            }
        }
        .navigationTitle("\(bias.name)")
        .listStyle(.sidebar)
        .cornerRadius(15)
    }
}

struct DetailView_Previews: PreviewProvider {
    @State static var BiasStruct: BiasData = BiasData.allBias
    static var previews: some View {
        DetailView(bias: BiasStruct.biases[0])
            .environmentObject(ViewModel())
    }
}

