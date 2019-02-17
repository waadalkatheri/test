//
//  FlickrData.swift
//  Virtual Tourist
//
//  Created by amnah on 2/3/19.
//  Copyright © 2019 amnah. All rights reserved.
//

import Foundation


import Foundation
import MapKit

class FlickrData:NSObject {
    
    
    private static func getImages(lat:Double, long:Double, completion: @escaping (_ error: Error?, _ flickrImages: [FlickrImage]?) -> Void)
    {
        let latitude = lat
        let longtitude = long
        let url = URL(string:"\(FlickrAPI.url)?\(FlickrAPI.FlikcerParameters.method)=\(FlickrAPI.FlickerImageVal.method)&\(FlickrAPI.FlikcerParameters.format)=\(FlickrAPI.FlickerImageVal.format)&\(FlickrAPI.FlikcerParameters.api_key)=\(FlickrAPI.FlickerImageVal.api_key)&\(FlickrAPI.FlikcerParameters.latitude)=\(latitude)&\(FlickrAPI.FlikcerParameters.longitude)=\(longtitude)&\("radius")=\(3)")!
        var request = URLRequest(url: url)
        // request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(error!, nil)
                return
            }
            let range = Range(uncheckedBounds: (14, data!.count - 1))
            let newData = data?.subdata(in: range)
            if let json = try? JSONSerialization.jsonObject(with: newData!) as? [String: Any],
                let photosMeta = json?["photos"] as? [String: Any],
                let photos = photosMeta["photo"] as? [Any]
            {
                print("photo", photos)
                var flickrImages:[FlickrImage] = []
             
                var currImage : [UIImage] = []
                
                for photo in photos {
                    if let flickrImage = photo as? [String:Any],
                        let id = flickrImage["id"] as? String,
                        let secret = flickrImage["secret"] as? String,
                        let server = flickrImage["server"] as? String,
                        let farm = flickrImage["farm"] as? Int
                    {
                        
                  //     let url = getImageurl(idVal:id)
                        
                   //     DataController.shared.savePhoto(url: <#T##String#>, image: photo as! NSData)
                        
                       // var  image =  UIImage(named: photo as! String)
                       // currImage.append(image!)
                        
                        //save image in core data 
                        
                      }
                }
                completion(nil, flickrImages)
            }
            print("this is out of if statement")
        }
        task.resume()
        
    }
    
    static func getFlickrImages(lat:Double,long:Double, completion: @escaping (_ error: Error?, _ flickrImages: [FlickrImage]?) -> Void){
        var res : [FlickrImage] = []
  
        FlickrData.getImages(lat: lat, long: long){ (error : Error?,  _ flickrImages : [FlickrImage]?) in
            guard error == nil else{
                completion(error!, nil)
                return
            }
//        FlickrData.getImages(lat: location) { (error : Error?,  _ flickrImages : [FlickrImage]?) in
//            guard error == nil else{
//                completion(error!, nil)
//                return
//            }
            if flickrImages!.count > 25 {
                var randomArray: [Int] = []
                while randomArray.count < 25
                {
                
                    let random = arc4random_uniform(UInt32(flickrImages!.count))
                    if !randomArray.contains(Int(random))
                    {randomArray.append(Int(random))}
                }
                for random in randomArray{
                    res.append(flickrImages! [random])
                }
                completion(nil, res)
                
            }else{
                completion(nil, res)
            }
        }
        print("this is res.count",res.count)
        
    }
    

    func getImageurl (idVal: String)->NSURL
    {
        let url = NSURL(
            string: "http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&format=json&nojsoncallback=1&api_key=\(FlickrAPI.FlickerImageVal.api_key)&photo_id=\(idVal)")
        
       //let res =  String(contentsOf: url!)
       // return "\(url)"
        return url!
    
    }
}
