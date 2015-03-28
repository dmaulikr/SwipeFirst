//
//  GameKitHelper.h
//  SwipeFirst
//
//  Created by Jared Weinstein on 3/28/15.
//  Copyright (c) 2015 CCHS. All rights reserved.
//

@import GameKit;

extern NSString *const PresentAuthenticationViewController;

@interface GameKitHelper : NSObject

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

+ (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;

@end