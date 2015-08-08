//
//  UIImagePickerController+Blocks.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/7/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^UIImagePickerControllerDidFinishPickingMediaBlock)(UIImagePickerController *picker, NSDictionary *info);
typedef void (^UIImagePickerControllerCancellationBlock)(UIImagePickerController *picker);


/**
 * A category to use UIImagePickerController without delegates.
 */
@interface UIImagePickerController (Blocks)

@property (nonatomic, copy) UIImagePickerControllerDidFinishPickingMediaBlock didFinishPickingBlock;
@property (nonatomic, copy) UIImagePickerControllerCancellationBlock cancellationBlock;

@end
