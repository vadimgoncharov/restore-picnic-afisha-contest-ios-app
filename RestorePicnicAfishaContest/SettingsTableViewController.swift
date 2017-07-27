//
//  SettingsTableViewController.swift
//  RestorePicnicAfishaContest
//
//  Created by Vadim Goncharov on 27/07/2017.
//  Copyright © 2017 Vadim Goncharov. All rights reserved.
//

import UIKit
import CoreData

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @IBOutlet var sessionTextField: UITextField!
  @IBOutlet var gameSwitch: UISwitch!
  var settings:SettingsMO!

  @IBAction func didClickCancelButton(withSender sender: AnyObject) {
    print("click cancel")
    navigationController?.popViewController(animated: true)
    
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didClickSaveButton(withSender sender: AnyObject) {
    print("click save")
    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
     
      let session = Int16(sessionTextField.text!)
      settings.session = session != nil ? session! : 0
      settings.is_game_finished = gameSwitch.isOn
      
      print("Saving data to context ...")
      appDelegate.saveContext()
      
    }
    navigationController?.popViewController(animated: true)
    dismiss(animated: true, completion: nil)
  }
  
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
      let fetchResultController: NSFetchedResultsController<SettingsMO>!

      let fetchRequest: NSFetchRequest<SettingsMO> = SettingsMO.fetchRequest()
      let sortDescriptor = NSSortDescriptor(key: "session", ascending: false)
      fetchRequest.sortDescriptors = [sortDescriptor]
      
      if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        let context = appDelegate.persistentContainer.viewContext
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
          try fetchResultController.performFetch()
          if let fetchedObjects = fetchResultController.fetchedObjects {
            settings = fetchedObjects[0]
          }
        } catch {
          print(error)
        }
      }
      
      let session = settings.session
      let isGameFinished = settings.is_game_finished
      if (session != nil) {
        sessionTextField.text = String(session)
      }
      if (isGameFinished != nil) {
        gameSwitch.isOn = isGameFinished
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

  
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
