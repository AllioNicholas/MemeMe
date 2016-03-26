//
//  ViewController.swift
//  MemeMe
//
//  Created by Nicholas Allio on 22/03/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    struct Meme {
        var topText: String
        var bottomText: String
        var image: UIImage
        var memedImage: UIImage
    }

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : Float(-1.0)
        ]
        
        topTextField.text = "TOP"
        topTextField.delegate = self
        topTextField.textAlignment = .Center
        topTextField.defaultTextAttributes = memeTextAttributes
        
        bottomTextField.text = "BOTTOM"
        bottomTextField.delegate = self
        bottomTextField.textAlignment = .Center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        shareButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(shiftUpBecauseOfKeyboard(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(shiftDownBecauseOfKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func shiftUpBecauseOfKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        self.view.frame.origin.y -= keyboardSize.CGRectValue().height
    }
    
    func shiftDownBecauseOfKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo
        print(userInfo)
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        self.view.frame.origin.y += keyboardSize.CGRectValue().height
    }

    @IBAction func pickImagePhotoLibrary(sender: AnyObject) {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func pickImageCamera(sender: AnyObject) {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.sourceType = UIImagePickerControllerSourceType.Camera
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
    
    func saveMeme() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navigationController?.toolbar.hidden = true
        navigationController?.navigationBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navigationController?.toolbar.hidden = false
        navigationController?.navigationBar.hidden = false
        
        return memedImage
    }

    @IBAction func shareMeme(sender: AnyObject) {
        let shareViewController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        presentViewController(shareViewController, animated: true, completion: nil)
        shareViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            self.saveMeme()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

