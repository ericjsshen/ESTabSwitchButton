//
//  ESTabSwitchButton.m
//  ESTabSwitchButton
//
//  Created by Shen Jian Song on 14-3-25.
//  Copyright (c) 2014年 Shen Jian Song. All rights reserved.
//

#import "ESTabSwitchButton.h"
#import <QuartzCore/QuartzCore.h>

@class ESTabSwitchButtonShapeView;

@interface ESTabSwitchButton ()

@property (strong, nonatomic) ESTabSwitchButtonShapeView *shapeView;
@property (strong, nonatomic) NSMutableArray *tabTitleLabels;
@property (assign, nonatomic) CGFloat initialXOffset;
@property (assign, nonatomic) BOOL canMoveButton;

@end

@interface ESTabSwitchButtonShapeLayer : CALayer

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
@property (readonly, nonatomic) CGFloat buttonWidth;
@property (readonly, nonatomic) CGFloat buttonHeight;
@property (readonly, nonatomic) CGFloat buttonWidthAndMargin;
@property (assign, nonatomic) BOOL isNotAnimation;

@end

@interface ESTabSwitchButtonShapeView : UIView

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
@property (strong, nonatomic) UIColor *titleColorHoldButton;
@property (readonly, nonatomic) CGFloat buttonWidth;
@property (readonly, nonatomic) CGFloat buttonHeight;
@property (readonly, nonatomic) CGFloat buttonWidthAndMargin;
@property (readonly, nonatomic) ESTabSwitchButtonShapeLayer *shapeLayer;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) NSMutableArray *tabTitleLabels;
@property (assign, nonatomic) BOOL isHighlightTitle;

- (id)initWithFrame:(CGRect)frame buttonRadius:(CGFloat)buttonRadius middleWidth:(CGFloat)middleWidth xMargin:(CGFloat)xMargin minMarginHeight:(CGFloat)minMarginHeight maxOffset:(CGFloat)maxOffset controlRatio1:(CGFloat)controlRatio1 controlRatio2:(CGFloat)controlRatio2 buttonNum:(NSUInteger)buttonNum buttonColors:(NSArray *)buttonColors buttonTitles:(NSArray *)buttonTitles titleFont:(UIFont *)titleFont titleColorInButton:(UIColor *)titleColorInButton titleColorHoldButton:(UIColor *)titleColorHoldButton;
- (void)layoutTitleLabels;
- (void)setDistance:(CGFloat)distance withAnimationDuration:(CGFloat)duration;

@end

@implementation ESTabSwitchButton

#pragma mark - Track event

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint p = [touch locationInView:self];
    CGRect currentButtonRect = CGRectMake(_currentButtonIndex * self.buttonWidthAndMargin, 0, self.buttonWidth, self.buttonHeight);
    if (CGRectContainsPoint(currentButtonRect, p)) {
        _canMoveButton = YES;
        _initialXOffset = p.x - _currentButtonIndex * self.buttonWidthAndMargin;
        self.shapeView.isHighlightTitle = YES;
        [self.shapeView layoutTitleLabels];
        return YES;
    }
    else {
        _targetButtonIndex = MIN(MAX(0, floor(p.x / self.buttonWidthAndMargin)), _buttonNum - 1);
        [self highlightTitleLabel];
        _canMoveButton = NO;
        return YES;
    }
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint p = [touch locationInView:self];
    if (_canMoveButton) {
        CGFloat targetDistance = p.x - self.initialXOffset;
        self.distance = MIN(MAX(targetDistance, 0), self.buttonWidthAndMargin * (_buttonNum - 1));
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    else {
        _targetButtonIndex = MIN(MAX(0, floor(p.x / self.buttonWidthAndMargin)), _buttonNum - 1);
        [self highlightTitleLabel];
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint p = [touch locationInView:self];
    if (_canMoveButton) {
        _targetButtonIndex = MIN(MAX(0, round(_distance / self.buttonWidthAndMargin)), _buttonNum - 1);
        self.shapeView.isHighlightTitle = NO;
        [self.shapeView layoutTitleLabels];
    }
    else {
        _targetButtonIndex = MIN(MAX(0, floor(p.x / self.buttonWidthAndMargin)), _buttonNum - 1);
        [self layoutTitleLabels];
        if (_currentButtonIndex != _targetButtonIndex) {
        }
    }
}

#pragma mark - View control

- (void)createTabTitleLabels
{
    [_buttonTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *title = obj;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(idx * self.buttonWidthAndMargin, 0, self.buttonWidth, self.buttonHeight)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        titleLabel.font = _titleFont;
        titleLabel.textColor = _titleColorOutButton;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.userInteractionEnabled = NO;
        [self addSubview:titleLabel];
        [_tabTitleLabels addObject:titleLabel];
    }];
}

- (void)layoutTitleLabels
{
    [_tabTitleLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *titleLabel = obj;
        titleLabel.frame = CGRectMake(idx * self.buttonWidthAndMargin, 0, self.buttonWidth, self.buttonHeight);
        if (idx < _buttonTitles.count && [_buttonTitles[idx] isKindOfClass:[NSString class]]) {
            titleLabel.text = _buttonTitles[idx];
        }
        else {
            titleLabel.text = nil;
        }
        titleLabel.font = _titleFont;
        titleLabel.textColor = _titleColorOutButton;
    }];
}

- (void)highlightTitleLabel
{
    [_tabTitleLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *titleLabel = obj;
        if (idx == _targetButtonIndex) {
            titleLabel.textColor = _titleColorHoldButton;
        }
        else {
            titleLabel.textColor = _titleColorOutButton;
        }
    }];
}

#pragma mark - Setter

- (void)setDistance:(CGFloat)distance
{
    _distance = distance;
    _shapeView.distance = distance;
    _currentButtonIndex = MIN(MAX(0, floor(_distance / self.buttonWidthAndMargin)), _buttonNum - 1);
}

- (void)setDistance:(CGFloat)distance withAnimationDuration:(CGFloat)duration
{
    _distance = distance;
    [_shapeView setDistance:distance withAnimationDuration:duration];
    _currentButtonIndex = MIN(MAX(0, floor(_distance / self.buttonWidthAndMargin)), _buttonNum - 1);
}

- (void)setButtonRadius:(CGFloat)buttonRadius
{
    _buttonRadius = buttonRadius;
    _shapeView.buttonRadius = buttonRadius;
    [self layoutTitleLabels];
}

- (void)setMiddleWidth:(CGFloat)middleWidth
{
    _middleWidth = middleWidth;
    _shapeView.middleWidth = middleWidth;
    [self layoutTitleLabels];
}

- (void)setXMargin:(CGFloat)xMargin
{
    _xMargin = xMargin;
    _shapeView.xMargin = xMargin;
    [self layoutTitleLabels];
}

- (void)setMinMarginHeight:(CGFloat)minMarginHeight
{
    _minMarginHeight = minMarginHeight;
    _shapeView.minMarginHeight = minMarginHeight;
}

- (void)setMaxOffset:(CGFloat)maxOffset
{
    _maxOffset = maxOffset;
    _shapeView.maxOffset = maxOffset;
}

- (void)setControlRatio1:(CGFloat)controlRatio1
{
    _controlRatio1 = controlRatio1;
    _shapeView.controlRatio1 = controlRatio1;
}

- (void)setControlRatio2:(CGFloat)controlRatio2
{
    _controlRatio2 = controlRatio2;
    _shapeView.controlRatio2 = controlRatio2;
}

- (void)setButtonNum:(NSUInteger)buttonNum
{
    _buttonNum = buttonNum;
    _shapeView.buttonNum = buttonNum;
}

- (void)setButtonColors:(NSArray *)buttonColors
{
    _buttonColors = buttonColors;
    _shapeView.buttonColors = buttonColors;
}

- (void)setButtonTitles:(NSArray *)buttonTitles
{
    _buttonTitles = buttonTitles;
    _shapeView.buttonTitles = buttonTitles;
    [self layoutTitleLabels];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    _shapeView.titleFont = titleFont;
    [self layoutTitleLabels];
}

- (void)setTitleColorInButton:(UIColor *)titleColorInButton
{
    _titleColorInButton = titleColorInButton;
    _shapeView.titleColorInButton = titleColorInButton;
}

- (void)setTitleColorOutButton:(UIColor *)titleColorOutButton
{
    _titleColorOutButton = titleColorOutButton;
    [self layoutTitleLabels];
}

#pragma mark - Getter

- (CGFloat)buttonWidth
{
    return _buttonRadius * 2 + _middleWidth;
}

- (CGFloat)buttonHeight
{
    return _buttonRadius * 2;
}

- (CGFloat)buttonWidthAndMargin
{
    return _buttonRadius * 2 + _middleWidth + _xMargin;
}

#pragma mark - Life cycle

- (id)initWithFrame:(CGRect)frame buttonRadius:(CGFloat)buttonRadius middleWidth:(CGFloat)middleWidth xMargin:(CGFloat)xMargin minMarginHeight:(CGFloat)minMarginHeight maxOffset:(CGFloat)maxOffset controlRatio1:(CGFloat)controlRatio1 controlRatio2:(CGFloat)controlRatio2 buttonNum:(NSUInteger)buttonNum buttonColors:(NSArray *)buttonColors buttonTitles:(NSArray *)buttonTitles titleFont:(UIFont *)titleFont titleColorInButton:(UIColor *)titleColorInButton titleColorOutButton:(UIColor *)titleColorOutButton titleColorHoldButton:(UIColor *)titleColorHoldButton
{
    self = [super initWithFrame:frame];
    if (self) {
        _distance = 0;
        _buttonRadius = buttonRadius;
        _middleWidth = middleWidth;
        _xMargin = xMargin;
        _minMarginHeight = minMarginHeight;
        _maxOffset = maxOffset;
        _controlRatio1 = controlRatio1;
        _controlRatio2 = controlRatio2;
        _buttonNum = buttonNum;
        _buttonColors = buttonColors;
        _buttonTitles = buttonTitles;
        _titleFont = titleFont;
        _titleColorInButton = titleColorInButton;
        _titleColorOutButton = titleColorOutButton;
        _titleColorHoldButton = titleColorHoldButton;
        _currentButtonIndex = 0;
        _targetButtonIndex = 0;
        _tabTitleLabels = [[NSMutableArray alloc] init];
        [self createTabTitleLabels];
        _shapeView = [[ESTabSwitchButtonShapeView alloc] initWithFrame:self.bounds buttonRadius:_buttonRadius middleWidth:_middleWidth xMargin:_xMargin minMarginHeight:_minMarginHeight maxOffset:_maxOffset controlRatio1:_controlRatio1 controlRatio2:_controlRatio2 buttonNum:_buttonNum buttonColors:_buttonColors buttonTitles:_buttonTitles titleFont:_titleFont titleColorInButton:_titleColorInButton titleColorHoldButton:_titleColorHoldButton];
        _shapeView.userInteractionEnabled = NO;
        [self addSubview:_shapeView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame buttonRadius:20 middleWidth:40 xMargin:30 minMarginHeight:16 maxOffset:10 controlRatio1:1.0f controlRatio2:0.7f buttonNum:1 buttonColors:@[[UIColor blueColor]] buttonTitles:@[@""] titleFont:[UIFont systemFontOfSize:15] titleColorInButton:[UIColor whiteColor] titleColorOutButton:[UIColor blackColor] titleColorHoldButton:[UIColor grayColor]];
    if (self) {
    }
    return self;
}

@end

@implementation ESTabSwitchButtonShapeLayer

@dynamic buttonRadius;
@dynamic middleWidth;
@dynamic xMargin;
@dynamic minMarginHeight;
@dynamic maxOffset;
@dynamic controlRatio1;
@dynamic controlRatio2;
@dynamic buttonNum;
@dynamic buttonColors;

#pragma mark - Getter

- (CGFloat)buttonWidth
{
    return self.buttonRadius * 2 + self.middleWidth;
}

- (CGFloat)buttonHeight
{
    return self.buttonRadius * 2;
}

- (CGFloat)buttonWidthAndMargin
{
    return self.buttonRadius * 2 + self.middleWidth + self.xMargin;
}

#pragma mark - Life cycle

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    return [key isEqualToString:@"distance"] ? YES : [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
    if (self.isNotAnimation) {
        CGContextSetFillColorWithColor(ctx, [self colorForLayer].CGColor);
        CGContextAddRect(ctx, self.bounds);
        CGContextFillPath(ctx);
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = [self pathForLayer].CGPath;
        maskLayer.fillColor = [UIColor blackColor].CGColor;
        self.mask = maskLayer;
    }
    else {
        CGContextSetFillColorWithColor(ctx, [self colorForLayer].CGColor);
        CGContextAddPath(ctx, [self pathForLayer].CGPath);
        CGContextEOFillPath(ctx);
    }
}

#pragma mark - View control;

- (UIBezierPath *)pathForLayer
{
    CGFloat relativeDistance = 0;
    CGFloat offsetDistance = 0;
    if (self.distance <= 0) {
        relativeDistance = 0;
        offsetDistance = 0;
    }
    else if (self.distance >= self.buttonWidthAndMargin * (self.buttonNum - 1)) {
        relativeDistance = 0;
        offsetDistance = self.buttonWidthAndMargin * (self.buttonNum - 1);
    }
    else {
        NSUInteger buttonIndex = floor(self.distance / self.buttonWidthAndMargin);
        relativeDistance = self.distance - buttonIndex * self.buttonWidthAndMargin;
        offsetDistance = self.distance - relativeDistance;
    }
    
    CGFloat leftOffset = 0;
    CGFloat rightOffset = 0;
    CGFloat leftRadius = self.buttonRadius;
    CGFloat rightRadius = self.buttonRadius;
    CGFloat leftMiddleWidth = 0;
    CGFloat rightMiddleWidth = 0;
    CGFloat leftMarginWidth = 0;
    CGFloat rightMarginWidth = 0;
    CGFloat marginHeight = self.minMarginHeight;
    
    if (relativeDistance <= self.maxOffset) {
        leftOffset = relativeDistance;
    }
    else if (relativeDistance <= self.buttonWidthAndMargin / 2) {
        leftOffset = (self.buttonWidthAndMargin / 2 - relativeDistance) * self.maxOffset / (self.buttonWidthAndMargin / 2 - self.maxOffset);
    }
    else {
        leftOffset = 0;
    }
    
    if (relativeDistance >= self.buttonWidthAndMargin - self.maxOffset) {
        rightOffset = self.buttonWidthAndMargin - relativeDistance;
    }
    else if (relativeDistance >= self.buttonWidthAndMargin / 2) {
        rightOffset = (relativeDistance - self.buttonWidthAndMargin / 2) * self.maxOffset / (self.buttonWidthAndMargin / 2 - self.maxOffset);
    }
    else {
        rightOffset = 0;
    }
    
    if (relativeDistance - leftOffset <= self.middleWidth) {
        leftRadius = self.buttonRadius;
    }
    else if (relativeDistance - leftOffset <= self.middleWidth + self.buttonRadius + self.xMargin / 2) {
        leftRadius = self.minMarginHeight / 2 + (self.middleWidth + self.buttonRadius + self.xMargin / 2 - relativeDistance + leftOffset) * (self.buttonRadius - self.minMarginHeight / 2) / (self.buttonRadius + self.xMargin / 2);
    }
    else {
        leftRadius = self.minMarginHeight / 2 + (relativeDistance - leftOffset - self.middleWidth - self.buttonRadius - self.xMargin / 2) * (self.buttonRadius - self.minMarginHeight / 2) / (self.buttonRadius + self.xMargin / 2);
    }
    
    if (relativeDistance + rightOffset >= 2 * self.buttonRadius + self.xMargin) {
        rightRadius = self.buttonRadius;
    }
    else if (relativeDistance + rightOffset >= self.buttonRadius + self.xMargin / 2) {
        rightRadius = self.minMarginHeight / 2 + (relativeDistance + rightOffset - self.buttonRadius - self.xMargin / 2) * (self.buttonRadius - self.minMarginHeight / 2) / (self.buttonRadius + self.xMargin / 2);
    }
    else {
        rightRadius = self.minMarginHeight / 2 + (self.buttonRadius + self.xMargin / 2 - relativeDistance - rightOffset) * (self.buttonRadius - self.minMarginHeight / 2) / (self.buttonRadius + self.xMargin / 2);
    }
    
    if (relativeDistance <= self.middleWidth) {
        leftMiddleWidth = self.middleWidth - relativeDistance;
    }
    else {
        leftMiddleWidth = 0;
    }
    
    if (relativeDistance >= 2 * self.buttonRadius + self.xMargin) {
        rightMiddleWidth = relativeDistance - 2 * self.buttonRadius - self.xMargin;
    }
    else {
        rightMiddleWidth = 0;
    }
    
    if (relativeDistance <= self.buttonRadius + self.xMargin / 2) {
        leftMarginWidth = relativeDistance + self.middleWidth - MAX(self.middleWidth, relativeDistance);
    }
    else {
        leftMarginWidth = MAX(0, self.buttonRadius + self.middleWidth + self.xMargin / 2 - relativeDistance - leftMiddleWidth);
    }
    
    if (relativeDistance >= self.middleWidth + self.buttonRadius + self.xMargin / 2) {
        rightMarginWidth = MIN(self.buttonRadius * 2 + self.middleWidth + self.xMargin, relativeDistance + self.middleWidth) - relativeDistance;
    }
    else {
        rightMarginWidth = MAX(0, relativeDistance - self.buttonRadius - self.xMargin / 2 - rightMiddleWidth);
    }
    
    if (leftOffset > 0 && leftMiddleWidth + leftMarginWidth > 0) {
        CGFloat offsetLeftMiddleWidth = leftMiddleWidth + leftOffset * leftMiddleWidth / (leftMiddleWidth + leftMarginWidth);
        CGFloat offsetLeftMarginWidth = leftMarginWidth + leftOffset * leftMarginWidth / (leftMiddleWidth + leftMarginWidth);
        leftMiddleWidth = offsetLeftMiddleWidth;
        leftMarginWidth = offsetLeftMarginWidth;
    }
    
    if (rightOffset > 0 && rightMiddleWidth + rightMarginWidth > 0) {
        CGFloat offsetRightMiddleWidth = rightMiddleWidth + rightOffset * rightMiddleWidth / (rightMiddleWidth + rightMarginWidth);
        CGFloat offsetRightMarginWidth = rightMarginWidth + rightOffset * rightMarginWidth / (rightMiddleWidth + rightMarginWidth);
        rightMiddleWidth = offsetRightMiddleWidth;
        rightMarginWidth = offsetRightMarginWidth;
    }
    
    if (relativeDistance <= self.buttonRadius + self.xMargin / 2) {
        marginHeight = rightRadius * 2;
    }
    else if (relativeDistance >= self.middleWidth + self.buttonRadius + self.xMargin / 2) {
        marginHeight = leftRadius * 2;
    }
    else {
        marginHeight = self.minMarginHeight;
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(relativeDistance + offsetDistance - leftOffset + self.buttonRadius, self.buttonRadius + leftRadius)];
    [bezierPath addArcWithCenter:CGPointMake(relativeDistance + offsetDistance - leftOffset + self.buttonRadius, self.buttonRadius)
                          radius:leftRadius
                      startAngle:M_PI/2
                        endAngle:-M_PI/2
                       clockwise:YES];
    
    if (leftMiddleWidth > 0) {
        CGPoint currentPoint = [bezierPath currentPoint];
        [bezierPath addLineToPoint:CGPointMake(currentPoint.x + leftMiddleWidth, 0)];
    }
    
    if (leftMarginWidth > 0) {
        CGPoint topLeftPoint1 = [bezierPath currentPoint];
        CGPoint topLeftPoint2 = CGPointMake(topLeftPoint1.x + leftMarginWidth, topLeftPoint1.y + (leftRadius - marginHeight / 2));
        [bezierPath addCurveToPoint:topLeftPoint2
                      controlPoint1:CGPointMake(topLeftPoint1.x + self.controlRatio1 * leftRadius * leftMarginWidth / (self.buttonRadius + self.xMargin / 2), topLeftPoint1.y)
                      controlPoint2:CGPointMake(topLeftPoint2.x - self.controlRatio2 * leftRadius * leftMarginWidth / (self.buttonRadius + self.xMargin / 2), topLeftPoint2.y)];
    }
    
    if (rightMarginWidth > 0) {
        CGPoint topRightPoint1 = [bezierPath currentPoint];
        CGPoint topRightPoint2 = CGPointMake(topRightPoint1.x + rightMarginWidth, topRightPoint1.y - (rightRadius - marginHeight / 2));
        [bezierPath addCurveToPoint:topRightPoint2
                      controlPoint1:CGPointMake(topRightPoint1.x + self.controlRatio2 * rightRadius * rightMarginWidth / (self.buttonRadius + self.xMargin / 2), topRightPoint1.y)
                      controlPoint2:CGPointMake(topRightPoint2.x - self.controlRatio1 * rightRadius * rightMarginWidth / (self.buttonRadius + self.xMargin / 2), topRightPoint2.y)];
    }
    
    if (rightMiddleWidth > 0) {
        [bezierPath addLineToPoint:CGPointMake(relativeDistance + offsetDistance + rightOffset + self.buttonRadius + self.middleWidth, 0)];
    }
    
    [bezierPath addArcWithCenter:CGPointMake(relativeDistance + offsetDistance + rightOffset + self.buttonRadius + self.middleWidth, self.buttonRadius)
                          radius:rightRadius
                      startAngle:-M_PI/2
                        endAngle:M_PI/2
                       clockwise:YES];
    
    if (rightMiddleWidth > 0) {
        CGPoint currentPoint = [bezierPath currentPoint];
        [bezierPath addLineToPoint:CGPointMake(currentPoint.x - rightMiddleWidth, self.buttonRadius * 2)];
    }
    
    if (rightMarginWidth > 0) {
        CGPoint bottomRightPoint1 = [bezierPath currentPoint];
        CGPoint bottomRightPoint2 = CGPointMake(bottomRightPoint1.x - rightMarginWidth, bottomRightPoint1.y - (rightRadius - marginHeight / 2));
        [bezierPath addCurveToPoint:bottomRightPoint2
                      controlPoint1:CGPointMake(bottomRightPoint1.x - self.controlRatio1 * rightRadius * rightMarginWidth / (self.buttonRadius + self.xMargin / 2), bottomRightPoint1.y)
                      controlPoint2:CGPointMake(bottomRightPoint2.x + self.controlRatio2 * rightRadius * rightMarginWidth / (self.buttonRadius + self.xMargin / 2), bottomRightPoint2.y)];
    }
    
    if (leftMarginWidth > 0) {
        CGPoint bottomLeftPoint1 = [bezierPath currentPoint];
        CGPoint bottomLeftPoint2 = CGPointMake(bottomLeftPoint1.x - leftMarginWidth, bottomLeftPoint1.y + (leftRadius - marginHeight / 2));
        [bezierPath addCurveToPoint:bottomLeftPoint2
                      controlPoint1:CGPointMake(bottomLeftPoint1.x - self.controlRatio2 * leftRadius * leftMarginWidth / (self.buttonRadius + self.xMargin / 2), bottomLeftPoint1.y)
                      controlPoint2:CGPointMake(bottomLeftPoint2.x + self.controlRatio1 * leftRadius * leftMarginWidth / (self.buttonRadius + self.xMargin / 2), bottomLeftPoint2.y)];
    }
    
    [bezierPath closePath];
    
    return bezierPath;
}

- (UIColor *)colorForLayer
{
    CGFloat relativeDistance = 0;
    NSUInteger buttonIndex = 0;
    if (self.distance <= 0) {
        relativeDistance = 0;
        buttonIndex = 0;
    }
    else if (self.distance >= self.buttonWidthAndMargin * (self.buttonNum - 1)) {
        relativeDistance = 0;
        buttonIndex = self.buttonNum - 1;
    }
    else {
        buttonIndex = floor(self.distance / self.buttonWidthAndMargin);
        relativeDistance = self.distance - buttonIndex * self.buttonWidthAndMargin;
    }
    UIColor *leftButtonColor = nil;
    UIColor *rightButtonColor = nil;
    if (buttonIndex < self.buttonColors.count) {
        leftButtonColor = self.buttonColors[buttonIndex];
        rightButtonColor = self.buttonColors[buttonIndex];
    }
    if (buttonIndex + 1 < self.buttonColors.count) {
        rightButtonColor = self.buttonColors[buttonIndex + 1];
    }
    
    UIColor *currentColor = nil;
    if (leftButtonColor && rightButtonColor) {
        CGFloat leftButtonRedColor = 0;
        CGFloat leftButtonGreenColor = 0;
        CGFloat leftButtonBlueColor = 0;
        CGFloat leftButtonAlphaColor = 0;
        
        CGFloat rightButtonRedColor = 0;
        CGFloat rightButtonGreenColor = 0;
        CGFloat rightButtonBlueColor = 0;
        CGFloat rightButtonAlphaColor = 0;
        
        if ([leftButtonColor getRed:&leftButtonRedColor green:&leftButtonGreenColor blue:&leftButtonBlueColor alpha:&leftButtonAlphaColor] && [rightButtonColor getRed:&rightButtonRedColor green:&rightButtonGreenColor blue:&rightButtonBlueColor alpha:&rightButtonAlphaColor]) {
            CGFloat ratio = relativeDistance / self.buttonWidthAndMargin;
            CGFloat currentButtonRedColor = leftButtonRedColor + ratio * (rightButtonRedColor - leftButtonRedColor);
            CGFloat currentButtonGreenColor = leftButtonGreenColor + ratio * (rightButtonGreenColor - leftButtonGreenColor);
            CGFloat currentButtonBlueColor = leftButtonBlueColor + ratio * (rightButtonBlueColor - leftButtonBlueColor);
            CGFloat currentButtonAlphaColor = leftButtonAlphaColor + ratio * (rightButtonAlphaColor - leftButtonAlphaColor);
            
            currentColor = [UIColor colorWithRed:currentButtonRedColor green:currentButtonGreenColor blue:currentButtonBlueColor alpha:currentButtonAlphaColor];
        }
    }
    
    return currentColor;
}

@end

@implementation ESTabSwitchButtonShapeView

#pragma mark - View control

- (void)createTabTitleLabels
{
    [_buttonTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *title = obj;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_maxOffset - _distance + idx * self.buttonWidthAndMargin, 0, self.buttonWidth, self.buttonHeight)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        titleLabel.font = _titleFont;
        titleLabel.textColor = _titleColorInButton;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleView addSubview:titleLabel];
        [_tabTitleLabels addObject:titleLabel];
    }];
}

- (void)layoutTitleLabels
{
    _titleView.frame = CGRectMake(-_maxOffset + _distance, 0, _buttonRadius * 2 + _middleWidth + _maxOffset * 2, _buttonRadius * 2);
    [_tabTitleLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *titleLabel = obj;
        titleLabel.frame = CGRectMake(_maxOffset - _distance + idx * self.buttonWidthAndMargin, 0, self.buttonWidth, self.buttonHeight);
        if (idx < _buttonTitles.count && [_buttonTitles[idx] isKindOfClass:[NSString class]]) {
            titleLabel.text = _buttonTitles[idx];
        }
        else {
            titleLabel.text = nil;
        }
        titleLabel.font = _titleFont;
        if (self.isHighlightTitle) {
            titleLabel.textColor = _titleColorHoldButton;
        }
        else {
            titleLabel.textColor = _titleColorInButton;
        }
    }];
}

#pragma mark - Setter

- (void)setDistance:(CGFloat)distance
{
    _distance = distance;
    self.shapeLayer.distance = _distance;
    [self layoutTitleLabels];
    [self.layer setNeedsDisplay];
}

- (void)setDistance:(CGFloat)distance withAnimationDuration:(CGFloat)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"distance"];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:_distance];
    animation.toValue = [NSNumber numberWithFloat:distance];
    [self.layer addAnimation:animation forKey:nil];
    self.layer.mask = nil;
    
    self.shapeLayer.distance = distance;
    _distance = distance;
    [self.layer setNeedsDisplay];
    [UIView animateWithDuration:duration animations:^{
        [self layoutTitleLabels];
    }];
}

- (void)setButtonColors:(NSArray *)buttonColors
{
    _buttonColors = buttonColors;
    self.shapeLayer.buttonColors = buttonColors;
    [self.layer setNeedsDisplay];
}

- (void)setButtonTitles:(NSArray *)buttonTitles
{
    _buttonTitles = buttonTitles;
    [self layoutTitleLabels];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    [self layoutTitleLabels];
}

- (void)setTitleColorInButton:(UIColor *)titleColorInButton
{
    _titleColorInButton = titleColorInButton;
    [self layoutTitleLabels];
}

#pragma mark - Getter

- (CGFloat)buttonWidth
{
    return _buttonRadius * 2 + _middleWidth;
}

- (CGFloat)buttonHeight
{
    return _buttonRadius * 2;
}

- (CGFloat)buttonWidthAndMargin
{
    return _buttonRadius * 2 + _middleWidth + _xMargin;
}

- (ESTabSwitchButtonShapeLayer *)shapeLayer
{
    return (ESTabSwitchButtonShapeLayer *)self.layer;
}

#pragma mark - Life cycle

+ (Class)layerClass
{
    return [ESTabSwitchButtonShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame buttonRadius:(CGFloat)buttonRadius middleWidth:(CGFloat)middleWidth xMargin:(CGFloat)xMargin minMarginHeight:(CGFloat)minMarginHeight maxOffset:(CGFloat)maxOffset controlRatio1:(CGFloat)controlRatio1 controlRatio2:(CGFloat)controlRatio2 buttonNum:(NSUInteger)buttonNum buttonColors:(NSArray *)buttonColors buttonTitles:(NSArray *)buttonTitles titleFont:(UIFont *)titleFont titleColorInButton:(UIColor *)titleColorInButton titleColorHoldButton:(UIColor *)titleColorHoldButton
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.backgroundColor = [UIColor clearColor];
        ESTabSwitchButtonShapeLayer *layer = self.shapeLayer;
        layer.isNotAnimation = YES;
        _distance = 0;
        layer.distance = _distance;
        _buttonRadius = buttonRadius;
        layer.buttonRadius = _buttonRadius;
        _middleWidth = middleWidth;
        layer.middleWidth = _middleWidth;
        _xMargin = xMargin;
        layer.xMargin =_xMargin;
        _minMarginHeight = minMarginHeight;
        layer.minMarginHeight = _minMarginHeight;
        _maxOffset = maxOffset;
        layer.maxOffset = _maxOffset;
        _controlRatio1 = controlRatio1;
        layer.controlRatio1 = _controlRatio1;
        _controlRatio2 = controlRatio2;
        layer.controlRatio2 = _controlRatio2;
        _buttonNum = buttonNum;
        layer.buttonNum = _buttonNum;
        _buttonColors = buttonColors;
        layer.buttonColors = _buttonColors;
        _buttonTitles = buttonTitles;
        _titleFont = titleFont;
        _titleColorInButton = titleColorInButton;
        _titleColorHoldButton = titleColorHoldButton;
        _tabTitleLabels = [[NSMutableArray alloc] init];
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(-_maxOffset + _distance, 0, _buttonRadius * 2 + _middleWidth + _maxOffset * 2, _buttonRadius * 2)];
        _titleView.clipsToBounds = YES;
        [self addSubview:_titleView];
        [self createTabTitleLabels];
        [self addObserver:self forKeyPath:@"buttonRadius" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"middleWidth" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"xMargin" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"minMarginHeight" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"maxOffset" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"controlRatio1" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"controlRatio2" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"buttonNum" options:0 context:NULL];
        [self.layer setNeedsDisplay];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame buttonRadius:20 middleWidth:40 xMargin:30 minMarginHeight:16 maxOffset:10 controlRatio1:1.0f controlRatio2:0.7f buttonNum:1 buttonColors:@[[UIColor blueColor]] buttonTitles:@[@""] titleFont:[UIFont systemFontOfSize:15] titleColorInButton:[UIColor whiteColor] titleColorHoldButton:[UIColor grayColor]];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"buttonRadius"];
    [self removeObserver:self forKeyPath:@"middleWidth"];
    [self removeObserver:self forKeyPath:@"xMargin"];
    [self removeObserver:self forKeyPath:@"minMarginHeight"];
    [self removeObserver:self forKeyPath:@"maxOffset"];
    [self removeObserver:self forKeyPath:@"controlRatio1"];
    [self removeObserver:self forKeyPath:@"controlRatio2"];
    [self removeObserver:self forKeyPath:@"buttonNum"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"buttonRadius"]) {
        self.shapeLayer.buttonRadius = _buttonRadius;
        [self.layer setNeedsDisplay];
        [self layoutTitleLabels];
    }
    else if (object == self && [keyPath isEqualToString:@"middleWidth"]) {
        self.shapeLayer.middleWidth = _middleWidth;
        [self.layer setNeedsDisplay];
        [self layoutTitleLabels];
    }
    else if (object == self && [keyPath isEqualToString:@"xMargin"]) {
        self.shapeLayer.xMargin = _xMargin;
        [self.layer setNeedsDisplay];
        [self layoutTitleLabels];
    }
    else if (object == self && [keyPath isEqualToString:@"minMarginHeight"]) {
        self.shapeLayer.minMarginHeight = _minMarginHeight;
        [self.layer setNeedsDisplay];
    }
    else if (object == self && [keyPath isEqualToString:@"maxOffset"]) {
        self.shapeLayer.maxOffset = _maxOffset;
        [self.layer setNeedsDisplay];
    }
    else if (object == self && [keyPath isEqualToString:@"controlRatio1"]) {
        self.shapeLayer.controlRatio1 = _controlRatio1;
        [self.layer setNeedsDisplay];
    }
    else if (object == self && [keyPath isEqualToString:@"controlRatio2"]) {
        self.shapeLayer.controlRatio2 = _controlRatio2;
        [self.layer setNeedsDisplay];
    }
    else if (object == self && [keyPath isEqualToString:@"buttonNum"]) {
        self.shapeLayer.buttonNum = _buttonNum;
        [self.layer setNeedsDisplay];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end

