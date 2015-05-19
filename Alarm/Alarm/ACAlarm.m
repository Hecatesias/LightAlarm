//
//  ACAlarm.m
//  Alarm
//
//  Created by Adrien on 2/21/14.
//  Copyright (c) 2014 Adrien. All rights reserved.
//

#import "ACAlarm.h"

@implementation ACAlarm
@synthesize week;
@synthesize nextAlarm;
@synthesize hh;
@synthesize mm;


static ACAlarm *sharedAlarm = nil;

+ (ACAlarm*)sharedAlarm {
    if (sharedAlarm == nil) {
        sharedAlarm = [[super allocWithZone:NULL] init];
        
        // initialize your variables here
        sharedAlarm.week = [NSArray arrayWithObjects:
                            [[ACDay alloc] initWithName:@"mon" AndBool:TRUE],
                            [[ACDay alloc] initWithName:@"tue" AndBool:TRUE],
                            [[ACDay alloc] initWithName:@"wed" AndBool:TRUE],
                            [[ACDay alloc] initWithName:@"thu" AndBool:TRUE],
                            [[ACDay alloc] initWithName:@"fri" AndBool:TRUE],
                            [[ACDay alloc] initWithName:@"sat" AndBool:FALSE],
                            [[ACDay alloc] initWithName:@"sun" AndBool:FALSE],
                            nil];
        sharedAlarm.hh = 0;
        sharedAlarm.mm = 0;
    }
    return sharedAlarm;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self)
	{
		if (sharedAlarm == nil)
		{
			sharedAlarm = [super allocWithZone:zone];
			return sharedAlarm;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)setDays:(NSInteger)nDay {
    [[week objectAtIndex:nDay] boolSwitch];
}

- (void)setNextAlarm {
    int i;
    
    NSDate *atm = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE dd/MM/YYYY HH:mm"];
    
    NSLocale *enLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocale:enLocal];
    
    NSString *now = [[dateFormatter stringFromDate:atm] lowercaseString];
    
    for (i = 0; i < 7 &&
         [now compare:[[week objectAtIndex:i] name]
                options:NSCaseInsensitiveSearch
                range: NSMakeRange(0, 3)] != NSOrderedSame; i++);
    if ([[week objectAtIndex:i] isSet]) {
        //today is set
        if ([[now substringWithRange:NSMakeRange(15, 2)] intValue] > hh) {
            //today's hour passed => same as not set
            [self setNextDayAlarm:atm dateStr:now Formatter:dateFormatter TodayIndex:i];
        }
        else if ([[now substringWithRange:NSMakeRange(15, 2)] intValue] < hh) {
            //today's hour is to come => set today's alarm
            [self setTodayAlarm:atm dateStr:now Formatter:dateFormatter];
        }
        else {
            //same hour, check minute
            if ([[now substringWithRange:NSMakeRange(18, 2)] intValue] > mm) {
                //minute passed => same as not set
                [self setNextDayAlarm:atm dateStr:now Formatter:dateFormatter TodayIndex:i];
            }
            else if ([[now substringWithRange:NSMakeRange(18, 2)] intValue] < mm) {
                //minute is to come => set today's alarm
                [self setTodayAlarm:atm dateStr:now Formatter:dateFormatter];
            }
            else {
                //same minute => same as not set
                [self setNextDayAlarm:atm dateStr:now Formatter:dateFormatter TodayIndex:i];
            }
        }
    }
    else {
        //today isn't set => set next set day's alarm
        [self setNextDayAlarm:atm dateStr:now Formatter:dateFormatter TodayIndex:i];
        
    }
    //debug
    /*NSLog(@"now is %@", now);
    NSLog(@"today's index %d", i);
    NSLog(@"#hour %d", [[now substringWithRange:NSMakeRange(15, 2)] intValue]);
    NSLog(@"#minute %d", [[now substringWithRange:NSMakeRange(18, 2)] intValue]);*/
}

- (void)setNextDayAlarm:(NSDate*)atm dateStr:(NSString*)now Formatter:(NSDateFormatter*)dateFormatter TodayIndex:(int)todayIndex {
    int i, count;
    BOOL fullCicle = FALSE;
    for (count = 0, i = (todayIndex + 1 == 7 ? 0 : todayIndex + 1);
         [[week objectAtIndex:i] isSet] == FALSE;
         i = (i + 1 == 7 ? 0: i + 1)) {
        if (i == (todayIndex + 1 == 7 ? 0 : todayIndex + 1))
            count++;
        if (count > 1) {
            fullCicle = TRUE;
            break;
        }
        //debug
        //NSLog(@"i = %d index = %d",i ,todayIndex);
    }
    if ((fullCicle ? TRUE : FALSE)) {
        //no day selected
        //nextAlarm = [NSDate dateWithTimeIntervalSince1970:0];
        
        //debug
        NSLog(@"is it real ?");
    }
    else {
        //nextday, thanks stackoverflow
        i = (i + 2 == 8 ? 1 : i + 2);
        NSCalendar  *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit |
                                        NSWeekCalendarUnit |
                                        NSWeekdayCalendarUnit fromDate:atm];
        NSUInteger  weekDayToday = [components weekday];
        if ((weekDayToday != i ? TRUE: FALSE)) {
            NSInteger daysToNextSet = (7 + i - weekDayToday) % 7;
            NSInteger   hhModifier = hh - [[now substringWithRange:NSMakeRange(15, 2)] intValue];
            NSInteger   mmModifier = mm - [[now substringWithRange:NSMakeRange(18, 2)] intValue];
            nextAlarm = [atm dateByAddingTimeInterval:(60 * 60 * 24 * daysToNextSet)
                         + (60 * 60 * hhModifier)
                         + (60 * mmModifier)];
        }
        else {
            NSInteger daysToNextSet = 7;
            NSInteger   hhModifier = hh - [[now substringWithRange:NSMakeRange(15, 2)] intValue];
            NSInteger   mmModifier = mm - [[now substringWithRange:NSMakeRange(18, 2)] intValue];
            nextAlarm = [atm dateByAddingTimeInterval:(60 * 60 * 24 * daysToNextSet)
                         + (60 * 60 * hhModifier)
                         + (60 * mmModifier)];
        }
        //debug
        //NSLog(@"Alarm set to %@",[dateFormatter stringFromDate:nextAlarm]);
    }
}

- (void)setTodayAlarm:(NSDate*)atm dateStr:(NSString*)now Formatter:(NSDateFormatter*)dateFormatter {
    NSInteger   hhModifier = hh - [[now substringWithRange:NSMakeRange(15, 2)] intValue];
    NSInteger   mmModifier = mm - [[now substringWithRange:NSMakeRange(18, 2)] intValue];
    nextAlarm = [atm dateByAddingTimeInterval:(60 * 60 * hhModifier) + (60 * mmModifier)];
    
    //debug
    //NSLog(@"Alarm set to %@",[dateFormatter stringFromDate:nextAlarm]);
}




@end
