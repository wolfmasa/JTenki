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
        
        requestToUrl("http://api.openweathermap.org/data/2.5/weather?q=London,uk")
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

/**
        //NSOperationQueueを使ってマルチスレッドでリクエスト
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
        
        //////////////////////////////////////
        //APIからtokenを取得
        
        //リクエスト用のパラメータを設定
        NSString *user = @"user_name";
        NSString *pass = @"password";
        NSString *url  = @"request_url";
        NSString *param = [NSString stringWithFormat:@"url_name=%@&password=%@", user, pass];
        
        //リクエストを生成
        NSMutableURLRequest *request;
        request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        [request setURL:[NSURL URLWithString:url]];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setTimeoutInterval:20];
        [request setHTTPShouldHandleCookies:FALSE];
        [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
        
        //同期通信で送信
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error != nil) {
        NSLog(@"Error!");
        return;
        }
        
        NSError *e = nil;
        
        //取得したレスポンスをJSONパース
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:nil error:&e];
        
        NSString *token = [dict objectForKey:@"token"];
        NSLog(@"Token is %@", token);
        
        //受け取ったtokenを付けて再度リクエスト
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"https://requst_url?token=%@", token]];
        NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
        NSURLResponse *response2 = nil;
        NSError *error2 = nil;
        NSData *data2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response2 error:&error2];
        
        if (error2 != nil) {
        NSLog(@"Error2!");
        return;
        }
        
        NSError *e2 = nil;
        NSDictionary *dict2 = [NSJSONSerialization JSONObjectWithData:data2 options:nil error:&e2];
        
        NSLog(@"Response2: %@", response2);
        NSLog(@"%@", dict2);
        NSLog(@"%d", [dict2 count]);
        }];
    }
**/

}

