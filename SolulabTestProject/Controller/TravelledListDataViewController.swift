//
//  TravelledListDataViewController.swift
//  SolulabTestProject
//
//  Created by Suraj on 05/01/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit

class TravelledListDataViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var travelledListData:[TravelledListDataModel] = [TravelledListDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.travelledListData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelledListDataTableViewCell", for: indexPath) as! TravelledListDataTableViewCell
        
        cell.travelledDistanceLabel.text = self.travelledListData[indexPath.row].distance + " meter(s)"
        cell.travelledDistanceOnTime.text = self.travelledListData[indexPath.row].time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    @IBAction func openMapPAge(_ sender: Any) {
        //ViewController
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let navBar = UINavigationController(rootViewController: destination)
        self.present(navBar, animated: true, completion: nil)
        
    }
    
}
