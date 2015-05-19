//
//  ACDay.m
//  Alarm
//
//  Created by Adrien on 2/22/14.
//  Copyright (c) 2014 Adrien. All rights reserved.
//

#import "ACDay.h"

@implementation ACDay
@synthesize name;
@synthesize isSet;


- (ACDay*)initWithName:(NSString *)dayName AndBool:(BOOL)boul{
    if (self = [super init]) {
        [self setDayName:dayName AndBool:boul];
        return self;
    }
    else
        return nil;
}

- (ACDay*)init {
    return [self initWithName:@"nope" AndBool:FALSE];
}

- (void)setDayName:(NSString*)dayName AndBool:(BOOL)boul{
    name = dayName;
    isSet = boul;
    
}

- (void)boolSwitch {
    isSet = (isSet == TRUE ? FALSE : TRUE);
}


@end
