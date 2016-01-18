//
//  NavigationControllerDelegate.m
//  Grability
//
//  Created by Camilo Morales on 18/1/16.
//  Copyright © 2016 Camilo Morales. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "CMScaleAnimation.h"
#import "ViewController.h"

@implementation NavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    //id<UIViewControllerAnimatedTransitioning> animation = nil;
    return [[CMScaleAnimation alloc] init];
  //  return [fromVC isKindOfClass:[ViewController class]] ? nil : [[CMScaleAnimation alloc] init];
    //return  animation;
}

@end
