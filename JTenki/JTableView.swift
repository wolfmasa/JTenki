//
//  JTableView.swift
//  JTenki
//
//  Created by ICP223G on 2015/03/23.
//  Copyright (c) 2015年 ProjectJ. All rights reserved.
//

import UIKit

struct Team {
    var label: String
    var imageName: String?
    var location: String
}


class JTableView: UITableViewController {

    var teamArray: Array<Team> = []
    var selectedTeam: Team = Team(label: "", imageName: "", location: "")


    override func viewDidLoad() {
        super.viewDidLoad()
        teamArray.append(Team(label: "ベガルタ仙台", imageName: nil, location: "Sendai"))
        teamArray.append(Team(label: "モンテディオ山形", imageName: nil, location: "Yamagata"))
        teamArray.append(Team(label: "鹿島アントラーズ", imageName: nil, location: "Kashima"))
        teamArray.append(Team(label: "浦和レッズ", imageName: nil, location: "Urawa-shi"))
        teamArray.append(Team(label: "柏レイソル", imageName: nil, location: "Kashiwa"))
        teamArray.append(Team(label: "FC東京", imageName: nil, location: "Tokyo"))
        teamArray.append(Team(label: "川崎フロンターレ", imageName: nil, location: "Kawasaki"))
        teamArray.append(Team(label: "横浜・F・マリノス", imageName: nil, location: "Yokohama"))
        teamArray.append(Team(label: "湘南ベルマーレ", imageName: nil, location: "Hiratsuka"))
        teamArray.append(Team(label: "ヴァンフォーレ甲府", imageName: nil, location: "Koufu-shi"))
        teamArray.append(Team(label: "松本山雅FC", imageName: nil, location: "Matsumoto-shi"))
        teamArray.append(Team(label: "アルビレックス新潟", imageName: nil, location: "Niigata-shi"))
        teamArray.append(Team(label: "清水エスパルス", imageName: nil, location: "Shimizu-shi"))
        teamArray.append(Team(label: "名古屋グランパス", imageName: nil, location: "Nagoya"))
        teamArray.append(Team(label: "ガンバ大阪", imageName: nil, location: "Osaka"))
        teamArray.append(Team(label: "ヴィッセル神戸", imageName: nil, location: "Kobe"))
        teamArray.append(Team(label: "サンフレッチェ広島", imageName: nil, location: "Hiroshima"))
        teamArray.append(Team(label: "サガン鳥栖", imageName: nil, location: "Tosu-shi"))
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedTeam = teamArray[indexPath.row]
        self.performSegueWithIdentifier("toDetailView", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetailView" {
            var dstView: WeatherDetail = segue.destinationViewController as WeatherDetail
            dstView.label = selectedTeam.label
            let backgroundArray = [
                "01d.png": "clearsky.jpg",
                "01n.png": "clearsky.jpg",
                "02d.png": "fewcloud.jpg",
                "02n.png": "fewcloud.jpg",
                "03d.png": "cloud.jpg",
                "03n.png": "cloud.jpg",
                "04d.png": "brokencloud.jpg",
                "04n.png": "brokencloud.jpg",
                "09d.png": "showerrain.jpg",
                "09n.png": "showerrain.jpg",
                "10d.png": "rain.jpg",
                "10n.png": "rain.jpg",
                "11d.png": "thunderstorm.jpg",
                "11n.png": "thunderstorm.jpg",
                "13d.png": "snow.jpg",
                "13n.png": "snow.jpg",
                "50d.png": "mist.jpg",
                "50n.png": "mist.jpg",
            ]

            dstView.image = UIImage(named: backgroundArray[selectedTeam.imageName!]!)

        }

    }

}
