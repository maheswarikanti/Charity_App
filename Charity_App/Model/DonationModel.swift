//
//  DonationModel.swift
//  Charity_App
//
//  .
//

import Foundation

class DonationModel {
    var orgName : String = ""
    var amount: Int = 0
    var date: String = ""
    var time: String = ""
    
    init(orgName: String, amount: Int, date: String, time: String) {
        self.orgName = orgName
        self.amount = amount
        self.date = date
        self.time = time
    }
}
