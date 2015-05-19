//
//  AppDelegate.m
//  Alarm
//
//  Created by Adrien on 2/21/14.
//  Copyright (c) 2014 Adrien. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize hhStepper;
@synthesize hhStepText;
@synthesize mmStepper;
@synthesize mmStepText;
@synthesize infoLabel;
@synthesize image;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [[window standardWindowButton:NSWindowZoomButton] setHidden:TRUE];
    CGFloat resizeIncrement = MAXFLOAT;
    [window setResizeIncrements:NSMakeSize(resizeIncrement, resizeIncrement)];
    
    [[ACAlarm sharedAlarm] setNextAlarm];
    [self refreshInfoLabel];
    [self awakening];
    [self windowWillExitFullScreen];
}

- (IBAction)monCheck:(id)sender {
    [[ACAlarm sharedAlarm] setDays:0];
    [[ACAlarm sharedAlarm] setNextAlarm];
}

- (IBAction)tueCheck:(id)sender {
    [[ACAlarm sharedAlarm] setDays:1];
    [[ACAlarm sharedAlarm] setNextAlarm];
}

- (IBAction)wedCheck:(id)sender {
    [[ACAlarm sharedAlarm] setDays:2];
    [[ACAlarm sharedAlarm] setNextAlarm];
}

- (IBAction)thuCheck:(id)sender {
    [[ACAlarm sharedAlarm] setDays:3];
    [[ACAlarm sharedAlarm] setNextAlarm];
}

- (IBAction)friCheck:(id)sender {
    [[ACAlarm sharedAlarm] setDays:4];
    [[ACAlarm sharedAlarm] setNextAlarm];
}

- (IBAction)satCheck:(id)sender {
    [[ACAlarm sharedAlarm] setDays:5];
    [[ACAlarm sharedAlarm] setNextAlarm];
}

- (IBAction)sunCheck:(id)sender {
    [[ACAlarm sharedAlarm] setDays:6];
    [[ACAlarm sharedAlarm] setNextAlarm];
}

- (void)hhStepTextSync {
    [hhStepper setIntegerValue:[ACAlarm sharedAlarm].hh];
    [hhStepText setIntegerValue:[ACAlarm sharedAlarm].hh];
    [[ACAlarm sharedAlarm] setNextAlarm];
}

- (IBAction)hhTextAction:(id)sender {
    [ACAlarm sharedAlarm].hh = [sender integerValue];
    [self hhStepTextSync];
}

- (IBAction)hhStepAction:(id)sender {
    if ([sender integerValue] == -1)
        [ACAlarm sharedAlarm].hh = 23;
    else if ([sender integerValue] == 24)
        [ACAlarm sharedAlarm].hh = 0;
    else
        [ACAlarm sharedAlarm].hh = [sender integerValue];
    [self hhStepTextSync];
}

- (void)mmStepTextSync {
    [mmStepper setIntegerValue:[ACAlarm sharedAlarm].mm];
    [mmStepText setIntegerValue:[ACAlarm sharedAlarm].mm];
    [[ACAlarm sharedAlarm] setNextAlarm];
}

- (IBAction)mmTextAction:(id)sender {
    [ACAlarm sharedAlarm].mm = [sender integerValue];
    [self mmStepTextSync];
}

- (IBAction)mmStepAction:(id)sender {
    if ([sender integerValue] == -1)
        [ACAlarm sharedAlarm].mm = 59;
    else if ([sender integerValue] == 60)
        [ACAlarm sharedAlarm].mm = 0;
    else
        [ACAlarm sharedAlarm].mm = [sender integerValue];
    [self mmStepTextSync];
}

- (void)awakening {
    NSDate *atm =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE dd/MM/YYYY HH:mm"];
    NSLocale *enLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocale:enLocal];
    NSString *atmStr = [dateFormatter stringFromDate:atm];
    NSString *alarmStr = [dateFormatter stringFromDate:[ACAlarm sharedAlarm].nextAlarm];
    
    if ([atmStr isEqualToString:alarmStr]) {
        NSImage *picture = [NSImage imageNamed:@"awake"];
        [image setImage:picture];
        [image setNeedsDisplay];
        [[ACAlarm sharedAlarm] setNextAlarm];
    }
    //NSLog(@"%@ || %@", atmStr, alarmStr);
    [self performSelector:@selector(awakening) withObject:nil afterDelay:1];
}

- (void)refreshInfoLabel
{
    NSDate *atm = [NSDate date];
    NSTimeInterval interval = [[ACAlarm sharedAlarm].nextAlarm timeIntervalSinceDate:atm];
    NSInteger ti = (NSInteger)interval;
    NSInteger h = (ti / 3600);
    NSInteger m = (ti / 60) % 60;
    NSString *infoStr = [NSString stringWithFormat:@"%ld hours and %ld minutes until next sunrise !", (long)h, (long)m];
    dispatch_async(dispatch_get_main_queue(),^{
        [self.infoLabel setStringValue:infoStr];
    });
    [self performSelector:@selector(refreshInfoLabel) withObject:nil afterDelay:0.5];
}

- (void)windowWillExitFullScreen {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillExitFullScreen) name:NSWindowWillExitFullScreenNotification object:window];
    [image setHidden:TRUE];
    [[window standardWindowButton:NSWindowZoomButton] setHidden:TRUE];
    CGFloat resizeIncrement = MAXFLOAT;
    [window setResizeIncrements:NSMakeSize(resizeIncrement, resizeIncrement)];

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidExitFullScreen) name:NSWindowDidExitFullScreenNotification object:window];
}

- (void)windowWillEnterFullScreen {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillEnterFullScreen) name:NSWindowWillEnterFullScreenNotification object:window];
    CGFloat resizeIncrement = 1;
    [window setResizeIncrements:NSMakeSize(resizeIncrement, resizeIncrement)];
    NSImage *sleepPic = [NSImage imageNamed:@"sleep"];
    [image setImage:sleepPic];
    [image setHidden:FALSE];
    CGRect screenRect = [[window screen] frame];
    [image setFrameSize:NSMakeSize(screenRect.size.width, screenRect.size.height)];
    [image setFrameOrigin:NSMakePoint(screenRect.origin.x, 360 - screenRect.size.height)];
}

- (IBAction)sleepAction:(id)sender {
    [self windowWillEnterFullScreen];
    [window toggleFullScreen:window];
    
}



@end
