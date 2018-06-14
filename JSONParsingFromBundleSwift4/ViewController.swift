//
//  ViewController.swift
//  JSONParsingFromBundleSwift4
//
//  Created by Inkswipe on 6/14/18.
//  Copyright © 2018 Fortune4 Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var colorTableView: UITableView!
    
    var colors : NSMutableArray!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        self.colorTableView.delegate = self
        self.colorTableView.dataSource = self
        colors = NSMutableArray()
        
        
        if let responseDic = self.pasrseDataFromFile(name: "Colors")
        {
            if let arr =  responseDic.value(forKey: "colors") as? NSArray
            {
                colors = arr.mutableCopy() as! NSMutableArray
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.colorTableView.dequeueReusableCell(withIdentifier: "ColorCell") as! ColorCell
        
        if let colorDict =  self.colors.object(at:indexPath.row) as? NSDictionary
        {
            cell.colorNameLabel.text = colorDict.value(forKey: "color") as? String ?? "No Color Name"
            
            
            if let code = colorDict.value(forKey: "code") as? NSDictionary
            {
                if let rgba = code.value(forKey: "rgba") as? NSArray
                {
                    
                    var r,g,b,a : Int!
                    
                    r = rgba.object(at: 0) as? Int ?? 0
                    g = rgba.object(at: 1) as? Int ?? 0
                    b = rgba.object(at: 2) as? Int ?? 0
                    a = rgba.object(at: 3) as? Int ?? 0
                    
                    print(r,g,b,a)
                    
                    cell.colorView.backgroundColor = UIColor(displayP3Red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(a))
                    
                }
            }
        }
        
        return cell
    }
    
    
    
    
    func pasrseDataFromFile(name:String)->NSDictionary?
    {
        do{
            
            if let file = Bundle.main.url(forResource: name, withExtension: "json")
            {
                let FileData = try Data(contentsOf: file)
                let jsonObject = try JSONSerialization.jsonObject(with: FileData, options: [])
                if let dict =  jsonObject as? NSDictionary
                {
                    return dict
                }
                else
                {
                    return nil
                }
            }
            else
            {
                print("File Not Found")
            }
            
        }
        catch
        {
            print(error)
        }
       return nil
    }
    

}
