//
//  ToyStoreTableViewController.swift
//  ToyStore
//
//  Created by Julio Pascoato on 03/05/24.
//

import UIKit
import Firebase

class ToyStoreTableViewController: UITableViewController {
    
    let collection = "toyStore"
    
    var toyStoreList: [ToyItem] = []
    
    lazy var firetore: Firestore = {
        let settings = FirestoreSettings()
        settings.cacheSettings = MemoryCacheSettings()
        
        let firetore = Firestore.firestore()
        firetore.settings = settings
        return firetore
    }()
    
    var listener: ListenerRegistration!
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ViewController,
           let indexPath = tableView.indexPathForSelectedRow?.row{
            viewController.toy = toyStoreList[indexPath]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadToyList()
    }
    
    
    func loadToyList(){
        listener = firetore.collection(collection).order(by: "name", descending: false).addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
          
            if let error = error {
                print(error as Any)
            }else{
                guard let snapshot = snapshot else {return}
                if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0{
                    self.showItemsFrom(snapshot: snapshot)
                }
            }
        })
    }
    
    func showItemsFrom(snapshot: QuerySnapshot){
        toyStoreList.removeAll()
        
        for document in snapshot.documents {
            let data = document.data()
            if let name = data["name"] as? String,
               let donor = data["donor"] as? String,
               let address = data["address"] as? String,
               let phoneNumber = data["phoneNumber"] as? String,
               let condition = data["condition"] as? Int
            
            {
                let toyItem = ToyItem(name: name, donor: donor, address: address, phoneNumber: phoneNumber, condition: condition, id: document.documentID)
                toyStoreList.append(toyItem)
            }
        }
        tableView.reloadData()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toyStoreList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
       
            let toyItem = toyStoreList[indexPath.row]
            cell.textLabel?.text = toyItem.name
            cell.detailTextLabel?.text = toyItem.toyCondition
        
        
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toyItem = toyStoreList[indexPath.row]
            firetore.collection(collection).document(toyItem.id).delete { error in
                if error == nil{
                    let alert = UIAlertController(title: "\(toyItem.name)", message: "Brinquedo excluido com sucesso", preferredStyle: .alert)
                    self.present(alert, animated: true)
                                     
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                }else{
                    return
                }
            }
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
