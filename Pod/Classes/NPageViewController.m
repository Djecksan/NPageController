//
//  NPageViewController.m
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

#import "NPageViewController.h"

@interface NPageViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *pageControllerScrollView;

@end

@implementation NPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    self.dataSource = self;

    self.pageControllerScrollView = self.view.subviews.firstObject;
    self.pageControllerScrollView.delegate = self;

    [self reloadViewControllers];

}

- (void)setCurrentPage:(NSInteger)page {

}

- (void)reloadViewControllers {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return nil;
}
@end


//class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
//
//    lazy var viewControllerTitles : [String] = []
//    lazy var viewControllerArray : [UIViewController] = []
//
//    private var currentPageIndex : Int = 0
//    dynamic private(set) var pageIndex : Int = 0
//
//    var pageControllerScrollView: UIScrollView?
//
//    var topScrollView : UIScrollView!
//    var pageControl : UIPageControl!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.delegate = self
//        self.dataSource = self
//
//        self.pageControllerScrollView = (self.view.subviews.first as? UIScrollView)
//        self.pageControllerScrollView?.delegate = self
//
//        self.reloadViewControllers()
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    func setCurrentPage(page: Int, animated: Bool, force: Bool = false) {
//
//        struct Previous {
//            static var timestamp: NSTimeInterval = 0
//        }
//
//        if page < 0
//            || page >= self.viewControllerArray.count
//            || (self.pageIndex == page && !force) {
//                return;
//            }
//
//        Previous.timestamp = NSDate().timeIntervalSince1970
//        let timestamp = Previous.timestamp
//
//        self.setViewControllers([self.viewControllerArray[page]],
//                                direction: page > self.currentPageIndex ? UIPageViewControllerNavigationDirection.Forward : .Reverse,
//                                animated: animated,
//                                completion: { [weak self] finished in
//                                    if (finished) {
//                                        dispatch_async(dispatch_get_main_queue()) {
//                                            if let strongSelf = self {
//                                                if (timestamp != Previous.timestamp) {
//                                                    return
//                                                }
//                                                strongSelf.setViewControllers([strongSelf.viewControllerArray[page]],
//                                                                              direction: UIPageViewControllerNavigationDirection.Forward,
//                                                                              animated: false,
//                                                                              completion: nil)
//                                            }
//                                            return
//                                        }
//                                    }
//                                    return
//                                })
//
//        if !animated {
//            self.currentPageIndex = page
//            self.pageIndex = page
//
//            if let scrollView = self.pageControllerScrollView {
//                self.scrollViewDidScroll(scrollView)
//            }
//        }
//    }
//
//    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//        self.currentPageIndex = max(0, self.currentPageIndex - 1)
//
//        for (index, vc) in enumerate(self.viewControllerArray) {
//            if viewController === vc && index != 0 {
//                return self.viewControllerArray[index - 1]
//            }
//        }
//
//        return nil
//    }
//
//    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
//        self.currentPageIndex = min(self.viewControllerArray.count - 1, self.currentPageIndex + 1)
//
//        for (index, vc) in enumerate(self.viewControllerArray) {
//            if viewController === vc && index != self.viewControllerArray.count - 1 {
//                return self.viewControllerArray[index + 1]
//            }
//        }
//
//        return nil
//    }
//
//    func reloadViewControllers() {
//        if self.viewControllerArray.first != nil {
//            self.setViewControllers([self.viewControllerArray[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
//        }
//
//
//        var view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
//        view.userInteractionEnabled = false
//        view.clipsToBounds = false
//
//        self.topScrollView = UIScrollView(frame: view.bounds)
//        self.topScrollView.scrollsToTop = false;
//        self.topScrollView.contentSize.width = self.topScrollView.bounds.width * CGFloat(self.viewControllerArray.count)
//        self.topScrollView.pagingEnabled = true
//        self.topScrollView.showsVerticalScrollIndicator = false
//        self.topScrollView.showsHorizontalScrollIndicator = false
//        self.topScrollView.clipsToBounds = false
//
//        self.navigationItem.titleView = view
//
//        for i in 0..<self.viewControllerArray.count {
//            var label = PageViewLabel(frame: self.topScrollView.bounds)
//            label.backgroundColor = UIColor.clearColor()
//            label.opaque = false
//            label.textAlignment = .Center
//            label.numberOfLines = 0
//            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
//            label.text = self.viewControllerTitles.count > i ? self.viewControllerTitles[i] : ""
//            label.frame.origin.x = CGFloat(i) * self.topScrollView.bounds.width
//
//            label.font = UIFont.systemFontOfSize(14)
//            label.adjustsFontSizeToFitWidth = true
//            label.minimumScaleFactor = 0.25
//
//            self.setupLabel(index: i, label: label)
//
//
//
//            self.topScrollView.addSubview(label)
//        }
//
//        self.topScrollView.backgroundColor = UIColor.clearColor()
//
//        self.view.backgroundColor = UIColor._whiteDark()
//
//        view.addSubview(self.topScrollView)
//
//        self.pageControl = UIPageControl(frame: view.bounds)
//        self.pageControl.numberOfPages = self.viewControllerArray.count
//        self.pageControl.transform = CGAffineTransformMakeScale(0.65, 0.65)
//        self.pageControl.center.y = view.bounds.height - 3
//        self.pageControl.pageIndicatorTintColor = UIColor.whiteColor().alpha(0.75)
//        self.pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
//
//        view.addSubview(self.pageControl)
//
//        for (index, view) in enumerate(self.topScrollView.subviews) {
//            (view as? UIView)?.alpha = 0
//        }
//
//        self.currentPageIndex = 0
//    }
//
//    func setupLabel(#index: Int, label: PageViewLabel?) {
//
//    }
//
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        var width = self.view.frame.width + ((self.valueForKey("pageSpacing") as? CGFloat) ?? 0)
//        var value = CGFloat(self.currentPageIndex) * (self.topScrollView.frame.width ?? 0)
//
//        if scrollView.contentOffset.x == width {
//            for (index, vc) in enumerate(self.viewControllerArray) {
//                if vc === self.viewControllers.first {
//                    self.currentPageIndex = index
//                    self.pageIndex = index
//                }
//            }
//            value = CGFloat(self.currentPageIndex) * (self.topScrollView.frame.width ?? 0)
//            self.topScrollView.contentOffset.x = value
//        }
//        else {
//            var persentage = (scrollView.contentOffset.x - width) / scrollView.bounds.width
//            self.topScrollView.contentOffset.x = value + (persentage * self.topScrollView.bounds.width ?? 0)
//        }
//
//        var firstIndex = Int(floor(self.topScrollView.contentOffset.x / self.topScrollView.bounds.width))
//        var secondIndex = Int(floor(self.topScrollView.contentOffset.x / self.topScrollView.bounds.width + 1))
//        var delta = CGFloat(secondIndex) - self.topScrollView.contentOffset.x / self.topScrollView.bounds.width
//        
//        for (index, view) in enumerate(self.topScrollView.subviews) {
//            (view as? UIView)?.alpha = 0
//            
//            if firstIndex == index {
//                (view as? UIView)?.alpha = delta
//            }
//            
//            if secondIndex == index {
//                (view as? UIView)?.alpha = 1 - delta
//            }
//        }
//        
//        self.pageControl.currentPage = Int(floor(self.topScrollView.contentOffset.x / self.topScrollView.bounds.width + 0.5))
//        
//    }
//    
//    deinit {
//        self.delegate = nil
//        self.dataSource = nil
//        self.pageControllerScrollView?.delegate = nil
//    }
//}