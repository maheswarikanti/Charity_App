//
//  OrganizationModel.swift
//  Charity_App
//
//  .
//

import Foundation

class OrganizationModel{
    var categoryID : String = ""
    var category: String = ""
    var description : String = ""
    var image : String = ""
    var orgName : String = ""
    var organizationID: String = ""
    
    init(categoryID: String, category: String, description: String, image: String, orgName: String, organizationID:String) {
        self.categoryID = categoryID
        self.image = image
        self.orgName = orgName
    }
}
