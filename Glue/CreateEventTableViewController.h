//
//  CreateEventTableViewController.h
//  Glue
//
//  Created by Pietro Rea on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateEventTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

// These properties are only used for Event Editing
@property (weak, nonatomic) NSString *eventName;
@property (weak, nonatomic) NSString *eventCategory;
@property (weak, nonatomic) NSString *eventLocation;
@property (weak, nonatomic) NSString *eventStartTime;
@property (weak, nonatomic) NSString *eventEndTime;
@property (weak, nonatomic) NSString *eventDescription;
@property (weak, nonatomic) NSDictionary *currentEventGuestList;
@property (weak, nonatomic) NSString *previousViewController;


@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventCategoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventStartTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventEndTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventDescriptionTextField;

//Properties for category picker and time picker
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *startTimeDatePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *endTimeDatePicker;
@property (strong, nonatomic) IBOutlet NSDateFormatter *dateFormatter;

- (IBAction)cancelCreateEventButtonPressed:(id)sender;

@end
