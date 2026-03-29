//
//  YTWebView.m
//  yt2009
//
//  Created by Adithiya Venkatakrishnan on 26/03/2026.
//  Copyright (c) 2026 atomtables. All rights reserved.
//

#import "YTWebView.h"

@implementation YTWebView

- (void)awakeFromNib {
    [self setUIDelegate:self];
    [self setFrameLoadDelegate:self];
    [self setNotificationsFromProgress];
    
    YTMainWindow* window = (YTMainWindow*)[self window];
    [window.backForwardButtons setEnabled:false forSegment:0];
    [window.backForwardButtons setEnabled:false forSegment:1];
    
    [window.backForwardButtons setTarget:self];
    [window.backForwardButtons setAction:@selector(backForwardHandler:)];
    [window.menuButtons setTarget:self];
    [window.menuButtons setAction:@selector(menuButtonHandler:)];
}

- (void)backForwardHandler:(NSSegmentedControl *)sender {
    NSLog(@"hello world back forward handler");
    NSInteger selected = [sender selectedSegment];
    switch (selected) {
        case 0:
            // back
            if ([self.backForwardList backListCount] > 0)
                [self goBack];
            break;
        case 1:
            if ([self.backForwardList forwardListCount] > 0)
                [self goForward];
            break;
    }
}

- (void)menuButtonHandler:(id)sender {
    NSSegmentedControl *control = (NSSegmentedControl *)sender;
    NSInteger selected = [control selectedSegment];
    NSLog(@"hi %@ %ld", self.mainFrameURL.lastPathComponent, (long)selected);
    switch (selected) {
        case 0: {
            NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/", [[NSApp delegate] source]]];
            NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url];
            [self.mainFrame loadRequest:req];
            break;
        }
        case 1: {
            NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/videos", [[NSApp delegate] source]]];
            NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url];
            [self.mainFrame loadRequest:req];
            break;
        }
        case 2: {
            NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/my_subscriptions", [[NSApp delegate] source]]];
            NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url];
            [self.mainFrame loadRequest:req];
            break;
        }
        case 3: {
            NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/flags", [[NSApp delegate] source]]];
            NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url];
            [self.mainFrame loadRequest:req];
            break;
        }
        case 4: {
            [self setCurrentSegment];
            break;
        }
    }
}

- (void)setNotificationsFromProgress {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(updateProgressBar:)
                                          name:WebViewProgressStartedNotification
                                          object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(updateProgressBar:)
                                          name:WebViewProgressEstimateChangedNotification
                                          object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(updateProgressBar:)
                                          name:WebViewProgressFinishedNotification
                                          object:self];
}

- (void)updateProgressBar:(NSNotification*)item {
    YTAppDelegate* appDelegate = (YTAppDelegate*)[NSApp delegate];
    if (item.name == WebViewProgressStartedNotification) {
        [appDelegate.window.progressBar setHidden:false];
        [appDelegate.window.progressBar setDoubleValue:0];
        [appDelegate.window.progressBar setIndeterminate:YES];
    } else if (item.name == WebViewProgressEstimateChangedNotification) {
        [appDelegate.window.progressBar setIndeterminate:NO];
        [appDelegate.window.progressBar setDoubleValue:self.estimatedProgress];
    } else if (item.name == WebViewProgressFinishedNotification) {
        [appDelegate.window.progressBar setDoubleValue:1];
        [appDelegate.window.progressBar setHidden:true];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Implement WebFrameLoadDelegate
- (void)webView:(WebView *)webView didFinishLoadForFrame:(WebFrame *)frame {
    NSLog(@"backlist count: %d", [self.backForwardList backListCount]);
    if ([self.backForwardList backListCount] > 0) {
        [[(YTMainWindow*)[self window] backForwardButtons] setEnabled:true forSegment:0];
    } else {
        [[(YTMainWindow*)[self window] backForwardButtons] setEnabled:false forSegment:0];
    }
    if ([self.backForwardList forwardListCount] > 0) {
        [[(YTMainWindow*)[self window] backForwardButtons] setEnabled:true forSegment:1];
    } else {
        [[(YTMainWindow*)[self window] backForwardButtons] setEnabled:false forSegment:1];
    }
    
    YTMainWindow* window = (YTMainWindow*)[self window];
    [window.backForwardButtons setTarget:self];
    [window.backForwardButtons setAction:@selector(backForwardHandler:)];
    [window.menuButtons setTarget:self];
    [window.menuButtons setAction:@selector(menuButtonHandler:)];
    [self setCurrentSegment];
}

- (void)setCurrentSegment {
    YTMainWindow* window = (YTMainWindow*)[self window];
    if ([[self.mainFrameURL componentsSeparatedByString:@"?"][0] rangeOfString:@"flags"].location != NSNotFound
        || [[self.mainFrameURL componentsSeparatedByString:@"?"][0] rangeOfString:@"toggle_f"].location != NSNotFound) {
        [window.menuButtons setSelectedSegment:3];
    } else if ([[self.mainFrameURL componentsSeparatedByString:@"?"][0] rangeOfString:@"subscriptions"].location != NSNotFound) {
        [window.menuButtons setSelectedSegment:2];
    } else if ([[self.mainFrameURL componentsSeparatedByString:@"?"][0] rangeOfString:@"videos"].location != NSNotFound
               || [[self.mainFrameURL componentsSeparatedByString:@"?"][0] rangeOfString:@"watch"].location != NSNotFound) {
        [window.menuButtons setSelectedSegment:1];
    } else if ([[self.mainFrameURL componentsSeparatedByString:@"?"][0] rangeOfString:@"/"].location != NSNotFound
               && [self.mainFrameURL.lastPathComponent isEqual:[[[NSApp delegate] source] lastPathComponent]]) {
        [window.menuButtons setSelectedSegment:0];
    } else [window.menuButtons setSelectedSegment:4];
    
    NSLog(@"%@ %@", self.mainFrameURL, self.mainFrameURL.lastPathComponent);
}

@end
