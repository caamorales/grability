//
//  CMScaleAnimation.m
//  Grability
//
//  Created by Camilo Morales on 17/1/16.
//  Copyright © 2016 Camilo Morales. All rights reserved.
//

#import "CMScaleAnimation.h"
#import "ViewController.h"

@implementation CMScaleAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .45;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *originatingVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *destinationVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    [containerView addSubview:destinationVC.view];
    destinationVC.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        destinationVC.view.transform = CGAffineTransformIdentity;
        originatingVC.view.transform = [self transformForVC:originatingVC];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (CGAffineTransform) transformForVC: (UIViewController *) VC{
    if ([VC isKindOfClass:[ViewController class]]) {
        CGAffineTransform scale = CGAffineTransformMakeScale(0.1, 0.1);
        return CGAffineTransformRotate(scale, 2 * M_PI_2);
    }else{
        return CGAffineTransformMakeScale(0.1, 0.1);
    }

}

@end
