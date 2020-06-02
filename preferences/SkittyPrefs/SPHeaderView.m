// SPHeaderView.m
#define ColorOne [UIColor colorWithRed:0.180 green:0.831 blue:0.710 alpha:1.0]
#define ColorTwo [UIColor colorWithRed:0.502 green:0.502 blue:0.502 alpha:1.0]
#import "SPHeaderView.h"

@import CoreText;

@implementation SPHeaderView

- (id)initWithSettings:(NSDictionary *)settings {
	self = [super init];

	if (self) {
		self.settings = settings;

		NSString *fontName = nil;
		if (settings[@"headerFontPath"]) {
			CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename([settings[@"headerFontPath"] UTF8String]);
			CGFontRef font = CGFontCreateWithDataProvider(dataProvider);
			CGDataProviderRelease(dataProvider);
			CTFontManagerRegisterGraphicsFont(font, nil);
			fontName = (NSString *)CFBridgingRelease(CGFontCopyPostScriptName(font));
			CGFontRelease(font);
		}

		self.backgroundColor = [UIColor clearColor];//settings[@"headerColor"] ?: settings[@"tintColor"];

		self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, self.bounds.size.width, 118)];
		[self addSubview:self.contentView];

		self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.bounds.size.width, 60)];
        self.titleLabel.text = @"iPadBar13"; //settings[@"name"];
		self.titleLabel.textAlignment = NSTextAlignmentCenter;
		if (fontName) {
            self.titleLabel.font = [UIFont fontWithName:fontName size:50];
		} else {
			self.titleLabel.font = [UIFont boldSystemFontOfSize:50];
		}
		self.titleLabel.textColor = [UIColor greenColor];//settings[@"textColor"] ?: [UIColor whiteColor];
		[self.contentView addSubview:self.titleLabel];

		self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 91, self.bounds.size.width, 35)];
		self.subtitleLabel.text = @"By AohuiLiu"; //settings[@"subtitle"];
		self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
		if (fontName) {
			self.subtitleLabel.font = [UIFont fontWithName:fontName size:28];
		} else {
			self.subtitleLabel.font = [UIFont systemFontOfSize:28];
		}
		self.subtitleLabel.textColor = ColorTwo;//settings[@"textColor"] ?: [UIColor whiteColor];
		[self.contentView addSubview:self.subtitleLabel];


        self.backgroundColor = [UIColor clearColor];//self.settings[@"headerColor"] ?: self.settings[@"tintColor"];
        self.titleLabel.textColor = ColorOne;//self.settings[@"textColor"] ?: [UIColor whiteColor];
        self.subtitleLabel.textColor = ColorTwo;//self.settings[@"textColor"] ?: [UIColor whiteColor];

	}

	return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];

	CGFloat statusBarHeight = 20;
	if (@available(iOS 13.0, *)) {
		statusBarHeight = self.window.windowScene.statusBarManager.statusBarFrame.size.height;
	} else {
		statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	}

	CGFloat offset = statusBarHeight + [self _viewControllerForAncestor].navigationController.navigationController.navigationBar.frame.size.height;

	self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, (frame.size.height - offset)/2 - self.contentView.frame.size.height/2 + offset - 10, frame.size.width, self.contentView.frame.size.height);

	self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, frame.size.width, self.titleLabel.frame.size.height);

	self.subtitleLabel.frame = CGRectMake(self.subtitleLabel.frame.origin.x, self.subtitleLabel.frame.origin.y, frame.size.width, self.subtitleLabel.frame.size.height);
}

- (CGFloat)contentHeightForWidth:(CGFloat)width {
	return 140;
}

@end
