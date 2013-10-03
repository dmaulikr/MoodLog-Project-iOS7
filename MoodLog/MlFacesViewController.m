//
//  MlFacesViewController.m
//  MoodLog
//
//  Created by Barry A. Langdon-Lassagne on 2/5/13.
//  Copyright (c) 2013 Barry A. Langdon-Lassagne. All rights reserved.
//

#import "MlFacesViewController.h"
#import "Prefs.h"

@interface MlFacesViewController ()

@end

@implementation MlFacesViewController


static short GROUP_SORT = 0;
static short AZ_SORT = 1;
static short SHUFFLE_SORT = 2;

NSUserDefaults *defaults;

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
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    defaults = [NSUserDefaults standardUserDefaults];
    [self setSelectedSortStyleSegment]; // Highlight the segment to show the current sort style
    [self setFaces:[self.detailItem.showFacesEditing boolValue]];
    [self setFacesColors:self.myMoodCollectionViewController.showColorsOnEmotions];
    self.detailItem.editing = [NSNumber numberWithBool:YES];
    // [self saveContext];
    self.fewerMoreSlider.value = (CGFloat)[defaults integerForKey:@"DefaultParrotLevel"];
    [self adjustUIToNewParrotLevel:[defaults integerForKey:@"DefaultParrotLevel"]];
    [self.myMoodCollectionViewController refresh];
}

- (void) viewWillDisappear:(BOOL)animated {
    self.detailItem.editing = [NSNumber numberWithBool:NO];
    [self saveContext];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MoodCollectionSegue2"]) {
        self.myMoodCollectionViewController = [segue destinationViewController]; // Getting a reference to the collection view
        ((MlMoodCollectionViewController *)[segue destinationViewController]).detailItem = self.detailItem;
    }
}

- (IBAction)sortABC:(id)sender {
    self.detailItem.sortStyleEditing = alphabeticalSort;
    [self saveContext];
    [self setSelectedSortStyleSegment];
    [self.myMoodCollectionViewController refresh];
}

- (IBAction)sortGroup:(id)sender {
    self.detailItem.sortStyleEditing = groupSort;
    [self saveContext];
    [self setSelectedSortStyleSegment];
    [self.myMoodCollectionViewController refresh];
}

- (IBAction)sortCBA:(id)sender {
    self.detailItem.sortStyleEditing = reverseAlphabeticalSort;
    [self saveContext];
    [self setSelectedSortStyleSegment];
    [self.myMoodCollectionViewController refresh];
}

- (IBAction)sortShuffle:(id)sender {
    self.detailItem.sortStyleEditing = shuffleSort;
    [self saveContext];
    [self setSelectedSortStyleSegment];
    [self.myMoodCollectionViewController refresh];
}

- (void) setSelectedSortStyleSegment {
    NSString *sortStyle = self.detailItem.sortStyleEditing;
    if ([sortStyle isEqualToString:groupSort]) {
        [self.sortStyleSegmentedControl setSelectedSegmentIndex:GROUP_SORT];
    }
    else if ([sortStyle isEqualToString:alphabeticalSort]) {
        [self.sortStyleSegmentedControl setSelectedSegmentIndex:AZ_SORT];
    }
    else if ([sortStyle isEqualToString:reverseAlphabeticalSort]) {
        [self.sortStyleSegmentedControl setSelectedSegmentIndex:AZ_SORT];
    }
    else if ([sortStyle isEqualToString:shuffleSort]) {
        [self.sortStyleSegmentedControl setSelectedSegmentIndex:SHUFFLE_SORT];
    }
    [defaults setObject:sortStyle forKey:@"DefaultSortStyleEditing"];
    [defaults synchronize];
}

- (IBAction)selectSegmentForSortStyle:(id)sender {
    NSString *sortStyle;
    if(self.sortStyleSegmentedControl.selectedSegmentIndex == GROUP_SORT) {
        sortStyle = groupSort;
    }
    else if (self.sortStyleSegmentedControl.selectedSegmentIndex == AZ_SORT) {        sortStyle = alphabeticalSort;
    }
    else if (self.sortStyleSegmentedControl.selectedSegmentIndex == SHUFFLE_SORT) {
        sortStyle = shuffleSort;
    }
    else {
        // there is no fourth option
    }
    self.detailItem.sortStyleEditing = sortStyle;
    [defaults setObject:sortStyle forKey:@"DefaultSortStyleEditing"];
    [defaults synchronize];
    [self.myMoodCollectionViewController refresh];
}

- (IBAction)toggleFaces:(id)sender {
    Boolean facesState = ![self.detailItem.showFacesEditing boolValue];
    [self setFaces:facesState];
    [defaults setBool:facesState forKey:@"DefaultFacesEditingState"];
    [defaults synchronize];
    
}

- (IBAction)toggleColors:(id)sender {
    self.myMoodCollectionViewController.showColorsOnEmotions =!self.myMoodCollectionViewController.showColorsOnEmotions;
    [self setFacesColors:self.myMoodCollectionViewController.showColorsOnEmotions];
    [defaults setBool:self.myMoodCollectionViewController.showColorsOnEmotions forKey:@"DefaultFacesColorState"];
    [defaults synchronize];
}

- (IBAction)slideFewerMoreSlider:(id)sender {
    static float lastValue = 2.0f;
    int discreteValue = roundl([self.fewerMoreSlider value]);
    // [self.fewerMoreSlider setValue:(float)discreteValue]; // Set this if you want the slider to jump between discrete values
    if (discreteValue != lastValue) {
        lastValue = discreteValue;
        [self adjustUIToNewParrotLevel: discreteValue];
   }
}

- (IBAction)finishedSlidingFewerMoreSlider:(id)sender {
    int discreteValue = roundl([self.fewerMoreSlider value]);
    [self.fewerMoreSlider setValue:(float)discreteValue];
}

- (IBAction)setFewer:(id)sender {
    if (self.fewerMoreSlider.value > 1.0f) {
        [self.fewerMoreSlider setValue:(self.fewerMoreSlider.value - 1.0f)];
    }
    // Calling workaroundAdjustUIToNewParrotLevel with a delay works around a bug in iOS 6 where the buttons aren't going gray/disabled after being clicked
    // I don't need to use a delay in iOS 7; I can just call adjustUIToNewParrotLevel:parrotLevel directly
    [self performSelector:@selector(workaroundAdjustUIToNewParrotLevel:) withObject:self afterDelay:0.1 ];
}

- (IBAction)setMore:(id)sender {
    if (self.fewerMoreSlider.value < 4.0f) {
        [self.fewerMoreSlider setValue:(self.fewerMoreSlider.value + 1.0f)];
    }
    // Calling workaroundAdjustUIToNewParrotLevel with a delay works around a bug in iOS 6 where the buttons aren't going gray/disabled after being clicked
    // I don't need to use a delay in iOS 7; I can just call adjustUIToNewParrotLevel:parrotLevel directly
    [self performSelector:@selector(workaroundAdjustUIToNewParrotLevel:) withObject:self afterDelay:0.1 ];
}

- (void)workaroundAdjustUIToNewParrotLevel: (id) sender {
    [self adjustUIToNewParrotLevel:roundl(self.fewerMoreSlider.value)];
}

- (void)adjustUIToNewParrotLevel: (int) parrotLevel {
    [defaults setInteger:parrotLevel forKey:@"DefaultParrotLevel"];
    self.myMoodCollectionViewController.currentParrotLevel = parrotLevel;
    if (parrotLevel == 1) {
        [self.fewerButton setEnabled:NO];
        self.fewerButton.titleLabel.textColor = [UIColor grayColor];
        [self.moreButton setEnabled:YES];
        self.moreButton.titleLabel.textColor = [UIColor blackColor];
    }
    else if (parrotLevel == 4) {
        [self.fewerButton setEnabled:YES];
        self.fewerButton.titleLabel.textColor = [UIColor blackColor];
        [self.moreButton setEnabled:NO];
        self.moreButton.titleLabel.textColor = [UIColor grayColor];
    }
    else {
        [self.fewerButton setEnabled:YES];
        self.fewerButton.titleLabel.textColor = [UIColor blackColor];
       [self.moreButton setEnabled:YES];
        self.moreButton.titleLabel.textColor = [UIColor blackColor];
    }
    [self.myMoodCollectionViewController refresh];
}

- (void) setFaces:(BOOL)facesState {
    if (facesState == YES) {
        self.myMoodCollectionViewController.cellIdentifier = @"moodCellFaces";
    }
    else {
        self.myMoodCollectionViewController.cellIdentifier = @"moodCell";
    }
    self.detailItem.showFacesEditing = [NSNumber numberWithBool:facesState]; // Save state in database
    [self.toggleFacesButton setSelected:facesState];
    // [self saveContext];
    [self.myMoodCollectionViewController refresh];
}

- (void) setFacesColors:(BOOL)faceColorsState {
    [self.toggleColorsButton setSelected:faceColorsState];
    [self.myMoodCollectionViewController refresh];
}

- (void) saveContext { // Save data to the database
    // Save the context.
    NSError *error = nil;
    if (![[self.detailItem managedObjectContext] save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSortGroupButton:nil];
    [super viewDidUnload];
}
@end
