//
//  DashboardViewController.swift
//  
//
//  .
//

import UIKit
import Firebase
import FirebaseFirestore

class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collView: UICollectionView!
    var db: Firestore!
    var arrCategories:[CategoryModel] = [CategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        getCategories()
        let uid = Auth.auth().currentUser?.uid
        CategorySelect.userId = uid!
    }
    
    func getCategories() {
        db.collection("organizationCategories")
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "error in getting categories" )
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let imageURL = data["image"] as? String ?? "None"
                    let name = data["name"] as? String ?? "None"
                    let categoryID = data["categoryID"] as? String ?? "None"
                
                    let out = CategoryModel(categoryID: categoryID, imageURL: imageURL, name: name)
                    
                    self.arrCategories.append(out)
                    
                }
                self.collView.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.imgCell.image = UIImage(named: arrCategories[indexPath.row].imageURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        CategorySelect.catID = self.arrCategories[indexPath.row].categoryID
        self.performSegue(withIdentifier: "categories", sender: self)
    }

    
    
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            KeychainService().keyChain.delete("uid")
            self.navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
    
}
