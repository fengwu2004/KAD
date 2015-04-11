//
//  KDNewsListApi.swift
//  KAD
//
//  Created by 开心马骝 on 14-8-6.
//  Copyright (c) 2014年 GuChengFeng. All rights reserved.
//

import Foundation

class KDNewsDetailApi
{
    var delegate:KDNewsDetailController
    
    var url:String

    init(delegate: KDNewsDetailController,url:String)
    {
        self.delegate=delegate
        
        self.url=url
        
        self.getNewsData()
    }
    
    func getNewsData()
    {
        var url:NSURL=NSURL(string:self.url)!
        
        var request:NSURLRequest=NSURLRequest(URL:url)
        
        var connection=NSURLConnection(request:request,delegate:delegate,startImmediately:false)
        
        println("NewsDetailUrl is :\(self.url)")
        
        connection!.start()
    }
}