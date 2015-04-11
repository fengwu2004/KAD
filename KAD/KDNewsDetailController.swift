//
//  ViewController.swift
//  KAD
//
//  Created by 开心马骝 on 14-8-6.
//  Copyright (c) 2014年 . All rights reserved.
//

import UIKit

class KDNewsDetailController: UIViewController {

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var kListApi:KDNewsDetailApi?
    var urlString:String = "http://news-at.zhihu.com/api/3/news/"//test id is 4074215
    var data:NSMutableData=NSMutableData()
    var aId:Int?
    var dicJson:NSDictionary=NSDictionary()
    
    @IBOutlet var labTitle : UILabel!
    @IBAction func btnReturn(sender : AnyObject) {
        
    }
    @IBOutlet var webContent : UIWebView!
    @IBOutlet var imgNews : UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.urlString="\(self.urlString)\(self.aId)"
        println("dddd:\(self.aId)")
        println("urlllstring:\(self.urlString)")
        kListApi=KDNewsDetailApi(delegate:self,url:self.urlString)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func connection(didReceiveResponse: NSURLConnection!,didReceiveResponse response: NSURLResponse!) {
            
            // Recieved a new request, clear out the data object
            self.data = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!,didReceiveData data: NSData!) {

            // Append the recieved chunk of data to our data object
            self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        
        var err: NSError
        
        dicJson = NSJSONSerialization.JSONObjectWithData(self.data,
            
            options:NSJSONReadingOptions.MutableContainers,
            
            error: nil) as NSDictionary
        
        print("NewsDetail Json Data:\(dicJson)")
        
        self.setupView()
    }
    
    func setupView()
    {
       var sTitle:String=dicJson["title"]? as String
       labTitle.text=sTitle
       var sImgNews=dicJson["image"] as String
       imgNews.setImage(sImgNews,placeHolder: UIImage(named:"001p9BkFgy6KqjPYZg74b&690.jpeg"))
       var body = dicJson["body"] as String
       webContent.loadHTMLString(body, baseURL: nil)
    }
}

