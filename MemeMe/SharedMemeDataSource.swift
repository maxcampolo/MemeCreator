//
//  SharedMemeDataSource.swift
//  MemeMe
//
//  Created by Max Campolo on 4/19/15.
//  Copyright (c) 2015 Max Campolo. All rights reserved.
//

/*
*   This class is a singleton instance used to store the shared Memes data source.
*   This is my preference to storing the array in the App Delegate.
*/

import UIKit

// Create private global shared class instance
private let oneInstance = SharedMemeDataSource()

class SharedMemeDataSource: NSObject {
    
    // Initialize data source
    var memeDataSource = [Meme]()
   
    // Get the shared instance
    class var sharedInstance: SharedMemeDataSource {
        return oneInstance
    }
}
