//
//  IDPObservableObject.m
//  Location
//
//  Created by Oleksa Korin on 10/21/13.
//  Copyright (c) 2013 Oleksa Korin. All rights reserved.
//

#import "IDPObservableObject.h"

#import "NSArray+IDPExtensions.h"

@interface IDPObservableObject ()
@property (nonatomic, retain)	NSMutableArray	*mutableObservers;

@end

@implementation IDPObservableObject

@dynamic observers;
@dynamic target;

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.mutableObservers = nil;
	
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.mutableObservers = [NSMutableArray weakArray];
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (NSArray *)observers {
    return [[self.mutableObservers copy] autorelease];
}

#pragma mark -
#pragma mark Accessors

- (id)target {
    return self;
}

#pragma mark -
#pragma mark Public

- (void)addObserver:(id)observer {
    if (![self isObjectAnObserver:observer]) {
        [self.mutableObservers addObject:observer];
    }
}

- (void)removeObserver:(id)observer {
    [self.mutableObservers removeObject:observer];
}

- (BOOL)isObjectAnObserver:(id)observer {
    return [self.mutableObservers containsObject:observer];
}

#pragma mark -
#pragma mark Private

- (void)notifyObserversWithSelector:(SEL)selector {
    for (id <NSObject> observer in self.observers) {
        if ([observer respondsToSelector:selector]) {
            [observer performSelector:selector withObject:self.target];
        }
    }
}

- (void)notifyObserversWithSelector:(SEL)selector userInfo:(id)info {
    for (id<NSObject> observer in self.observers) {
        if ([observer respondsToSelector:selector]) {
            [observer performSelector:selector withObject:self withObject:info];
        }
    }
}

- (void)notifyObserversWithSelector:(SEL)selector userInfo:(id)info error:(id)error {
    for (id<NSObject> observer in self.observers) {
        if ([observer respondsToSelector:selector]) {
            [observer performSelector:selector withObject:info withObject:error];
        }
    }
}

- (void)notifyObserversOnMainThreadWithSelector:(SEL)selector {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self notifyObserversWithSelector:selector];
    });
}

- (void)notifyObserversOnMainThreadWithSelector:(SEL)selector userInfo:(id)info {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self notifyObserversWithSelector:selector userInfo:info];
    });
}

- (void)notifyObserversOnMainThreadWithSelector:(SEL)selector
                                       userInfo:(id)info
                                          error:(id)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self notifyObserversWithSelector:selector userInfo:info error:error];
    });
}

@end
