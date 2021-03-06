//
//  MlNotificationsTableViewController.h
//  MoodLog
//
//  Created by Barry Langdon-Lassagne on 7/15/13.
//  Copyright (c) 2013 Barry A. Langdon-Lassagne.
//  See LICENSE.rtf for full license agreement.
//

#import <UIKit/UIKit.h>

@interface MlNotificationsTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UISwitch *randomReminderSwitch;
@property (weak, nonatomic) IBOutlet UITextField *reminderCount;
@property (weak, nonatomic) IBOutlet UILabel *reminderInitialText;
@property (weak, nonatomic) IBOutlet UIStepper *reminderStepper;
@property (weak, nonatomic) IBOutlet UILabel *reminderQuietHoursText1;
@property (weak, nonatomic) IBOutlet UILabel *reminderQuietHoursText2;
@property (weak, nonatomic) IBOutlet UITextField *reminderMinutesCount;
@property (weak, nonatomic) IBOutlet UIStepper *reminderMinutesStepper;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, assign) NSInteger theNumber;
@property (weak, nonatomic) IBOutlet UILabel *minutesTimerText;
@property (weak, nonatomic) IBOutlet UILabel *timesPerDayText;
@property (weak, nonatomic) IBOutlet UIButton *minutesSetButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonOfDoom;
@property (weak, nonatomic) IBOutlet UIButton *notificationListButton;
@property (weak, nonatomic) IBOutlet UITextView *scheduledNotificationsList;
@property (weak, nonatomic) IBOutlet UIButton *clearAllNotificationsButton;
@property (strong, nonatomic) NSDate *quietStart;
@property (strong, nonatomic) NSDate *quietEnd;
@property (strong, nonatomic) NSDate *remindersTime0;
@property (strong, nonatomic) NSDate *remindersTime1;
@property (strong, nonatomic) NSDate *remindersTime2;
@property (strong, nonatomic) NSDate *remindersTime3;
@property (strong, nonatomic) NSDate *remindersTime4;
@property (strong, nonatomic) NSDate *remindersTime5;
@property (weak, nonatomic) IBOutlet UILabel *reminderTime0Label;
@property (weak, nonatomic) IBOutlet UILabel *reminderTime1Label;
@property (weak, nonatomic) IBOutlet UILabel *reminderTime2Label;
@property (weak, nonatomic) IBOutlet UILabel *reminderTime3Label;
@property (weak, nonatomic) IBOutlet UILabel *reminderTime4Label;
@property (weak, nonatomic) IBOutlet UILabel *reminderTime5Label;
@property (weak, nonatomic) IBOutlet UISwitch *reminderTime0Switch;
@property (weak, nonatomic) IBOutlet UISwitch *reminderTime1Switch;
@property (weak, nonatomic) IBOutlet UISwitch *reminderTime2Switch;
@property (weak, nonatomic) IBOutlet UISwitch *reminderTime3Switch;
@property (weak, nonatomic) IBOutlet UISwitch *reminderTime4Switch;
@property (weak, nonatomic) IBOutlet UISwitch *reminderTime5Switch;

@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *reminderTimeSwitches;

- (IBAction)changeReminderSwitchState:(id)sender;

- (IBAction)changeRandomReminderSwitchState:(id)sender;
- (IBAction)incrementReminders:(id)sender;
- (IBAction)incrementMinuteStepper:(id)sender;
- (IBAction)pressButtonOfDoom:(id)sender;
- (IBAction)pressNotificationListButton:(id)sender;
- (IBAction)pressClearAllNotificationsButton:(id)sender;
- (IBAction)setMinutesTimerButton:(id)sender;
- (IBAction)pressDoneButton:(id)sender;
- (IBAction)pressAddButton:(id)sender;
- (void) setRepeatingDateNotification: (NSDate *)date;
- (void) updateRepeatingDateNotifications;
- (void)cancelNotificationMatchingTime: (NSDate *)date;

@end
