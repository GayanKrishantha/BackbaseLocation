//
//  BBCCityViewController.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import UIKit

class BBCCityViewController: BBCBaseViewController {

    var viewModel: BBCCityViewModel = BBCCityViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchFieldImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var validationLabel: UILabel!
    var refreshControl: UIRefreshControl!
    private var selectedIndex:Int = 0
    
    
    //Constants
    let ROE_HEIGHT:CGFloat = 50.0
    let SECTION_COUNT:Int = 1
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        
        self.nibRegistration()
        
        // Check forceTouch avalability in devices
        if(traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: collectionView)
        }
        
        //Notify each text changes in text field
        self.searchField.addTarget(self, action: #selector(self.textFiedDidChange(_:)), for: UIControlEvents.editingChanged)
        
        //Custom implementations
        self.initialImplementation()
        self.fetchdData()
        
        // Quick action validation for filter selection
        if let search = self.viewModel.isCandidateSearch {
            if search {
                self.keyboardAppear()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Custom methods
    /*
     Fetch location data from view model by locally saved JSON file
     */
    private func fetchdData() {
        self.viewModel.fetchLocation { (status) in
            if status {
                self.collectionView.reloadData()
            } else {
                self.showErrorAlertPopup(title: BBCConstants.CustomErrorCodes.NO_DATA_TITLE, message: BBCConstants.CustomErrorCodes.NO_DATA_AVAILABLE, okButtonTitle: "Ok", cancelButtonTitle: "")
            }
        }
    }
    
    /*
     Initial view controller UI proprty
     implementation
     */
    private func initialImplementation() {
        self.searchField.delegate = self
        
        self.validationLabel.isHidden = true
        
        //Add shadow effect to the search bar
        self.searchView!.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.searchView!.layer.shadowColor = UIColor.lightGray.cgColor
        self.searchView!.layer.shadowRadius = 5
        self.searchView!.layer.shadowOpacity = 0.40
        self.searchView!.layer.masksToBounds = false
        self.searchView!.clipsToBounds = false
        
        // Pull to refresh implement
        let lastRefreshTime = BBCCommonValidation.getCurrentDateAndTime(formatString: BBCConstants.CustomErrorCodes.DATEFORMATTER_DATE_TIME, prefixText: BBCConstants.CustomErrorCodes.DATEFORMATTER_PREFIX)
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: lastRefreshTime)
        refreshControl?.addTarget(self, action: #selector(self.refreshDate), for: UIControlEvents.valueChanged)
        collectionView.refreshControl = refreshControl
        
        //Access the String file
        validationLabel.text = NSLocalizedString("Empty validation", comment: "")
    }
    
    // Pull to refresh date showing and set the animation
    @objc func refreshDate(sender:AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if (self.refreshControl?.isRefreshing)! {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func redirectToSettingsPage() {
        guard let profileUrl = URL(string: "App-Prefs:root=Wi-Fi") else {
            return
        }
        if UIApplication.shared.canOpenURL(profileUrl) {
            UIApplication.shared.open(profileUrl, completionHandler: { (success) in
                //print(" Profile Settings opened: \(success)")
            })
        }
    }
    
    func navigateToMapVieController() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BBCMapView")  as? BBCMapViewController else {
            return
        }
        let cityObject = viewModel.searchData[selectedIndex]
        controller.viewModel = BBCMapViewModel(city: cityObject)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //Show validation by common method
    func showErrorAlertPopup(title:String, message:String, okButtonTitle:String?, cancelButtonTitle:String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Create Ok actions
        let okAction = UIAlertAction(title: okButtonTitle, style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        // Create Cancel actions
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.redirectToSettingsPage()
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkOnlineStatusValidation() {
        let isOnline:Bool = BBCCommonValidation.isConnectedToNetwork()
        
        if isOnline{
            self.navigateToMapVieController()
        }else{
            self.showErrorAlertPopup(title: BBCConstants.CustomErrorCodes.ONLINE_STATUS, message: BBCConstants.CustomErrorCodes.NO_INTRNET, okButtonTitle: BBCConstants.CustomErrorCodes.ALERT_CANCEL, cancelButtonTitle: BBCConstants.CustomErrorCodes.ALERT_SETTINGS)
        }
    }
    
    func keyboardAppear() {
        searchField.resignFirstResponder()
    }
}

extension BBCCityViewController: UITextFieldDelegate {
    
    //Hide the keyboard when press the "Done" of the keyboard
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.searchField = textField
        return true
    }
    
    //called when 'Done' key pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.viewModel.searchData = self.viewModel.data
        self.collectionView.reloadData()
        (self.viewModel.searchData.count == 0) ? (self.validationLabel.isHidden = false) : (self.validationLabel.isHidden = true)
        textField.resignFirstResponder()
        return true
    }
    
    /*
     Get the every text changes of textfield and process with "BBCityViewModel"
     */
    @objc func textFiedDidChange(_ textField: UITextField) {
        let search = textField.text?.lowercased()
        self.activityIndicator.startAnimating()
        
        if (search?.count != 0) {
            self.viewModel.sortByName(searchString: search!, completion: {
                self.collectionView.reloadData()
                self.searchFieldImage.isHidden = true
                (self.viewModel.searchData.count == 0) ? (self.validationLabel.isHidden = false) : (self.validationLabel.isHidden = true)
                self.activityIndicator.stopAnimating()
            })
            
        }else {
            self.viewModel.sortByName(searchString: search!, completion: {
                self.viewModel.searchData = self.viewModel.data
                self.collectionView.reloadData()
                (self.viewModel.searchData.count == 0) ? (self.validationLabel.isHidden = false) : (self.validationLabel.isHidden = true)
                self.searchFieldImage.isHidden = false
                self.activityIndicator.stopAnimating()
            })
        }
    }
}

extension BBCCityViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //XIB registre
    func nibRegistration() {
        let managerCell = UINib(nibName: "BBCCityCell", bundle: nil)
        self.collectionView?.register(managerCell, forCellWithReuseIdentifier: "BBCCityCell")
    }
    
    //Row
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SECTION_COUNT
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = self.flowLayout.sectionInset
        let width = self.collectionView!.bounds.size.width - (insets.left + insets.right)
        return CGSize(width: width, height: ROE_HEIGHT)
    }
    
    //Cell
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.activityIndicator.stopAnimating()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.activityIndicator.stopAnimating()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BBCCityCell", for: indexPath) as! BBCCityCell
        
        let cityObject = viewModel.searchData[indexPath.row]
        cell.displayCity(citty: cityObject)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.checkOnlineStatusValidation()
    }
}

extension BBCCityViewController: UIViewControllerPreviewingDelegate {
    /*
     3D touch inplrmantation to show the city in map view by long pressing
     Sample - https://developer.apple.com/ios/3d-touch/
     */
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let favoriteViewController = storyboard?.instantiateViewController(withIdentifier: "BBCMapView") as? BBCMapViewController
        favoriteViewController?.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        let offsetPoint = self.collectionView.contentOffset
        let realLocation = CGPoint(x: location.x + offsetPoint.x, y: location.y + offsetPoint.y)
        if let indexPath = self.collectionView.indexPathForItem(at: realLocation){
            let cityObject = viewModel.data[indexPath.row]
            favoriteViewController?.viewModel = BBCMapViewModel(city: cityObject)
            return favoriteViewController
        }
        
        return favoriteViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //self.check3DTouch()
    }
}

/*
 Search function working on the background without
 disturbing the UI Thread... It has defined with the time delay
 */
extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}

