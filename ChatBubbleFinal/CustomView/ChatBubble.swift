//
//  ChatBubble.swift
//  ChatBubbleScratch
//
//  Created by Sauvik Dolui on 02/09/15.
//  Copyright (c) 2015 Innofied Solution Pvt. Ltd. All rights reserved.
//

import UIKit

class ChatBubble: UIView {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    // Properties
    var imageViewChat: UIImageView?
    var imageViewBG: UIImageView?
    var imageDoubleTick: UIImageView?
    var text: String?
    var labelChatText: UILabel?
    var labelTimeSend: UILabel?
    
    /**
     Initializes a chat bubble view
     
     :param: data   ChatBubble Data
     :param: startY origin.y of the chat bubble frame in parent view
     
     :returns: Chat Bubble
     */
    init(data: ChatBubbleData, startY: CGFloat){
        
        // 1. Initializing parent view with calculated frame
        super.init(frame: ChatBubble.framePrimary(data.type, startY:startY))
        
        // Making Background transparent
        self.backgroundColor = UIColor.clear
        // status space chatImage
        var boolSpace:Bool=true
        
        let padding: CGFloat = 10.0
        
        // 2. Drawing image if any
        if let chatImage = data.image {
            
            let width: CGFloat = min(chatImage.size.width, self.frame.width - 2 * padding)
            print("min =================================== ", min(10,30))
            if width == self.frame.width - 2 * padding {
                boolSpace = false
                print("BoolSpace ====================================== ",boolSpace)
            }
            let height: CGFloat = chatImage.size.height * (width / chatImage.size.width)
            imageViewChat = UIImageView(frame: CGRect(x: padding, y: padding, width: width, height: height))
            imageViewChat?.image = chatImage
            imageViewChat?.layer.cornerRadius = 5.0
            imageViewChat?.layer.masksToBounds = true
            self.addSubview(imageViewChat!)
        }
        
        // 3. Going to add Text if any
        if let chatText = data.text {
            // frame calculation
            var startX = padding
            var startY:CGFloat = 5.0
            if let imageView = imageViewChat {
                startY += imageViewChat!.frame.maxY
            }
            labelChatText = UILabel(frame: CGRect(x: startX, y: startY, width: self.frame.width - 2 * startX , height: 5))
            labelChatText?.textAlignment = data.type == .mine ? .left : .left
            labelChatText?.font = UIFont.systemFont(ofSize: 14)
            labelChatText?.numberOfLines = 0 // Making it multiline
            print("numberOfLines ============================= ",labelChatText?.numberOfLines)
            labelChatText?.text = data.text
            labelChatText?.sizeToFit() // Getting fullsize of it
            self.addSubview(labelChatText!)
            
            if let imageView = imageViewChat {
                print("status imagechat")
                imageDoubleTick = UIImageView(frame: CGRect(x: max(imageViewChat!.frame.maxX, labelChatText!.frame.maxX) + padding - 60, y: labelChatText!.frame.maxY + padding/2 + 2, width: 10 , height: 10))
                imageDoubleTick?.image = UIImage(named: "DoubleTick.png")
                self.addSubview(imageDoubleTick!)
                
                // set label time on viewChat
                labelTimeSend = UILabel(frame: CGRect(x: max(imageViewChat!.frame.maxX, labelChatText!.frame.maxX) + padding - 45, y: labelChatText!.frame.maxY + padding/2, width: self.frame.width - 2 * startX , height: 5))
                labelTimeSend?.textAlignment = data.type == .mine ? .right : .left
                labelTimeSend?.font = UIFont.systemFont(ofSize: 10)
                labelTimeSend?.numberOfLines = 0 // Making it multiline
                labelTimeSend?.text = "10:19"
                labelTimeSend?.sizeToFit() // Getting fullsize of it
                self.addSubview(labelTimeSend!)            }
            // setting for more 1(one) line
            else if labelChatText!.frame.maxY != 22.0 {
                //set double tick
                print("status !22.0")
                imageDoubleTick = UIImageView(frame: CGRect(x: labelChatText!.frame.width + labelChatText!.frame.minX + padding - 60, y: labelChatText!.frame.maxY + padding/2 + 2, width: 10 , height: 10))
                imageDoubleTick?.image = UIImage(named: "DoubleTick.png")
                self.addSubview(imageDoubleTick!)
                
                // set label time on viewChat
                labelTimeSend = UILabel(frame: CGRect(x: labelChatText!.frame.width + labelChatText!.frame.minX + padding - 45, y: labelChatText!.frame.maxY + padding/2, width: self.frame.width - 2 * startX , height: 5))
                labelTimeSend?.textAlignment = data.type == .mine ? .right : .left
                labelTimeSend?.font = UIFont.systemFont(ofSize: 10)
                labelTimeSend?.numberOfLines = 0 // Making it multiline
                labelTimeSend?.text = "10:19"
                labelTimeSend?.sizeToFit() // Getting fullsize of it
                self.addSubview(labelTimeSend!)
                // setting for 1(one) line
            }
            else {
                //set double tick
                print("status else")
                imageDoubleTick = UIImageView(frame: CGRect(x: labelChatText!.frame.width + labelChatText!.frame.minX + padding - 5, y: labelChatText!.frame.maxY - 12, width: 10 , height: 10))
                imageDoubleTick?.image = UIImage(named: "DoubleTick.png")
                self.addSubview(imageDoubleTick!)
                
                // set label time on viewChat
                labelTimeSend = UILabel(frame: CGRect(x: labelChatText!.frame.width + labelChatText!.frame.minX + padding - -5, y: labelChatText!.frame.maxY - 13, width: self.frame.width - 2 * startX , height: 5))
                labelTimeSend?.textAlignment = data.type == .mine ? .right : .left
                labelTimeSend?.font = UIFont.systemFont(ofSize: 10)
                labelTimeSend?.numberOfLines = 0 // Making it multiline
                labelTimeSend?.text = "10:19"
                labelTimeSend?.sizeToFit() // Getting fullsize of it
                self.addSubview(labelTimeSend!)
            }
            
        }
        
        // 4. Calculation of new width and height of the chat bubble view
        var viewHeight: CGFloat = 0.0
        var viewWidth: CGFloat = 0.0
        if let imageView = imageViewChat {
            // Height calculation of the parent view depending upon the image view and text label
            viewWidth = max(imageViewChat!.frame.maxX, labelChatText!.frame.maxX) + padding
            viewHeight = max(imageViewChat!.frame.maxY, labelChatText!.frame.maxY) + padding + 20
//            if (data.text?.characters.count)! > 30 {
//                viewHeight = max(imageViewChat!.frame.maxY, labelChatText!.frame.maxY) + padding + 20
//            }else {
//                viewHeight = max(imageViewChat!.frame.maxY, labelChatText!.frame.maxY) + padding
//            }
            print("status in")
            
        } else {
            if labelChatText!.frame.maxY != 22.0 {
                viewHeight = labelChatText!.frame.maxY + padding/2 + 20
                viewWidth = labelChatText!.frame.width + labelChatText!.frame.minX + padding
            }else {
                viewHeight = labelChatText!.frame.maxY + padding/2
                viewWidth = labelChatText!.frame.width + labelChatText!.frame.minX + padding + 40
            }
            print("labelChatText!.frame.maxY ==================================== ",labelChatText!.frame.maxY)
            
        }
        
        // 5. Adding new width and height of the chat bubble frame
        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: viewWidth, height: viewHeight)
        
        // 6. Adding the resizable image view to give it bubble like shape
        let bubbleImageFileName = data.type == .mine ? "bubbleMine" : "bubbleSomeone"
        imageViewBG = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        if data.type == .mine {
            imageViewBG?.image = UIImage(named: bubbleImageFileName)?.resizableImage(withCapInsets: UIEdgeInsetsMake(14, 14, 17, 28))
        } else {
            imageViewBG?.image = UIImage(named: bubbleImageFileName)?.resizableImage(withCapInsets: UIEdgeInsetsMake(14, 22, 17, 20))
        }
        self.addSubview(imageViewBG!)
        self.sendSubview(toBack: imageViewBG!)
        
        // Frame recalculation for filling up the bubble with background bubble image
        var repsotionXFactor:CGFloat = data.type == .mine ? 0.0 : -8.0
        var bgImageNewX = imageViewBG!.frame.minX + repsotionXFactor
        var bgImageNewWidth =  imageViewBG!.frame.width + CGFloat(12.0)
        var bgImageNewHeight =  imageViewBG!.frame.height + CGFloat(6.0)
        imageViewBG?.frame = CGRect(x: bgImageNewX, y: 0.0, width: bgImageNewWidth, height: bgImageNewHeight)
        
        
        // Keepping a minimum distance from the edge of the screen
        var newStartX:CGFloat = 0.0
        if data.type == .mine {
            // Need to maintain the minimum right side padding from the right edge of the screen
            var extraWidthToConsider = imageViewBG!.frame.width
            newStartX = ScreenSize.SCREEN_WIDTH - extraWidthToConsider
        } else {
            // Need to maintain the minimum left side padding from the left edge of the screen
            newStartX = -imageViewBG!.frame.minX + 3.0
        }
        
        self.frame = CGRect(x: newStartX, y: self.frame.minY, width: frame.width, height: frame.height)
        
    }
    
    // 6. View persistance support
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FRAME CALCULATION
    class func framePrimary(_ type:BubbleDataType, startY: CGFloat) -> CGRect{
        let paddingFactor: CGFloat = 0.02
        let sidePadding = ScreenSize.SCREEN_WIDTH * paddingFactor
        let maxWidth = ScreenSize.SCREEN_WIDTH * 0.65 // We are cosidering 65% of the screen width as the Maximum with of a single bubble
        let startX: CGFloat = type == .mine ? ScreenSize.SCREEN_WIDTH * (CGFloat(1.0) - paddingFactor) - maxWidth : sidePadding
        return CGRect(x: startX, y: startY, width: maxWidth, height: 5) // 5 is the primary height before drawing starts
    }
    
}
