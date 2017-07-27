//
//  PlayerTableViewController.swift
//  RestorePicnicAfishaContest
//
//  Created by Vadim Goncharov on 26/07/2017.
//  Copyright © 2017 Vadim Goncharov. All rights reserved.
//

import UIKit
import CoreData

class PlayerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var fetchResultController: NSFetchedResultsController<PlayerMO>!
    var players:[PlayerMO] = []
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
      let fetchRequest: NSFetchRequest<PlayerMO> = PlayerMO.fetchRequest()
      let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
      fetchRequest.sortDescriptors = [sortDescriptor]
      
      if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        let context = appDelegate.persistentContainer.viewContext
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultController.delegate = self
        
        do {
          try fetchResultController.performFetch()
          if let fetchedObjects = fetchResultController.fetchedObjects {
            players = fetchedObjects
          }
        } catch {
          print(error)
        }
      }
    }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("begin")
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    print("didchange")
    switch type {
    case .insert:
      if let newIndexPath = newIndexPath {
        tableView.insertRows(at: [newIndexPath], with: .fade)
      }
    case .delete:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
    case .update:
      if let indexPath = indexPath {
        tableView.reloadRows(at: [indexPath], with: .fade)
      }
    default:
      tableView.reloadData()
    }
    
    if let fetchedObjects = controller.fetchedObjects {
      players = fetchedObjects as! [PlayerMO]
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("end")
    tableView.endUpdates()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return players.count
    }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cellIdentifier = "Cell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlayerTableViewCell
    
    let indexRowId = indexPath.row;
    // Configure the cell...
    cell.nameLabel?.text = players[indexRowId].name
    if let playerAvatar = players[indexPath.row].image {
      cell.avatarImageView.image = UIImage(data: playerAvatar as Data)
    }
    cell.scoreLabel?.text = String(players[indexRowId].score)
    cell.sessionLabel?.text = String(players[indexRowId].id)
    
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showEditPlayer" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let destinationController = segue.destination as! EditPlayerTableViewController
        let rowIndex = indexPath.row
        destinationController.player = players[rowIndex]
      }
    }
  }

  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    // Delete button
    let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action, indexPath) -> Void in
      
      if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        let context = appDelegate.persistentContainer.viewContext
        let playerToDelete = self.fetchResultController.object(at: indexPath)
        context.delete(playerToDelete)
        
        appDelegate.saveContext()
      }
    })
    
    return [deleteAction]
  }
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
