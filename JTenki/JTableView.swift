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

        teamArray.append(Team(label: "鹿島アントラーズ", imageName: nil, location: "Kashima"))
        teamArray.append(Team(label: "ガンバ大阪", imageName: nil, location: "Osaka"))
        teamArray.append(Team(label: "横浜・F・マリノス", imageName: nil, location: "Yokohama"))
        teamArray.append(Team(label: "サンフレッチェ広島", imageName: nil, location: "Hiroshima"))
        teamArray.append(Team(label: "川崎フロンターレ", imageName: nil, location: "Kawasaki"))
        teamArray.append(Team(label: "ベガルタ仙台", imageName: nil, location: "Sendai"))
        teamArray.append(Team(label: "名古屋グランパス", imageName: nil, location: "Nagoya"))
        teamArray.append(Team(label: "FC東京", imageName: nil, location: "Tokyo"))
        teamArray.append(Team(label: "柏レイソル", imageName: nil, location: "Kashiwa"))
        teamArray.append(Team(label: "湘南ベルマーレ", imageName: nil, location: "Hiratsuka"))
        teamArray.append(Team(label: "モンテディオ山形", imageName: nil, location: "Yamagata"))
        teamArray.append(Team(label: "ヴィッセル神戸", imageName: nil, location: "Kobe"))
        teamArray.append(Team(label: "アルビレックス新潟", imageName: nil, location: "Niigata-shi"))

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

            if selectedTeam.imageName == "01d.png" || selectedTeam.imageName == "01n.png" {
                dstView.image = UIImage(named: "clearsky.jpg")
            }
            else if selectedTeam.imageName == "02d.png" || selectedTeam.imageName == "02n.png" {
                dstView.image = UIImage(named: "fewcloud.jpg")
            }
            else if selectedTeam.imageName == "03d.png" || selectedTeam.imageName == "03n.png" {
                dstView.image = UIImage(named: "cloud.jpg")
            }
            else if selectedTeam.imageName == "04d.png" || selectedTeam.imageName == "04n.png" {
                dstView.image = UIImage(named: "brokencloud.jpg")
            }
            else if selectedTeam.imageName == "09d.png" || selectedTeam.imageName == "09n.png" {
                dstView.image = UIImage(named: "showerrain.jpg")
            }
            else if selectedTeam.imageName == "10d.png" || selectedTeam.imageName == "10n.png" {
                dstView.image = UIImage(named: "rain.jpg")
            }
            else if selectedTeam.imageName == "11d.png" || selectedTeam.imageName == "11n.png" {
                dstView.image = UIImage(named: "thunderstorm.jpg")
            }
            else if selectedTeam.imageName == "13d.png" || selectedTeam.imageName == "13n.png" {
                dstView.image = UIImage(named: "snow.jpg")
            }
            else if selectedTeam.imageName == "50d.png" || selectedTeam.imageName == "50n.png" {
                dstView.image = UIImage(named: "mist.jpg")
            }

        }

    }

}
