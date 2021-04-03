//
//  ViewController.swift
//  kito
//
//  Created by Егор Уваров on 03.04.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //singlton
    // instance
    var context: NSManagedObjectContext!
    
    var textField: UITextField = {
        var text = UITextField()
        text.borderStyle = .roundedRect
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var doneButton: UIButton = {
        var button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add contact"
        
        view.addSubview(textField)
        view.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Contacts", style: .plain, target: self, action: #selector(pushContacts))
        
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            doneButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 25),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func buttonAction(){
        guard let text = textField.text else { return }
        storeDataBase(text)
        navigationController?.pushViewController(ContactsVC(), animated: true)
    }
    
    @objc func pushContacts(){
        navigationController?.pushViewController(ContactsVC(), animated: true)
    }
    
    func storeDataBase(_ text: String){
        // set context
        context = appDelegate.persistentContainer.viewContext
        // Retrive entity
        let entity = NSEntityDescription.entity(forEntityName: "Contacts", in: context)!
        // Insert new object into entity
        let newContact = NSManagedObject(entity: entity, insertInto: context)
        // Set value for attribute name
        newContact.setValue(text, forKey: "name")
        // Close context
        print("Contact is saving")
        do {
            try context.save()
        } catch {
            print("Failed, error happened. Fix it")
        }
    }
}

