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

- (void)setPage:(UIViewController*)page atIndex:(NSInteger)index {
    if (index >= self.innerPages.count) {
        return;
    }
    
    NSMutableArray *array = [self.innerPages mutableCopy];
    
    array[index] = page;
    
    self.innerPages = array;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIViewController *viewController = [self interactionViewController];
    viewController.view.userInteractionEnabled = YES;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    UIViewController *viewController = [self interactionViewController];
    viewController.view.userInteractionEnabled = YES;
    
    [self setCurrentPage:self.pageIndex animated:YES force:YES withCompletion:nil];
}

- (NSArray *)pages {
    return self.innerPages;
}

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

- (void)setCurrentPage:(NSInteger)page withCompletion:(void (^)(void))completion {
    [self setCurrentPage:page
                animated:NO
          withCompletion:completion];
}

- (void)setCurrentPage:(NSInteger)page
              animated:(BOOL)animated {
    [self setCurrentPage:page
                animated:animated
                   force:NO withCompletion:nil];
}

- (void)setCurrentPage:(NSInteger)page
              animated:(BOOL)animated withCompletion:(void (^)(void))completion {
    [self setCurrentPage:page
                animated:animated
                   force:NO withCompletion:completion];
}

- (void)setCurrentPage:(NSInteger)page
              animated:(BOOL)animated
                 force:(BOOL)force {
    [self setCurrentPage:page animated:animated force:force withCompletion:nil];
}

- (UIViewController*)interactionViewController {
    return self.parentViewController ?: self;
}

- (void)setCurrentPage:(NSInteger)page
              animated:(BOOL)animated
                 force:(BOOL)force
        withCompletion:(void (^)(void))completion {
    if (page < 0
        || page > self.innerPages.count - 1
        || (page == self.pageIndex
            && !force)) {
            return;
        }
    
    UIViewController *viewController = [self interactionViewController];
    viewController.view.userInteractionEnabled = NO;
    
    self.transitionTimestamp = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval transitionTimestamp = self.transitionTimestamp;
    
    __weak __typeof(self) weakSelf = self;
    [self setViewControllers:@[self.innerPages[page]]
                   direction:(_pageIndex > page
                              ? UIPageViewControllerNavigationDirectionReverse
                              : UIPageViewControllerNavigationDirectionForward)
                    animated:animated
                  completion:^(BOOL finished) {
                      viewController.view.userInteractionEnabled = YES;
                      
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
                                                  completion:^(BOOL finished) {
                                                      if (completion) {
                                                          completion();
                                                      }
                                                  }];
                          }
                      });
                      
                  }];
    
    if (!animated) {
        self.pageIndex = page;
        [self scrollViewDidScroll:self.pageControllerScrollView];
        if (completion) {
            completion();
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    UIViewController *viewController = [self interactionViewController];
    viewController.view.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UIViewController *viewController = [self interactionViewController];
    viewController.view.userInteractionEnabled = YES;
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