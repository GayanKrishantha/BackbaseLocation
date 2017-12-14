//
//  BBCLoadingViewController.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import UIKit

class BBCLoadingViewController: BBCBaseViewController {

    var viewModel:BBCLoadingViewModel = BBCLoadingViewModel()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var scrolViewHolder: UIView!
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialImplementation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        self.loadScrollView()
    }
    
    //Status bar reference
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Custom mnethods
    func initialImplementation()  {
        //Add shadow effect to the search bar
        self.scrolViewHolder!.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.scrolViewHolder!.layer.shadowColor = UIColor.white.cgColor
        self.scrolViewHolder!.layer.shadowRadius = 4
        self.scrolViewHolder!.layer.shadowOpacity = 0.40
        self.scrolViewHolder!.layer.masksToBounds = false
        self.scrolViewHolder!.clipsToBounds = false
    }
    
    //MARK: Page tap action
    @objc func pageChanged() {
        let pageNumber = pageController.currentPage
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(pageNumber)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    //MARK: Button action
    @IBAction func skipButtonPressed(_ sender: Any) {
        self.navigateToCityViewControllert()
    }
    
    func navigateToCityViewControllert() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BBCCityView")  as? BBCCityViewController else {
            return
        }
        controller.viewModel = BBCCityViewModel()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func loadScrollView() {
        let pageCount : CGFloat = CGFloat(self.viewModel.retriveImageData().count)
        
        scrollView.backgroundColor = UIColor.clear
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * pageCount, height: scrollView.frame.size.height)
        
        scrollView.showsHorizontalScrollIndicator = false
        
        pageController.numberOfPages = Int(pageCount)
        pageController.addTarget(self, action: #selector(self.pageChanged), for: .valueChanged)
        
        for i in 0..<Int(pageCount) {
            //print(self.scrollView.frame.size.width)
            let image = UIImageView(frame: CGRect(x: self.scrollView.frame.size.width * CGFloat(i), y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height))
            image.layer.cornerRadius = 4
            image.image = UIImage(named: self.viewModel.retriveImageData()[i])
            image.contentMode = UIViewContentMode.scaleAspectFit
            self.scrollView.addSubview(image)
        }
    }
}

extension BBCLoadingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let viewWidth: CGFloat = scrollView.frame.size.width
        // content offset - tells by how much the scroll view has scrolled.
        let pageNumber = floor((scrollView.contentOffset.x - viewWidth / 50) / viewWidth) + 1
        pageController.currentPage = Int(pageNumber)
    }
}


