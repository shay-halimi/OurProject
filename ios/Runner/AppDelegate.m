#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSString *filePath;

    #ifdef DEBUG
      NSLog(@"[ --------- Development mode --------- ]");
      [GMSServices provideAPIKey:@"AIzaSyAU2f_IHncdwreMxEpAWq_35TL9WHkbTxY"];
      filePath = [[NSBundle mainBundle] pathForResource:@"GoogleService-Info" ofType:@"plist" inDirectory:@"Debug"];
    #else
      NSLog(@"[ ********* PRODUCTION MODE ********* ]");
      [GMSServices provideAPIKey:@"AIzaSyCoYKtXYQumrk-z30YDxIvrFWLHKMedARM"];
      filePath = [[NSBundle mainBundle] pathForResource:@"GoogleService-Info" ofType:@"plist" inDirectory:@"Release"];
    #endif

    FIROptions *options = [[FIROptions alloc] initWithContentsOfFile:filePath];
    [FIRApp configureWithOptions:options];


  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end