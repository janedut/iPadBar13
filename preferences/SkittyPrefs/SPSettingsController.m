// SPSettingsController.m
#define ColorOne [UIColor colorWithRed:0.180 green:0.831 blue:0.710 alpha:1.0]
#define ColorTwo [UIColor colorWithRed:0.502 green:0.502 blue:0.502 alpha:1.0]

#import "SPSettingsController.h"
//#import "UIColor+Hex.h"
#import <Preferences/PSSpecifier.h>

@implementation SPSettingsController



- (void)loadView {
	[super loadView];

	// Load settings
	NSURL *url = [NSURL fileURLWithPath:[[self resourceBundle] pathForResource:@"Root" ofType:@"plist"]];
	NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfURL:url];
	self.settings = [settings mutableCopy];
	[self.settings removeObjectForKey:@"items"];

}

- (void)viewDidLoad {
	[super viewDidLoad];

	UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-50, -5, titleView.bounds.size.width+100, titleView.bounds.size.height)];
//				self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, self.bounds.size.width, 118)];
	self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
	self.titleLabel.text = @"";
	self.titleLabel.alpha = 1.0;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	[titleView addSubview:self.titleLabel];

	self.versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(-50, 0, titleView.bounds.size.width+100, titleView.bounds.size.height)];
//				self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, self.bounds.size.width, 118)];
	self.versionLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	self.versionLabel.text = @"2.0.2";
	self.versionLabel.textColor = ColorOne;
	self.versionLabel.alpha = 1.0;
	self.versionLabel.textAlignment = NSTextAlignmentCenter;
	[titleView addSubview:self.versionLabel];


	self.iconView = [[UIImageView alloc] initWithFrame:titleView.bounds];
	self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/iPadBar13.bundle/icon/icon.png"];
	self.iconView.alpha = 0;
	[titleView addSubview:self.iconView];

	self.navigationItem.titleView = titleView;


	// Create header view
	self.headerView = [[SPHeaderView alloc] initWithSettings:[self.settings copy]];
	self.headerView.layer.zPosition = 1000;
	[self.view addSubview:self.headerView];

	// Update offset for header
	UITableView *tableView = [self valueForKey:@"_table"];
	CGFloat contentHeight = [self.headerView contentHeightForWidth:self.view.bounds.size.width];
	[tableView setContentOffset:CGPointMake(0, -contentHeight) animated: NO];
	self.iconView.alpha = 1;

	/*UIAlertController* alert = [UIAlertController alertControllerWithTitle:@":("
							message:@"Remove cydiakk repo and redownload iPadBar13 from my repo."
							preferredStyle:UIAlertControllerStyleAlert];

	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Caches/com.saurik.Cydia/lists/apt.cydiakk.com_._Packages"] || [[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/apt/lists/apt.cydiakk.com_._Packages"] || [[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Application Support/xyz.willy.Zebra/lists/apt.cydiakk.com_._Packages"] || ![[NSFileManager defaultManager] fileExistsAtPath:@"/Library/dpkg/info/com.aohuiliu.ipadbar13.list"] || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/dpkg/info/apt.cydiakk.ipadbar13.list"]){
		[self presentViewController:alert animated:YES completion:nil];
		// nothing
	}
		else {
		//[self presentViewController:alert animated:YES completion:nil];
	}*/
}

- (void)viewWillAppear:(BOOL)animated {
	// color

	[super viewWillAppear:animated];
	UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
	self.navigationItem.rightBarButtonItem = applyButton;
	UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
	self.view.tintColor = ColorOne;
	keyWindow.tintColor = ColorOne;
	[UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]].onTintColor = ColorOne;
	self.iconView.alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
  keyWindow.tintColor = nil;
}


// Header positioning
- (void)layoutHeader {
	UITableView *tableView = [self valueForKey:@"_table"];

	CGFloat contentHeight = [self.headerView contentHeightForWidth:self.view.bounds.size.width];

	CGFloat yPos = fmin(0, -tableView.contentOffset.y);
	CGFloat elasticHeight = -tableView.contentOffset.y - contentHeight;

	if (elasticHeight < 0) {
		yPos += elasticHeight;
		elasticHeight = 0;
	}

	self.headerView.frame = CGRectMake(0, yPos, self.view.bounds.size.width, contentHeight + elasticHeight);
	self.headerView.elasticHeight = elasticHeight;
	tableView.contentInset = UIEdgeInsetsMake(contentHeight, 0, 0, 0);

	if (@available(iOS 13.0, *)) {
		tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
	}
	tableView.scrollIndicatorInsets = UIEdgeInsetsMake(contentHeight + elasticHeight, 0, 0, 0);

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self layoutHeader];
	CGFloat offsetY = scrollView.contentOffset.y;

	if (offsetY > -45) {
			[UIView animateWithDuration:0.20 animations:^{
					self.iconView.alpha = 1.0;
					self.titleLabel.alpha = 0;
					self.versionLabel.alpha = 0;
			}];
	} else {
			[UIView animateWithDuration:0.20 animations:^{
					self.iconView.alpha = 0;
					self.titleLabel.alpha = 1.0;
					self.versionLabel.alpha = 1.0;
			}];
	}

}


// Bundle for fetching resources
// This should probably be overridden in subclasses.
- (NSBundle *)resourceBundle {
	return [NSBundle bundleForClass:self.class];
}

@end





@implementation LabeledSliderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

    if (self)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,8,300,20)];
        label.text = specifier.properties[@"label"];

        [self.contentView addSubview:label];
        [self.control setFrame:CGRectOffset(self.control.frame, 10, 10)];
		//[self setBackgroundColor:[UIColor whiteColor]];
    }

    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.control setFrame:CGRectOffset(self.control.frame, 0, 9)];
}

@end




@implementation SublabelLinkCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];
  if (self) {
    //NSString *subTitleValue = [specifier.properties objectForKey:@"subtitle"];
    self.detailTextLabel.text = [specifier.properties objectForKey:@"sublabel"];
  }
  return self;
}

- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)style {
  [super setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}
@end

@implementation SublabelSwitchCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];
  if (self) {
    NSString *subTitleValue = [specifier.properties objectForKey:@"sublabel"];
    self.detailTextLabel.text = subTitleValue;

  }
  return self;
}



@end
