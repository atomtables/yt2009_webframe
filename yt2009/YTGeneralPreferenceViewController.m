//
//  YTGeneralPreferenceViewController.m
//  yt2009
//
//  Created by Adithiya Venkatakrishnan on 28/03/2026.
//  Copyright (c) 2026 atomtables. All rights reserved.
//

#import "YTAppDelegate.h"
#import "YTGeneralPreferenceViewController.h"

@interface YTGeneralPreferenceViewController ()

@end

@implementation YTGeneralPreferenceViewController

- (id)init {
    return [super initWithNibName:@"GeneralView" bundle:nil];
}

- (void)loadView {
    [super loadView];
    
    [self.urlTextField setStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"source"]];
}

- (IBAction)onTextFieldChange:(NSTextField*)sender {
    YTAppDelegate* delegate = [NSApp delegate];
    delegate.source = sender.stringValue;
    [[NSUserDefaults standardUserDefaults] setValue:sender.stringValue forKey:@"source"];
}

@end
