//
//  MlChartCollectionViewController.m
//  MoodLog
//
//  Created by Barry A. Langdon-Lassagne on 2/21/13.
//  Copyright (c) 2013 Barry A. Langdon-Lassagne. All rights reserved.
//

#import "MlChartCollectionViewController.h"
#import "MlChartCollectionViewCell.h"
#import "MoodLogEvents.h"
#import "Emotions.h"

CGSize cellSize;
NSUInteger labelLines;
NSUInteger bottomLabelHeight = 50.0; // Height of view at bottom of CollectionViewCells (date labels are there)

@interface MlChartCollectionViewController ()

@end

@implementation MlChartCollectionViewController

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
    if (!self.cellIdentifier) {
        self.cellIdentifier = @"chartCellPortrait";
    }
//    NSLog(@"viewDidLoad, collectionView: %@", self.collectionView);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear, collectionView: %@", self.collectionView);
    UIInterfaceOrientation *orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self setCellTypeAndSize:orientation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"viewDidAppear, collectionView: %@", self.collectionView);
    // On first load, go to the end of the CollectionView (most recent)
    NSUInteger lastSection = [[self.fetchedResultsController sections] count] - 1;
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.collectionView numberOfItemsInSection:lastSection] - 1) inSection:lastSection];
    [self.collectionView scrollToItemAtIndexPath:scrollIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCollectionView:nil];
    [self setManagedObjectContext:nil];
    [self setFetchedResultsController:nil];
    [super viewDidUnload];
}

- (void) setCellTypeAndSize: (UIInterfaceOrientation)toInterfaceOrientation {
    if (toInterfaceOrientation == UIDeviceOrientationPortrait || toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //portrait
        self.cellIdentifier = @"chartCellPortrait";
        cellSize = CGSizeMake(92.0,508.0);
        labelLines = 35;
    }
    else {
        //landscape
        self.cellIdentifier = @"chartCell";
        cellSize = CGSizeMake(92.0,260.0);
        labelLines = 15;
    }
    [self.collectionView reloadData];
}

#pragma mark - Orientation change
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self setCellTypeAndSize:toInterfaceOrientation];
}

#pragma mark - Delegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    //    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    //    return [sectionInfo numberOfObjects];
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return cellSize; // set when orientation changes
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    MlChartCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MoodLogEvents" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"header" cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)configureCell:(MlChartCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    MoodLogEvents *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDate *today = [object valueForKey:@"date"];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
    NSInteger day = [weekdayComponents day];
    
    static NSArray *dayNames = nil;
    if (!dayNames) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setCalendar:[NSCalendar currentCalendar]];
        dayNames = [formatter weekdaySymbols];
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"h:mm a";
    
    cell.timeLabel.text = [dateFormatter stringFromDate: today];
    dateFormatter.dateFormat = @"MMMM yyyy";
    cell.monthLabel.text = [dateFormatter stringFromDate: today];

    cell.dateLabel.text = [NSString stringWithFormat:@"%d", day];
    
    // Fetch the Mood list for this journal entry
    NSSet *emotionsforEntry = object.relationshipEmotions; // Get all the emotions for this record
    NSPredicate *myFilter = [NSPredicate predicateWithFormat:@"selected == %@", [NSNumber numberWithBool: YES]];
    NSArray *emotionArray = [[[emotionsforEntry filteredSetUsingPredicate:myFilter] allObjects] sortedArrayUsingSelector:@selector(compare:)];
    NSString *selectedEms = [[NSString alloc] init];
    NSString *lastEm = [[NSString alloc] init];
    NSUInteger blankLines = labelLines - MIN([emotionArray count], labelLines); // Label in collectionview is labelLines lines tall
    
    if ([emotionArray count] > 0) {
        NSMutableArray *mutableEmotionArray = [NSMutableArray arrayWithArray:emotionArray];
        // Treat the last emotion as special (preface with 'and' and end with '.')
        if ([mutableEmotionArray count] > 0) {
            lastEm = [NSString stringWithFormat:@"%@", [((Emotions *)[mutableEmotionArray objectAtIndex:[mutableEmotionArray count] - 1]).name lowercaseString]];
            [mutableEmotionArray removeObjectAtIndex:[mutableEmotionArray count] - 1];
        }
        for (id emotion in mutableEmotionArray) {
            selectedEms = [selectedEms stringByAppendingFormat:@"%@\n", [((Emotions *)emotion).name lowercaseString]];
        }
    }
    NSString *displayString = [[NSString alloc] init];
    for (int i=0;i<blankLines;i++) {
        displayString = [displayString stringByAppendingString:@"\n"];
    }
    if (emotionArray) {
        displayString = [displayString stringByAppendingFormat:@"%@%@", selectedEms, lastEm];
    }
    cell.emotionsLabel.text = displayString;
    CGFloat height = (arc4random() % 20) - 10.0;
    cell.chartHeightLabel.text = [NSString stringWithFormat:@"%2.0f", height];
    [cell.chartDrawingView setChartHeight:height];
    [cell.chartDrawingView setNeedsDisplay]; // without this, the bars don't match the data
}

@end