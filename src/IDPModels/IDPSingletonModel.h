//
//  IDPSingletonModel.h
//  MovieScript
//
//  Created by Artem Chabanniy on 10/09/2013.
//  Copyright (c) 2013 IDAP Group. All rights reserved.
//

#import "IDPModel.h"

/* You have to implement following method in your subclass:
 
 + (dispatch_once_t *)onceToken {
    static dispatch_once_t onceToken;
    return &onceToken;
 }
 */

@interface IDPSingletonModel : IDPModel

+ (id)sharedObject;

@end
