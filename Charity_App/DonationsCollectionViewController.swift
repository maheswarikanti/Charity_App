//
//  DonationsCollectionViewController.swift
//  
//
//  .
//

import UIKit
import Firebase
import FirebaseFirestore

private let reuseIdentifier = "Cell"

class DonationsCollectionViewController: UICollectionViewController {
    var db: Firestore!
    var donationArr: [DonationModel] = [DonationModel]()
    let boldAttribute = [
          NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!
       ]
    let regularAttribute = [
          NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 18.0)!
       ]

    @IBOutlet var collView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        collectionView.register(UINib.init(nibName: "DonationsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        getDonations()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return donationArr.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DonationsCollectionViewCell
        
        let nameBold = NSAttributedString(string: "Name: ", attributes: self.boldAttribute)
        let nameRegular = NSAttributedString(string: donationArr[indexPath.row].orgName, attributes: self.regularAttribute)
        let nameString = NSMutableAttributedString()
        nameString.append(nameBold)
        nameString.append(nameRegular)
        cell.lblOrgName.attributedText = nameString
        
        let timeBold = NSAttributedString(string: "Time: ", attributes: self.boldAttribute)
        let timeRegular = NSAttributedString(string: donationArr[indexPath.row].time, attributes: self.regularAttribute)
        let timeString = NSMutableAttributedString()
        timeString.append(timeBold)
        timeString.append(timeRegular)
        cell.lblTime.attributedText = timeString
        
        let dateBold = NSAttributedString(string: "Date: ", attributes: self.boldAttribute)
        let dateRegular = NSAttributedString(string: donationArr[indexPath.row].date, attributes: self.regularAttribute)
        let dateString = NSMutableAttributedString()
        dateString.append(dateBold)
        dateString.append(dateRegular)
        cell.lblDate.attributedText = dateString
        
        let amountBold = NSAttributedString(string: "Amount Donated :", attributes: self.boldAttribute)
        let amountRegular = NSAttributedString(string: String(donationArr[indexPath.row].amount), attributes: self.regularAttribute)
        let amountString = NSMutableAttributedString()
        amountString.append(amountBold)
        amountString.append(amountRegular)
        cell.lblAmount.attributedText = amountString
    
        return cell
    }
    
    func getDonations() {
        
        db.collection("donations").whereField("userId", isEqualTo: CategorySelect.userId)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "error in getting donations")
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let amount = data["amount"] as? Int ?? 0
                    let date = data["date"] as? String ?? "None"
                    let orgName = data["orgName"] as? String ?? "None"
                    let time = data["time"] as? String ?? "None"
                    
                    let out = DonationModel(orgName: orgName, amount: amount, date: date, time: time)
                    self.donationArr.append(out)
                    
                }
                self.collView.reloadData()
        }
    }
    
    

}
