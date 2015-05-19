//
//  AppDelegate.h
//  Alarm
//
//  Created by Adrien on 2/21/14.
//  Copyright (c) 2014 Adrien. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ACAlarm.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSButtonCell *monCheck;

@property (weak) IBOutlet NSButtonCell *tueCheck;

@property (weak) IBOutlet NSButton *wedCheck;

@property (weak) IBOutlet NSButton *thuCheck;

@property (weak) IBOutlet NSButton *friCheck;

@property (weak) IBOutlet NSButton *satCheck;

@property (weak) IBOutlet NSView *sunCheck;

@property (weak) IBOutlet NSStepperCell *hhStepper;

@property (weak) IBOutlet NSTextField *hhStepText;

@property (weak) IBOutlet NSStepperCell *mmStepper;

@property (weak) IBOutlet NSTextField *mmStepText;

@property (weak) IBOutlet NSTextField *infoLabel;

@property (weak) IBOutlet NSButton *sleepButton;

@property (weak) IBOutlet NSImageView *image;


@end
