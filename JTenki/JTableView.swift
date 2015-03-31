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
    var status: Int
}


class JTableView: UITableViewController {

    var teamArray: Array<Team> = []
    var selectedTeam: Team = Team(label: "", imageName: "", location: "", status: 0)


    override func viewDidLoad() {
        super.viewDidLoad()
        teamArray.append(Team(label: "ベガルタ仙台", imageName: nil, location: "Sendai", status: 0))
        teamArray.append(Team(label: "モンテディオ山形", imageName: nil, location: "Yamagata", status: 0))
        teamArray.append(Team(label: "鹿島アントラーズ", imageName: nil, location: "Kashima", status: 0))
        teamArray.append(Team(label: "浦和レッズ", imageName: nil, location: "Saitama", status: 0))
        teamArray.append(Team(label: "柏レイソル", imageName: nil, location: "Kashiwa", status: 0))
        teamArray.append(Team(label: "FC東京", imageName: nil, location: "Tokyo", status: 0))
        teamArray.append(Team(label: "川崎フロンターレ", imageName: nil, location: "Kawasaki", status: 0))
        teamArray.append(Team(label: "横浜・F・マリノス", imageName: nil, location: "Yokohama", status: 0))
        teamArray.append(Team(label: "湘南ベルマーレ", imageName: nil, location: "Hiratsuka", status: 0))
        teamArray.append(Team(label: "ヴァンフォーレ甲府", imageName: nil, location: "Kofu-shi", status: 0))
        teamArray.append(Team(label: "松本山雅FC", imageName: nil, location: "Matsumoto", status: 0))
        teamArray.append(Team(label: "アルビレックス新潟", imageName: nil, location: "Niigata-shi", status: 0))
        teamArray.append(Team(label: "清水エスパルス", imageName: nil, location: "Shizuoka-shi", status: 0))
        teamArray.append(Team(label: "名古屋グランパス", imageName: nil, location: "Nagoya", status: 0))
        teamArray.append(Team(label: "ガンバ大阪", imageName: nil, location: "Osaka", status: 0))
        teamArray.append(Team(label: "ヴィッセル神戸", imageName: nil, location: "Kobe", status: 0))
        teamArray.append(Team(label: "サンフレッチェ広島", imageName: nil, location: "Hiroshima", status: 0))
        teamArray.append(Team(label: "サガン鳥栖", imageName: nil, location: "Tosu", status: 0))
    }

    func requestToUrl(location :String){

        let url = "http://api.openweathermap.org/data/2.5/weather?q=\(location),jp"

        // 通信先のURLを生成.
        var myUrl:NSURL = NSURL(string:url)!
        // リクエストを生成.
        var myRequest:NSURLRequest  = NSURLRequest(URL: myUrl)
        NSLog("request: %@", myUrl)
        // 送信処理を始める.
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(myRequest, queue: queue, completionHandler: self.getHttp)

    }

    func getHttp(res:NSURLResponse?,data:NSData?,error:NSError?){

        println("getHttp: \(res?.URL?.absoluteString)")

        if res == nil || (res as NSHTTPURLResponse).statusCode != 200 {
            if res != nil {
                println((res as NSHTTPURLResponse).statusCode)
            }
            return
        }

        // 帰ってきたデータを文字列に変換.
        var myData:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        // TextViewにセット.
        //textArea.text = myData
        //println(myData)

        if data?.length < 16 {
            println("not enough data size")
            println(data)
            return
        }

        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary

        if let cod = json["cod"] as? NSString {
            if cod == "404" {
                println("404 not found")
                return
            }
        }
        else if let cod = json["cod"] as? NSNumber {
            if cod == 404 {
                println("404 not found")
                return
            }
        }
        else {
            println("other error")
            println(json)
            return
        }


        let array = json["weather"]! as NSArray
        let weatherIcon = (array[0] as NSDictionary)["icon"] as NSString

        var foundFlag = false
        for( var i=0; i<teamArray.count; i++ ) {
            var t = teamArray[i]
            let url = "http://api.openweathermap.org/data/2.5/weather?q=\(t.location),jp"
            if url == res?.URL?.absoluteString && teamArray[i].imageName == nil{
                NSLog("Hit: %@", url)
                teamArray[i].imageName = "\(weatherIcon).png"
                teamArray[i].status = 2
                //println(teamArray[i].label)
                //println(teamArray[i].imageName)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    })
                foundFlag = true
                break
            }
        }

        if !foundFlag {
            println("not found request")
            println(json)
        }

    }


//delegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Cellの.を取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as UITableViewCell

        // Cellに値を設定する.
        cell.textLabel!.text = teamArray[indexPath.row].label
        if teamArray[indexPath.row].status == 2 && teamArray[indexPath.row].imageName != nil {

            cell.imageView?.image = UIImage(named: teamArray[indexPath.row].imageName!)
        }
        else if teamArray[indexPath.row].status == 0 {
            requestToUrl(teamArray[indexPath.row].location)
            teamArray[indexPath.row].status = 1
        }

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
        if selectedTeam.imageName != nil {
         self.performSegueWithIdentifier("toDetailView", sender: nil)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetailView" {
            if selectedTeam.imageName != nil {
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

}
