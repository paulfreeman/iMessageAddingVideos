//
//  AppViewController.swift
//  videotest MessagesExtension
//
//  Created by Paul Freeman on 12/03/2018.
//  Copyright © 2018 Paul Freeman. All rights reserved.
//

import UIKit
import Messages

class AppViewController: UIViewController {
 
    @IBOutlet weak var addingStyle: UILabel!
    var addAsLayoutTemplate = true
    
    var messagesController : MessagesController?
    
    @IBAction func saveAsLayout(_ sender: Any) {
        guard let sw = sender as? UISwitch else { return }
        self.addAsLayoutTemplate = sw.isOn
        addingStyle.text = self.addAsLayoutTemplate ? "Add as MSMessagesTemplateLayout" : "Add as an attachment"
    }
    
    @IBAction func addVideo(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "SampleVideo", ofType: "MP4") else {  print("no path to resource"); return }
        let url = URL(fileURLWithPath: path) //else {  print("no path to resource") ; return }
        self.composeMessage(with: url, caption: "Sample Video")
    }
    
    fileprivate func composeMessage(with mediaUrl: URL, caption: String)   {
        
        guard let convo  = messagesController?.getActiveConversation()  else { print("fail no iMessage conversation"); return }
    
        
        //NOTE: inserting video into layout caused memory problems and crashes (and also performance problems because of too many autoplaying high res videos in current thread)
        if self.addAsLayoutTemplate {
            addAsLiveLayout(conversation: convo, with:mediaUrl, caption:caption)
        }
            //NOTE: inserting video as an attachment does not cause any problems
        else {
            convo.insertAttachment(mediaUrl, withAlternateFilename: "Sample.MP4",  completionHandler : { error in
                if let error = error {
                    print(error)
                }
            })
        }
    }
    
    //The version that caused a memory issue
    func addAsLiveLayout(conversation: MSConversation, with mediaUrl: URL, caption: String ) {
        
        let  session = conversation.selectedMessage?.session
        
        //1. Instantiate new Layout (following exact sequence suggested in Docs)
        let layout = MSMessageLiveLayout(alternateLayout:  getTemplateLayout(mediaUrl, caption:caption))
      
        let message = MSMessage(session: session ?? MSSession())
        message.url =  URL(string: "http://www.paulfreeman.com")
        
        //3. Assign the instance to the MSMessages layout property
        message.layout = layout
        
        conversation.insert(message, completionHandler: { error in
            if let error = error {
                print(error)
            }
        })
    }
    
    func getTemplateLayout(_  mediaUrl: URL, caption: String) -> MSMessageTemplateLayout {
     
        //1. Instantiate new Layout (following exact sequence suggested in Docs)
        let layout = MSMessageTemplateLayout()
        
        //2. Assign values to the desired layout properties
        layout.mediaFileURL = mediaUrl
        layout.caption = caption
        return layout
    }
    
    //The version that caused a memory issue
    func addAsLayoutTemplate(conversation: MSConversation, with mediaUrl: URL, caption: String ) {
       
        let  session = conversation.selectedMessage?.session
       
        //1. Instantiate new Layout (following exact sequence suggested in Docs)
        let layout = getTemplateLayout(mediaUrl, caption:caption)
        
        let message = MSMessage(session: session ?? MSSession())
        message.url =  URL(string: "http://www.paulfreeman.com")
        
        //3. Assign the instance to the MSMessages layout property
        message.layout = layout
        
        conversation.send(message, completionHandler: { error in
            if let error = error {
                print(error)
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
