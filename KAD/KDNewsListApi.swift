//
//  KDNewsListApi.swift
//  KAD
//
//  Created by 开心马骝 on 14-8-6.
//  Copyright (c) 2014年 GuChengFeng. All rights reserved.
//

import Foundation

class KDNewsListApi
{
    var delegate:KDNewsListController
    
    var url:String
    
    var connection:NSURLConnection?

    init(delegate:KDNewsListController, url:String)
    {
        self.delegate = delegate
        
        self.url = url
        
        self.getNewsData()
    }
    
    func getNewsData()
    {
        var url:NSURL = NSURL(string:self.url)!
        
        var request:NSURLRequest = NSURLRequest(URL:url)
        
        connection = NSURLConnection(request:request, delegate:delegate, startImmediately:false)
        
        println("NewsListUrl is :\(self.url)")
        
        connection!.start()
    }
    
    func reopenConnection()
    {
        if ((connection) != nil)
        {
           connection = nil
            
           self.getNewsData()
        }
    }
    
    func closeConnection()
    {
        if ((connection) != nil)
        {
            connection = nil
        }
    }
}