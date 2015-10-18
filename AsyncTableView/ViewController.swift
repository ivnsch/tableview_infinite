//
//  ViewController.swift
//  AsyncTableView
//
//  Created by ischuetz on 27/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import UIKit


struct MyItem {
    let name: String
    init(name: String) {
        self.name = name
    }
}

class MyDataProvider {
    
    static var instance: MyDataProvider {
        return MyDataProvider()
    }
    
    func requestData(offset: Int, size: Int, listener: [MyItem] -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // simulate delay
            sleep(2)
            
            // generate items
            let items = (offset...(offset + size)).map {
                MyItem(name: "Item \($0)")
            }
            
            // call listener in main thread
            dispatch_async(dispatch_get_main_queue()) {
                listener(items)
            }
        }
    }
}


class ViewController: UITableViewController {

    @IBOutlet var tableViewFooter: MyFooter!
    
    private let pageSize = 20
    
    private var items: [MyItem] = []
    
    private var loading = false {
        didSet {
            tableViewFooter.hidden = !loading
        }
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 40 {
            loadSegment(items.count, size: pageSize)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewFooter.hidden = true
        loadSegment(0, size: pageSize)
    }
    
    func loadSegment(offset: Int, size: Int) {
        
        if (!loading) {
            loading = true

            MyDataProvider.instance.requestData(offset, size: size) {[weak self] items in
                for item in items {
                    self?.items.append(item)
                }
                
                self?.tableView.reloadData()

                self?.loading = false
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
}

