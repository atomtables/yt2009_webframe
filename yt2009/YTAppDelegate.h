//
//  YTAppDelegate.h
//  yt2009
//
//  Created by Adithiya Venkatakrishnan on 26/03/2026.
//  Copyright (c) 2026 atomtables. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YTMainWindow.h"
#import "YTPreferenceWindowController.h"

@class YTMainWindow;

@interface YTAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet YTMainWindow *window;
@property (strong) YTPreferenceWindowController* preferenceWindowController;
@property (strong) NSString* source;

@end
