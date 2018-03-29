//
//  UIView+Line.h
//  
//
//  Created by Bizfocus on 15/10/10.
//  Copyright © 2015年 cathy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Expense)

//添加旋转动画
- (void)setRotatingAnimation:(BOOL)isClockwise time:(NSInteger)time;
//移除旋转动画
- (void)removeRotatingAnimation;
//跳动的动画
- (void)setJumpupAnimation;
//中间扩散的动画
- (CAEmitterLayer *)setCenterHeartLayerWithFrame:(CGRect)rect;
//飘落的动画
- (CAEmitterLayer *)setEmitterLayerWithFrame:(CGRect)rect;
//变大变小的动画
- (void)getBiggerAndSmaller:(BOOL)repeat;
//晃动的动画
- (void)addShakeAnimation:(BOOL)repeat;
//移除晃动的动画
- (void)removeShakeAnimation;
//加返回动画
+ (void)setPopAnimation:(UIView *)view;
//加跳转动画
+ (void)setPushAnimation:(UIView *)view;
//自定义弹出画面
+ (void)pushCustomView:(UIView *)view animation:(BOOL)animated openTap:(BOOL)openTap completion:(void(^)(void))completion;
//自定义消失
+ (void)dismissCustomViewWithAnimated:(BOOL)animated completion:(void(^)(void))completion;
//加毛玻璃
+ (void)setBlurEffectView:(UIView *)view frame:(CGRect)frame;
//加背景
+ (void)setBackView:(UIView *)view frame:(CGRect)frame;
//加阴影
+ (void)setShadowLayer:(UIView *)view;
//加线
- (void)addLineWithCorner:(CGFloat)corner;

// 从底部弹出画面
+ (void)popBottomView:(UIView *)bottomView animation:(BOOL)animated;

// 消失
+ (void)dismissBottomViewWithAnimated:(BOOL)animated;

+ (instancetype)viewFromNib;

- (void)cleanSawtooth;

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;

/**
 * The view controller whose view contains this view.
 */
- (UIViewController*)viewController;

@end
