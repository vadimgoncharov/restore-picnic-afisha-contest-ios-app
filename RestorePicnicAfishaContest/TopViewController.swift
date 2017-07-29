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
  
  @IBOutlet var player1View: UIView!
  @IBOutlet var player1name: UILabel!
  @IBOutlet var player1score: UILabel!
  @IBOutlet var player1avatar: UIImageView!
  
  
  @IBOutlet var player2View: UIView!
  @IBOutlet var player2name: UILabel!
  @IBOutlet var player2score: UILabel!
  @IBOutlet var player2avatar: UIImageView!
  
  
  @IBOutlet var player3View: UIView!
  @IBOutlet var player3name: UILabel!
  @IBOutlet var player3score: UILabel!
  @IBOutlet var player3avatar: UIImageView!
  
  @IBOutlet var top3View: UIView!
  @IBOutlet var restPlayersView: UICollectionView!
  @IBOutlet var mainView: UIView!
  
  var players:[PlayerMO] = []
  var settings:[SettingsMO] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      loadSettings()
      loadPlayers()
      setTop3PlayersValues()
      toggleTop3PlayersVisibility()
      
      scaleScreen()
    }
  
  func scaleScreen() {
    let scaleFactor = CGFloat(0.55)
    mainView.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
  }

  func loadPlayers() {
    let fetchRequest: NSFetchRequest<PlayerMO> = PlayerMO.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "score", ascending: false)
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
  
  /*
   pluralForm(28, forms: ["год", "года", "лет"])
   output: "лет"
   */
  func pluralForm(number: Int64, forms: [String]) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale(identifier: "FR_fr")
    let formattedNumber = formatter.string(for: number) ?? "0"
    
    let str = number % 10 == 1 && number % 100 != 11 ? forms[0] :
      (number % 10 >= 2 && number % 10 <= 4 && (number % 100 < 10 || number % 100 >= 20) ? forms[1] : forms[2])
    return "\(formattedNumber) \(str)"
  }
  
  
  var pluarFormsScore = ["очко", "очка", "очков"];
  

  func setTop3PlayersValues() {
    if (players.indices.contains(0)) {
      player1View.isHidden = false
      let player1 = players[0]
      player1name.text = player1.name
      player1score.text = pluralForm(number: player1.score, forms: pluarFormsScore)
      if let playerAvatar = player1.image {
        player1avatar.image = UIImage(data: playerAvatar as Data)
      }
    }
    else {
      player1View.isHidden = true
    }
    
    if (players.indices.contains(1)) {
      player2View.isHidden = false
      let player2 = players[1]
      player2name.text = player2.name
      player2score.text = pluralForm(number: player2.score, forms: pluarFormsScore)
      if let playerAvatar = player2.image {
        player2avatar.image = UIImage(data: playerAvatar as Data)
      }
    }
    else {
      player2View.isHidden = true
    }
    
    if (players.indices.contains(2)) {
      player3View.isHidden = false
      print(players[2])
      let player3 = players[2]
      player3name.text = player3.name
      player3score.text = pluralForm(number: player3.score, forms: pluarFormsScore)
      if let playerAvatar = player3.image {
        player3avatar.image = UIImage(data: playerAvatar as Data)
        
      }
    }
    else {
      player3View.isHidden = true
    }
  }
  
  func toggleTop3PlayersVisibility() {
    top3View.isHidden = false
    return
    
//    if (settings[0].is_game_finished) {
//      top3View.isHidden = false
//      restPlayersView.frame = CGRect(x: 143, y: 277, width: 802, height: 433)
//    } else {
//      restPlayersView.frame = CGRect(x: 143, y: 150, width: 802, height: 433)
//      top3View.isHidden = true
//    }
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
    let totalCount = players.count
    if (settings[0].is_game_finished) {
      let withoutTop3Count = max(0, totalCount - 3)
      return min(15, withoutTop3Count)
    }
    else {
      return min(15, totalCount)
    }
    
  }
  
  // make a cell for each cell index path
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    // get a reference to our storyboard cell
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TopCollectionViewCell
    
    let indexIdWithoutTop3 = settings[0].is_game_finished ? indexPath.item + 3 : indexPath.item
    // Use the outlet in our custom class to get a reference to the UILabel in the cell
    if (players.indices.contains(indexIdWithoutTop3)) {
      let player = self.players[indexIdWithoutTop3]
      cell.nameLabel.text = player.name
      cell.scoreLabel.text = pluralForm(number: player.score, forms: pluarFormsScore)
      cell.positionLabel.text = String(indexIdWithoutTop3 + 1)
      if let playerAvatar = player.image {
        cell.avatarImageView.image = UIImage(data: playerAvatar as Data)
      }
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
