//
//  ADViewController.m
//  DragDropCellsBetweenTable
//
//  Created by Aditya Deshmane on 04/10/14.
//  Copyright (c) 2014 Aditya Deshmane. All rights reserved.
//

#import "ADViewController.h"

#define CELL_ID @"DragDropTableCell"

@interface ADViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
{
    //Private Vars
    UITableViewCell*    _cellDragged;
    NSMutableArray*     _arrDataTableONE;
    NSMutableArray*     _arrDataTableTWO;
    id                  _draggedData;
    BOOL            _bIsDraggedFromTableONE;
    NSIndexPath*    _indexPathDraggedCell;
}

//Outlets
@property (strong, nonatomic) IBOutlet UITableView *tableViewONE;
@property (strong, nonatomic) IBOutlet UITableView *tableViewTWO;

//Private Methods
- (void)setupUI;
- (void)setupData;

- (void)initDraggedCellWithCell:(UITableViewCell*)cell AtPoint:(CGPoint)point;
- (void)draggingStarted:(UIPanGestureRecognizer *)gestureRecognizer;

- (void)doDrag:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)stopDragging:(UIPanGestureRecognizer *)gestureRecognizer;

- (UITableViewCell*)configureCellForTableONEAtIndexPath:(NSIndexPath*)indexPath;
- (UITableViewCell*)configureCellForTableTWOAtIndexPath:(NSIndexPath*)indexPath;

@end

@implementation ADViewController

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupUI];
    [self setupData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Initialization methods

- (void)setupUI
{
    //table ONE
    _tableViewONE.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _tableViewONE.layer.borderWidth = 2.0;
    
    //table TWO
    _tableViewTWO.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tableViewTWO.layer.borderWidth = 2.0;
    
    //pan gesture
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)setupData
{
    _arrDataTableONE = [[NSMutableArray alloc] initWithObjects:@"item0", @"item1", @"item2", @"item3", @"item4", nil];
    _arrDataTableTWO = [[NSMutableArray alloc] initWithObjects:@"item5", @"item6", nil];
    
    _cellDragged = nil;
    _draggedData = nil;
    _indexPathDraggedCell = nil;
}

#pragma mark -
#pragma mark UIGestureRecognizer

- (void)handlePanning:(UIPanGestureRecognizer *)gestureRecognizer
{
    switch ([gestureRecognizer state])
    {
        case UIGestureRecognizerStateBegan:
            [self draggingStarted:gestureRecognizer];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self doDrag:gestureRecognizer];
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self stopDragging:gestureRecognizer];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark Dragginhg handling

- (void)draggingStarted:(UIPanGestureRecognizer *)gestureRecognizer
{
    //1. By default it is assumed that point is inside table ONE
    _bIsDraggedFromTableONE = YES;
    UITableView *table = _tableViewONE;
    NSMutableArray *arrDataSource = _arrDataTableONE;
    CGPoint point = [gestureRecognizer locationInView:_tableViewONE];
    
    //2. Update variables if point is inside table TWO
    CGPoint pointInDst = [gestureRecognizer locationInView:_tableViewTWO];
    if([_tableViewTWO pointInside:pointInDst withEvent:nil])
    {
        _bIsDraggedFromTableONE = NO;
        table = _tableViewTWO;
        arrDataSource = _arrDataTableTWO;
        point = pointInDst;
    }
    
    //3. Create cellView to drag around
    NSIndexPath* indexPath = [table indexPathForRowAtPoint:point];
    UITableViewCell* cell = [table cellForRowAtIndexPath:indexPath];
    
    if(cell)
    {
        CGPoint origin = cell.frame.origin;
        origin.x += table.frame.origin.x;
        origin.y += table.frame.origin.y;
        [self initDraggedCellWithCell:cell AtPoint:origin];
        cell.highlighted = NO;
    }
    
    //4. set _draggedData, set _indexPathDraggedCell
    if(cell)
    {
        _draggedData = [arrDataSource objectAtIndex:indexPath.row] ;
        _indexPathDraggedCell = indexPath ;
    }
    
    //5. Remove cell from souce table
    if(cell)
    {
        [arrDataSource removeObjectAtIndex:indexPath.row];
        [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

- (void)initDraggedCellWithCell:(UITableViewCell*)cell AtPoint:(CGPoint)point
{
    // get rid of old cell, if it wasn't disposed already
    if(_cellDragged != nil)
    {
        [_cellDragged removeFromSuperview];
        _cellDragged = nil;
    }
    
    CGRect frame = CGRectMake(point.x, point.y, cell.frame.size.width, cell.frame.size.height);
    
    _cellDragged = [[UITableViewCell alloc] init];
    _cellDragged.selectionStyle = UITableViewCellSelectionStyleGray;
    _cellDragged.textLabel.text = cell.textLabel.text;
    _cellDragged.textLabel.textColor = cell.textLabel.textColor;
    _cellDragged.highlighted = YES;
    _cellDragged.frame = frame;
    _cellDragged.alpha = 0.8;
    
    [self.view addSubview:_cellDragged];
}


- (void)doDrag:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(_cellDragged != nil && _draggedData != nil)
    {
        //Keep cell's center at current drag point
        CGPoint translation = [gestureRecognizer translationInView:[_cellDragged superview]];
        [_cellDragged setCenter:CGPointMake([_cellDragged center].x + translation.x,
                                           [_cellDragged center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[_cellDragged superview]];
    }
}

- (void)stopDragging:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(_cellDragged != nil && _draggedData != nil)
    {
        if([gestureRecognizer state] == UIGestureRecognizerStateEnded)
        {
            //1. set default drop area as table ONE
            BOOL bIsDropAreaTableONE = YES;
            UITableView *table = _tableViewONE;
            NSMutableArray *arrData = _arrDataTableONE;
            
            //2. check if drop area is table TWO
            if((_bIsDraggedFromTableONE && [_tableViewTWO pointInside:[gestureRecognizer locationInView:_tableViewTWO] withEvent:nil]) ||
               
               (_bIsDraggedFromTableONE == NO && [_tableViewONE pointInside:[gestureRecognizer locationInView:_tableViewONE] withEvent:nil] == NO))
            {
                bIsDropAreaTableONE = NO;
            }
         
            //3. if bIsDropAreaTableONE chagne drop area to destination table
            if (bIsDropAreaTableONE == NO)
            {
                table = _tableViewTWO;
                arrData = _arrDataTableTWO;
            }
         
            //4. Add cell to drop area table
            NSIndexPath* indexPath = [table indexPathForRowAtPoint:[gestureRecognizer locationInView:table]];
            if(indexPath != nil)//drop area is between cell
            {
                [arrData insertObject:_draggedData atIndex:indexPath.row];
                [table insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            }
            else//drop area is not between cell add cell at end
            {
                [arrData addObject:_draggedData];
                [table reloadData];
            }
        }
        
        //remove cell view used to drag around
        [_cellDragged removeFromSuperview];
        _cellDragged = nil;
        _draggedData = nil;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource delegate methods

- (BOOL)tableView:(UITableView*)tableView canMoveRowAtIndexPath:(NSIndexPath*)indexPath
{
    // Disable default reordering functionality
    return NO;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    
    if([tableView isEqual:_tableViewONE])
    {
        count = [_arrDataTableONE count];
    }
    else if([tableView isEqual:_tableViewTWO])
    {
        count = [_arrDataTableTWO count];
    }
    
    return count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* result = nil;
    
    if([tableView isEqual:_tableViewONE])
    {
        result = [self configureCellForTableONEAtIndexPath:indexPath];
    }
    else if([tableView isEqual:_tableViewTWO])
    {
        result = [self configureCellForTableTWOAtIndexPath:indexPath];
    }
    
    return result;
}

#pragma mark -
#pragma mark Table cells configure

- (UITableViewCell*)configureCellForTableONEAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [_tableViewONE dequeueReusableCellWithIdentifier:CELL_ID];
    cell.textLabel.text = [[_arrDataTableONE objectAtIndex:indexPath.row] description];
    return cell;
}

- (UITableViewCell*)configureCellForTableTWOAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [_tableViewTWO dequeueReusableCellWithIdentifier:CELL_ID];
    cell.textLabel.text = [[_arrDataTableTWO objectAtIndex:indexPath.row] description];
    return cell;
}

@end
