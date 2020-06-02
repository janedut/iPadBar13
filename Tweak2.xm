#import "Tweak.h"
static BOOL BoldPer;
static BOOL EnableCustomCarrier;
static CGFloat PerSize;

static CGFloat DataSize;
static CGFloat CarSize;
static BOOL BoldCar;
static BOOL BoldData;
static NSString *CarText;
static NSString *DataText;

// change isCarrier

%group CustomCarrier
%hook _UIStatusBarDataCellularEntry
- (void)setString:(id)arg1 {
    arg1 = CarText;
    %orig;
}
%end
%end


%hook _UIStatusBarStringView

// prevent weird resizes
- (void)setFont:(UIFont*)arg1 {
    if (!([self.text containsString:@"%"] || ([self.text containsString:CarText] && EnableCustomCarrier == YES) || [self.text containsString:DataText])) {

        %orig(arg1);
    }
}




-(void)setText:(id)arg1 {
//    %orig;
    if ([arg1 containsString:CarText] && EnableCustomCarrier == YES) {
      if (BoldCar) [self setFont: [UIFont systemFontOfSize:CarSize weight:UIFontWeightSemibold]];
      else [self setFont: [UIFont systemFontOfSize:CarSize weight:UIFontWeightMedium]];
        %orig(CarText);
      }

    else if ([arg1 containsString:@"4G"] || [arg1 containsString:@"LTE"]) {
      if (BoldData) [self setFont: [UIFont systemFontOfSize:DataSize weight:UIFontWeightSemibold]];
      else [self setFont: [UIFont systemFontOfSize:DataSize weight:UIFontWeightMedium]];
        %orig(DataText);

      }
    else if ([arg1 containsString:@"%"]) {
      if (BoldPer) [self setFont: [UIFont systemFontOfSize:PerSize weight:UIFontWeightSemibold]];
      else [self setFont: [UIFont systemFontOfSize:PerSize weight:UIFontWeightMedium]];
        %orig(arg1);
//    self.attributedText = formattedAttributedString1();
      }

    else {
        %orig(arg1);
      }

  }


%end



static void loadPrefs() {
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.aohuiliu.ipadbar13.plist"];

  if (prefs) {

    EnableCustomCarrier = ( [prefs objectForKey:@"EnableCustomCarrier"] ? [[prefs objectForKey:@"EnableCustomCarrier"] boolValue] : NO );
    CarText		= [prefs objectForKey:@"CarText"] ?[prefs objectForKey : @"CarText"]  : @"iPadbar13";
    DataText		= [prefs objectForKey:@"DataText"] ?[prefs objectForKey : @"DataText"]  : @"10G";
    BoldCar = ( [prefs objectForKey:@"BoldCar"] ? [[prefs objectForKey:@"BoldCar"] boolValue] : NO );
    BoldData = ( [prefs objectForKey:@"BoldData"] ? [[prefs objectForKey:@"BoldData"] boolValue] : NO );
    CarSize	= [prefs valueForKey:@"CarSize"] ?[[prefs valueForKey : @"CarSize"] floatValue] : 12.0;
    DataSize	= [prefs valueForKey:@"DataSize"] ?[[prefs valueForKey : @"DataSize"] floatValue] : 12.0;
    PerSize	= [prefs valueForKey:@"PerSize"] ?[[prefs valueForKey : @"PerSize"] floatValue] : 12.0;
    BoldPer = ( [prefs objectForKey:@"BoldPer"] ? [[prefs objectForKey:@"BoldPer"] boolValue] : NO );


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


  if(EnableCustomCarrier == YES) {
    %init(CustomCarrier);
    }

    %init(_ungrouped);
  }
}
