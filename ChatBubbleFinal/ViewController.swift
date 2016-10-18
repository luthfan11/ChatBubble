//
//  ViewController.swift
//  ChatBubbleFinal
//
//  Created by Sauvik Dolui on 02/09/15.
//  Copyright (c) 2015 Innofied Solution Pvt. Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var messageComposingView: UIView!
    @IBOutlet weak var messageCointainerScroll: UIScrollView!
    @IBOutlet weak var buttomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var viewAttachments: UIView!
    
    // block attachment
    @IBOutlet weak var blockA1: UIView!
    @IBOutlet weak var blockA2: UIView!
    
    
    var selectedImage : UIImage?
    var lastChatBubbleY: CGFloat = 10.0
    var internalPadding: CGFloat = 8.0
    var lastMessageType: BubbleDataType?
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false //2
        imagePicker.sourceType = .photoLibrary //3
        sendButton.isEnabled = false
        viewAttachments.isHidden = true
//        blockA1.isHidden = true
//        blockA2.isHidden = true
        viewAttachments?.backgroundColor = UIColor(hue: 0.9222, saturation: 0.5, brightness: 0.04, alpha: 0.5)
        
        //add gesture for action viewAttachments
        let gesture = UITapGestureRecognizer(target: self, action: "closeAttachment:")
        viewAttachments.addGestureRecognizer(gesture)
        
        let chatBubbleData1 = ChatBubbleData(text: "Hey !!!", image:UIImage(named: "chatImage1.jpg"), date: Date(), type: .mine)
        addChatBubble(chatBubbleData1)
        
        let chatBubbleData2 = ChatBubbleData(text: "Nice.... what about this oneblablablablablablablablablablablablablablablablablablablablablabla", image:UIImage(named: "chatImage3.jpg"), date: Date(), type: .opponent)
        addChatBubble(chatBubbleData2)
        
        let chatBubbleData3 = ChatBubbleData(text: "Great Bro....!blablablablablablablablablablablablablablablablablablablablablablablabla!!", image:nil, date: Date(), type: .mine)
        addChatBubble(chatBubbleData3)
        
        self.messageCointainerScroll.contentSize = CGSize(width: messageCointainerScroll.frame.width, height: lastChatBubbleY + internalPadding)
        self.addKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        moveToLastMessage();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    // MARK:- Notification
    func keyboardWillShow(_ notification: Notification) {
        var info = (notification as NSNotification).userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            //self.buttomLayoutConstraint = keyboardFrame.size.height
            self.buttomLayoutConstraint.constant = keyboardFrame.size.height

            }, completion: { (completed: Bool) -> Void in
                    self.moveToLastMessage()
        }) 
    }
    
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.buttomLayoutConstraint.constant = 0.0
            }, completion: { (completed: Bool) -> Void in
                self.moveToLastMessage()
        }) 
    }
    
    @IBAction func sendButtonClicked(_ sender: AnyObject) {
        self.addRandomTypeChatBubble()
        textField.resignFirstResponder()
    }
    
    @IBAction func cameraButtonClicked(_ sender: AnyObject) {
        self.present(imagePicker, animated: true, completion: nil)//4
    }
    
    
    func addRandomTypeChatBubble() {
        var bubbleData = ChatBubbleData(text: textField.text, image: selectedImage, date: Date(), type: getRandomChatDataType())
        addChatBubble(bubbleData)
    }
    func addChatBubble(_ data: ChatBubbleData) {
        
        let padding:CGFloat = lastMessageType == data.type ? internalPadding/3.0 :  internalPadding
        let chatBubble = ChatBubble(data: data, startY:lastChatBubbleY + padding)
        self.messageCointainerScroll.addSubview(chatBubble)
        
        lastChatBubbleY = chatBubble.frame.maxY
        
        
        self.messageCointainerScroll.contentSize = CGSize(width: messageCointainerScroll.frame.width, height: lastChatBubbleY + internalPadding)
        self.moveToLastMessage()
        lastMessageType = data.type
        textField.text = ""
        sendButton.isEnabled = false
    }
    
    func moveToLastMessage() {

        if messageCointainerScroll.contentSize.height > messageCointainerScroll.frame.height {
            let contentOffSet = CGPoint(x: 0.0, y: messageCointainerScroll.contentSize.height - messageCointainerScroll.frame.height)
            self.messageCointainerScroll.setContentOffset(contentOffSet, animated: true)
        }
    }
    func getRandomChatDataType() -> BubbleDataType {
        return BubbleDataType(rawValue: Int(arc4random() % 2))!
    }
    
    // function for show view attachments
    @IBAction func showAttachment(_ sender: AnyObject) {
        if viewAttachments.isHidden {
            viewAttachments.isHidden = false
//            blockA1.isHidden = true
        } else{
            viewAttachments.isHidden = true
        }
    }
    // close attachment
    func closeAttachment(_ sender:ViewController){
        // do other task
        viewAttachments.isHidden = true
    }
    
}


// MARK: TEXT FILED DELEGATE METHODS

extension ViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Send button clicked
        textField.resignFirstResponder()
        self.addRandomTypeChatBubble()
        return true
    }
    
    @objc(textField:shouldChangeCharactersInRange:replacementString:) func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text: String
        
//        if (textField.text?.count)! > 0 {
//            text = String(format:"%@%@",textField.text!, string);
//        } else {
////            var string = textField.text as NSString
////            text = string.substringToIndex(string.length - 1) as String
//        }
//        if text.characters.count > 0 {
//            sendButton.isEnabled = true
//        } else {
//            sendButton.isEnabled = false
//        }
        sendButton.isEnabled = true
        return true
    }
}
//
extension ViewController{
    //MARK: Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
    @nonobjc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable: Any]) {
        
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        var bubbleData = ChatBubbleData(text: textField.text, image: chosenImage, date: Date(), type: getRandomChatDataType())
        addChatBubble(bubbleData)
        picker.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
}

