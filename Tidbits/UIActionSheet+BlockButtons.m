//
//  UIActionSheet+BlockButtons.m
//  Tipbit
//
//  Created by Navi Singh on 3/29/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import "Dispatch.h"
#import "NSString+Misc.h"
#import "SynthesizeAssociatedObject.h"

#import "UIActionSheet+BlockButtons.h"


static NSString *UIActionSheetDismissAction = @"~~UIActionSheetDismissAction~~";


@interface UIActionSheet (BlockButtons)

@property (nonatomic) NSArray * tb_blockButtons;

@end


@implementation UIActionSheet (BlocksButtons)

+ (instancetype)createWithTitle:(NSString *)title
                       delegate:(id<UIActionSheetDelegate>)delegate
              cancelButtonTitle:(NSString *)cancelButtonTitle
         destructiveButtonTitle:(NSString *)destructiveButtonTitle
              otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *buttonsArray = [NSMutableArray array];
    NSString *eachItem;
    va_list argumentList;
    if (otherButtonTitles)
    {
        [buttonsArray addObject: otherButtonTitles];
        va_start(argumentList, otherButtonTitles);
        while((eachItem = va_arg(argumentList, NSString *)))
        {
            [buttonsArray addObject: eachItem];
        }
        va_end(argumentList);
    }
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:title
                                                        delegate:delegate
                                               cancelButtonTitle:nil
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:nil];
    for(NSString *item in buttonsArray)
    {
        [action addButtonWithTitle:item];
    }
    
    if(destructiveButtonTitle)
    {
        action.destructiveButtonIndex = [action addButtonWithTitle:destructiveButtonTitle];
    }
    if(cancelButtonTitle)
    {
        action.cancelButtonIndex = [action addButtonWithTitle:cancelButtonTitle];
    }
    return action;
}

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
             destructiveButton:(BlockButton *)destructiveButton
                     onDismiss:(void(^)())dismissAction
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
    
    return [UIActionSheet createWithTitle:title
                             cancelButton:cancelButton
                        destructiveButton:destructiveButton
                                onDismiss:dismissAction
                                  buttons:buttonsArray];
}

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
             destructiveButton:(BlockButton *)destructiveButton
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
    
    return [UIActionSheet createWithTitle:title
                             cancelButton:cancelButton
                        destructiveButton:destructiveButton
                                onDismiss:nil
                                  buttons:buttonsArray];
}

+(instancetype)createWithButtons:(NSArray *)buttonsArray
{
    return [UIActionSheet createWithTitle:nil cancelButton:nil buttons:buttonsArray];
}

+(instancetype)createWithTitle:(NSString *)title
                       buttons:(NSArray *)buttonsArray
{
    return [UIActionSheet createWithTitle:nil cancelButton:nil buttons:buttonsArray];
}

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
                       buttons:(NSArray *)buttonsArray
{
    BlockButton *header = nil;
    BlockButton *destructiveButton = nil;
    for (BlockButton *button in buttonsArray) {
        if (button.isHeader) {
            header = button;
        }
        else if (button.isCancel) {
            cancelButton = button;
        }
        else if (button.isDestructive || [button.label isEqualToStringCaseInsensitive:@"delete"]) {
            destructiveButton = button;
        }
    }

    if (header != nil || destructiveButton != nil || cancelButton != nil) {
        NSMutableArray *array = [buttonsArray mutableCopy];
        if (header) {
            [array removeObject:header];
        }
        if (cancelButton != nil) {
            [array removeObject:cancelButton];
        }
        if (destructiveButton != nil) {
            [array removeObject:destructiveButton];
        }
        buttonsArray = array;
    }

    if (cancelButton == nil) {
        cancelButton = [BlockButton label:NSLocalizedString(@"Cancel", nil)];
    }

    if (title == nil) {
        title = header.label;
    }

    return [UIActionSheet createWithTitle:title
                             cancelButton:cancelButton
                        destructiveButton:destructiveButton
                                onDismiss:nil
                                  buttons:buttonsArray];
}


+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
             destructiveButton:(BlockButton *)destructiveButton
                       buttons:(NSArray *)buttonsArray
{
    return [UIActionSheet createWithTitle:title
                             cancelButton:cancelButton
                        destructiveButton:destructiveButton
                                onDismiss:nil
                                  buttons:buttonsArray];
}

//This is the main function where all the magic happens.
+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
             destructiveButton:(BlockButton *)destructiveButton
                     onDismiss:(void(^)())dismissAction
                       buttons:(NSArray *)buttons
{
    NSMutableArray *buttonsArray;
    if (buttons)
        buttonsArray = [NSMutableArray arrayWithArray:buttons];
    else
        buttonsArray = [NSMutableArray array];
    
    //we got to do this because delegate is defined as id<UIActionSheetDelegate>
    //unlike what happens for UIAlertViews.
    id<UIActionSheetDelegate> selfClass = (id<UIActionSheetDelegate>)[UIActionSheet class];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
															 delegate:selfClass
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];
    
	if(destructiveButton)
    {
        destructiveButton.parentView = actionSheet;
		[buttonsArray insertObject:destructiveButton atIndex:0];
        //		[buttonsArray addObject:destructiveButton];
        actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle:destructiveButton.label];
    }
    
	for(BlockButton *item in buttonsArray)
    {
		if (!(item == destructiveButton)){
			item.parentView = actionSheet;
			[actionSheet addButtonWithTitle:item.label];
		}
    }
    
    if(cancelButton)
    {
        cancelButton.parentView = actionSheet;
        [buttonsArray addObject:cancelButton];
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:cancelButton.label];
    }
    if (dismissAction) {
        //We create a dummy button for the dismiss action that makes our life easier.
        BlockButton *dismissButton = [BlockButton label:UIActionSheetDismissAction action:dismissAction];
        [buttonsArray addObject:dismissButton];
    }

    actionSheet.tb_blockButtons = buttonsArray;

    return actionSheet;
}

-(void)dismiss:(BOOL)animated
{
    [self dismissWithClickedButtonIndex:-1 animated:animated];
}

#pragma mark UIActionSheetDelegate

+(void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    NSUInteger i = 1;
    for (BlockButton * button in actionSheet.tb_blockButtons) {
        if (button.isChecked) {
            UIButton * btn = (UIButton *)[actionSheet viewWithTag:i];
            UILabel *check = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 20, btn.frame.size.height)];
            check.font = [UIFont fontWithName:@"ZapfDingbatsITC" size:20];
            check.textColor = button.checkColor;
            check.text = @"✔";
            [btn addSubview:check];
        }
        i++;
    }
}


+ (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSArray * buttonsArray = actionSheet.tb_blockButtons;

    // Action sheets pass back -1 when they're cleared for some reason other than a button being
    // pressed.
    if (buttonIndex >= 0)
    {
        BlockButton *button = buttonsArray[buttonIndex];
        dispatchAsyncMainThread(^{
            [button executeAction];
        });
    }
    else if (buttonsArray.count > 0) {
        //See if the last item in the array is the dismissActionDummy button.
        BlockButton *dismissButton = buttonsArray[buttonsArray.count - 1];
        if ([dismissButton.label isEqualToString:UIActionSheetDismissAction]) {
            dispatchAsyncMainThread(^{
                [dismissButton executeAction];
            });
        }
    }
}


SYNTHESIZE_ASSOCIATED_OBJ(NSArray *, tb_blockButtons, setTb_blockButtons, OBJC_ASSOCIATION_RETAIN_NONATOMIC);


@end
