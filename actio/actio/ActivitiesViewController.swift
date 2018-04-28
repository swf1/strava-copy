//
//  ActivitiesViewController.swift
//  actio
//
//  Contributors:
//    Alieta Train
//    Tyler Mcginnis on 4/22/18.
//    Jason Hoffman
//  Copyright © 2018 corvus group. All rights reserved.
//

import UIKit
import Firebase

class ActivitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var firebase: FirebaseAdapter!
    var activities: [Activity]! = []
    fileprivate var _refHandle: DatabaseHandle!

    @IBOutlet weak var clientTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clientTable.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        firebase = FirebaseAdapter(model: "activities")
        _refHandle = firebase.getRef().observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            guard let activity = Activity(snapshot: snapshot) else { return }
            strongSelf.activities.append(activity)
            strongSelf.clientTable.insertRows(
                at: [IndexPath(row: strongSelf.activities.count-1, section: 0)],
                with: .automatic
            )
        })
    }

    deinit {
        if _refHandle != nil {
            firebase.getRef().removeObserver(withHandle: _refHandle)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.clientTable.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        let activity = self.activities[indexPath.row]
        cell.textLabel?.text = "\(activity.name)"
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
