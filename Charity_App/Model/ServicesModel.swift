//
//  ServicesModel.swift
//  Charity_App
//
//  .
//

import Foundation

class ServicesModel {
    var orgName : String = ""
    var address : String = ""
    var from: String = ""
    var date: String = ""
    var to: String = ""
    
    init(orgName: String,address: String, from: String, date: String, to: String) {
        self.orgName = orgName
        self.address = address
        self.from = from
        self.date = date
        self.to = to
    }
}
