//
//  ViewController.m
//  ESTabSwitchButton
//
//  Created by Shen Jian Song on 14-3-25.
//  Copyright (c) 2014年 Shen Jian Song. All rights reserved.
//

#import "ViewController.h"
#import "ESTabSwitchButton.h"

@interface ViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) ESTabSwitchButton *button;
@property (strong, nonatomic) UIScrollView *contentScrollView;
@property (strong, nonatomic) NSArray *buttonTitles;
@property (nonatomic, assign) CGFloat buttonRadius;
@property (nonatomic, assign) CGFloat middleWidth;
@property (nonatomic, assign) CGFloat xMargin;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.contentScrollView];
    self.contentScrollView.delegate = self;
    self.contentScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 3, self.view.bounds.size.height);
    _contentScrollView.pagingEnabled = YES;
    
    UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(60, 200, 200, 100)];
    orangeView.backgroundColor = [UIColor orangeColor];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(380, 200, 200, 100)];
    redView.backgroundColor = [UIColor redColor];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(700, 200, 200, 100)];
    blueView.backgroundColor = [UIColor blueColor];
    
    [self.contentScrollView addSubview:orangeView];
    [self.contentScrollView addSubview:redView];
    [self.contentScrollView addSubview:blueView];
    
    self.button = [[ESTabSwitchButton alloc] initWithFrame:CGRectMake(10, 100, 300, 40) buttonRadius:20 middleWidth:40 xMargin:30 minMarginHeight:16 maxOffset:10 controlRatio1:1.0f controlRatio2:0.7f buttonNum:3 buttonColors:@[[UIColor orangeColor], [UIColor redColor], [UIColor blueColor]] buttonTitles:@[@"早市", @"团购", @"抢购"] titleFont:[UIFont systemFontOfSize:15] titleColorInButton:[UIColor whiteColor] titleColorOutButton:[UIColor blackColor] titleColorHoldButton:[UIColor grayColor]];
    [self.button addTarget:self action:@selector(tabSwitchButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.button addTarget:self action:@selector(tabSwitchButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.button addTarget:self action:@selector(tabSwitchButtonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:self.button];
}

- (void)tabSwitchButtonValueChanged:(id)sender
{
    [self.contentScrollView setContentOffset:CGPointMake(self.button.distance * 320 / 110, 0) animated:NO];
}

- (void)tabSwitchButtonTouchUp:(id)sender
{
    ESTabSwitchButton *button = sender;
    CGFloat targetDistance = button.targetButtonIndex * (button.buttonRadius * 2 + button.middleWidth + button.xMargin);
    CGFloat duration = fabs(targetDistance - button.distance) * 0.4 / 110;
    
    if (fabs(targetDistance - button.distance) >= button.buttonWidthAndMargin) {
        [self.button setDistance:targetDistance withAnimationDuration:duration];
        [UIView animateWithDuration:duration animations:^{
            [self.contentScrollView setContentOffset:CGPointMake(targetDistance * 320 / 110, 0)];
        }];
    }
    else {
        [self.contentScrollView setContentOffset:CGPointMake(targetDistance * 320 / 110, 0) animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.button.distance = scrollView.contentOffset.x / 320 * 110;
}

@end
