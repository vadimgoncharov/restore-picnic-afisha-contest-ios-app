//
//  AddPlayerTableViewController.swift
//  RestorePicnicAfishaContest
//
//  Created by Vadim Goncharov on 26/07/2017.
//  Copyright © 2017 Vadim Goncharov. All rights reserved.
//

import UIKit
import CoreData

class AddPlayerTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  var player:PlayerMO!

  @IBOutlet var avatarImageView: UIImageView!
  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var scoreTextField: UITextField!
  @IBOutlet var sessionTextField: UITextField!

  @IBAction func didClickSaveButton(withSender sender: AnyObject) {
    
    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
      let context = appDelegate.persistentContainer.viewContext
      var maxId = 0
      
      let fetchRequest: NSFetchRequest<PlayerMO> = PlayerMO.fetchRequest()
      let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
      fetchRequest.sortDescriptors = [sortDescriptor]
      
      let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      
      
      do {
        try fetchResultController.performFetch()
        if let fetchedObjects = fetchResultController.fetchedObjects {
          for player in fetchedObjects {
            maxId = max(Int(player.id), maxId)
          }
        }
      } catch {
        print(error)
      }
      
      let score = Int16(scoreTextField.text!)
      let session = Int16(sessionTextField.text!)
      player = PlayerMO(context: context)
      player.name = nameTextField.text
      player.score = score != nil ? score! : 0
      player.session = session != nil ? session! : 0
      player.id = Int16(maxId + 1)
      
      
      if let avatar = avatarImageView.image {
        if let imageData = UIImagePNGRepresentation(avatar) {
          player.image = NSData(data: imageData)
        }
      }
      
      nameTextField.text = nil
      scoreTextField.text = nil
      sessionTextField.text = nil
      avatarImageView.image = nil
      
      
      print("Saving data to context ...")
      appDelegate.saveContext()
      
    }
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
      nameTextField.text = nil
      scoreTextField.text = nil
      sessionTextField.text = nil
      avatarImageView.image = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
      }
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      avatarImageView.image = selectedImage
      avatarImageView.contentMode = .scaleAspectFill
      avatarImageView.clipsToBounds = true
    }
    
    let leadingConstraint = NSLayoutConstraint(item: avatarImageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: avatarImageView.superview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
    leadingConstraint.isActive = true
    
    let trailingConstraint = NSLayoutConstraint(item: avatarImageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: avatarImageView.superview, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
    trailingConstraint.isActive = true
    
    let topConstraint = NSLayoutConstraint(item: avatarImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: avatarImageView.superview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
    topConstraint.isActive = true
    
    let bottomConstraint = NSLayoutConstraint(item: avatarImageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: avatarImageView.superview, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
    bottomConstraint.isActive = true
    
    
    dismiss(animated: true, completion: nil)
  }

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
