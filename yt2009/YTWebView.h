//
//  YTWebView.h
//  yt2009
//
//  Created by Adithiya Venkatakrishnan on 26/03/2026.
//  Copyright (c) 2026 atomtables. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <WebKit/WebUIDelegate.h>
#import "YTAppDelegate.h"
#import "YTMenuSegmentedControlView.h"

@interface YTWebView : WebView

- (void)menuButtonHandler:(YTMenuSegmentedControlView*)sender;

@end
