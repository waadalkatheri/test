//
//  collectionView.swift
//  Virtual Tourist
//
//  Created by amnah on 2/3/19.
//  Copyright © 2019 amnah. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import  MapKit

class collectionView :UIViewController,UICollectionViewDelegate{
  
    
    let datacontroller = DataController.shared
  
    
  
    
      let annotation = MyPinAnnotation()
    
    var pin: PinObj!
    var photos = [PhotoObj]()
    var selectedIndex = [NSIndexPath]()
    
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
  
    @IBOutlet weak var noImagesLabel: UILabel!
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    var page: Int = 0
    var fetchedResultsController: NSFetchedResultsController<PhotoObj>!
    
    var isEmpty: Bool {
        
       return  fetchedResultsController?.fetchedObjects?.count != 0
    
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("these are the pins",pin)
        noImagesLabel.isHidden = true
        //collectionView.dataSource = self
        collectionView.delegate = self
       
        // set the anotation
//        if let mapView = mapView {
//            let mapData = CLLocationCoordinate2D(latitude: CLLocationDegrees( self.annotation.pinData.latitude), longitude: CLLocationDegrees( self.annotation.pinData.longitude))
//            let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//            let mapRegion = MKCoordinateRegion(center: mapData, span: mapSpan)
//            mapView.setRegion(mapRegion, animated: true)
//            mapView.isUserInteractionEnabled = false
//
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = mapData
//            mapView.addAnnotation(annotation)
//        }
        
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if photos.count == 0 {
            barButton.isEnabled = false
        //   getNewCollectionPhoto()
        }
    }
   
    //this func chescks if the core data is empty it gets images from flikcr API
    //if not empty --> if returns images from the core data
    public func fetch()
    {
        if isEmpty == true
        {
            //access flickr API to get photos
         callFlickrAPI()
            print("there is no stored in this location"   )
        }else{
            
            let fetchRequest : NSFetchRequest<PhotoObj> = PhotoObj.fetchRequest()
            
            let predicate = NSPredicate(format: "PinObj == %@",  pin)
            fetchRequest.predicate = predicate
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchedResultsController.delegate = self as! NSFetchedResultsControllerDelegate
            do{
                try fetchedResultsController.performFetch()
            }catch{
                fatalError("The fetch could not be performed: \(error.localizedDescription)")
                
            }
        }
        
        
    }
    // this func calls get flickrImages()
    func callFlickrAPI()
    {
        
        
        FlickrData.getFlickrImages(lat: self.annotation.coordinate.latitude, long: self.annotation.coordinate.longitude)
            
        { (error : Error?,  _ flickrImages : [FlickrImage]?) in
            print("this is the error",error)
                        guard error == nil else{

                            return
                        }

        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! collectionViewCell
//
//
//        let photo = photos[indexPath.row]
//        if let image = photo.
//       flickrImageView = fetchedResultsController.object(at: indexPath)
//
//        let flickrImg:
//        return
//    }
//
    
}

