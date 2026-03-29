//
//  YTPreferenceWindow.h
//  yt2009
//
//  Created by Adithiya Venkatakrishnan on 28/03/2026.
//  Copyright (c) 2026 atomtables. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface YTPreferenceWindowController : NSWindowController <NSToolbarDelegate>

@property (strong) NSViewController *currentViewController;
+ (instancetype)sharedController;

@end
