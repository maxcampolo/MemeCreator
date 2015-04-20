//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Max Campolo on 4/19/15.
//  Copyright (c) 2015 Max Campolo. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memesDataSource: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.setupDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Reload the table view
        self.updateDataSource()
    }
    
    // MARK: - Setup
    
    func setupDataSource() {
        self.memesDataSource = SharedMemeDataSource.sharedInstance.memeDataSource
    }
    
    // MARK: - Action
    
    @IBAction func newMeme(sender: AnyObject) {
        // Present the make meme view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("makeMemeNavController") as! UINavigationController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - Helper
    
    func updateDataSource() {
        if SharedMemeDataSource.sharedInstance.memeDataSource.count != self.memesDataSource.count {
            self.memesDataSource = SharedMemeDataSource.sharedInstance.memeDataSource
        }
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Our table view will have one section
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of items in the data source
        print(self.memesDataSource)
        return self.memesDataSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeTableViewCell", forIndexPath: indexPath) as! MemeTableViewCell

        // Configure the cell...
        cell.setupCellWithMeme(self.memesDataSource[indexPath.row])

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "memeDetailViewSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let destinationVC = segue.destinationViewController as! MemeDetailViewController
            destinationVC.memeImage = self.memesDataSource[indexPath!.row].memedImage
        }
    }

}
