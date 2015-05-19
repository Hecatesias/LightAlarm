//
//  ACAlarm.h
//  Alarm
//
//  Created by Adrien on 2/21/14.
//  Copyright (c) 2014 Adrien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACDay.h"

@interface ACAlarm : NSObject
{
    NSArray *week;
    NSDate  *nextAlarm;
    int     hh;
    int     mm;
}

@property NSArray   *week;
@property NSDate    *nextAlarm;
@property int       hh;
@property int       mm;


+ (ACAlarm*)sharedAlarm;


- (void)setDays:(NSInteger)nDay;
- (void)setNextAlarm;


//debug


@end
