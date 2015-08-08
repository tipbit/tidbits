//
//  UIImagePickerController+Blocks.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/7/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "SynthesizeAssociatedObject.h"

#import "UIImagePickerController+Blocks.h"


@interface UIImagePickerController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end


@implementation UIImagePickerController (Blocks)


-(UIImagePickerControllerDidFinishPickingMediaBlock)didFinishPickingBlock {
    return objc_getAssociatedObject(self, @selector(didFinishPickingBlock));
}

-(void)setDidFinishPickingBlock:(UIImagePickerControllerDidFinishPickingMediaBlock)didFinishPickingBlock {
    objc_setAssociatedObject(self, @selector(didFinishPickingBlock), didFinishPickingBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _tb_updateDelegate];
}


-(UIImagePickerControllerCancellationBlock)cancellationBlock {
    return objc_getAssociatedObject(self, @selector(cancellationBlock));
}


-(void)setCancellationBlock:(UIImagePickerControllerCancellationBlock)cancellationBlock {
    objc_setAssociatedObject(self, @selector(cancellationBlock), cancellationBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _tb_updateDelegate];
}


-(void)_tb_updateDelegate {
    BOOL enabled = (self.didFinishPickingBlock != NULL || self.cancellationBlock != NULL);
    self.delegate = (enabled ? self : nil);
}


#pragma mark UIImagePickerControllerDelegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImagePickerControllerDidFinishPickingMediaBlock block = self.didFinishPickingBlock;
    if (block != NULL) {
        block(self, info);
    }
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    UIImagePickerControllerCancellationBlock block = self.cancellationBlock;
    if (block != NULL) {
        block(self);
    }
}


@end
