//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Max Campolo on 4/19/15.
//  Copyright (c) 2015 Max Campolo. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var memeImageView: UIImageView!
    var memeImage: UIImage?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.memeImageView.image = memeImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
