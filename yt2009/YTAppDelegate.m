//
//  YTAppDelegate.m
//  yt2009
//
//  Created by Adithiya Venkatakrishnan on 26/03/2026.
//  Copyright (c) 2026 atomtables. All rights reserved.
//

#import "YTAppDelegate.h"

@implementation YTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowDidBecomeKey:)
                                                 name:NSWindowDidBecomeKeyNotification
                                               object:nil];
    
    self.source = [[NSUserDefaults standardUserDefaults] stringForKey:@"source"];
    if (self.source == nil) {
        self.source = [[NSBundle mainBundle] pathForResource:@"blank" ofType:@"html"];
        NSLog(@"%@", self.source);
    }
    
    NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/", self.source]];
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url];
    [self.window.webview.mainFrame loadRequest:req];
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    NSWindow *window = [notification object];
    NSRect screenFrame = [[NSScreen mainScreen] frame];
    
    // Check if the new key window is exactly the size of the screen
    if (NSEqualRects([window frame], screenFrame)) {
        // It's likely the Flash fullscreen overlay! Hide the menu bar and dock.
        [NSApp setPresentationOptions: NSApplicationPresentationAutoHideMenuBar | NSApplicationPresentationAutoHideDock];
    } else {
        // It's a normal window. Restore standard presentation.
        [NSApp setPresentationOptions: NSApplicationPresentationDefault];
    }
}

- (IBAction)goToSuburl:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText     = @"Enter the sub-URL you would like to visit.";
    alert.informativeText = @"Start with a / in your path (e.g. \"/my_subscriptions\"";
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 260, 24)];
    alert.accessoryView = input;
    
    // Force the text field to be ready for input
    [alert.window makeFirstResponder:input];
    [input performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
    [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse response) {
        if (response == NSAlertFirstButtonReturn) {
            NSString* value = input.stringValue;
            if (value && value.length > 0) {
                NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", self.source, value]];
                NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url];
                [self.window.webview.mainFrame loadRequest:req];
            }
        }
    }];
}

- (IBAction)showPreferences:(id)sender {
    if (!self.preferenceWindowController) {
        self.preferenceWindowController =
        [[YTPreferenceWindowController alloc] init];
    }
    
    [self.preferenceWindowController showWindow:self];
    [[self.preferenceWindowController window] makeKeyAndOrderFront:nil];
}

@end
