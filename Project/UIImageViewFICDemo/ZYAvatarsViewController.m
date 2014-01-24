//
//  ZYAvatarsViewController.m
//  UIImageViewFICDemo
//
//  Created by Xuanxiang Pan on 1/24/14.
//  Copyright (c) 2014 Ziyisoft. All rights reserved.
//

#import "ZYAvatarsViewController.h"
#import "FICDTableView.h"
#import "ZYAvatarCell.h"

@interface ZYAvatarsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_avatarUrls;
    
    FICDTableView *_tableView;
    UILabel *_averageFPSLabel;
}

@end

@implementation ZYAvatarsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"UIImageFICDemo";
    
	NSString *urlsInfoPath = [[NSBundle mainBundle] pathForResource:@"weibo_avatars" ofType:@"plist"];
    _avatarUrls = [NSArray arrayWithContentsOfFile:urlsInfoPath];
    
    _tableView = [[FICDTableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
    // Configure the average FPS label
    if (_averageFPSLabel == nil) {
        _averageFPSLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 54, 22)];
        [_averageFPSLabel setBackgroundColor:[UIColor clearColor]];
        [_averageFPSLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [_averageFPSLabel setTextAlignment:NSTextAlignmentRight];
        
        [_tableView addObserver:self forKeyPath:@"averageFPS" options:NSKeyValueObservingOptionNew context:NULL];
    }
    UIBarButtonItem *averageFPSLabelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_averageFPSLabel];
    [self.navigationItem setRightBarButtonItem:averageFPSLabelBarButtonItem];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil(1.0f * [_avatarUrls count] / kAVATARS_PER_ROW);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifer = @"avatar-cell";
    ZYAvatarCell *cell = (ZYAvatarCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
    if (!cell){
        cell = [[ZYAvatarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger startIndex = [indexPath row] * kAVATARS_PER_ROW;
    NSInteger count = MIN(kAVATARS_PER_ROW, [_avatarUrls count] - startIndex);    
    cell.avatarUrls = [_avatarUrls subarrayWithRange:NSMakeRange(startIndex, count)];
    return cell;
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}


#pragma mark - NSObject (NSKeyValueObserving)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _tableView && [keyPath isEqualToString:@"averageFPS"]) {
        CGFloat averageFPS = [[change valueForKey:NSKeyValueChangeNewKey] floatValue];
        averageFPS = MIN(MAX(0, averageFPS), 60);
        [self _displayAverageFPS:averageFPS];
    }
}

#pragma mark - Displaying the Average Framerate

- (void)_displayAverageFPS:(CGFloat)averageFPS {
    if ([_averageFPSLabel attributedText] == nil) {
        CATransition *fadeTransition = [CATransition animation];
        [[_averageFPSLabel layer] addAnimation:fadeTransition forKey:kCATransition];
    }
    
    NSString *averageFPSString = [NSString stringWithFormat:@"%.0f", averageFPS];
    NSUInteger averageFPSStringLength = [averageFPSString length];
    NSString *displayString = [NSString stringWithFormat:@"%@ FPS", averageFPSString];
    
    UIColor *averageFPSColor = [UIColor blackColor];
    
    if (averageFPS > 45) {
        averageFPSColor = [UIColor colorWithHue:(114 / 359.0) saturation:0.99 brightness:0.89 alpha:1]; // Green
    } else if (averageFPS <= 45 && averageFPS > 30) {
        averageFPSColor = [UIColor colorWithHue:(38 / 359.0) saturation:0.99 brightness:0.89 alpha:1];  // Orange
    } else if (averageFPS < 30) {
        averageFPSColor = [UIColor colorWithHue:(6 / 359.0) saturation:0.99 brightness:0.89 alpha:1];   // Red
    }
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:displayString];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:averageFPSColor range:NSMakeRange(0, averageFPSStringLength)];
    
    [_averageFPSLabel setAttributedText:mutableAttributedString];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_hideAverageFPSLabel) object:nil];
    [self performSelector:@selector(_hideAverageFPSLabel) withObject:nil afterDelay:1.5];
}

- (void)_hideAverageFPSLabel {
    CATransition *fadeTransition = [CATransition animation];
    
    [_averageFPSLabel setAttributedText:nil];
    [[_averageFPSLabel layer] addAnimation:fadeTransition forKey:kCATransition];
}

@end
