//
//  ACDay.h
//  Alarm
//
//  Created by Adrien on 2/22/14.
//  Copyright (c) 2014 Adrien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACDay : NSObject {
    NSString    *name;
    BOOL        isSet;
}

@property NSString* name;
@property BOOL      isSet;


- (ACDay*)initWithName:(NSString*)dayName AndBool:(BOOL)boul;
- (ACDay*)init;

- (void)setDayName:(NSString*)dayName AndBool:(BOOL)boul;
- (void)boolSwitch;

@end
