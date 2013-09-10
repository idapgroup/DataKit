//
//  ACModel.h
//  Accomplist
//
//  Created by Oleksa 'trimm' Korin on 4/14/13.
//  Copyright (c) 2013 IDAP Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IDPModelProtocol.h"

@interface IDPModel : NSObject <IDPModel>

@property (nonatomic, readonly)   id<IDPModel>    target;

- (void)notifyObserversOfSuccessfulLoad;
- (void)notifyObserversOfFailedLoad;
- (void)notifyObserversOfCancelledLoad;
- (void)notifyObserversOfChanges;
- (void)notifyObserversOfChangesWithMessage:(NSDictionary *)message;
- (void)notifyObserversOfUnload;

@end
