//
//  ESTabSwitchButton.h
//  ESTabSwitchButton
//
//  Created by Shen Jian Song on 14-3-25.
//  Copyright (c) 2014年 Shen Jian Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESTabSwitchButton : UIControl

@property (assign, nonatomic) CGFloat distance;
@property (assign, nonatomic) CGFloat buttonRadius;
@property (assign, nonatomic) CGFloat middleWidth;
@property (assign, nonatomic) CGFloat xMargin;
@property (assign, nonatomic) CGFloat minMarginHeight;
@property (assign, nonatomic) CGFloat maxOffset;
@property (assign, nonatomic) CGFloat controlRatio1;
@property (assign, nonatomic) CGFloat controlRatio2;
@property (assign, nonatomic) NSUInteger buttonNum;
@property (strong, nonatomic) NSArray *buttonColors;
@property (strong, nonatomic) NSArray *buttonTitles;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *titleColorInButton;
@property (strong, nonatomic) UIColor *titleColorOutButton;
@property (strong, nonatomic) UIColor *titleColorHoldButton;
@property (assign, nonatomic) NSInteger currentButtonIndex;
@property (assign, nonatomic) NSInteger targetButtonIndex;
@property (readonly, nonatomic) CGFloat buttonWidth;
@property (readonly, nonatomic) CGFloat buttonHeight;
@property (readonly, nonatomic) CGFloat buttonWidthAndMargin;

- (id)initWithFrame:(CGRect)frame buttonRadius:(CGFloat)buttonRadius middleWidth:(CGFloat)middleWidth xMargin:(CGFloat)xMargin minMarginHeight:(CGFloat)minMarginHeight maxOffset:(CGFloat)maxOffset controlRatio1:(CGFloat)controlRatio1 controlRatio2:(CGFloat)controlRatio2 buttonNum:(NSUInteger)buttonNum buttonColors:(NSArray *)buttonColors buttonTitles:(NSArray *)buttonTitles titleFont:(UIFont *)titleFont titleColorInButton:(UIColor *)titleColorInButton titleColorOutButton:(UIColor *)titleColorOutButton titleColorHoldButton:(UIColor *)titleColorHoldButton;
- (void)setDistance:(CGFloat)distance withAnimationDuration:(CGFloat)duration;

@end
