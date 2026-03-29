//
//  YTMainWindow.m
//  yt2009
//
//  Created by Adithiya Venkatakrishnan on 26/03/2026.
//  Copyright (c) 2026 atomtables. All rights reserved.
//

#import "YTMainWindow.h"

@interface YTMainWindow ()

@end

@implementation YTMainWindow

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupTitleBarControls];
    [self setupFullScreenObservers];
}

- (void)close {
    [super close];
    [NSApp terminate:self];
}

- (void)setupTitleBarControls {
    NSView *themeFrame = [[self contentView] superview];
    [self setupBackForwardButtons:themeFrame];
    [self setupMenuButtons1:themeFrame];
    [self setupProgressBar:themeFrame];
}

- (void)setupMenuButtons1:(NSView*)themeFrame {
    NSArray* objects = nil;
    if ([NSBundle.mainBundle loadNibNamed:@"MenuSegmentedControl" owner:self.menuButtons topLevelObjects:&objects]) {
        for (id object in objects) {
            if ([object isKindOfClass:[YTMenuSegmentedControlView class]]) {
                self.menuButtons = object;
                break;
            }
        }
    }
//    [self.menuButtons setTarget:self];
    [self.menuButtons setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [themeFrame addSubview:self.menuButtons];
    
    [themeFrame addConstraints:@[
                                 [NSLayoutConstraint constraintWithItem:self.menuButtons
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.backForwardButtons
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:8.0],
                                 [NSLayoutConstraint constraintWithItem:self.menuButtons
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.backForwardButtons
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0
                                                               constant:0.0],
//                                 [NSLayoutConstraint constraintWithItem:self.backForwardButtons
//                                                              attribute:NSLayoutAttributeWidth
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:nil
//                                                              attribute:NSLayoutAttributeNotAnAttribute
//                                                             multiplier:1.0
//                                                               constant:60.0],
                                 ]];
}

- (void)setupBackForwardButtons:(NSView *)themeFrame {
    NSButton *zoomButton = [self standardWindowButton:NSWindowZoomButton];
    
    self.backForwardButtons = [[NSSegmentedControl alloc] initWithFrame:NSZeroRect];
    [self.backForwardButtons setSegmentCount:2];
    [self.backForwardButtons setImage:[NSImage imageNamed:NSImageNameGoLeftTemplate] forSegment:0];
    [self.backForwardButtons setImage:[NSImage imageNamed:NSImageNameGoRightTemplate] forSegment:1];
    [self.backForwardButtons setSegmentStyle:NSSegmentStyleTexturedRounded];
    [[self.backForwardButtons cell] setTrackingMode:NSSegmentSwitchTrackingMomentary];
    [self.backForwardButtons setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [themeFrame addSubview:self.backForwardButtons];
    
    [themeFrame addConstraints:@[
                                 [NSLayoutConstraint constraintWithItem:self.backForwardButtons
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:zoomButton
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:8.0],
                                 [NSLayoutConstraint constraintWithItem:self.backForwardButtons
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:zoomButton
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0
                                                               constant:4.0],
                                 [NSLayoutConstraint constraintWithItem:self.backForwardButtons
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:60.0],
                                 ]];
}

- (void)setupProgressBar:(NSView *)themeFrame {
    self.progressBar = [[NSProgressIndicator alloc] initWithFrame:NSZeroRect];
    [self.progressBar setStyle:NSProgressIndicatorBarStyle];
    [self.progressBar setIndeterminate:NO];
    [self.progressBar setMinValue:0.0];
    [self.progressBar setMaxValue:1.0];
    [self.progressBar setDoubleValue:0.0];
    [self.progressBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [themeFrame addSubview:self.progressBar];
    
    [themeFrame addConstraints:@[
                                 [NSLayoutConstraint constraintWithItem:self.progressBar
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:themeFrame
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-26.0],
                                 [NSLayoutConstraint constraintWithItem:self.progressBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0],
                                 [NSLayoutConstraint constraintWithItem:self.progressBar
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:themeFrame
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:6.0],
                                 [NSLayoutConstraint constraintWithItem:self.progressBar
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:20.0],
                                 ]];
}

- (void)setupFullScreenObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowWillEnterFullScreen:)
                                                 name:NSWindowWillEnterFullScreenNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowWillExitFullScreen:)
                                                 name:NSWindowWillExitFullScreenNotification
                                               object:self];
}

- (void)windowWillEnterFullScreen:(NSNotification *)notification {
    [self.backForwardButtons setHidden:YES];
    // Make your xib component take full screen
//    [self.yourXibView setFrame:[[self contentView] bounds]];
//    [self.yourXibView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
}

- (void)windowWillExitFullScreen:(NSNotification *)notification {
    [self.backForwardButtons setHidden:NO];
    // Restore your xib component's original frame if needed
//    [self.yourXibView setFrame:yourOriginalFrame];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
