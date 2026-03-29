//
//  YTMainWindow.h
//  yt2009
//
//  Created by Adithiya Venkatakrishnan on 26/03/2026.
//  Copyright (c) 2026 atomtables. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YTWebView.h"
#import "YTMenuSegmentedControlView.h"

@class YTWebView;

@interface YTMainWindow : NSWindow

@property (nonatomic, retain) NSSegmentedControl* backForwardButtons;
@property (nonatomic, retain) NSProgressIndicator* progressBar;
@property (nonatomic, retain) YTMenuSegmentedControlView* menuButtons;
@property (nonatomic, weak) IBOutlet YTWebView* webview;

@end
