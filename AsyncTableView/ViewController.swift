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
    
    static var instance: MyDataProvider = MyDataProvider()
    
    func requestData(_ offset: Int, size: Int, listener: @escaping ([MyItem]) -> Void) {
        DispatchQueue.global(qos: .default).async {
            // simulate delay
            sleep(2)
            
            // generate items
            let items = (offset...(offset + size)).map {
                MyItem(name: "Item \($0)")
            }
            
            // call listener in main thread
            DispatchQueue.main.async {
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
            tableViewFooter.isHidden = !loading
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 40 {
            loadSegment(items.count, size: pageSize)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewFooter.isHidden = true
        loadSegment(0, size: pageSize)
    }
    
    func loadSegment(_ offset: Int, size: Int) {
        
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
}

