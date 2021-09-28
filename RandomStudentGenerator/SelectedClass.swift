//
//  SelectedClass.swift
//  RandomStudentGenerator
//
//  Created by PAIGE KELLER on 9/15/21.
//

import UIKit

// on unwind from class settings to this screen and myClasses screen no function, viewDidAppear or viewWillAppear, resets the screen




class SelectedClass: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var spotlight: UIImageView!
    @IBOutlet weak var studentChoosenLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var randBtn: UIButton!
    @IBOutlet weak var r1: UILabel!
    @IBOutlet weak var r2: UILabel!
    
    
    
    var selectedClass: MyClass = MyClass()
    var indexAt: Int = 0
    var temp = UserDefaults.standard.string(forKey: "keepStudentSettings")
    let alert2 = UIAlertController(title: "New Student Name", message: nil, preferredStyle: .alert)
    var students: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UserDefaults.standard.string(forKey: "keepStudentSettings"))
        
        if temp == nil { //if running at for the first time
            UserDefaults.standard.set("true", forKey: "keepStudentSettings")
        }
        print("         \(temp)")

        classNameLabel.text = selectedClass.className
        tableview.delegate = self
        tableview.dataSource = self
        print(indexAt)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        classNameLabel.text = selectedClass.className
        students = selectedClass.students
        print("Hello World")
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toClassSettings" {
    let nvc = segue.destination as! ClassSettings
    nvc.selectedClass = self.selectedClass
    nvc.indexAt = self.indexAt
        nvc.tempRS = self.temp!
    }
   }
    
    
    @IBAction func unwindToSelectedClass(_ seg: UIStoryboardSegue ) {
        print("unwinding to my class")
    }
    
    @IBAction func resetAction(_ sender: UIButton) {
        
        resetBtn.isHidden = true
        students = selectedClass.students
        spotlight.isHidden = true
        studentChoosenLabel.text = ""
        randBtn.alpha = 1
        r1.alpha = 1
        r2.alpha = 1
    }
    
    
    
    @IBAction func randBtn(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "keepStudentSettings") == "true" {
        let random = Int.random(in: 0...(selectedClass.students.count-1))
        
        studentChoosenLabel.text = selectedClass.students[random]
        
        spotlight.isHidden = false
        studentChoosenLabel.isHidden = false
        } else {
            print("otherwise")
            let random = Int.random(in: 0...(students.count-1))
            studentChoosenLabel.text = students[random]
            if students.count != 1{
            students.remove(at: random)
            } else { //does = 1
                randBtn.alpha = 0.35
                r1.alpha = 0.35
                r2.alpha = 0.35
                resetBtn.isHidden = false
            }
            spotlight.isHidden = false
            studentChoosenLabel.isHidden = false
        }
    }
    

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
    //DELETE STUDENT ACTION
    let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: {action, indexPath in
            
            print("deleted")
            self.selectedClass.students.remove(at: indexPath.row)
            self.tableview.deleteRows(at: [indexPath], with: .automatic)

        var tempClassArray = UserDefaults.standard.array(forKey: "classArray")
        
        do {
        let encoder = JSONEncoder()
            let data = try encoder.encode(self.selectedClass)
        tempClassArray?[self.indexAt] = data
            UserDefaults.standard.set(tempClassArray, forKey: "classArray")
            
            print("successfully removed student")
            
        } catch {
            print("Unable to Encode Class (\(error))")
        }
        
        })
    
    
    //EDIT STUDENT ACTION
    let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: {action, indexPath in
        
        self.alert2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.alert2.addTextField(configurationHandler: { textField in
            textField.placeholder = "enter name here"
                                    })
        self.alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            if let name = self.alert2.textFields?.first?.text {
                print("new name = \(name)")
                self.selectedClass.students[indexPath.row] = name
            
                var tempClassArray = UserDefaults.standard.array(forKey: "classArray")
                
                do {
                let encoder = JSONEncoder()
                    let data = try encoder.encode(self.selectedClass)
                tempClassArray?[self.indexAt] = data
                    UserDefaults.standard.set(tempClassArray, forKey: "classArray")
                    self.tableview.reloadData()
                    print("successfully changed name")
                    
                } catch {
                    print("Unable to Encode Class (\(error))")
                }
                
                
                
            }
        }))
        self.present(self.alert2, animated: true)
        
        print("edited")
        
    })
        
    editAction.backgroundColor = UIColor.blue
    
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedClass.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "myCell")!
        
        cell.textLabel?.font = UIFont(name: "Futura", size: CGFloat(18))
        
        cell.textLabel?.text = selectedClass.students[indexPath.row]
        
    
        
        return cell
    }
    
    

}
