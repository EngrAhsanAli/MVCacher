//
//  ViewController.swift
//  MVCacher
//
//  Created by EngrAhsanAli on 09/11/2019.
//  Copyright (c) 2019 EngrAhsanAli. All rights reserved.
//

import UIKit
import AAExtensions
import AANetworking
import AAMaterialSpinner
import MVCacher

// MARK: - ViewController
class ViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    
    let requestURL = "http://pastebin.com/raw/wgkJgazE"
    
    var dataSource = [DataModel]()
    
    /// Cacher for JSON
    lazy var jsonCacher: MVCacher = {
        let cacher = MVCacher(cacheType: .memory)
        let memoryCapacity: UInt64 = 500 * 1024 // 512 KB
        cacher.memoryCapacity = memoryCapacity
        return cacher
    }()
    
    /// Cacher for Images
    lazy var imageCacher: MVCacher = {
        let cacher = MVCacher(cacheType: .memory)
        let memoryCapacity: UInt64 = 100 * 1024 * 1024 // 10 MB
        cacher.memoryCapacity = memoryCapacity
        return cacher
    }()

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMaterialLoader()
        setupCollectionView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction

    
    /// Open the URL in external browser
    @IBAction func openUrlAction(_ sender: Any) {
        guard let selectedIndex = collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        let data = dataSource[selectedIndex.row]
        let url = data.urls.full
        url.aa_openURL()
        print("MVCacherDemo:- ", "Opened --> \(url)")

    }
    
    /// Stop download request
    @IBAction func stopDownloadAction(_ sender: Any) {
        guard let selectedIdentifier = selectedIdentifier else { return }
        imageCacher.cancelTask(selectedIdentifier)
        print("MVCacherDemo:- ", "Downloading stopped --> \(selectedIdentifier)")
    }
    
    /// Reloads the all data from the network
    @IBAction func reloadFromNetworkAction(_ sender: Any) {
        emptyCacheAction(sender)
        fetchData()
        print("MVCacherDemo:- ", "Reloaded from network and cleared cache")

    }
    
    /// Clear the cache and collection view
    @IBAction func emptyCacheAction(_ sender: Any) {
        jsonCacher.clearCache()
        imageCacher.clearCache()
        dataSource.removeAll()
        collectionView.reloadData()
        print("MVCacherDemo:- ", "Reset all data")

    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell

        cell.selectionColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        cell.imageView.image = #imageLiteral(resourceName: "Image")
        
        let data = dataSource[indexPath.row]
        let url = data.urls.full

        if let data = imageCacher.getItem(identifier: url) {
            // Sets the cached image with animation
            cell.imageView.mv_setImage(withData: data, placeholder: nil)
            print("MVCacherDemo:- ", "Loaded from Cache --> \(url)")

        }
        else {
            // Download the data from the URL and sets Image if its valid
            imageCacher.downloadData(url, identifier: "Image\(indexPath.row)") {
                cell.imageView.mv_setImage(withData: $0, placeholder: #imageLiteral(resourceName: "Image"))
                print("MVCacherDemo:- ", "Loaded from Network --> \(url)")
            }
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}


// MARK: - Helper methods
extension ViewController {
    
    /// Selected Image Identifier
    var selectedIdentifier: String? {
        guard let selectedIndex = collectionView.indexPathsForSelectedItems?.first else {
            return nil
        }
        return "Image\(selectedIndex.row)"
    }
    
    /// Setup collection view and UIRefreshControl
    func setupCollectionView() {
        collectionView.aa_setItemsInRow(2, multiplier: 1.5, spacing: 20)
        
        let refreshControl = collectionView.aa_addRefreshControl {
            self.fetchData()
        }
        refreshControl.trigger()
    }
    
    /// Setup Material Loader
    func setupMaterialLoader() {
        let spinner = AAMaterialSpinner.setMaskedSpinnerView(bgColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7543878425),
                                                             spinnerSize: 70,
                                                             spinnerWidth: 2)
        spinner.colorArray = [#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1), #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)]
    }
    
    /// Fetch Data either from the network or from the cache
    func fetchData() {
        
        if let data = jsonCacher.getItem(identifier: requestURL) {
            self.mapData(data)
            self.collectionView.reloadData()
        }
        else {
            AAMaterialSpinner.showMaskedSpinner(self)
            ApiProvider.aa_request(ApiAction.data, completion: {
                AAMaterialSpinner.dismissMaskedSpinner()
                guard let data = $0 as? Data else {
                    print("MVCacherDemo:- ", "Something went wrong with the network resource")
                    return
                }
                self.jsonCacher.addItem(data, identifier: self.requestURL)
                self.mapData(data)
                self.collectionView.reloadData()
            })
            
        }
    }
    
    /// Maps JSON string to Object
    ///
    /// - Parameter data: network data
    func mapData(_ data: Data) {
        
        do {
            let mappedData = try JSONDecoder().decode([DataModel].self, from: data)
            self.dataSource = mappedData
        } catch {
            print("MVCacherDemo:- ", error.localizedDescription)
        }
        
    }
    

    
}
