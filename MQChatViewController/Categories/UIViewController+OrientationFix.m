//
//  UIViewController_Orientation.m
//  GrubbyWorm
//
//  Created by ian luo on 16/3/14.
//  Copyright © 2016年 GAME-CHINA.ORG. All rights reserved.
//

#import "UIViewController+OrientationFix.h"

@implementation UIViewController(OrientationFix)

- (BOOL)shouldAutorotate {
    return [self supportsLandscape] && [self supportsPortait];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIInterfaceOrientationMask supportedOrientation = 0;
    if ([self supportsLandscape]) {
        supportedOrientation |= UIInterfaceOrientationMaskLandscape;
    }
    
    if ([self supportsPortait]) {
        supportedOrientation |= UIInterfaceOrientationMaskPortrait;
        supportedOrientation |= UIInterfaceOrientationMaskPortraitUpsideDown;
    }
    
    return supportedOrientation;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [UIApplication sharedApplication].statusBarOrientation;
}

#pragma mark - private

- (NSArray *)supportedOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UISupportedInterfaceOrientations"];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UISupportedInterfaceOrientations~ipad"];
    } else {
        return @[@"UIInterfaceOrientationPortrait"];
    }
}

- (BOOL)supportsPortait {
    NSArray *supportedOrientation = [self supportedOrientations];
    BOOL support = NO;
    
    if ([supportedOrientation containsObject:@"UIInterfaceOrientationPortrait"] ||
        [supportedOrientation containsObject:@"UIInterfaceOrientationPortraitUpsideDown"]) {
        support = YES;
    }
    
    return support;
}

- (BOOL)supportsLandscape {
    NSArray *supportedOrientation = [self supportedOrientations];
    BOOL support = NO;
    
    if ([supportedOrientation containsObject:@"UIInterfaceOrientationLandscapeLeft"] ||
        [supportedOrientation containsObject:@"UIInterfaceOrientationLandscapeRight"]) {
        support = YES;
    }
    
    return support;
}

@end