//
//  HCLBouncesView.m
//  AnimationBEIZER
//
//  Created by Charlie.huang on 15/9/9.
//  Copyright (c) 2015年 Chalie. All rights reserved.
//

#import "HCLBouncesView.h"
@implementation HCLBouncesView
{
    UIView *topView;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createLine];
        [self addPanGesture];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createLine];
        [self addPanGesture];
    }
    return self;
}
-(void)createLine
{
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.shapeLayer.lineWidth = 1.0f;
    self.shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:self.shapeLayer];
}
-(void)addPanGesture
{
    self.gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self  action:@selector(handlePan:)];
    [self addGestureRecognizer:self.gesture];
}
-(void)handlePan:(UIPanGestureRecognizer *)gesture
{
    
    CGFloat panX = [gesture locationInView:self].x;
    CGFloat panY = [gesture locationInView:self].y;
    
    if ( ABS(panY) < ABS(panX)) {
        
       // [self cancelPost];
        return;
    }
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
    }
    if (gesture.state == UIGestureRecognizerStateChanged) {
        if (panY >= 0) {
    self.shapeLayer.path = [self changePathByAmount:panY];
        }
    }

    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        
        [self topLineReturnFrom:panY];
    }

}
-(CGPathRef)changePathByAmount:(CGFloat)amount
{
    CGPoint leftPoint = CGPointMake(0, 0);
    CGPoint midPoint = CGPointMake(self.frame.size.width/2, amount);
    CGPoint rightPoint = CGPointMake(self.frame.size.width, 0);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:leftPoint];
    [path addQuadCurveToPoint:rightPoint controlPoint:midPoint];
    [path closePath];
    return path.CGPath;
}
-(void)cancelPost
{
 [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
     

 } completion:nil];
}
-(void)topLineReturnFrom:(CGFloat)positionX
{
    CAKeyframeAnimation *morph = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    NSArray *values = @[
                        (id) [self changePathByAmount:positionX],
                        (id) [self changePathByAmount:-(positionX * 0.4)],
                        (id) [self changePathByAmount:(positionX * 0.6)],
                        (id) [self changePathByAmount:-(positionX * 0.4)],
                        (id) [self changePathByAmount:(positionX * 0.25)],
                        (id) [self changePathByAmount:-(positionX * 0.15)],
                        (id) [self changePathByAmount:(positionX * 0.05)],
                        (id) [self changePathByAmount:0.0]
                        ];
    morph.values = values;
    morph.duration = 0.5;
    morph.removedOnCompletion = NO;
    morph.fillMode = kCAFillModeForwards;
    morph.delegate = self;
    [self.shapeLayer addAnimation:morph forKey:@"bounce_left"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(anim == [self.shapeLayer animationForKey:@"bounce_left"])
    {
        self.shapeLayer.path = [self changePathByAmount:0.0];
        [self.shapeLayer removeAllAnimations];
    }
}
@end
