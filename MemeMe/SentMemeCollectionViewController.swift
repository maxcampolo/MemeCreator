//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Max Campolo on 4/19/15.
//  Copyright (c) 2015 Max Campolo. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"
let memeReuseIdentifier = "memeCollectionViewCell"

class SentMemeCollectionViewController: UICollectionViewController {
    
    var memesDataSource: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        //self.collectionView!.registerClass(MemeCollectionViewCell.self, forCellWithReuseIdentifier: memeReuseIdentifier)
        // Do any additional setup after loading the view.
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
    
    @IBAction func handleCreateMemePressed(sender: AnyObject) {
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
        self.collectionView!.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memesDataSource.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(memeReuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
    
        // Configure the cell
        cell.memeImageView.image = self.memesDataSource[indexPath.row].memedImage
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        if segue.identifier == "memeCollectionDetailViewSegue" {
            let indexPath: AnyObject? = self.collectionView!.indexPathsForSelectedItems().first
            let destinationVC = segue.destinationViewController as! MemeDetailViewController
            destinationVC.memeImage = self.memesDataSource[indexPath!.row].memedImage
        }
    }
    

}
