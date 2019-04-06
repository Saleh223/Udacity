//
//  ViewController.swift
//  Meme_Me 0.1
//
//  Created by Saleh on 03/04/2019.
//  Copyright © 2019 Saleh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate , UITextFieldDelegate{

   
  
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var albumBtn: UIBarButtonItem!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var toolbarTop: UIToolbar!
    @IBOutlet weak var toolbarDown: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    var keboardIsHide: Bool!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        PrepareTextField(bottomTextField)
        PrepareTextField(topTextField)
        keboardIsHide = true
       
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        toolbarDown.isHidden = true
             if(keboardIsHide) {
            view.frame.origin.y -= getKeyboardHeight(notification) * (0.75)
        }
        keboardIsHide = false
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
      toolbarDown.isHidden = false
      if(!keboardIsHide) {
        view.frame.origin.y = 0
      }
      keboardIsHide = true
    }
    

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func ablumBtnAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraBtnAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnShare(_ sender: Any) {
        let memeImg = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memeImg], applicationActivities: nil)
        present(controller,animated: true, completion: nil)
        
        controller.completionWithItemsHandler = { (activity, success, items, error) in
            if(success) {
               self.save()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
        if(textField.isEqual(bottomTextField)) {
            unsubscribeFromKeyboardNotifications()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = " "
        if(textField.isEqual(bottomTextField)) {
        subscribeToKeyboardNotifications()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
      if let image = info[.originalImage] as? UIImage {
        imagePickerView.image = image
        imagePickerView.contentMode = .scaleAspectFit
        shareBtn.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func PrepareTextField(_ textField: UITextField) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 0]
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memeImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        toolbarTop.isHidden = true
        toolbarDown.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        toolbarTop.isHidden = false
        toolbarDown.isHidden = false
        
        return memedImage
    }
}



