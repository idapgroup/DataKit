//
//  IDPSingletonModel.m
//  MovieScript
//
//  Created by Artem Chabanniy on 10/09/2013.
//  Copyright (c) 2013 IDAP Group. All rights reserved.
//

#import "IDPSingletonModel.h"
#import "NSObject+IDPExtensions.h"

static id __sharedObject = nil;

@implementation IDPSingletonModel

#pragma mark -
#pragma mark Class methods

+ (id)sharedObject {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedObject = [[self alloc] init];
    });
    return __sharedObject;
}
#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        [self baseInit];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
    static dispatch_once_t once;
    
    __block id result = __sharedObject;
    
    dispatch_once(&once, ^{
        if (!__sharedObject) {
            result = [super allocWithZone:zone];
        }
    });
    
    return result;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}


@end
