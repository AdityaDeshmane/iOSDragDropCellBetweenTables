iOSDragDropCellBetweenTables
============================

![      ](/iOSDragDropBetweenTables.gif "")


## Features :
>
* Drag cell from one table and drop to another table.
>
* Rearrange cells within table.
>

## About 

This is single view application, you can use code as it is just by setting outlets of your two tables and setting cell identifier (Application is using string array to populate data in tables few modifation will let you use whichever data you want)
<li>Basic idea/logic behid this source : </li>

<li>1. Find source indexpath of cell from drag start point in source table.</li>

<li>2. Save data related to cell at source indexpath.</li>

<li>3. Remove that cell.</li>

<li>4. Create cell view to drag around by using saved data.</li>

<li>5. From drop point find destination indexpath, point could be in same or different table.</li>

<li>6. Add new cell by using saved data at destination indexpath.</li>


## Other Info : 


<li>Works from iOS 6 to 11

<li>Uses ARC : Yes </li>

<li> Requires storybord/xib ? : You just need outlets of UItableViews (works on both)</li>




