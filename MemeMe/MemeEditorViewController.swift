//
//  ViewController.swift
//  MemeMe
//
//  Created by Nicholas Allio on 22/03/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldWithInitialText(topTextField, text: "TOP")
        setupTextFieldWithInitialText(bottomTextField, text: "BOTTOM")
        
        shareButton.enabled = false
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    func setupTextFieldWithInitialText(textField: UITextField, text: String) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : Float(-1.0)
        ]
        
        textField.text = text
        textField.delegate = self
        textField.textAlignment = .Center
        textField.defaultTextAttributes = memeTextAttributes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(shiftUpBecauseOfKeyboard(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(shiftDownBecauseOfKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func shiftUpBecauseOfKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = keyboardSize.CGRectValue().height * -1
        }
            }
    
    func shiftDownBecauseOfKeyboard(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }

    @IBAction func pickImagePhotoLibrary(sender: AnyObject) {
        pickImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickImageCamera(sender: AnyObject) {
        pickImageFromSource(UIImagePickerControllerSourceType.Camera)
    }
    
    func pickImageFromSource(source: UIImagePickerControllerSourceType) {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.sourceType = source
        presentViewController(imagePickerViewController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            shareButton.enabled = true
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func saveMeme(memed: UIImage) {
        let meme = Meme(topText: topTextField.text!, image: memed, bottomText: bottomTextField.text!)
        var memes = [Meme]()
        if let savedMemes = NSKeyedUnarchiver.unarchiveObjectWithFile(Meme.ArchiveURL.path!) as? [Meme] {
            memes += savedMemes
        } // else is the first meme
        
        memes.append(meme!)
        NSKeyedArchiver.archiveRootObject(memes, toFile: Meme.ArchiveURL.path!)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbars
        topToolBar.hidden = true
        bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbars
        topToolBar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }

    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let shareViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(shareViewController, animated: true, completion: nil)
        shareViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            self.saveMeme(memedImage)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cancelCreation(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

