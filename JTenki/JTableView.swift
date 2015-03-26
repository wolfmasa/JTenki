//
//  JTableView.swift
//  JTenki
//
//  Created by ICP223G on 2015/03/23.
//  Copyright (c) 2015年 ProjectJ. All rights reserved.
//

import UIKit

struct Teams {
    var label: String
    var imageName: String?
    var location: String
}


class JTableView: UITableViewController {

    var teamArray: Array<Teams> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        teamArray.append(Teams(label: "鹿島アントラーズ", imageName: nil, location: "Kashima"))
        teamArray.append(Teams(label: "ガンバ大阪", imageName: nil, location: "Osaka"))
        teamArray.append(Teams(label: "横浜・F・マリノス", imageName: nil, location: "Yokohama"))
        teamArray.append(Teams(label: "サンフレッチェ広島", imageName: nil, location: "Hiroshima"))
        teamArray.append(Teams(label: "川崎フロンターレ", imageName: nil, location: "Kawasaki"))
        teamArray.append(Teams(label: "ベガルタ仙台", imageName: nil, location: "Sendai"))
        teamArray.append(Teams(label: "名古屋グランパス", imageName: nil, location: "Nagoya"))
        teamArray.append(Teams(label: "FC東京", imageName: nil, location: "Tokyo"))
        teamArray.append(Teams(label: "柏レイソル", imageName: nil, location: "Kashiwa"))
        teamArray.append(Teams(label: "湘南ベルマーレ", imageName: nil, location: "Hiratsuka"))
        teamArray.append(Teams(label: "モンテディオ山形", imageName: nil, location: "Yamagata"))
        teamArray.append(Teams(label: "ヴィッセル神戸", imageName: nil, location: "Kobe"))
        teamArray.append(Teams(label: "アルビレックス新潟", imageName: nil, location: "Niigata-shi"))

    }

    func requestToUrl(location :String){

        let url = "http://api.openweathermap.org/data/2.5/weather?q=\(location),jp"

        // 通信先のURLを生成.
        var myUrl:NSURL = NSURL(string:url)!
        // リクエストを生成.
        var myRequest:NSURLRequest  = NSURLRequest(URL: myUrl)
        // 送信処理を始める.
        NSURLConnection.sendAsynchronousRequest(myRequest, queue: NSOperationQueue.mainQueue(), completionHandler: self.getHttp)

    }

    func getHttp(res:NSURLResponse?,data:NSData?,error:NSError?){


        if (res as NSHTTPURLResponse).statusCode != 200 {
            return ;
        }

        // 帰ってきたデータを文字列に変換.
        var myData:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        // TextViewにセット.
        //textArea.text = myData
        //println(myData)

        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary

        let array = json["weather"]! as NSArray
        let weatherIcon = (array[0] as NSDictionary)["icon"] as NSString

        for( var i=0; i<teamArray.count; i++ ) {
            var t = teamArray[i]
            let url = "http://api.openweathermap.org/data/2.5/weather?q=\(t.location),jp"
            if url == res?.URL?.absoluteString && teamArray[i].imageName == nil{
                teamArray[i].imageName = "\(weatherIcon).png"
                self.tableView.reloadData()
                break;
            }
        }


    }


//delegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Cellの.を取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as UITableViewCell

        // Cellに値を設定する.
        cell.textLabel!.text = teamArray[indexPath.row].label
        if(teamArray[indexPath.row].imageName != nil){

            cell.imageView?.image = UIImage(named: teamArray[indexPath.row].imageName!)
        }

        requestToUrl(teamArray[indexPath.row].location)

        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamArray.count
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("segueeee")
    }

}
