//
//  MPMoviePlayerViewController+Ext.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/6/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "Dispatch.h"
#import "TBAsserts.h"

#import "MPMoviePlayerViewController+Ext.h"


@interface MPMoviePlayerCompletion : NSObject

@property (nonatomic, strong) MPMoviePlayerController* player;
@property (nonatomic, copy) VoidBlock onCompletion;

@property (nonatomic, strong) MPMoviePlayerCompletion* thisSelf;

-(instancetype)init:(MPMoviePlayerController*)player onCompletion:(VoidBlock)onCompletion;

@end


@implementation MPMoviePlayerViewController (Ext)


-(void)playModal:(UIViewController*)vc onCompletion:(VoidBlock)onCompletion __attribute__((nonnull(1))) {
    AssertOnMainThread();
    NSParameterAssert(vc);

    __unused MPMoviePlayerCompletion* cleanup = [[MPMoviePlayerCompletion alloc] init:self.moviePlayer onCompletion:onCompletion];
    [vc presentMoviePlayerViewControllerAnimated:self];
}


@end


@implementation MPMoviePlayerCompletion


-(instancetype)init:(MPMoviePlayerController *)player onCompletion:(VoidBlock)onCompletion {
    self = [super init];
    if (self) {
        _player = player;
        _onCompletion = onCompletion;

        _thisSelf = self;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    }
    return self;
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)playbackDidFinish:(NSNotification*)notification {
    if (notification.object != self.player)
        return;

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    VoidBlock onCompletion = self.onCompletion;
    self.onCompletion = NULL;
    if (onCompletion) {
        dispatchAsyncMainThread(^{
            onCompletion();
        });
    }

    self.player = nil;
    self.thisSelf = nil;
}


@end
