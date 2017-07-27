//
//  TopViewController.swift
//  RestorePicnicAfishaContest
//
//  Created by Vadim Goncharov on 27/07/2017.
//  Copyright © 2017 Vadim Goncharov. All rights reserved.
//

import UIKit
import CoreData

class TopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  // https://stackoverflow.com/questions/31735228/how-to-make-a-simple-collection-view-with-swift
  @IBAction func didClickCancelButton(withSender sender: AnyObject) {
    print("click cancel")
    navigationController?.popViewController(animated: true)
    
    dismiss(animated: true, completion: nil)
  }
  
  var players:[PlayerMO] = []
  var settings:[SettingsMO] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      loadSettings()
      loadPlayers()

    }

  func loadPlayers() {
    let fetchRequest: NSFetchRequest<PlayerMO> = PlayerMO.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
      let context = appDelegate.persistentContainer.viewContext
      let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      
      
      do {
        try fetchResultController.performFetch()
        if let fetchedObjects = fetchResultController.fetchedObjects {
          players = fetchedObjects.filter(isAtActiveSession)
        }
      } catch {
        print(error)
      }
    }
  }
  
  func loadSettings() {
    let fetchRequest: NSFetchRequest<SettingsMO> = SettingsMO.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "session", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
      let context = appDelegate.persistentContainer.viewContext
      let fetchResultControllerSettings = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      
      
      do {
        try fetchResultControllerSettings.performFetch()
        if let fetchedObjects = fetchResultControllerSettings.fetchedObjects {
          settings = fetchedObjects
        }
      } catch {
        print(error)
      }
    }
  }
  
  func isAtActiveSession(player: PlayerMO) -> Bool {
    return player.session == settings[0].session
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Hide the navigation bar on the this view controller
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Show the navigation bar on other view controllers
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  let reuseIdentifier = "CollectionCell" // also enter this string as the cell identifier in the storyboard
  
  // MARK: - UICollectionViewDataSource protocol
  
  // tell the collection view how many cells to make
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.players.count
  }
  
  // make a cell for each cell index path
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    // get a reference to our storyboard cell
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TopCollectionViewCell
    
    // Use the outlet in our custom class to get a reference to the UILabel in the cell
    let player = self.players[indexPath.item]
    cell.nameLabel.text = player.name
    cell.scoreLabel.text = String(player.score)
    cell.positionLabel.text = String(indexPath.item + 1)
    if let playerAvatar = player.image {
      cell.avatarImageView.image = UIImage(data: playerAvatar as Data)
    }
    
    return cell
  }
  
  // MARK: - UICollectionViewDelegate protocol
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // handle tap events
    print("You selected cell #\(indexPath.item)!")
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
