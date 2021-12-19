//
//  CategoryModel.swift
//  Charity_App
//
//  .
//

import Foundation

class CategoryModel {
    var categoryID: String = ""
    var imageURL: String = ""
    var name: String = ""
    
    init(categoryID: String, imageURL: String, name: String) {
        self.categoryID = categoryID
        self.imageURL = imageURL
        self.name = name
    }
}
