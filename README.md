iOSDragDropCellBetweenTables
============================

![      ](\cellTransferImg.png "")


>
Features :
>
* Lets you drag cell from one table and drop that cell to another table.
>
* You can drag drop cell from table ONE to table TWO and vice versa.
>
* Reordering of cells within same table.

##About 

>This is single view application, you can use code as it is just by setting outlets of your two tables and setting cell identifier (Application is using string array to populate data in tables few modifation will let you use whichever data you want)
<li>Basic idea/logic behid this source : </li>

><li>1. Find source indexpath of cell from drag point in source table.</li>

><li>2. Save data related to cell at source indexpath.</li>

><li>3. Remove that cell.</li>

><li>4. Create cell view to drag around by using saved data.</li>

><li>5. From drop point find destination indexpath, point could be in same or different table.</li>



><li>6. Add new cell by using saved data at destination indexpath.</li>


## Where you can use it ?

>You can use it for UITableViews but with few modifications this code can be used for UICollectionView also.


How to use it?
-------------

>

>
* Download project and go thro files, comments are added wherever necessary..

>
* This is just reference project not custom control.

##Other Info : 


><li>Works for : iOS 6, 7 and 8 (will work on lower also but not tested)</li>

><li>Uses ARC : Yes </li>

><li>Xcode : 4 to 6 (Developed using 5.1.1) </li>

><li>Base SDK : 7.0 works fine on 6.0 to 8.0 also </li>



><li> Requires storybord/xib ? : You just need outlets of UItableViews (works on both)</li>




