//
//  ViewController.swift
//  GCD
//
//  Created by 劉奕伶 on 2018/8/31.
//  Copyright © 2018年 Appwork School. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var gcdTableView: UITableView!
    
    var someArray: [String] = []
    
    let client = APIClient()
    
    var semaphore = DispatchSemaphore(value: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gcdTableView.delegate = self
        gcdTableView.dataSource = self
        
//        showByOrder()
        
        showAtTheSameTime()
    }
    
    func showByOrder() {
        
        let loadingQueue = DispatchQueue.global()
        
        loadingQueue.async {
            
            self.semaphore.wait()
            self.client.getName { (data, error) in
            print(data!)
                
            self.someArray.append(data!)
                
            self.gcdTableView.reloadData()
                
            self.semaphore.signal()
                
                
            }
            
            self.semaphore.wait()
            self.client.getAddress { (data, error) in
            print(data!)
                
            self.someArray.append(data!)
                
            self.gcdTableView.reloadData()
                
            self.semaphore.signal()
            }
            
            self.semaphore.wait()
            self.client.getChief { (data, error) in
            print(data!)
                
            self.someArray.append(data!)
                
            self.gcdTableView.reloadData()
                
            self.semaphore.signal()
            }
        }
    }
    
    func showAtTheSameTime() {
        
        let group = DispatchGroup()

            group.enter()
            self.client.getName { (data, error) in
            print(data!)
                
            self.someArray.append(data!)
            group.leave()
                
            }
            
            
            group.enter()
            self.client.getAddress { (data, error) in
            print(data!)
                
            self.someArray.append(data!)
            group.leave()
            
            }
            
            
            group.enter()
            self.client.getChief { (data, error) in
            print(data!)
                
            self.someArray.append(data!)
            group.leave()
            
            }
            
            group.notify(queue: DispatchQueue.main) {
                
                self.gcdTableView.reloadData()
                
            }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return someArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = gcdTableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = someArray[indexPath.row]
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class APIClient {
    
    typealias Name = (String?, Error?) -> Void

    func getName(completionHandler completion: @escaping Name) {
        
    
        guard let url = URL(string: "https://stations-98a59.firebaseio.com/name.json") else {return}
    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
    
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
            DispatchQueue.main.async {
            
            
                guard error == nil else {
                
                    completion(nil, error)
                
                    return
                }
            
                guard let httpResponse = response as? HTTPURLResponse else {
                
                    completion(nil, error)
                
                    return
                }
            
                switch httpResponse.statusCode {
            
                case 200...299:
                
                    if let returnData = String(data: data!, encoding: .utf8) {
                    completion(returnData, nil)
                }
                
                default:
                    completion(nil, error)
                }
            }
        
        }
        
        task.resume()
    }
    
    func getAddress(completionHandler completion: @escaping Name) {

        guard let url = URL(string: "https://stations-98a59.firebaseio.com/address.json") else {return}

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            DispatchQueue.main.async {


                guard error == nil else {

                    completion(nil, error)

                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {

                    completion(nil, error)

                    return
                }

                switch httpResponse.statusCode {

                case 200...299:

                    if let returnData = String(data: data!, encoding: .utf8) {
                        completion(returnData, nil)
                    }

                default:
                    completion(nil, error)
                }
            }

        }

        task.resume()
    }
    
    func getChief(completionHandler completion: @escaping Name) {

        guard let url = URL(string: "https://stations-98a59.firebaseio.com/head.json") else {return}

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            DispatchQueue.main.async {


                guard error == nil else {

                    completion(nil, error)

                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {

                    completion(nil, error)

                    return
                }

                switch httpResponse.statusCode {

                case 200...299:

                    if let returnData = String(data: data!, encoding: .utf8) {
                        completion(returnData, nil)
                    }

                default:
                    completion(nil, error)
                }
            }

        }

        task.resume()
    }

}


























