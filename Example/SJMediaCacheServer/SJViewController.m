//
//  SJViewController.m
//  SJMediaCacheServer
//
//  Created by changsanjiang@gmail.com on 05/30/2020.
//  Copyright (c) 2020 changsanjiang@gmail.com. All rights reserved.
//

#import "SJViewController.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import <Masonry/Masonry.h>

#import "SJMediaCacheServer.h"

#import <SJMediaCacheServer/NSURLRequest+MCS.h>
#import <SJMediaCacheServer/MCSURLRecognizer.h>
#import <SJMediaCacheServer/MCSPrefetcherManager.h>
#import <SJBaseVideoPlayer/SJAVMediaPlaybackController.h>

#import <MCSDownload.h>

static NSString *const DEMO_URL_HLS = @"http://hls.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/bca293257d954934afadfaa96d865172/450.m3u8";
static NSString *const DEMO_URL_FILE = @"https://dh2.v.netease.com/2017/cg/fxtpty.mp4";

@interface SJViewController ()
@property (nonatomic, strong, nullable) SJVideoPlayer *player;
@end

@implementation SJViewController

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
    
    SJMediaCacheServer.shared.enabledConsoleLog = YES;
    SJMediaCacheServer.shared.logOptions = MCSLogOptionPrefetcher;
     
//    [self _demo1];
//    [self _demo2];
    [self _demo3];
}

- (void)_demo3 {
    NSArray<NSString *> *urls = @[
        @"https://xy2.v.netease.com/2020/dhp/qkjoimclekw15.mp4",
        @"https://xy2.v.netease.com/2020/dhp/kijqolmhew14.mp4",
        @"https://xy2.v.netease.com/2020/dhp/qaoimkqoiwj13.mp4",
        @"https://xy2.v.netease.com/2020/dhp/kenjlmvkkh12.mp4",
        @"https://xy2.v.netease.com/2020/dhp/qokwiomlveo11.mp4",
        @"https://xy2.v.netease.com/2020/dhp/wlijwlmuewl10.mp4",
        @"https://xy2.v.netease.com/2020/dhp/wporkinkr9.mp4",
        @"https://xy2.v.netease.com/2020/dhp/wpolijorjlo8.mp4",
        @"https://xy2.v.netease.com/2020/dhp/wiojeoijw7.mp4",
        @"https://xy2.v.netease.com/2020/dhp/isjolemkli6.mp4",
        @"https://xy2.v.netease.com/2020/dhp/jolnksihg5.mp4",
        @"https://xy2.v.netease.com/2020/dhp/e4.mp4",
        @"https://xy2.v.netease.com/2020/dhp/e3.mp4",
        @"https://xy2.v.netease.com/2020/dhp/e2.mp4",
        @"https://xy2.v.netease.com/2020/dhp/e1.mp4",
    ];
    
    for ( NSString *url in urls ) {
        [self _prefetch:[NSURL URLWithString:url]];
    }
    
    SJMediaCacheServer.shared.maxConcurrentPrefetchCount = 15;
}

- (void)_demo2 {
    // prefetch
    NSString *url = DEMO_URL_HLS;
    NSURL *URL = [NSURL URLWithString:url];
    [self _prefetch:URL];
}

- (void)_demo1 {
    // play
    NSString *url = DEMO_URL_FILE;
    NSURL *URL = [NSURL URLWithString:url];
    [self _play:URL];
}

#pragma mark -

- (void)_play:(NSURL *)URL {
    NSURL *playbackURL = [SJMediaCacheServer.shared playbackURLWithURL:URL];
    // play
    _player.URLAsset = [SJVideoPlayerURLAsset.alloc initWithURL:playbackURL startPosition:0];
}

- (void)_prefetch:(NSURL *)URL {
    [SJMediaCacheServer.shared prefetchWithURL:URL preloadSize:20 * 1024 * 1024 progress:^(float progress) {
        
        // progress ...
        
    } completed:^(NSError * _Nullable error) {
        
        // complete ...
        NSLog(@"error: %@", error);
    }];
}

- (void)_setupViews {
    _player = SJVideoPlayer.player;
    _player.pauseWhenAppDidEnterBackground = NO;
    [self.view addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.centerY.offset(0);
        make.height.offset(210);
    }];
}
@end
