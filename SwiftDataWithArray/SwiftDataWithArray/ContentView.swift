//
//  ContentView.swift
//  SwiftDataWithArray
//
//  Created by Steven Lipton on 9/26/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var modelAs:[ModelA]
    
    //The properties of a model need to be individual state variables. Don't try storing them in a single instance of the model. `@State var modelA:ModelA` will cause errors as SwiftData tries to find backing for the data that does not match.
    @State var name:String = ""
    @State var id:Int = 0
    
    //Child related  variables
    
    /// The list of all words from all sources
    /// You dont need this for it to work in `ModelA`.
    @Query var submodel:[SubModel]
    
    /// This is an object that is a model. It is required that the object be a `@Model`  for it to work in `ModelA`
    @State var words:[SubModel] = []
    @State var word:String = ""
    
    // other stuff
    @State var searchId:String = ""
    
    /// Function to find the next available ID my finding the maximum and then incrementing.
    ///  - Parameters:
    ///     - ids - a list of integers that are unique. 
    func nextId(ids:[Int])->Int{
        let maxId = ids.max(by: { a, b in a < b }) ?? 0
        return maxId + 1
    }
    
    /// Function to add an entry to the database from the views set on this page.
    ///  While based on the  state variables in this view, it makes  immutable copies to prevent links to the original value.
    func addModelA(){
        //everything needs a value type not connected to anything.
        let newID = nextId(ids:modelAs.map { $0.id })
        let newName = name
        let newWords = words
        //make the instance for the entry
        let newModel = ModelA(id:newID, name: newName)
        //then add in what wasn't in the initializer
        newModel.words = newWords
        //then insert
        modelContext.insert(newModel)
       
        // Clear all fields
        name = ""
        id = 0
        words = []
    }
    var body: some View {
        VStack(alignment: .leading){
            // Header
            Text("\(modelAs.count) records").font(.title).bold()
            
            //Search for a record and if found display it
            HStack{
                TextField("Search for id", text: $searchId)
                    .background()
                    .onSubmit {
                        let searchedId = Int(searchId) ?? 0
                        if let searchedModel = modelAs.first(where: { $0.id == searchedId}){
                            name = searchedModel.name
                            id = searchedModel.id
                            words = searchedModel.words
                        }
                    }
                Spacer()
            }
            .padding()
            .background(.regularMaterial)
            .padding(.bottom)
            
            // Header(parent) info
            HStack{
                Text(id,format: .number)
                Text(" - " + name)
            }
            .font(.largeTitle)
            
            // Parent input
            HStack{
                TextField("Some Text", text: $name)
                    .background()
                Spacer()
                Button("Add"){
                    addModelA()
                }
            }
            .padding()
            .background(.regularMaterial)
            
            //Current child info
            VStack(alignment:.leading){
                if words.isEmpty{
                    Text("No words added")
                } else{
                    ForEach(words){item in
                        Text(item.name)
                            .padding(.leading,20)
                    }
                }
            }
            
            
            //Child input
            HStack{
                TextField("Description words", text: $word)
                    .background()
                    .onSubmit {
                        //same pattern as above for adding entries
                        // make new copies then add to the model, then clear
                        let newWord = word
                        let newId = nextId(ids:words.map{$0.id})
                        let newSubModel = SubModel(id: newId, name: newWord)
                        words.append(newSubModel)
                        word = ""
                    }
                Spacer()
            }
            .padding()
            .background(.regularMaterial)
            
            Spacer()
 // a list of the model so we see waht is happening.
            List{
                Section("Model"){
                    ForEach(modelAs){ item in
                        VStack(alignment:.leading) {
                            HStack{
                                Text(item.id,format:.number)
                                Spacer()
                                Text(item.name)
                            }
                            .font(.headline)
                            .padding(5)
                            .background(.ultraThinMaterial, in: Capsule())
                            ForEach(item.words){ word in
                                Text("(\(word.id)) \(word.name)")
                                    .padding(.leading,25)
                            }
                        }
                    }
                }
                Section("SubModel"){
                    ForEach(submodel){ item in
                        HStack{
                            Text(item.id,format:.number)
                            Text(item.name)
                        }
                    }
                }
            }
            
            
        }//Main Vstack
    }
}

#Preview {
    ContentView()
}
