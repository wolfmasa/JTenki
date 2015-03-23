//
//  ViewController.swift
//  JTenki
//
//  Created by JobaraMasashi on 2015/03/22.
//  Copyright (c) 2015年 ProjectJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textArea: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        requestToUrl("http://api.openweathermap.org/data/2.5/weather?q=Kawasaki,jp")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func requestToUrl(url :String){
        
        // 通信先のURLを生成.
        var myUrl:NSURL = NSURL(string:url)!
        // リクエストを生成.
        var myRequest:NSURLRequest  = NSURLRequest(URL: myUrl)
        // 送信処理を始める.
        NSURLConnection.sendAsynchronousRequest(myRequest, queue: NSOperationQueue.mainQueue(), completionHandler: self.getHttp)

    }

    func getHttp(res:NSURLResponse?,data:NSData?,error:NSError?){

        // 帰ってきたデータを文字列に変換.
        var myData:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        // TextViewにセット.
        textArea.text = myData
        //println(myData)

        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary

        let array = json["weather"]! as NSArray
        let weather = (array[0] as NSDictionary)["main"] as NSString
        textLabel.text = weather
        println(weather)
    }


}

