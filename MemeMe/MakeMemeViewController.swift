//
//  MakeMemeViewController.swift
//  MemeMe
//
//  Created by Max Campolo on 3/22/15.
//  Copyright (c) 2015 Max Campolo. All rights reserved.
//

import UIKit

class MakeMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Class variables

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var takePhotoButton: UIBarButtonItem!
    @IBOutlet weak var choosePhotoButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupInterfaceAttributes()
        // And initially set the share button disabled
        self.shareButton.enabled = false
        // Register for keyboard notifications
        registerForKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Disable take photo button if there is no camera
        self.takePhotoButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.topTextField.isFirstResponder()  {
            self.topTextField.resignFirstResponder()
        }
        if self.bottomTextField.isFirstResponder() {
            self.bottomTextField.resignFirstResponder()
        }
    }
    
    deinit {
        // Unsubscribe from notificaitons
        //removeObserverForKeyboardNotifications()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Setup
    
    func setupInterfaceAttributes() {
        // Set the text field delegates
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        // And set the text field text attributes
        let memeTextAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(), NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSStrokeWidthAttributeName : 2, NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        // Set alignment
        self.topTextField.textAlignment = NSTextAlignment.Center
        self.bottomTextField.textAlignment = NSTextAlignment.Center
    }
    
    // MARK: - Action

    @IBAction func handleTakePhotoPressed(sender: AnyObject) {
        // Instantiate image picker
        let imagePicker = UIImagePickerController()
        // Set delegate and source
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        // Present view controller
        self.presentViewController(imagePicker, animated: true, completion:nil)
    }

    @IBAction func handleChoosePhotoPressed(sender: AnyObject) {
        // Instantiate image picker
        let imagePicker = UIImagePickerController()
        // Set delegate and source
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        // Present view controller
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Dismiss keyboard when tapping on screen
        self.view.endEditing(true)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memeImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memeImage as UIImage], applicationActivities: nil)
        // Set the completion handler
        activityVC.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
                println("completed \(s) \(ok) \(items) \(err)")
                let meme = self.createMemeObject()
                // If the user wants to share, we will save the meme otherwise do nothing
            if ok == true {
                SharedMemeDataSource.sharedInstance.memeDataSource.append(meme)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
        // Present the activity view controller
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func handleCancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Helper
    
    func createMemeObject() -> Meme {
        let meme = Meme(topText: self.topTextField.text, bottomText: self.bottomTextField.text, image: self.selectedImageView.image, memedImage: generateMemedImage())
        return meme
    }
    
    func generateMemedImage() -> UIImage {
        // Set interface elements hidden
        self.toolbar.hidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Render view to an image
        //let memeView = CGRectMake(self.selectedImageView.frame.origin.x, self.selectedImageView.frame.origin.y, self.selectedImageView.frame.size.width, self.selectedImageView.frame.size.height)
        let memeFrame = self.view.frame
        //UIGraphicsBeginImageContext(CGSizeMake(memeView.width, memeView.height))
        UIGraphicsBeginImageContext(memeFrame.size)
        self.view.drawViewHierarchyInRect(memeFrame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // And reshow the interface elements
        self.toolbar.hidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    
        return memedImage
    }
    
    // MARK: - Image Picker Controller Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // Set the image in the image view
        selectedImageView.image = image
        // And dismiss the picker controller
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        // Set the image in the image view
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.selectedImageView.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.selectedImageView.image = image
        }
        // And dismiss the picker controller
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            // Set the share button enabled
            self.shareButton.enabled = true
        })
        
        // And make sure the tool bar is shown
        self.view.bringSubviewToFront(self.toolbar)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // User cancelled picking image - dismiss view controller
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Clear the text in the text field
        if textField.text == "TOP" {
            textField.text = ""
        }
        if textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Dismiss the keyboard
        textField.resignFirstResponder()
        // And reset if necessary
        if textField == self.topTextField && textField.text == "" {
            textField.text = "TOP"
        } else if textField == self.bottomTextField && textField.text == "" {
            textField.text = "BOTTOM"
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Reset the text field if necessary
        if textField == self.topTextField && textField.text == "" {
            textField.text = "TOP"
        } else if textField == self.bottomTextField && textField.text == "" {
            textField.text = "BOTTOM"
        }
    }
    
    // MARK: - Keyboard Handler
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeObserverForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: UIKeyboardWillHideNotification)
        NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: UIKeyboardWillShowNotification)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= self.getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = UIScreen.mainScreen().bounds.origin.y
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
}

struct Meme {
    var topText : NSString?
    var bottomText :NSString?
    var image : UIImage?
    var memedImage: UIImage?
}

