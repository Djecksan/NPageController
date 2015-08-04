//
//  NPageViewController.h
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

@import UIKit;

@class NHPageViewController;

@protocol NHPageViewControllerDelegate <NSObject>

@optional
- (void)nhPageViewController:(NHPageViewController*)pageController
        didChangePageToIndex:(NSInteger)index
               andController:(UIViewController*)controller;

- (void)nhPageViewController:(NHPageViewController*)pageController
               didScrollView:(UIScrollView*)scrollView
                    toOffset:(CGPoint)offset;
@end

@interface NHPageViewController : UIPageViewController

@property (nonatomic, weak) id<NHPageViewControllerDelegate> nhDelegate;
@property (nonatomic, readonly, weak) UIScrollView *pageControllerScrollView;

@property (nonatomic, readonly, assign) NSInteger pageIndex;

@property (nonatomic, readonly, copy) NSArray *pages;

- (void)setPage:(UIViewController*)page atIndex:(NSInteger)index;

- (void)setCurrentPage:(NSInteger)page;
- (void)setCurrentPage:(NSInteger)page
        withCompletion:(void(^)(void))completion;
- (void)setCurrentPage:(NSInteger)page
              animated:(BOOL)animated;
- (void)setCurrentPage:(NSInteger)page
              animated:(BOOL)animated
        withCompletion:(void(^)(void))completion;
- (void)setCurrentPage:(NSInteger)page
              animated:(BOOL)animated
                 force:(BOOL)force;
- (void)setCurrentPage:(NSInteger)page
              animated:(BOOL)animated
                 force:(BOOL)force
        withCompletion:(void(^)(void))completion;

- (void)setPages:(NSArray*)array;
@end
