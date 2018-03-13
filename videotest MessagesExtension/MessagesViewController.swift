//
//  MessagesViewController.swift
//  videotest MessagesExtension
//
//  Created by Paul Freeman on 12/03/2018.
//  Copyright © 2018 Paul Freeman. All rights reserved.
//

import UIKit
import Messages

protocol MessagesController {
    func getActiveConversation() -> MSConversation?
}

extension MSMessagesAppViewController: MessagesController {
    func getActiveConversation() -> MSConversation? {
         return self.activeConversation
    }
}

class MessagesViewController: MSMessagesAppViewController {
    
    var currentViewController: UIViewController? = nil
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Use this method to configure the extension and restore previously stored state.
        switch self.presentationStyle {
            case  .transcript :  showVideoVC(); break ;
            default : showAppVC()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - View Controllers
    
    
    func presentViewControllerInContainer(_ controller:UIViewController?) {
    
        guard let controller = controller else { return }
        
        //just for keeping track (model?)
        self.currentViewController = controller
        
        removeAllChildViewControllers()
        
        controller.willMove(toParentViewController: self)
        
        controller.view.alpha = 0.0
        
        addChildViewController(controller)
        
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        controller.didMove(toParentViewController: self)
        
        UIView.animate(withDuration: 0.6) {
            controller.view.alpha = 1.0
        }
     }
 
    override func contentSizeThatFits(_ size: CGSize) -> CGSize {
         print("need content size to fit \(size)")
         let aspect =  CGFloat(16/9)
         return CGSize(width: size.height * aspect , height: size.height)
    }

    func removeAllChildViewControllers() {
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }

    func showVideoVC() {
        guard let vc = UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController else { return }
        vc.messagesController = self
        presentViewControllerInContainer(vc)
    }
    
    func showAppVC() {
        guard let vc = UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "AppViewController") as? AppViewController else { return }
        vc.messagesController = self
        presentViewControllerInContainer(vc)
    }
    
    // MARK: - Conversation Handling
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
        
        switch presentationStyle {
            case  .transcript :  showVideoVC(); break ;
            default : showAppVC()
        }
        
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
     
    
    //MARK: Unused
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
       
        
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        
        // Use this to clean up state related to the deleted message.
    }

}
