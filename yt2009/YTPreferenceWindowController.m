//
//  YTPreferenceWindow.m
//  yt2009
//
//  Created by Adithiya Venkatakrishnan on 28/03/2026.
//  Copyright (c) 2026 atomtables. All rights reserved.
//

#import "YTPreferenceWindowController.h"
#import "YTGeneralPreferenceViewController.h"
#import "YTAdvancedPreferenceViewController.h"

static NSString* const kGeneralItem   = @"GeneralItem";
static NSString* const kAdvancedItem  = @"AdvancedItem";

@implementation YTPreferenceWindowController

+ (instancetype)sharedController {
    static YTPreferenceWindowController *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    return [super initWithWindowNibName:@"PreferenceWindow"];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"PrefsToolbar"];
    toolbar.delegate = self;
    toolbar.allowsUserCustomization = NO;
    toolbar.autosavesConfiguration  = NO;
    toolbar.displayMode = NSToolbarDisplayModeIconAndLabel;
    self.window.toolbar = toolbar;
    
    // Select first pane
    [toolbar setSelectedItemIdentifier:kGeneralItem];
    [self switchToIdentifier:kGeneralItem animate:NO];
}

- (void)switchToIdentifier:(NSString *)identifier animate:(BOOL)animate {
    NSViewController *vc;
    NSString *title;
    
    if ([identifier isEqualToString:kGeneralItem]) {
        vc    = [[YTGeneralPreferenceViewController alloc] init];
        title = @"General";
    } else {
        vc    = [[YTAdvancedPreferenceViewController alloc] init];
        title = @"Advanced";
    }
    
    [self transitionToViewController:vc title:title animate:animate];
}

- (void)transitionToViewController:(NSViewController *)newVC
                             title:(NSString *)title
                           animate:(BOOL)animate {
    NSView *newView = newVC.view;
    NSSize newSize  = newView.frame.size;
    
    // Compute new window frame
    NSRect windowFrame  = self.window.frame;
    NSRect contentFrame = [self.window contentRectForFrameRect:windowFrame];
    CGFloat toolbarH    = NSHeight(windowFrame) - NSHeight(contentFrame);
    NSRect newFrame     = windowFrame;
    newFrame.size.width  = newSize.width;
    newFrame.size.height = newSize.height + toolbarH;
    newFrame.origin.y   += NSHeight(windowFrame) - NSHeight(newFrame); // anchor top-left
    
    // Swap content
    [[self.window.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currentViewController = newVC;
    self.window.title = title;
    
    if (animate) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *ctx) {
            ctx.duration = 0.2;
            [self.window.animator setFrame:newFrame display:YES];
        } completionHandler:^{
            [self.window.contentView addSubview:newView];
            newView.frame = [self.window.contentView bounds];
        }];
    } else {
        [self.window setFrame:newFrame display:NO];
        [self.window.contentView addSubview:newView];
        newView.frame = [self.window.contentView bounds];
    }
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar {
    return @[kGeneralItem, kAdvancedItem];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar {
    return @[kGeneralItem, kAdvancedItem];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar*)toolbar {
    return @[kGeneralItem, kAdvancedItem];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSString *)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag {
    
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    
    if ([itemIdentifier isEqualToString:kGeneralItem]) {
        item.label  = @"General";
        item.image  = [NSImage imageNamed:NSImageNamePreferencesGeneral];
        item.action = @selector(toolbarItemClicked:);
        item.target = self;
    } else if ([itemIdentifier isEqualToString:kAdvancedItem]) {
        item.label  = @"Advanced";
        item.image  = [NSImage imageNamed:NSImageNameAdvanced];
        item.action = @selector(toolbarItemClicked:);
        item.target = self;
    }
    return item;
}

- (void)toolbarItemClicked:(NSToolbarItem *)item {
    [self switchToIdentifier:item.itemIdentifier animate:YES];
}

@end
