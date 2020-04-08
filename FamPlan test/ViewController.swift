//
//  ViewController.swift
//  Final-MyFamPlan
//
//  Created by Tommy on 2/23/20.
//  Copyright © 2020 conant. All rights reserved.
//

import UIKit
import Firebase




class Login: UIViewController {
    
    @IBOutlet weak var Familyinput: UITextField!
    @IBOutlet weak var Nameinput: UITextField!
    @IBOutlet weak var ChoresToDo: UILabel!
    var name = ""
    var WeeklyNumber = "NA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func ChangeScreen(_ sender: Any) {
        name = Nameinput.text!
        let db = Firestore.firestore()
        db.collection("Family").document(Familyinput.text! + "").collection(Nameinput.text! + "").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            var check: String
                            check = document.get("Name") as! String
                            print(check)
                            if check == self.name{
                                print("Name Exists")
                                
                            self.performSegue(withIdentifier: "ToMainScreen", sender: self)
                            }
                        }
            }
        }
            
        
    }
    
    
    

    

    
    
    
    
    @IBAction func Login(_ sender: Any) {
        
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().signIn()
        
        
//        var Kids = (Array<String>)();
//        var ChoresToDo = (Array<String>());
//
//        let db = Firestore.firestore()
//        db.collection("Family").document(Familyinput.text!).collection(Nameinput.text!).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                    self.ChoresToDo.text = "\(document.data())"
//                    var Role: String
//                    Role = document.get("Role") as! String
//                    print(Role)
//                    if Role == "Adult"{
//                        print("BDSIDIUSBUIDGS")
//                        db.collection("Family").whereField("Name", isEqualTo: self.Familyinput.text!)
//                            .getDocuments() { (querySnapshot, err) in
//                                if let err = err {
//                                    print("Error getting documents: \(err)")
//                                } else {
//                                    for document in querySnapshot!.documents {
//                                        print(document.get("kids")!)
//                                        Kids = document.get("kids") as! (Array<String>)
//                                        var placeholder = ""
//                                        for Stuff in Kids{
//                                            placeholder += Stuff + " "
//                                        }
//                                        self.ChoresToDo.text = placeholder
//                                    }
//                                }
//                        }
//                    }
//                    else {
//                        ChoresToDo = document.get("Chores-Not-Completed") as! (Array<String>)
//                        var placeholder = ""
//                        for Stuff in ChoresToDo{
//                            placeholder += Stuff + " "
//                        }
//                        self.ChoresToDo.text = placeholder
//                    }
//
//                }
//
//            }
//        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destVC : ViewMainScreen = segue.destination as!
        ViewMainScreen
        destVC.modalPresentationStyle = .fullScreen
        name = Nameinput.text!
        destVC.FamilyName = Familyinput.text! + ""
        destVC.AccountName = Nameinput.text! + ""
    }

    
    
}




class ViewMainScreen: UIViewController {
    
    var FamilyName = ""
    var AccountName = ""
    var role = ""
    var WeeklyNumber = 0
    var ChoresCompleted  = 0
    var Viewgoingto = ""
    var Chores = [String]()
    var ChoresAdult = [String]()
    @IBOutlet weak var LableName: UILabel!
    @IBOutlet weak var LableWeeklyPercent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Testing --- Screen post")
        print(FamilyName)
        print(AccountName)
        print("--End--")
        LableName.text = AccountName
        DisplayWeeklyPercent()
                
 
               
        

        
        
    }
    
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func DisplayWeeklyPercent()  {
        
        let db = Firestore.firestore()
                db.collection("Family").document(FamilyName).collection(AccountName).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            self.role = document.get("Role") as! String
                            print(self.role)
                            if self.role == "Child"{
                                self.LableWeeklyPercent.text = "%" + String(document.get("Chores-Completed") as! Int) + " / " + String(document.get("Weekly-Number") as! Int)
                            }
                            else if self.role == "Adult"{
                                self.LableWeeklyPercent.text = "NA"
                            }
                        }
                        
                    }
        }
        
    }
    
    
    @IBAction func ToChoreView(_ sender: Any) {
        Viewgoingto = "Chores"
        ChoresAdult = [String]()
        let db = Firestore.firestore()
        db.collection("Family").document(FamilyName).collection("Chores").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.ChoresAdult.append(document.get("Name") as! String)
                }
                print(self.ChoresAdult.count)
                self.DelayForChoreViewSwitcher()
            }
        }
        
        
    }

    
    func DelayForChoreViewSwitcher()  {
        let db = Firestore.firestore()
        db.collection("Family").document(FamilyName).collection(AccountName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.role = document.get("Role") as! String
                    print(self.role)
                    if self.role == "Child"{
                        self.Chores = document.get("Chores-Not-Completed") as! [String]
                        self.performSegue(withIdentifier: "ToChildView", sender: self)
                    }
                    else if self.role == "Adult"{
                        self.performSegue(withIdentifier: "ToAdultChoreView", sender: self)
                    }
                }
            }
        }
    }
    
    @IBAction func GoToFamily(_ sender: Any) {
        Viewgoingto = "Family"
        print("Ayyyyy Bro this is looking good man!!!")
        if role == "Adult"{
            self.performSegue(withIdentifier: "ToFamilyAdult", sender: self)
        }
        else if role == "Child"{
            self.performSegue(withIdentifier: "ToFamilyChild", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if role == "Child" && Viewgoingto == "Chores"{
            let destVC : ChildChoreView = segue.destination as! ChildChoreView
            destVC.modalPresentationStyle = .fullScreen
            destVC.FamilyName = FamilyName
            destVC.AccountName = AccountName
            destVC.role = role
            destVC.Chores = Chores
            destVC.ChoresCompleted = ChoresCompleted
        }
        
        else if role == "Adult" && Viewgoingto == "Chores"{
            let destVC : AdultChoreView = segue.destination as! AdultChoreView
            destVC.modalPresentationStyle = .fullScreen
            destVC.FamilyName = FamilyName
            destVC.AccountName = AccountName
            destVC.role = role
            destVC.Chores = ChoresAdult
        }
        else if role == "Child" && Viewgoingto == "Family"{
            let destVC : FamilyChild = segue.destination as! FamilyChild
            destVC.modalPresentationStyle = .fullScreen
            destVC.FamilyName = FamilyName
            destVC.AccountName = AccountName
            destVC.role = role
        }
            
        else if role == "Adult" && Viewgoingto == "Family"{
            let destVC : FamilyAdult = segue.destination as! FamilyAdult
            destVC.modalPresentationStyle = .fullScreen
            destVC.FamilyName = FamilyName
            destVC.AccountName = AccountName
            destVC.role = role
        }
        
    }
    
}




class FamilyChild: UIViewController {
    var role = ""
    var FamilyName = ""
    var AccountName = ""
    var Chores = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Testing --- Screen post")
        print(FamilyName)
        print(AccountName)
        print(role)
        print("--End--")
    }
    
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}



class FamilyAdult: UIViewController {
    var role = ""
    var FamilyName = ""
    var AccountName = ""
    var Chores = [String]()
    let db = Firestore.firestore()
    
    @IBOutlet weak var AddMember: UITextField!
    
    @IBOutlet weak var AdultTest: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Testing --- Screen post")
        print(FamilyName)
        print(AccountName)
        print(role)
        print("--End--")
    }
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func AddFamilyMember(_ sender: Any) {
        if AdultTest.isOn {
            db.collection("Family").document(FamilyName).collection(AddMember.text!).document("Info").setData([
                "Name": AddMember.text!,
                "Role": "Adult"
                
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            }
        else if !AdultTest.isOn{
            db.collection("Family").document(FamilyName).collection(AddMember.text!).document("Info").setData([
                "Name": AddMember.text!,
                "Role": "Child",
                "Chores-Completed": 0,
                "Chores-Not-Completed": [],
                "Weekly-Number": 10
                
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            var Kids = db.collection("Family").document(FamilyName)
            Kids.updateData([
                "kids": FieldValue.arrayUnion([AddMember.text!])
                ])
        }
    }
    
    
    
}













class ChildChoreView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    
    var role = ""
    var ChoresCompleted = 0
    var FamilyName = ""
    var AccountName = ""
    var Chores = [String]()
    var SelectedChore = ""
    @IBOutlet weak var ChoreLable: UITextField!
    @IBOutlet weak var TableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Display()
        TableView.dataSource = self
        TableView.delegate = self
        print("Testing --- Screen post")
        print(FamilyName)
        print(AccountName)
        print(role)
        print("--End--")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Chores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "ChoreValue", for: indexPath)
        cell.textLabel!.text = Chores[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedChore = Chores[indexPath.row]
        self.performSegue(withIdentifier: "ToChoreDetails", sender: self)
    }
    
    
    func Display()  {
        let db = Firestore.firestore()
        db.collection("Family").document(FamilyName).collection(AccountName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.Chores = document.get("Chores-Not-Completed") as! [String]
                    print(self.Chores)
                }
                
                var out = ""
                for stuff in self.Chores{
                    out += stuff
                }
                self.ChoreLable.text = out
            }
        }
    }
    
    func ChoreList()  {
        let db = Firestore.firestore()
        db.collection("Family").document(FamilyName).collection(AccountName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.Chores = document.get("Chores-Not-Completed") as! [String]
                    print(self.Chores)
                }
            }
        }
    }
    
    

    
    
    @IBAction func ViewChoreStuff(_ sender: Any) {
        var test = false
        for stuff in Chores{
            if (ChoreLable.text == stuff){
                test = true
            }
        }
        if test {
            self.performSegue(withIdentifier: "ToChoreDetails", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : ChoreDetail = segue.destination as! ChoreDetail
        destVC.modalPresentationStyle = .fullScreen
        destVC.FamilyName = FamilyName
        destVC.AccountName = AccountName
        destVC.ChoreName  = SelectedChore
        destVC.ChoresCompleted = ChoresCompleted
        
    }
    
    
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}





class ChoreDetail: UIViewController{
    
    var ChoresCompleted = 0
    var FamilyName = ""
    var AccountName = ""
    var ChoreName = ""
    var role = ""
    var AssignedTo = ""
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var NameLable: UILabel!
    @IBOutlet weak var NameField: UITextField!
    
    @IBOutlet weak var DetailLable: UILabel!
    @IBOutlet weak var DetailField: UITextField!
    
    @IBOutlet weak var DateLable: UILabel!
    @IBOutlet weak var DateField: UITextField!
    
    @IBOutlet weak var CompletedLable: UILabel!
    @IBOutlet weak var FinishedSlider: UISwitch!
    
    
    
    override func viewDidLoad() {
        
        if role == "Adult"{
            DetailField.isUserInteractionEnabled = true
            NameField.isUserInteractionEnabled = false
            DateField.isUserInteractionEnabled = true
        }
        else{
            DetailField.isUserInteractionEnabled = false
            NameField.isUserInteractionEnabled = false
            DateField.isUserInteractionEnabled = false
        }
        print(ChoreName)
        super.viewDidLoad()
        db.collection("Family").document(FamilyName).collection("Chores").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if(document.get("Name") as! String == self.ChoreName){
                        self.NameField.text = self.ChoreName
                        self.DateField.text = document.get("Date") as! String
                        self.DetailField.text = document.get("Description") as! String
                        self.AssignedTo = document.get("Assigned") as! String
                        if(document.get("Done") as! Bool){
                            self.CompletedLable.text = "Done"
                        }
                        else{
                            self.CompletedLable.text = "Work In Progress"
                        }
                    }
                    
                }
                
               
            }
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    @IBAction func UpdateChore(_ sender: Any) {
        var DataChoreName = db.collection("Family").document(FamilyName).collection("Chores").document(ChoreName)
        var DataChoreList = db.collection("Family").document(FamilyName).collection(AccountName).document("Info")
        if role == "Adult"{
            DataChoreName = db.collection("Family").document(FamilyName).collection("Chores").document(ChoreName)
            DataChoreList = db.collection("Family").document(FamilyName).collection(AssignedTo).document("Info")
        }

        DataChoreName.updateData([
            "Done": FinishedSlider.isOn,
            "Date": DateField.text!,
            "Name": NameField.text!,
            "Description": DetailField.text!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        if FinishedSlider.isOn{
            DataChoreList.updateData([
                "Chores-Not-Completed": FieldValue.arrayRemove([ChoreName]),
                "Chores-Completed": (ChoresCompleted+1)
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        else if !FinishedSlider.isOn{
            DataChoreList.updateData([
                
                "Chores-Not-Completed": FieldValue.arrayUnion([ChoreName])
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        
    }
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}



class AdultChoreView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var TableView: UITableView!
    var destination = ""
    var SelectedChore = ""
    var role = ""
    var FamilyName = ""
    var AccountName = ""
    var Chores = [String]()
    @IBOutlet weak var ChoreList: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
        print("Testing --- Screen post")
        print(FamilyName)
        print(AccountName)
        print(role)
        print("--End--")
        Display()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Chores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "ChoreValueAdult", for: indexPath)
        cell.textLabel!.text = Chores[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        destination = "ChoreDetails"
        SelectedChore = Chores[indexPath.row]
        self.performSegue(withIdentifier: "ChoreDetails", sender: self)
    }
    
    func Display() {
       
        let db = Firestore.firestore()
        db.collection("Family").document(FamilyName).collection("Chores").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.Chores.append(document.get("Name") as! String)
                    
                }
               
                //self.ChoreList.text = self.Chores

            }
        }
    }
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ToAddChore(_ sender: Any) {
        destination = "AddChores"
        self.performSegue(withIdentifier: "ToAddChores", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if destination == "ChoreDetails" {
            let destVC : ChoreDetail = segue.destination as! ChoreDetail
            destVC.modalPresentationStyle = .fullScreen
            destVC.FamilyName = FamilyName
            destVC.AccountName = AccountName
            destVC.role = role
            destVC.ChoreName = SelectedChore
        }
        if destination == "AddChores" {
            let destVC : AddChores = segue.destination as! AddChores
            destVC.modalPresentationStyle = .fullScreen
            destVC.FamilyName = FamilyName
            destVC.AccountName = AccountName
            destVC.role = role
        }
        
    }
}





class AddChores: UIViewController {
   
   var FamilyName = ""
   var AccountName = ""
   var role = ""
   var WeeklyNumber = 0
   var ChoresCompleted  = 0
   @IBOutlet weak var NameChoreInput: UITextField!
   @IBOutlet weak var DateChoreInput: UITextField!
   @IBOutlet weak var DescriptionChoreInput: UITextField!
   @IBOutlet weak var AssignedChoreInput: UITextField!
   
    
    
    
    
   override func viewDidLoad() {
       super.viewDidLoad()
       print("Testing --- Screen post")
       print(FamilyName)
       print(AccountName)
       print("Add Chores")
       print("--End--")
   }
    
    let db = Firestore.firestore()
    
    func AddData() {
        
        db.collection("Family").document(FamilyName).collection("Chores").document(NameChoreInput.text!).setData([
            "Name": NameChoreInput.text!,
            "Date": DateChoreInput.text!,
            "Description": DescriptionChoreInput.text!,
            "Assigned": AssignedChoreInput.text!,
            "Done": false
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        let UserChild = db.collection("Family").document(FamilyName).collection(AssignedChoreInput.text!).document("Info")
        UserChild.updateData([
            "Chores-Not-Completed": FieldValue.arrayUnion([NameChoreInput.text!])
            ])
        
    }
    
    
   @IBAction func Exit(_ sender: Any) {
    var Kids = (Array<String>)();
    db.collection("Family").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                if document.get("Name") as! String == self.FamilyName{
                    Kids = document.get("kids") as! Array<String>
                    print(Kids)
                    var CheckKidinFamily = false
                    for Kid in Kids{
                        if Kid == self.AssignedChoreInput.text!{
                            CheckKidinFamily = true
                        }
                    }
                    if CheckKidinFamily{
                        self.AddData()
                    }
                }
                
            }
        }
    }
       dismiss(animated: true, completion: nil)
   }
    
}
















