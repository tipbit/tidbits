//
//  OperationManager.h
//  TBClientLib
//
//  Created by Ewan Mellor on 7/4/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"


typedef void(^IdOperationBlock)(IdBlock onSuccess, NSErrorBlock onFailure);
typedef void(^VoidOperationBlock)(VoidBlock onSuccess, NSErrorBlock onFailure);
typedef void(^NSDataOperationBlock)(NSDataBlock onSuccess, NSErrorBlock onFailure);


/**
 * OperationManager will perform a given operation, but if there is an attempt to perform the same operation multiple
 * times in parallel then it will ensure that the operation is only performed once, and all the callbacks are triggered correctly
 * when that single operation completes.
 *
 * This class is internally thread-safe, and does no dispatching of its own.  The operation will start on whichever thread the
 * perform* call is made on.  The onSuccess / onFailure callbacks will run on whichever thread the operation is using when it calls them.
 */
@interface OperationManager : NSObject

-(void)performId:(id<NSCopying>)key onSuccess:(IdBlock)onSuccess onFailure:(NSErrorBlock)onFailure op:(IdOperationBlock)op;
-(void)performNSData:(id<NSCopying>)key onSuccess:(NSDataBlock)onSuccess onFailure:(NSErrorBlock)onFailure op:(NSDataOperationBlock)op;
-(void)performVoid:(id<NSCopying>)key onSuccess:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure op:(VoidOperationBlock)op;

@end
