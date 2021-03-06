//
//  UIAlertView+BlockButtons.m
//  Tipbit
//
//  Created by Navi Singh on 3/29/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import "NSString+Misc.h"

#import "UIAlertView+BlockButtons.h"


@interface UIAlertViewHelper : NSObject <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *alertButtons;
@property (nonatomic, strong) NSMutableDictionary *alertViews;

+(instancetype) sharedHelper;

@end


@implementation UIAlertViewHelper

+(instancetype) sharedHelper
{
	static dispatch_once_t once = 0;
    __strong static UIAlertViewHelper *_sharedHelper = nil;
    dispatch_once(&once, ^{
        _sharedHelper = [[UIAlertViewHelper alloc] init];
    });
    return _sharedHelper;
}

- (void) setButtons:(NSArray *)buttons forAlert:(UIAlertView *)alert
{
    for (BlockButton * button in buttons) {
        button.parentView = alert;
    }

    if (!self.alertButtons)
        self.alertButtons = [NSMutableDictionary dictionary];
    [self.alertButtons setObject:buttons forKey:[NSValue valueWithNonretainedObject:alert]];
    if (!self.alertViews)
        self.alertViews = [NSMutableDictionary dictionary];
    [self.alertViews setObject:alert forKey:[NSValue valueWithNonretainedObject:alert]];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *buttonsArray = [self.alertButtons objectForKey:[NSValue valueWithNonretainedObject:alertView]];
    [self.alertButtons removeObjectForKey:[NSValue valueWithNonretainedObject:alertView]];
    [self.alertViews removeObjectForKey:[NSValue valueWithNonretainedObject:alertView]];

    // If the button index is -1 it means we were dismissed with no selection
    // TODO:  Should we treat the button index == -1 as a cancel and call the cancel block if any?
    if (buttonIndex >= 0)
    {
        BlockButton *button = [buttonsArray objectAtIndex:buttonIndex];

        NSString *text0 = @"";
        NSString *text1 = @"";
        switch (alertView.alertViewStyle) {
            case UIAlertViewStyleDefault:
                if(button.action)
                    button.action();
                if (button.actionWithText)
                    button.actionWithText(button.label);
                break;
            case UIAlertViewStyleSecureTextInput:
            case UIAlertViewStylePlainTextInput:
                if (button.actionWithText) {
                    text0 = [[alertView textFieldAtIndex:0] text];
                    button.actionWithText(text0);
                }
                break;
            case UIAlertViewStyleLoginAndPasswordInput:
                if (button.actionWithTextText) {
                    text0 = [[alertView textFieldAtIndex:0] text];
                    text1 = [[alertView textFieldAtIndex:1] text];
                    button.actionWithTextText(text0, text1);
                }
                break;
            default:
                break;
        }
    }
}

@end


@implementation UIAlertView (BlockButtons)


+(instancetype) showWithMessage:(NSString *)message {
    return [UIAlertView showWithTitle:@"" message:message];
}


+(instancetype) showWithTitle:(NSString *)title message:(NSString *)message {
    return [UIAlertView showWithTitle:title message:message cancelButtonTitle:NSLocalizedString(@"OK", nil)];
}


+(instancetype) showWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
{
    if (title == nil) {
        // title == nil looked fine on iOS 7.  It looks *rubbish* on iOS 8 beta 5.
        // Set it to the empty string instead.
        title = @"";
    }
    NSString * accessibilityLabel = [title isNotWhitespace] ? title : message;

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:[UIAlertViewHelper sharedHelper]
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    alert.accessibilityLabel = accessibilityLabel;

    [alert show];

    return alert;
}

+(instancetype) showWithTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(BlockButton *)cancelButton
{
    if (cancelButton) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                   cancelButton:cancelButton
                                                        buttons:nil];
        [alert show];
        return alert;
    }
    else {
        return [UIAlertView showWithTitle:title message:message];
    }
}


+(instancetype) showWithTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(BlockButton *)cancelButton
                  otherButton:(BlockButton *)okButton
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                               cancelButton:cancelButton
                                                    buttons:@[okButton]];
    [alert show];
    return alert;
}

+(instancetype) showWithTitle:(NSString *)title
                      message:(NSString *)message
                      textBox:(NSString *)defaultText
                 cancelButton:(BlockButton *)cancelButton
                  otherButton:(BlockButton *)okButton
{
    if (title == nil) {
        // As above.
        title = @"";
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:[UIAlertViewHelper sharedHelper]
                                          cancelButtonTitle:cancelButton.label
                                          otherButtonTitles:okButton.label, nil];
    alert.accessibilityLabel = title;

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    if (defaultText)
        [[alert textFieldAtIndex:0] setText:defaultText];

    [[UIAlertViewHelper sharedHelper] setButtons:@[cancelButton, okButton] forAlert:alert];

    [alert show];

    return alert;
}

+ (instancetype)askForPasswordWithTitle:(NSString *)title
                                message:(NSString *)message
                           cancelButton:(BlockButton *)cancelButton
                            otherButton:(BlockButton *)okButton
{
    if (title == nil) {
        // As above.
        title = @"";
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:[UIAlertViewHelper sharedHelper]
                                          cancelButtonTitle:cancelButton.label
                                          otherButtonTitles:okButton.label, nil];
    alert.accessibilityLabel = title;
    
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    
    [[UIAlertViewHelper sharedHelper] setButtons:@[cancelButton, okButton] forAlert:alert];
    
    [alert show];
    
    return alert;
}

+(instancetype) showWithTitle:(NSString *)title
                      message:(NSString *)message
                     userName:(NSString *)userName
                     password:(NSString *)password
                 cancelButton:(BlockButton *)cancelButton
                  otherButton:(BlockButton *)okButton
{
    if (title == nil) {
        // As above.
        title = @"";
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:[UIAlertViewHelper sharedHelper]
                                          cancelButtonTitle:cancelButton.label
                                          otherButtonTitles:okButton.label, nil];
    alert.accessibilityLabel = title;

    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    if (userName)
        [[alert textFieldAtIndex:0] setText:userName];
    if (password)
        [[alert textFieldAtIndex:1] setText:password];

    [[UIAlertViewHelper sharedHelper] setButtons:@[cancelButton, okButton] forAlert:alert];

    return alert;
}


// If we wanted to implement an equivalent -initWithTitle,
// there are some hoops we need to go through.
// Read: http://c-faq.com/varargs/handoff.html which explains the issues to the problem asked at:
// http://stackoverflow.com/questions/1185177/how-to-send-optional-arguments-to-another-function-method?rq=1
// This function is based on sample at https://github.com/jivadevoe/UIAlertView-Blocks
+(instancetype) showWithTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(BlockButton *)cancelButton
                 otherButtons:(BlockButton *)otherButtons, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *buttonsArray = [NSMutableArray array];
    BlockButton *eachItem;
    va_list argumentList;
    if (otherButtons)
    {
        [buttonsArray addObject: otherButtons];
        va_start(argumentList, otherButtons);
        while((eachItem = va_arg(argumentList, BlockButton *)))
        {
            [buttonsArray addObject: eachItem];
        }
        va_end(argumentList);
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                               cancelButton:cancelButton
                                                    buttons:buttonsArray];
    [alert show];
    return alert;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

-(instancetype) initWithTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(BlockButton *)cancelButton
                 otherButtons:(BlockButton *)otherButtons, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *buttonsArray = [NSMutableArray array];
    BlockButton *eachItem;
    va_list argumentList;
    if (otherButtons)
    {
        [buttonsArray addObject: otherButtons];
        va_start(argumentList, otherButtons);
        while((eachItem = va_arg(argumentList, BlockButton *)))
        {
            [buttonsArray addObject: eachItem];
        }
        va_end(argumentList);
    }

    return [[UIAlertView alloc] initWithTitle:title
                                      message:message
                                 cancelButton:cancelButton
                                      buttons:buttonsArray];
}

-(instancetype) initWithTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(BlockButton *)cancelButton
                      buttons:(NSArray *)buttons
{
    if (title == nil) {
        // As above.
        title = @"";
    }

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:[UIAlertViewHelper sharedHelper]
                                           cancelButtonTitle:(cancelButton ? cancelButton.label : nil)
                                           otherButtonTitles:nil];
    alert.accessibilityLabel = title;

    NSMutableArray * buttonsArray = buttons == nil ? [NSMutableArray array] : [buttons mutableCopy];

    for (BlockButton * button in buttonsArray) {
        [alert addButtonWithTitle:button.label];
    }

    if (cancelButton) {
        [buttonsArray insertObject:cancelButton atIndex:0];
    }

    [[UIAlertViewHelper sharedHelper] setButtons:buttonsArray forAlert:alert];
    
    return alert;
}
#pragma clang diagnostic pop

-(void)dismiss:(BOOL)animated
{
    [self dismissWithClickedButtonIndex:-1 animated:animated];
}

@end

