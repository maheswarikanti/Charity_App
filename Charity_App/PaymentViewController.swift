//
//  PaymentViewController.swift
//  
//
//  .
//

import UIKit
import Firebase
import FirebaseFirestore

class PaymentViewController: UIViewController {
    var db: Firestore!
    var date = ""
    var time = ""
    let boldAttribute = [
          NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!
       ]
    let regularAttribute = [
          NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 18.0)!
       ]

    @IBOutlet weak var imgHappy: UIImageView!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        getData()
        self.lblStatus.text = " "
    }
    
    func getData() {
        let nameBold = NSAttributedString(string: "Name: ", attributes: self.boldAttribute)
        let nameRegular = NSAttributedString(string: CategorySelect.orgName, attributes: self.regularAttribute)
        let nameString = NSMutableAttributedString()
        nameString.append(nameBold)
        nameString.append(nameRegular)
        self.lblName.attributedText = nameString
        
        let totalBold = NSAttributedString(string: "Total: ", attributes: self.boldAttribute)
        let totalRegular = NSAttributedString(string: String(CategorySelect.total), attributes: self.regularAttribute)
        let totalString = NSMutableAttributedString()
        totalString.append(totalBold)
        totalString.append(totalRegular)
        self.lblTotal.attributedText = totalString
        
        let addressBold = NSAttributedString(string: "Address: ", attributes: self.boldAttribute)
        let addressRegular = NSAttributedString(string: CategorySelect.address, attributes: self.regularAttribute)
        let addressString = NSMutableAttributedString()
        addressString.append(addressBold)
        addressString.append(addressRegular)
        self.lblAddress.attributedText = addressString
        
        let formatter : DateFormatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
        date = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        let formatterTime : DateFormatter = DateFormatter()
            formatterTime.dateFormat = "HH:mm"
        time = formatterTime.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        let dateBold = NSAttributedString(string: "Date: ", attributes: self.boldAttribute)
        let dateRegular = NSAttributedString(string: date, attributes: self.regularAttribute)
        let dateString = NSMutableAttributedString()
        dateString.append(dateBold)
        dateString.append(dateRegular)
        self.lblDate.attributedText = dateString
    }
    
    @IBAction func paymentAction(_ sender: Any) {
        addDonationToDB()
        self.btnPay.isHidden = true
        self.lblStatus.text = "Thank you for the donation!!"
        self.imgHappy.image = UIImage(named: "Happy")
    }
    
    func addDonationToDB () {
        let newDonation = db.collection("donations").document()
        let donationID = newDonation.documentID
        let uid = Auth.auth().currentUser?.uid
        
        newDonation.setData(["userId": uid!,
                             "orgName": CategorySelect.orgName,
                             "amount": CategorySelect.total,
                             "date": date,
                             "time": time,
                             "donationId": donationID
        ])
        
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            KeychainService().keyChain.delete("uid")
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            print(error)
        }
    }
    
}
