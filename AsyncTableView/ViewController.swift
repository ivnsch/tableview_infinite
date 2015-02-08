//
//  ViewController.swift
//  AsyncTableView
//
//  Created by ischuetz on 27/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let PageSize = 20
    let cellId = "cell"
    
    @IBOutlet var tableViewFooter:MyFooter!
    
    var items:[MyItem] = []
    
    var loading = false
    

    class MyItem : Printable {
        let name:String!
        
        init(name:String) {
            self.name = name
        }
        
        var description: String {
            return name
        }
    }
    
    class MyDataProvider {
        
        class func getInstance() -> MyDataProvider {
            return MyDataProvider() //return a new instance since class vars not supported yet
        }
        
        func requestData(offset:Int, size:Int, listener:([MyItem]) -> ()) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                //simulate delay
                sleep(2)
                
                //generate items
                var arr:[MyItem] = []
                for i in offset...(offset + size) {
                    arr.append(MyItem(name: "Item \(i)"))
                }
                
                //call listener in main thread
                dispatch_async(dispatch_get_main_queue()) {
                    listener(arr)
                }
            }
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 40 {
            loadSegment(items.count, size: PageSize)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        self.tableViewFooter.hidden = true

        loadSegment(0, size: PageSize)
    }
    
    func loadSegment(offset:Int, size:Int) {
        
        if (!self.loading) {
            
            self.setLoadingState(true)

            MyDataProvider.getInstance().requestData(offset, size: size,
                listener: {(items:[ViewController.MyItem]) -> () in
                    
                    for item:MyItem in items {
                        self.items.append(item)
                    }
                    
                    self.tableView.reloadData()

                    self.setLoadingState(false)
                })
        }
    }
    
    func setLoadingState(loading:Bool) {
        self.loading = loading
        self.tableViewFooter.hidden = !loading
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as UITableViewCell
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
}

