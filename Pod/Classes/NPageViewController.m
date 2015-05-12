//
//  NPageViewController.m
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

#import "NPageViewController.h"

@interface NHPageViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSArray *innerPages;

@property (nonatomic, weak) UIScrollView *pageControllerScrollView;

@end

@implementation NHPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    self.dataSource = self;

    self.pageIndex = 0;

    self.pageControllerScrollView = self.view.subviews.firstObject;
    self.pageControllerScrollView.delegate = self;

    if (self.innerPages.firstObject) {
        [self setViewControllers:@[self.innerPages.firstObject]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:nil];
    }

}

- (void)setPages:(NSArray*)array {
    self.innerPages = array;
}

- (void)setCurrentPage:(NSInteger)page {
    [self setCurrentPage:page
                animated:NO];
}

- (void)setCurrentPage:(NSInteger)page
              animated:(BOOL)animated {
    [self setCurrentPage:page
                animated:animated
                   force:NO];
}

- (void)setCurrentPage:(NSInteger)page
              animated:(BOOL)animated
                 force:(BOOL)force {
    if (page < 0
        || page > self.innerPages.count - 1
        || (page == self.pageIndex
            && !force)) {
        return;
    }


    __weak __typeof(self) weakSelf = self;
    [self setViewControllers:@[self.innerPages[page]]
                   direction:(self.pageIndex > page
                              ? UIPageViewControllerNavigationDirectionReverse
                              : UIPageViewControllerNavigationDirectionForward)
                    animated:animated
                  completion:^(BOOL finished) {
                      __strong __typeof(weakSelf) strongSelf = weakSelf;
                      if (finished) {
                          [strongSelf setViewControllers:@[strongSelf.innerPages[page]]
                                               direction:UIPageViewControllerNavigationDirectionForward
                                                animated:NO
                                              completion:nil];
                      }
                  }];

    if (!animated) {
        self.pageIndex = page;
        [self scrollViewDidScroll:self.pageControllerScrollView];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.bounds.size.width;

    if (scrollView.contentOffset.x == width) {
        [self.innerPages enumerateObjectsUsingBlock:^(UIViewController *obj,
                                                      NSUInteger idx,
                                                      BOOL *stop) {
            if (obj == self.viewControllers.firstObject) {
                self.pageIndex = idx;
            }
        }];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    __block UIViewController *resultViewController;

    [self.innerPages enumerateObjectsUsingBlock:^(UIViewController *obj,
                                                  NSUInteger idx,
                                                  BOOL *stop) {
        if (viewController == obj && idx > 0) {
            resultViewController = self.innerPages[idx - 1];
            *stop = YES;
        }
    }];

    return resultViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    __block UIViewController *resultViewController;

    [self.innerPages enumerateObjectsUsingBlock:^(UIViewController *obj,
                                                  NSUInteger idx,
                                                  BOOL *stop) {
        if (viewController == obj && idx < self.innerPages.count - 1) {
            resultViewController = self.innerPages[idx + 1];
            *stop = YES;
        }
    }];

    return resultViewController;
}

- (void)dealloc {
    self.pageControllerScrollView.delegate = nil;
    self.dataSource = nil;
    self.delegate = nil;
}
@end

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
