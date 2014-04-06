//
//  UIAlertView+BlockButtons.h
//  Tipbit
//
//  Created by Navi Singh on 3/29/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockButton.h"

@interface UIAlertView (BlockButtons)

/**
 * @discussion Alerts without delegates. - cancelButtonTitle:@"OK".
 */
+ (instancetype)showWithTitle:(NSString *)title;
+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message;

+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle;

/**
 * @discussion Alert with single block button.
 */
+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(BlockButton *)cancelButtonItem;

/**
 * @discussion Alert with two block buttons.
 */
+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(BlockButton *)cancelButton
                  otherButton:(BlockButton *)okButton;

/**
 * @discussion Alert with many block buttons.
 */
+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(BlockButton *)cancelButton
                 otherButtons:(BlockButton *)otherButtons, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(BlockButton *)cancelButton
                 otherButtons:(BlockButton *)otherButtons, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * @discussion Alert using single editable text box.
 */
+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
                      textBox:(NSString *)textBox
                 cancelButton:(BlockButton *)cancelButton
                  otherButton:(BlockButton *)okButton;

/**
 * @discussion Alert using username/pasword editable text boxes.
 */
+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
                     userName:(NSString *)userName
                     password:(NSString *)password
                 cancelButton:(BlockButton *)cancelButton
                  otherButton:(BlockButton *)okButton;

- (void)dismiss:(BOOL)animated;

@end


/** 
 * @discussion Sample Usage
    [UIAlertView showWithTitle:@"hello" message:@"world"];
    [UIAlertView showWithTitle:@"hello" message:@"world"
          cancelButton:[BlockButton label:@"test" action:^{
        NSLog(@"clicked cancel");
    }]];
    [UIAlertView showWithTitle:@"hello"
               message:@"world"
          cancelButton:button(@"cancel", ^{
        NSLog(@"clicked cancel");
    })];
    [UIAlertView showWithTitle:@"hello" message:@"world"
          cancelButton:button(@"cancel", ^{
        NSLog(@"clicked cancel");
    })
           otherButton:button(@"other", ^{
        NSLog(@"clicked other");
    })
     ];
    [UIAlertView showWithTitle:@"hello" message:@"world"
          cancelButton:
         button(@"cancel", ^{
            NSLog(@"clicked cancel");
        })
              otherButtons:
         button(@"other1", ^{
            NSLog(@"clicked other1");
        }),
         button(@"other2", ^{
            NSLog(@"clicked other2");
        }),
         nil
     ];
 */
