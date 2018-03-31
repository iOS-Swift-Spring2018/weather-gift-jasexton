//
//  PageVC.swift
//  WeatherGift1
//
//  Created by Jack Sexton on 3/26/18.
//  Copyright © 2018 Jack Sexton. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController
{
   
    
    // Keeps track of current page
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var pageControl: UIPageControl!
    var listButton: UIButton!
    var barButtonWidth: CGFloat = 44
    var barButtonHeight: CGFloat = 44
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        var newLocation = WeatherLocation()
        newLocation.name = ""
        locationsArray.append(newLocation)
        
        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
      
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        configurePageControl()
        configureListButton()
    }
    //MARK:- Configure Methods
    func configurePageControl()
    {
        let pageControlHeight: CGFloat = barButtonHeight
        let pageControlWidth: CGFloat = view.frame.width - (barButtonWidth*2)
        
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth)/2, y: safeHeight - pageControlHeight, width: pageControlWidth, height: pageControlHeight ))
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.backgroundColor = UIColor.white
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        pageControl.addTarget(self, action: #selector(pageControlPressed), for: .touchUpInside)
        
        view.addSubview(pageControl)
    }
    
    func configureListButton()
    {
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        listButton = UIButton(frame: CGRect(x: view.frame.width - barButtonWidth, y: safeHeight - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        
        listButton.setImage(UIImage(named: "listButton"), for: .normal)
        listButton.setImage(UIImage(named: "listButton-highlighted"), for: .highlighted)
        
        listButton.addTarget(self, action: #selector(segueToListVC), for: .touchUpInside)
        
        view.addSubview(listButton)
    }
    //Mark:- Segues
    @objc func segueToListVC()
    {
        performSegue(withIdentifier: "ToListVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        guard let currentViewController = self.viewControllers?[0] as? DetailedVC else {return}
        locationsArray = currentViewController.locationsArray
        if segue.identifier == "ToListVC"
        {
            let destination = segue.destination as! ListVC
            destination.locationsArray = locationsArray
            destination.currentPage = currentPage
        }
    }
    
    @IBAction func unwindFromListVC(sender: UIStoryboardSegue)
    {
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        setViewControllers([createDetailVC(forPage: currentPage)], direction: .forward, animated: false, completion: nil)
    }
    
    //MARK:- Create View Controller for UIViewPageViewController
    func createDetailVC(forPage page: Int) -> DetailedVC
    {
        currentPage = min(max(0, page), locationsArray.count - 1)
        
        let detailedVC = storyboard!.instantiateViewController(withIdentifier: "DetailedVC") as! DetailedVC
        
        detailedVC.locationsArray = locationsArray
        detailedVC.currentPage = currentPage
        
        return detailedVC
    }
}




extension PageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
    //After
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        //swiped left to right. Do we create page for page after this?
        if let currentViewController = viewController as? DetailedVC
        {
            if currentViewController.currentPage < locationsArray.count - 1
            {
                return createDetailVC(forPage: currentViewController.currentPage + 1)
            }
        }
        return nil
    }
    //Before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        if let currentViewController = viewController as? DetailedVC
        {
            if currentViewController.currentPage > 0
            {
                return createDetailVC(forPage: currentViewController.currentPage - 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if let currentViewController = pageViewController.viewControllers?[0] as? DetailedVC
        {
            pageControl.currentPage = currentViewController.currentPage
        }
    }
    
    @objc func pageControlPressed()
    {
        guard let currentViewController = self.viewControllers?[0] as? DetailedVC else {return}
            currentPage = currentViewController.currentPage
            // Black dot moving backward
            if pageControl.currentPage < currentPage
            {
                setViewControllers([createDetailVC(forPage: pageControl.currentPage)], direction: .reverse, animated: true, completion: nil)
            }
                // Black dot moving forward
            else if pageControl.currentPage > currentPage
            {
                setViewControllers([createDetailVC(forPage: pageControl.currentPage)], direction: .forward, animated: true, completion: nil)
            }
    }
    
}
