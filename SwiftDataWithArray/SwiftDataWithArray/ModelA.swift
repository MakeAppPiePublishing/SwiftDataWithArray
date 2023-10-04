//
//  ModelA.swift
//  SwiftDataWithArray
//
//  Created by Steven Lipton on 9/26/23.
//

import Foundation

import SwiftData
@Model
class ModelA:Identifiable{
    var id:Int
    var name:String
    var words:[SubModel]
    init(id:Int){
        self.id = id
        self.name = ""
        self.words = []
    }
    
    init(id:Int, name:String){
        self.id = id
        self.name = name
        self.words = []
    }
}

@Model
class SubModel:Identifiable{
    var id:Int
    var name:String
    
    init(id:Int){
        self.id = id
        self.name = ""
    }
    
    init(id:Int, name:String){
        self.id = id
        self.name = name
    }
}

