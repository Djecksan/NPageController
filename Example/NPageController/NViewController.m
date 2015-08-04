//
//  NViewController.m
//  NPageController
//
//  Created by Naithar on 04/23/2015.
//  Copyright (c) 2014 Naithar. All rights reserved.
//

#import "NViewController.h"
#import "NEmptyViewController.h"

@interface NViewController ()<NHPageViewControllerDelegate>

@property (strong, nonatomic) NHPageViewController *pageViewController;
@property (strong, nonatomic) UIButton *firstButton;
@property (strong, nonatomic) UIButton *seconButton;

@end

@implementation NViewController

- (void)viewDidLoad
{
    self.firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.firstButton.frame = CGRectMake(0, 0, 100, 40);
    self.firstButton.backgroundColor = [UIColor redColor];
    [self.firstButton addTarget:self action:@selector(firstButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    self.seconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.seconButton.frame = CGRectMake(150, 0, 100, 40);
    self.seconButton.backgroundColor = [UIColor greenColor];
    [self.seconButton addTarget:self action:@selector(secondButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.firstButton];
    [self.view addSubview:self.seconButton];
    
    
    self.pageViewController = [[NHPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:@{
                                         UIPageViewControllerOptionInterPageSpacingKey : @10
                                         }];
    self.pageViewController.nhDelegate = self;
    
    NEmptyViewController *firstViewController = [[NEmptyViewController alloc] init];
    firstViewController.view.backgroundColor = [UIColor redColor];
    
    NEmptyViewController *secondViewController = [[NEmptyViewController alloc] init];
    secondViewController.view.backgroundColor = [UIColor greenColor];
    
    [self.pageViewController setPages:@[firstViewController, secondViewController]];
    
    
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    [self.pageViewController setCurrentPage:1];
    
    [self.pageViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageViewController.view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0 constant:50]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageViewController.view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageViewController.view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageViewController.view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0 constant:0]];
    
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *viewController = [[UIViewController alloc] init];
        viewController.view.backgroundColor = [UIColor greenColor];
        
        [self.navigationController pushViewController:viewController animated:YES];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"dis");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"app");
}

- (void)firstButtonTouch:(id)_ {
    [self.pageViewController setCurrentPage:0 animated:YES];
}

- (void)secondButtonTouch:(id)_ {
    [self.pageViewController setCurrentPage:1 animated:YES];
}

- (void)nhPageViewController:(NHPageViewController *)pageController didChangePageToIndex:(NSInteger)index andController:(UIViewController *)controller {
    [self.firstButton setTitle:[@(index) stringValue] forState:UIControlStateNormal];
    [self.seconButton setTitle:[@(index) stringValue] forState:UIControlStateNormal];
}

- (void)nhPageViewController:(NHPageViewController *)pageController
               didScrollView:(UIScrollView *)scrollView
                    toOffset:(CGPoint)offset {
//    NSLog(@"%@", NSStringFromCGPoint(offset));
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
