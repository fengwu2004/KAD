//
//  ViewController.swift
//  KAD
//
//  Created by 开心马骝 on 14-8-6.
//  Copyright (c) 2014年 . All rights reserved.
//

import UIKit

class KDNewsListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    var currentPage = 1
    
    let identifier = "myCell"
    
    var kListApi:KDNewsListApi?
    
    var urlString:String = "http://news-at.zhihu.com/api/3/news/latest"
    
    var data:NSMutableData = NSMutableData()
    
    var jsonDic:NSDictionary = NSDictionary()
    
    var jsonArrStories:NSMutableArray = NSMutableArray()
    
    var jsonArrtop_stories:NSMutableArray = NSMutableArray()
    
    var thumbQueue = NSOperationQueue()
    
    @IBOutlet var tabNewList:UITableView!
    
    @IBOutlet var scrollNewList:UIScrollView!
    
    @IBOutlet var pageNewList : UIPageControl!
    
    @IBOutlet var labScrollTitle : UILabel!
    
    var tabActivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    var scrollActivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tabActivity.center = tabNewList.center
        
        tabNewList.addSubview(tabActivity)
        
        tabActivity.startAnimating()
        
        scrollActivity.center = scrollNewList.center
        
        scrollNewList.addSubview(scrollActivity)
        
        scrollActivity.startAnimating()
        
        // Do any additional setup after loading the view, typically from a nib.
        kListApi = KDNewsListApi(delegate:self, url:self.urlString)
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
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        var err: NSError
        
        jsonDic = NSJSONSerialization.JSONObjectWithData(self.data,
            
            options:NSJSONReadingOptions.MutableContainers,
            
            error: nil) as NSDictionary
        
        jsonArrStories = jsonDic.objectForKey("stories") as NSMutableArray
        
        jsonArrtop_stories = jsonDic.objectForKey("top_stories") as NSMutableArray
        
      //print("NewsList Json Data:\(jsonDic)")
        
        print("jsonArrStories:\(jsonArrStories)")
        
        print("jsonArrtop_stories:\(jsonArrtop_stories)")
    
        tabActivity.stopAnimating()
        
        tabActivity.removeFromSuperview()
        
        scrollActivity.stopAnimating()
        
        scrollActivity.removeFromSuperview()
        
        self.setupViews()
    
    }
    
    func setupViews()
    {
        //tableView
        tabNewList.delegate = self
        
        tabNewList.dataSource = self
        
        var nib = UINib(nibName:"NewsCell", bundle: nil)
        
        self.tabNewList?.registerNib(nib, forCellReuseIdentifier: identifier)
        
        //scrollView
        scrollNewList.delegate = self
        
        var pageCount = jsonArrtop_stories.count
        
        println("pageCount\(pageCount)")
        
        scrollNewList.contentSize = CGSizeMake(CGFloat(pageCount*320), CGFloat(140))
        
        scrollNewList.pagingEnabled = true
        
        self.addImgsToScroll(scrollNewList, arrStory_Top: self.jsonArrtop_stories)
        
        //pageConrol
        pageNewList.numberOfPages = pageCount
        
        pageNewList.currentPage = 1
        
        var dic1 = jsonArrtop_stories.objectAtIndex(0) as NSDictionary
        
        var title1 = dic1["title"] as String
        
        labScrollTitle.text = title1
        
        //RefreshControl
        self.addRefreshView("PullUpView")
       // self.addRefreshView("PullDownView")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
       return 104
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return jsonArrStories.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as NewsCell
        
        var index = indexPath.row
        
        var data = self.jsonArrStories[index] as NSDictionary
        
        var sTitle = data.objectForKey("title") as String
        
        cell.NLabContent.text = sTitle
        
        var arrImgURL = data.objectForKey("images") as NSArray
        
        var imagURL = arrImgURL[0] as String
        
        println("imageURL:\(imagURL)")
        
        cell.NImg.setImage(imagURL,placeHolder: UIImage(named: "001p9BkFgy6KqjPYZg74b&690.jpeg"))
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var index = indexPath.row
        
        var data = self.jsonArrStories[index] as NSDictionary
        
        var aId : Int = data.objectForKey("id") as Int
        
        var board:UIStoryboard = UIStoryboard(name:"Main", bundle:nil);
        
        var detailConrol = board.instantiateViewControllerWithIdentifier("KDNewsDetailController") as KDNewsDetailController
        
        detailConrol.aId = aId
        
        println("detailConrol.id\(aId)")
        
        self.showViewController(detailConrol, sender: self)
        
//        self.presentModalViewController(detailConrol, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) // any offset changes
    {
        //set pageConrol
        var pageWidth:Int = Int(scrollView.frame.size.width)
        
        var offX:Int = Int(scrollView.contentOffset.x)
        
        var a = offX - pageWidth / 2 as Int
        
        var b = a / pageWidth as Int
        
        var c = floor(Double(b))
        
        var page:Int = Int(c) + 1
        
        println("current page:\(page)")
        
        currentPage = page
        
        pageNewList.currentPage = currentPage
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!)
    {
        pageNewList.currentPage=currentPage
        var dic1=jsonArrtop_stories.objectAtIndex(currentPage) as NSDictionary
        var title1=dic1["title"] as String
        labScrollTitle.text=title1
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool)
    {
        println("contentOffset.y\(tabNewList.contentOffset.y)")
     
        
        //上拉刷新
       if (tabNewList.contentOffset.y>tabNewList.contentSize.height-tabNewList.frame.size.height)
       {
          println("start to load more")
       }
        
        //下拉刷新
        if(tabNewList.contentOffset.y<(-50))
        {
            kListApi!.reopenConnection()
        }
    }
    
    
    func addImgsToScroll(scroll:UIScrollView,arrStory_Top:NSArray)
    {
        var cursor = 0
        for item : AnyObject in arrStory_Top
        {
            println(item)
            
            var curImg = UIImageView(frame:CGRectMake(CGFloat(320*cursor),CGFloat(0),CGFloat(320),CGFloat(140)))
            
            var ImgURL:String! = item.objectForKey("image") as String
            
            curImg.setImage(ImgURL,placeHolder: UIImage(named:"001p9BkFgy6KqjPYZg74b&690.jpeg"))
            
            scroll.addSubview(curImg)
            
            cursor++
        }
    }
    
    func addRefreshView(var sXibName:NSString!)
    {
        var nibView:NSArray = NSBundle.mainBundle().loadNibNamed(sXibName, owner: nil, options: nil) as NSArray
        
        var rView = nibView[0] as PullUpView
        
        tabNewList.tableFooterView = rView
    }
}