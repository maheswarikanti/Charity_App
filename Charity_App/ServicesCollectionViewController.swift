//
//  ServicesCollectionViewController.swift
//  
//
//  .
//

import UIKit
import Firebase
import FirebaseFirestore

private let reuseIdentifier = "Cell"

class ServicesCollectionViewController: UICollectionViewController {
    var db: Firestore!
    var servicesArr: [ServicesModel] = [ServicesModel]()
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
        collectionView.register(UINib.init(nibName: "ServicesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        getServices()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicesArr.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ServicesCollectionViewCell
        
        let dateBold = NSAttributedString(string: "Date: ", attributes: self.boldAttribute)
        let dateRegular = NSAttributedString(string: servicesArr[indexPath.row].date, attributes: self.regularAttribute)
        let dateString = NSMutableAttributedString()
        dateString.append(dateBold)
        dateString.append(dateRegular)
        cell.lblDate.attributedText = dateString
        
        let nameBold = NSAttributedString(string: "Name: ", attributes: self.boldAttribute)
        let nameRegular = NSAttributedString(string: servicesArr[indexPath.row].orgName, attributes: self.regularAttribute)
        let nameString = NSMutableAttributedString()
        nameString.append(nameBold)
        nameString.append(nameRegular)
        cell.lblOrgName.attributedText = nameString
        
        let fromBold = NSAttributedString(string: "From: ", attributes: self.boldAttribute)
        let fromRegular = NSAttributedString(string: servicesArr[indexPath.row].from, attributes: self.regularAttribute)
        let fromString = NSMutableAttributedString()
        fromString.append(fromBold)
        fromString.append(fromRegular)
        cell.lblFrom.attributedText = fromString
        
        let toBold = NSAttributedString(string: "To: ", attributes: self.boldAttribute)
        let toRegular = NSAttributedString(string: servicesArr[indexPath.row].to, attributes: self.regularAttribute)
        let toString = NSMutableAttributedString()
        toString.append(toBold)
        toString.append(toRegular)
        cell.lblTo.attributedText = toString
        
        let addressBold = NSAttributedString(string: "Address: ", attributes: self.boldAttribute)
        let addressRegular = NSAttributedString(string: servicesArr[indexPath.row].address, attributes: self.regularAttribute)
        let addressString = NSMutableAttributedString()
        addressString.append(addressBold)
        addressString.append(addressRegular)
        cell.lblAddress.attributedText = addressString
    
        return cell
    }
    
    func getServices() {
        print(CategorySelect.userId)
        db.collection("services").whereField("userId", isEqualTo: CategorySelect.userId)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "error in getting donations")
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let date = data["date"] as? String ?? "None"
                    let orgName = data["orgName"] as? String ?? "None"
                    let from = data["from"] as? String ?? "None"
                    let address = data["address"] as? String ?? "None"
                    let to = data["to"] as? String ?? "None"
                    
                    let out = ServicesModel(orgName: orgName, address: address, from: from, date: date, to: to)
                    self.servicesArr.append(out)
                    
                }
                self.collView.reloadData()
        }
    }
}
