//
//  ViewController.swift
//  Final-MyFamPlan
//
//  Created by Tommy on 2/23/20.
//  Copyright © 2020 conant. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var Nameinput: UITextField!
    @IBOutlet weak var ChoresToDo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func Login(_ sender: Any) {
        var Kids = (Array<String>)();
        var ChoresToDo = (Array<String>());
        
        let db = Firestore.firestore()
        db.collection("Family").document("Federmeyer").collection(Nameinput.text!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.ChoresToDo.text = "\(document.data())"
                    var Role: String
                    Role = document.get("Role") as! String
                    print(Role)
                    if Role == "Adult"{
                        print("BDSIDIUSBUIDGS")
                        db.collection("Family").whereField("Name", isEqualTo: "Federmeyer")
                            .getDocuments() { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    for document in querySnapshot!.documents {
                                        print(document.get("kids")!)
                                        Kids = document.get("kids") as! (Array<String>)
                                        var placeholder = ""
                                        for Stuff in Kids{
                                            placeholder += Stuff + " "
                                        }
                                        self.ChoresToDo.text = placeholder
                                    }
                                }
                        }
                    }
                    else {
                        ChoresToDo = document.get("Chores-Not-Completed") as! (Array<String>)
                        var placeholder = ""
                        for Stuff in ChoresToDo{
                            placeholder += Stuff + " "
                        }
                        self.ChoresToDo.text = placeholder
                    }
                    
                }
                
            }
        }
    }
    
    
    
}



