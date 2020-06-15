

%group fuckkkGroup
#define fCydia @"/var/mobile/Library/Caches/com.saurik.Cydia/lists/apt.cydiakk.com_._Packages"
#define fSelio @"/var/lib/apt/lists/apt.cydiakk.com_._Packages"
#define fZebra @"/var/mobile/Library/Application Support/xyz.willy.Zebra/lists/apt.cydiakk.com_._Packages"
#define fKK @"/Library/dpkg/info/apt.cydiakk.ipadbar13.list"
#define fiPadBar13 @"/Library/dpkg/info/com.aohuiliu.ipadbar13.list"
static BOOL fuckkk;

%hook SpringBoard
  -(void)applicationDidFinishLaunching:(id)arg1 {
    %orig;

    if ([[NSFileManager defaultManager] fileExistsAtPath:fCydia] || [[NSFileManager defaultManager] fileExistsAtPath:fSelio] || [[NSFileManager defaultManager] fileExistsAtPath:fZebra] || ![[NSFileManager defaultManager] fileExistsAtPath:fiPadBar13] || [[NSFileManager defaultManager] fileExistsAtPath:fKK]){

      fuckkk = YES;

    }else fuckkk = NO;

    if(fuckkk == YES) {
      UIAlertController *fuckkkAlert = [UIAlertController alertControllerWithTitle:@":(" message:@"Remove cydiakk repo and redownload iPadBar13 from my repo." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
      [fuckkkAlert addAction:cancelAction];
      [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:fuckkkAlert animated:YES completion:nil];
    }
  }
%end
%end

#import "Tweak.h"
#define CGRectSetY(rect, y) CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height)

//#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static BOOL EnableiPadStatusBar, extraPadding, HideBarCC, EnableCustomTimeFormat, PercentInBattery, BoldFont1, BoldFont2, BoldFont3;
static BOOL showDND, showAlarm, showLocationServices, showRotationLock, showSignal, showLockIcon,
showBattery, showBatteryPercent, showAirplane, showVPN, showBreadcrumb, showActivity, showTime, showCarrier,
showBatteryPercentSign, showWifi, showData;
static CGFloat FontSize1, FontSize2, FontSize3;

static BOOL Fakepencent;
static long long FakePercentage;
static long long speedStyle;
static NSString *speedUnitK;
static NSString *speedUnitM;
static NSString *speedUnitG;
static long long speedUnitValue;

static NSString *lang	= @"en_US";

%group fakepercentGroup
%hook BCBatteryDevice
- (long long)percentCharge {
    return FakePercentage;
}
%end
%end

%hook _UIStatusBarVisualProvider_iOS
+ (Class)class {
  if (EnableiPadStatusBar) {
    if (extraPadding) {
      return NSClassFromString(@"_UIStatusBarVisualProvider_RoundedPad_ForcedCellular");
    } else {
      return NSClassFromString(@"_UIStatusBarVisualProvider_Pad_ForcedCellular");
    }
  } else {
    return %orig;
  }



}
%end

%group hideBarInCC

/*%hook CCUIHeaderPocketView
- (void)setFrame:(CGRect)frame {
    %orig(CGRectSetY(frame, 900))
}


%end*/
%hook CCUIStatusBar
  - (void)setFrame:(CGRect)frame {
      %orig(CGRectSetY(frame, 900));

}
%end
%end
// fix statusbar bigger

%hook _UIStatusBarStyleAttributes
- (long long)mode {
  if(EnableiPadStatusBar == YES){
    return 0;
  }else {
    return %orig;
  }
}
%end




//netspeed
#import <ifaddrs.h>
#import <net/if.h>

// ___________________________________________________________________________________

/* NETWORK SPEED (by julioverne) */
static BOOL EnableNetspeed;
static int limitbytes;
static const long kilobytes = 1 << 10;
static const long megabytes = 1 << 20;
static const long gigabytes = 1 << 30;

NSString* bytesFormat(long bytes) {
	@autoreleasepool {
		if (EnableNetspeed == YES && bytes < limitbytes*1000) {
			return @"";
		}else {
      switch (speedUnitValue) {
        case 0:
        speedUnitK = @"K/s";
        speedUnitM = @"M/s";
        speedUnitG = @"G/s";
        break;

        case 1:
        speedUnitK = @"KB/s";
        speedUnitM = @"MB/s";
        speedUnitG = @"GB/s";
        break;

        case 2:
        speedUnitK = @"K";
        speedUnitM = @"M";
        speedUnitG = @"G";
        break;

        case 3:
        speedUnitK = @"KB";
        speedUnitM = @"MB";
        speedUnitG = @"GB";
        break;
      }
      switch (speedStyle) {
        case 0:
        if (EnableNetspeed == YES && bytes < megabytes) {
    			return [NSString stringWithFormat:@"%.0f%@", (double)bytes / kilobytes, speedUnitK];
    		}
    		if (EnableNetspeed == YES && bytes < gigabytes) {
    			return [NSString stringWithFormat:@"%.0f%@", (double)bytes / megabytes, speedUnitM];
    		}
        if (EnableNetspeed == YES ) {
    			return [NSString stringWithFormat:@"%.0f%@", (double)bytes / gigabytes, speedUnitG];
    		}
        break;

        case 1:
        if (EnableNetspeed == YES && bytes < megabytes) {
    			return [NSString stringWithFormat:@"%.1f%@", (double)bytes / kilobytes, speedUnitK];
    		}
    		if (EnableNetspeed == YES && bytes < gigabytes) {
    			return [NSString stringWithFormat:@"%.1f%@", (double)bytes / megabytes, speedUnitM];
    		}
        if (EnableNetspeed == YES ) {
    			return [NSString stringWithFormat:@"%.1f%@", (double)bytes / gigabytes, speedUnitG];
    		}
        break;

        case 2:
        if (EnableNetspeed == YES && bytes < megabytes) {
    			return [NSString stringWithFormat:@"%.2f%@", (double)bytes / kilobytes, speedUnitK];
    		}
    		if (EnableNetspeed == YES && bytes < gigabytes) {
    			return [NSString stringWithFormat:@"%.2f%@", (double)bytes / megabytes, speedUnitM];
    		}
        if (EnableNetspeed == YES ) {
    			return [NSString stringWithFormat:@"%.2f%@", (double)bytes / gigabytes, speedUnitG];
    		}
        break;

      }
    return @"";

	}
}
}

long getBytesTotal() {
	@autoreleasepool {
		struct ifaddrs *ifa_list = 0, *ifa;
		if (getifaddrs(&ifa_list) == -1) {
			return 0;
		}

		uint32_t iBytes = 0;
		uint32_t oBytes = 0;
		for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
			if (AF_LINK != ifa->ifa_addr->sa_family) {
				continue;
			}
			if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) {
				continue;
			}
			if (ifa->ifa_data == 0) {
				continue;
			}
			struct if_data *if_data = (struct if_data *)ifa->ifa_data;
			iBytes += if_data->ifi_ibytes;
			oBytes += if_data->ifi_obytes;
		}

		freeifaddrs(ifa_list);
		return iBytes + oBytes;
	}
}

// ___________________________________________________________________________________

/* Detect when device is unlocked */

static BOOL isDeviceUnlocked = YES;
%hook SBCoverSheetPresentationManager
-(void)setHasBeenDismissedSinceKeybagLock:(BOOL)hasBeenDismissed {
	%orig;
	isDeviceUnlocked = hasBeenDismissed;
}
%end

// ___________________________________________________________________________________


// CutomTimeFormat
static NSAttributedString* cachedAttributedString;
static NSDictionary* attributes1;
static NSDictionary* attributes2;
static NSDictionary* attributes3;
static NSDateFormatter* dateFormatter1;
static NSDateFormatter* dateFormatter2;
static long oldSpeed;
static NSString *TimeFormat1;
static NSString *TimeFormat2;

static NSMutableAttributedString* formattedAttributedString() {
	NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] init];

	// HH:mm
  NSString* date1 = [dateFormatter1 stringFromDate: [NSDate date]];
//	date1 = [date1 stringByAppendingString: @" "];
	NSAttributedString* first = [[NSAttributedString alloc] initWithString:date1 attributes:attributes1];
	[attributedString appendAttributedString: first];

  NSString* date2 = [dateFormatter2 stringFromDate: [NSDate date]];
	NSAttributedString* second = [[NSAttributedString alloc] initWithString:date2 attributes:attributes2];
	[attributedString appendAttributedString: second];


  // Speed
	long nowData = getBytesTotal();
	long dataDiff = nowData-oldSpeed;
	oldSpeed = nowData;
  if(EnableNetspeed ==YES ){
	NSString* formattedBytes = bytesFormat(dataDiff);
	NSAttributedString* third = [[NSAttributedString alloc] initWithString:formattedBytes attributes:attributes3];
	[attributedString appendAttributedString: third];
}
	return attributedString;
}

/*@interface _UIStatusBarStringView: UILabel
@property (nonatomic) NSInteger numberOfLines;
@property (nonatomic) NSTextAlignment textAlignment;
@property(nonatomic) BOOL adjustsFontSizeToFitWidth;
//@property(nonatomic) BOOL adjustsFontSizeToFitWidth;
@property (nullable, nonatomic, copy) NSAttributedString* attributedText;
-(void)setText:(NSString*)arg1;
@end*/



// ===== ITEM HIDING ===== //
%hook SBStatusBarStateAggregator
-(BOOL)_setItem:(int)index enabled:(BOOL)enableItem {


  UIStatusBarItem *item = [%c(UIStatusBarItem) itemWithType:index idiom:0];

  // Unfortunately the date icon doesn't have a name - might break in future iOS versions
  if (index == 1 ) {
    return %orig(index, NO);
  }

  else if ([item.description containsString:@"QuietMode"] && !showDND) {
    return %orig(index, NO);
  }

  else if ([item.description containsString:@"AirplaneMode"] && !showAirplane) {
    return %orig(index, NO);
  }

  else if ([item.description containsString:@"BatteryPercentItem"] && !showBatteryPercent) {
    return %orig(index, NO);
  }

  else if ([item.description containsString:@"Alarm"] && !showAlarm) {
    return %orig(index, NO);
  }

  else if ([item.description containsString:@"Location"] && !showLocationServices) {
    return %orig(index, NO);
  }

  else if ([item.description containsString:@"RotationLock"] && !showRotationLock) {
    return %orig(index, NO);
  }

  else if ([item.description containsString:@"VPN"] && !showVPN) {
    return %orig(index, NO);
  }

  else if ([item.description containsString:@"BarLockItem"] && !showLockIcon) {
    return %orig(index, NO);
  }

  else if ([item.description containsString:@"ActivityItem"] && !showActivity) {
    return %orig(index, NO);
  }

  return %orig;
}
%end

%hook _UIBatteryView
+(CGSize)_batterySizeForIconSize:(long long)arg1{
  if (!showBattery) {
     return CGSizeMake(0, 0);
  }
  return %orig;
}
+(CGSize)_pinSizeForIconSize:(long long)arg1{
  if (!showBattery) {
     return CGSizeMake(0, 0);
  }
  return %orig;
}

%group PercentInBat
- (bool)_currentlyShowsPercentage {
    return YES;
}

- (id)boltLayer {
    return nil;
}

- (void)setBoltMaskLayer:(id)arg1 {
    arg1 = nil;
    %orig;
}
- (void)setBoltLayer:(id)arg1 {
    arg1 = nil;
    %orig;
}

%end
%end

%hook _UIStatusBarData
- (void)setBackNavigationEntry:(id)arg1 {
  if (!showBreadcrumb) {
    return;
  } else {
    %orig;
  }
}
%end

%hook _UIStatusBarCellularItem
-(_UIStatusBarStringView *)serviceNameView {
  _UIStatusBarStringView *orig = %orig;
  orig.isCarrier = YES;
  return orig;
}
-(_UIStatusBarStringView *)networkTypeView {
  _UIStatusBarStringView *orig = %orig;
  orig.isData = YES;

  return orig;
}
%end

%hook _UIStatusBarStringView
%property (nonatomic, assign) BOOL isCarrier;
%property (nonatomic, assign) BOOL isData;

// prevent weird resizes
- (void)setFont:(UIFont*)arg1 {
    if (!(([self.text containsString:@":"] && EnableCustomTimeFormat == YES ) )) {

        //    [self setFont: [UIFont systemFontOfSize:11 weight:UIFontWeightBold]];
        %orig(arg1);
    }
}

-(id)initWithFrame:(CGRect)arg1 {
	%orig;
	self.numberOfLines	= 2;
	self.textAlignment = NSTextAlignmentLeft;
	[NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer*timer) {
		if (isDeviceUnlocked && self && self.window != nil && [self.text containsString: @":"] && EnableCustomTimeFormat == YES) {
			self.adjustsFontSizeToFitWidth = NO;
			self.attributedText = cachedAttributedString;
		}
	}];
	return self;
}


-(void)setText:(id)arg1 {
  %orig;
  if ([arg1 containsString:@":"] && EnableCustomTimeFormat == YES) {
//		self.adjustsFontSizeToFitWidth = NO;
    self.attributedText = cachedAttributedString;
  }
      else {
      %orig(arg1);
    }

 //  if (!enabled) return;

   if (!showTime && [arg1 containsString:@":"]) {
     %orig(@"");
   }

   if (!showCarrier && self.isCarrier && ![arg1 containsString:@":"]) {
     %orig(@"");
   }

   if (!showBatteryPercentSign && [arg1 containsString:@"%"]) {
     NSString* percentageOnly = [arg1 substringToIndex:[arg1 length] - 1];
     %orig(percentageOnly);
   }

   if (!showData && self.isData) {
     %orig(@"");
   }

}


%end



%hook _UIStatusBarCellularSignalView
-(double)_heightForBarAtIndex:(long long)arg1 mode:(long long)arg2 {
  if (!showSignal) {
      return 0;
    } else {
      return %orig;
    }
}
%end

%hook _UIStatusBarWifiSignalView
+(double)_totalWidthForIconSize:(long long)arg1 {
  if (!showWifi) {
    return 0;
  } else {
    return %orig;
  }
}
+(double)_interspaceForIconSize:(long long)arg1 {
  if (!showWifi) {
    return 0;
  } else {
    return %orig;
  }
}
+(double)_barThicknessAtIndex:(unsigned long long)arg1 iconSize:(long long)arg2 {
  if (!showWifi) {
    return 0;
  } else {
    return %orig;
  }
}
%end

// ===== PREFERENCE HANDLING ===== //

static void loadPrefs() {
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.aohuiliu.ipadbar13.plist"];

  if (prefs) {
    EnableiPadStatusBar = ( [prefs objectForKey:@"EnableiPadStatusBar"] ? [[prefs objectForKey:@"EnableiPadStatusBar"] boolValue] : YES );
    extraPadding = ( [prefs objectForKey:@"extraPadding"] ? [[prefs objectForKey:@"extraPadding"] boolValue] : NO );

    showDND = ( [prefs objectForKey:@"showDND"] ? [[prefs objectForKey:@"showDND"] boolValue] : YES );
    showAlarm = ( [prefs objectForKey:@"showAlarm"] ? [[prefs objectForKey:@"showAlarm"] boolValue] : YES );
    showLocationServices = ( [prefs objectForKey:@"showLocationServices"] ? [[prefs objectForKey:@"showLocationServices"] boolValue] : YES );
    showRotationLock = ( [prefs objectForKey:@"showRotationLock"] ? [[prefs objectForKey:@"showRotationLock"] boolValue] : YES );
    showSignal = ( [prefs objectForKey:@"showSignal"] ? [[prefs objectForKey:@"showSignal"] boolValue] : YES );
    showLockIcon = ( [prefs objectForKey:@"showLockIcon"] ? [[prefs objectForKey:@"showLockIcon"] boolValue] : YES );
    showBattery = ( [prefs objectForKey:@"showBattery"] ? [[prefs objectForKey:@"showBattery"] boolValue] : YES );
    showBatteryPercent = ( [prefs objectForKey:@"showBatteryPercent"] ? [[prefs objectForKey:@"showBatteryPercent"] boolValue] : YES );
    showAirplane = ( [prefs objectForKey:@"showAirplane"] ? [[prefs objectForKey:@"showAirplane"] boolValue] : YES );
    showVPN = ( [prefs objectForKey:@"showVPN"] ? [[prefs objectForKey:@"showVPN"] boolValue] : YES );
    showBreadcrumb = ( [prefs objectForKey:@"showBreadcrumb"] ? [[prefs objectForKey:@"showBreadcrumb"] boolValue] : YES );
    showActivity = ( [prefs objectForKey:@"showActivity"] ? [[prefs objectForKey:@"showActivity"] boolValue] : YES );
    showTime = ( [prefs objectForKey:@"showTime"] ? [[prefs objectForKey:@"showTime"] boolValue] : YES );
    showCarrier = ( [prefs objectForKey:@"showCarrier"] ? [[prefs objectForKey:@"showCarrier"] boolValue] : YES );
    showBatteryPercentSign = ( [prefs objectForKey:@"showBatteryPercentSign"] ? [[prefs objectForKey:@"showBatteryPercentSign"] boolValue] : YES );
    showWifi = ( [prefs objectForKey:@"showWifi"] ? [[prefs objectForKey:@"showWifi"] boolValue] : YES );
    showData = ( [prefs objectForKey:@"showData"] ? [[prefs objectForKey:@"showData"] boolValue] : YES );



    lang		= [prefs objectForKey:@"lang"] ?[prefs objectForKey : @"lang"]  : @"en_US";
    EnableCustomTimeFormat = ( [prefs objectForKey:@"EnableCustomTimeFormat"] ? [[prefs objectForKey:@"EnableCustomTimeFormat"] boolValue] : NO );
    TimeFormat1		= [prefs objectForKey:@"TimeFormat1"] ?[prefs objectForKey : @"TimeFormat1"]  : @"h:mm ";
    TimeFormat2		= [prefs objectForKey:@"TimeFormat2"] ?[prefs objectForKey : @"TimeFormat2"]  : @"a ";
//    GestureSwitcher = ( [prefs objectForKey:@"GestureSwitcher"] ? [[prefs objectForKey:@"GestureSwitcher"] boolValue] :  );
    BoldFont1 = ( [prefs objectForKey:@"BoldFont1"] ? [[prefs objectForKey:@"BoldFont1"] boolValue] : NO );
    BoldFont2 = ( [prefs objectForKey:@"BoldFont2"] ? [[prefs objectForKey:@"BoldFont2"] boolValue] : NO );
    BoldFont3 = ( [prefs objectForKey:@"BoldFont3"] ? [[prefs objectForKey:@"BoldFont3"] boolValue] : NO );
    HideBarCC = ( [prefs objectForKey:@"HideBarCC"] ? [[prefs objectForKey:@"HideBarCC"] boolValue] : NO );
    EnableNetspeed = ( [prefs objectForKey:@"EnableNetspeed"] ? [[prefs objectForKey:@"EnableNetspeed"] boolValue] : NO );

    FontSize1	= [prefs valueForKey:@"FontSize1"] ?[[prefs valueForKey : @"FontSize1"] floatValue] : 14.0;
    FontSize2	= [prefs valueForKey:@"FontSize2"] ?[[prefs valueForKey : @"FontSize2"] floatValue] : 11.0;
    FontSize3	= [prefs valueForKey:@"FontSize3"] ?[[prefs valueForKey : @"FontSize3"] floatValue] : 10.0;
    limitbytes	= [prefs valueForKey:@"limitbytes"] ?[[prefs valueForKey : @"limitbytes"] intValue] : 0;

    PercentInBattery = ( [prefs objectForKey:@"PercentInBattery"] ? [[prefs objectForKey:@"PercentInBattery"] boolValue] : NO );
    Fakepencent = ( [prefs objectForKey:@"Fakepencent"] ? [[prefs objectForKey:@"Fakepencent"] boolValue] : NO );
    FakePercentage	= [prefs valueForKey:@"FakePercentage"] ?[[prefs valueForKey : @"FakePercentage"] longValue] : 100;
    speedStyle	= [prefs valueForKey:@"speedStyle"] ?[[prefs valueForKey : @"speedStyle"] longValue] : 0;
    speedUnitValue	= [prefs valueForKey:@"speedUnitValue"] ?[[prefs valueForKey : @"speedUnitValue"] longValue] : 0;



  }

}

static void update() {
  loadPrefs();

  SBStatusBarStateAggregator *stateAggregator = [%c(SBStatusBarStateAggregator) sharedInstance];
  for (int i = 1; i <= 40; i++) {
      [stateAggregator updateStatusBarItem:i];
  }

}

static void initPrefs() {
  // Copy the default preferences file when the actual preference file doesn't exist


  NSString *path = @"/User/Library/Preferences/com.aohuiliu.ipadbar13.plist";
  NSString *pathDefault = @"/Library/PreferenceBundles/iPadBar13.bundle/defaults.plist";
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:path]) {
    [fileManager copyItemAtPath:pathDefault toPath:path error:nil];
  }
}


%ctor {

  @autoreleasepool {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)update, CFSTR("com.aohuiliu.ipadbar13/prefsupdated"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  initPrefs();
  loadPrefs();
if (!fuckkk){
  dateFormatter1 = [[NSDateFormatter alloc] init];
  [dateFormatter1 setDateFormat:TimeFormat1];
  dateFormatter2 = [[NSDateFormatter alloc] init];
  [dateFormatter2 setDateFormat:TimeFormat2];


  if(EnableNetspeed == YES && EnableCustomTimeFormat ==YES){
  if(BoldFont3 == YES) {

    attributes3 = @{ NSFontAttributeName: [UIFont systemFontOfSize:FontSize3 weight:UIFontWeightSemibold] };
  } else

    attributes3 = @{ NSFontAttributeName: [UIFont systemFontOfSize:FontSize3 weight:UIFontWeightMedium] };

  }
  cachedAttributedString = formattedAttributedString();


  [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer* timer) {
  			if (isDeviceUnlocked) {
  				cachedAttributedString = formattedAttributedString();
  			}
  		}];
  if(EnableCustomTimeFormat == YES){

      dateFormatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier:lang];

      dateFormatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:lang];

  if(BoldFont1 == YES) {

    attributes1 = @{ NSFontAttributeName: [UIFont systemFontOfSize:FontSize1 weight:UIFontWeightSemibold] };
  } else {

    attributes1 = @{ NSFontAttributeName: [UIFont systemFontOfSize:FontSize1 weight:UIFontWeightMedium] };

  }
  if(BoldFont2 == YES) {

    attributes2 = @{ NSFontAttributeName: [UIFont systemFontOfSize:FontSize2 weight:UIFontWeightSemibold] };
  } else {
    attributes2 = @{ NSFontAttributeName: [UIFont systemFontOfSize:FontSize2 weight:UIFontWeightMedium] };

  }
}

  if (PercentInBattery == YES) %init(PercentInBat);
  if (Fakepencent == YES) %init(fakepercentGroup);
  if (HideBarCC == YES) %init(hideBarInCC);
  %init(_ungrouped);}
  %init(fuckkkGroup);
}
}
