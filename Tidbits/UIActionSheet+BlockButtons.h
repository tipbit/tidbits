//
//  UIActionSheet+BlockButtons.h
//  Tipbit
//
//  Created by Navi Singh on 3/29/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockButton.h"

@interface UIActionSheet (BlocksButtons)

+ (instancetype)createWithTitle:(NSString *)title
                       delegate:(id<UIActionSheetDelegate>)delegate
              cancelButtonTitle:(NSString *)cancelButtonTitle
         destructiveButtonTitle:(NSString *)destructiveButtonTitle
              otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
             destructiveButton:(BlockButton *)destructiveButton
                  otherButtons:(BlockButton *)otherButtons, ... NS_REQUIRES_NIL_TERMINATION;

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
                     onDismiss:(void(^)())dismissAction
             destructiveButton:(BlockButton *)destructiveButton
                  otherButtons:(BlockButton *)otherButtons, ... NS_REQUIRES_NIL_TERMINATION;

+(instancetype)createWithButtons:(NSArray *)otherButtons;

+(instancetype)createWithTitle:(NSString *)title
                       buttons:(NSArray *)otherButtons;

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
                       buttons:(NSArray *)otherButtons;

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
             destructiveButton:(BlockButton *)destructiveButton
                       buttons:(NSArray *)otherButtons;

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
                     onDismiss:(void(^)())dismissAction
             destructiveButton:(BlockButton *)destructiveButton
                       buttons:(NSArray *)otherButtons;

-(void)dismiss:(BOOL)animated;

@end
