//
//  ContactsVC.swift
//  kito
//
//  Created by Егор Уваров on 03.04.2021.
//

import UIKit
import CoreData
import SnapKit

class ContactsVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //singlton
    // instance
    var context: NSManagedObjectContext!
    
    private var tableView = UITableView()
    private let reuseId = "cell"
    private var myContacts = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white

//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//        ])
//
        tableView.snp.makeConstraints{(make) in
            make.edges.equalTo(view)
        }
        tableView.register(UITableViewCell.self , forCellReuseIdentifier: reuseId)
        tableView.dataSource = self
        fetchData()
    }
    
}



extension ContactsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.textLabel?.text = myContacts[indexPath.row]
        cell.textLabel?.textColor = .systemGreen
        return cell
    }
    
    
}

// fetch CoreData

extension ContactsVC {
    func fetchData(){
        // Open main context
        context = appDelegate.persistentContainer.viewContext
        //Form request for fetching data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        request.returnsObjectsAsFaults = false
        
        do {
            // Grabing data from entity
            let result = try context.fetch(request)
            var array = [String]()
            // Iterating in array of results objects
            for data in result as! [NSManagedObject] {
                // Getting attribute value
                let name = data.value(forKey: "name") as! String
                // Saving in the array
                array.append(name)
                print(name)
            }
            myContacts.append(contentsOf: array)
        } catch {
            print(error.localizedDescription)
        }
    }
}
