//
//  NPageViewController.m
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

#import "NHPageViewController.h"

@interface NHPageViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSArray *innerPages;

@property (nonatomic, weak) UIScrollView *pageControllerScrollView;

@property (nonatomic, assign) NSTimeInterval transitionTimestamp;
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
    
    
    self.transitionTimestamp = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval transitionTimestamp = self.transitionTimestamp;
    
    __weak __typeof(self) weakSelf = self;
    [self setViewControllers:@[self.innerPages[page]]
                   direction:(_pageIndex > page
                              ? UIPageViewControllerNavigationDirectionReverse
                              : UIPageViewControllerNavigationDirectionForward)
                    animated:animated
                  completion:^(BOOL finished) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          __strong __typeof(weakSelf) strongSelf = weakSelf;
                          
                          if (strongSelf.transitionTimestamp != transitionTimestamp) {
                              return;
                          }
                          
                          if (finished
                              && page < strongSelf.innerPages.count) {
                              [strongSelf setViewControllers:@[strongSelf.innerPages[page]]
                                                   direction:UIPageViewControllerNavigationDirectionForward
                                                    animated:NO
                                                  completion:nil];
                          }
                      });
                      
                  }];
    
    if (!animated) {
        self.pageIndex = page;
        [self scrollViewDidScroll:self.pageControllerScrollView];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.bounds.size.width;
    CGPoint contentOffset = scrollView.contentOffset;
    
    if (scrollView.contentOffset.x == width) {
        [self.innerPages enumerateObjectsUsingBlock:^(UIViewController *obj,
                                                      NSUInteger idx,
                                                      BOOL *stop) {
            if (obj == self.viewControllers.firstObject) {
                self.pageIndex = idx;
                
                __weak __typeof(self) weakSelf = self;
                if ([weakSelf.nhDelegate respondsToSelector:@selector(nhPageViewController:didChangePageToIndex:andController:)]) {
                    [weakSelf.nhDelegate nhPageViewController:weakSelf
                                         didChangePageToIndex:idx
                                                andController:obj];
                }
            }
        }];
    }
    
    __weak __typeof(self) weakSelf = self;
    if ([weakSelf.nhDelegate respondsToSelector:@selector(nhPageViewController:didScrollView:toOffset:)]) {
        [weakSelf.nhDelegate nhPageViewController:weakSelf
                                    didScrollView:scrollView
                                         toOffset:contentOffset];
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
    self.nhDelegate = nil;
    self.dataSource = nil;
    self.delegate = nil;
}

@end