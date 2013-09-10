//
//  ACModel.m
//  Accomplist
//
//  Created by Oleksa 'trimm' Korin on 4/14/13.
//  Copyright (c) 2013 IDAP Group. All rights reserved.
//

#import "IDPModel.h"

#import "NSArray+IDPExtensions.h"

@interface IDPModel ()

@property (nonatomic, retain)               NSMutableArray  *mutableObservers;
@property (nonatomic, assign, readwrite)    IDPModelState   state;

- (void)notifyObserversWithSelector:(SEL)selector;

@end

@implementation IDPModel

@synthesize state               = _state;
@synthesize mutableObservers    = _mutableObservers;

@dynamic observers;
@dynamic target;

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.mutableObservers = nil;
    [self cleanup];
    
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

- (id<IDPModel>)target {
    return self;
}

#pragma mark -
#pragma mark Public

- (BOOL)load {
    if (IDPModelFinished == self.state) {
        [self notifyObserversOfSuccessfulLoad];
        return NO;
    }

    BOOL result = IDPModelLoading != self.state;
    self.state = IDPModelLoading;
    
    return result;
}

- (void)finishLoading {
    self.state = IDPModelFinished;
    [self notifyObserversOfSuccessfulLoad];
}

- (void)failLoading {
    self.state = IDPModelFailed;
    [self cleanup];
    [self notifyObserversOfFailedLoad];
}

- (void)cancel {
    if (IDPModelLoading != self.state) {
        return;
    }
    self.state = IDPModelCancelled;
    [self cleanup];
    [self notifyObserversOfCancelledLoad];
}

- (void)dump {
    if (IDPModelUnloaded == self.state) {
        return;
    }
    
    self.state = IDPModelUnloaded;
    [self cleanup];    
    [self notifyObserversOfUnload];
}

- (void)cleanup {
    
}

- (void)addObserver:(id <IDPModelObserver>)observer {
    if (![self isObjectAnObserver:observer]) {
        [self.mutableObservers addObject:observer];
    }
}

- (void)removeObserver:(id <IDPModelObserver>)observer {
    [self.mutableObservers removeObject:observer];
}

- (BOOL)isObjectAnObserver:(id <IDPModelObserver>)observer {
    return [self.mutableObservers containsObject:observer];
}

#pragma mark -
#pragma mark Private

- (void)notifyObserversOfSuccessfulLoad {
    [self notifyObserversWithSelector:@selector(modelDidLoad:)];
}

- (void)notifyObserversOfFailedLoad {
    [self notifyObserversWithSelector:@selector(modelDidFailToLoad:)];
}

- (void)notifyObserversOfCancelledLoad {
    [self notifyObserversWithSelector:@selector(modelDidCancelLoading:)];
}

- (void)notifyObserversOfChanges {
    [self notifyObserversWithSelector:@selector(modelDidChange:)];
}

- (void)notifyObserversOfChangesWithMessage:(NSDictionary *)message {
    SEL selector = @selector(modelDidChange:message:);
    for (id<IDPModelObserver> observer in self.observers) {
        if ([observer respondsToSelector:selector]) {
            [observer modelDidChange:self.target message:message];
        }
    }
}

- (void)notifyObserversOfUnload {
    [self notifyObserversWithSelector:@selector(modelDidUnload:)];
}

- (void)notifyObserversWithSelector:(SEL)selector {
    for (id<IDPModelObserver> observer in self.observers) {
        if ([observer respondsToSelector:selector]) {
            [observer performSelector:selector withObject:self.target];
        }
    }
}

@end
