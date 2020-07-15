//
//  ViewController.swift
//  QonilQui
//
//  Created by Alisher Sattarbek on 7/3/20.
//  Copyright © 2020 AlisherSattarbek. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let arr = ["Welcome1", "Welcome2", "Welcome3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = arr.count
        
        for i in 0..<arr.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.image = UIImage(named: arr[i])
            let xPos = CGFloat(i)*self.view.bounds.size.width
            imageView.frame = CGRect(x: xPos, y:0, width: view.frame.size.width, height: scrollView.frame.size.height)
            scrollView.contentSize.width = view.frame.size.width*CGFloat(i+1)
            scrollView.addSubview(imageView)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        
        pageControl.currentPage = Int(page)
    }

}
