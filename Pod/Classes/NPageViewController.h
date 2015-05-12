//
//  NPageViewController.h
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

@import UIKit;

@interface NHPageViewController : UIPageViewController

@property (nonatomic, readonly, assign) NSInteger pageIndex;

- (void)setCurrentPage:(NSInteger)page;
- (void)setCurrentPage:(NSInteger)page animated:(BOOL)animated;
- (void)setCurrentPage:(NSInteger)page
              animated:(BOOL)animated
                 force:(BOOL)force;

- (void)setPages:(NSArray*)array;
@end
