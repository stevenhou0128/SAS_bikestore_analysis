/* Import Data ABC_Bikes Woolywheels*/
proc import datafile="/export/viya/homes/hsing-yu.hou@alumni.uts.edu.au/assignfolder/ABC_Bikes.xlsx"
    dbms=xlsx
	out=ABC_BIKES
	replace;
	sheet="Products";
run;

proc import datafile="/export/viya/homes/hsing-yu.hou@alumni.uts.edu.au/assignfolder/woolyswheels_com_au.xlsx"
    dbms=xlsx
	out=Woolywheels
	replace;
	sheet="Products";
run;

proc contents data=ABC_BIKES;
run;

proc contents data=Woolywheels;
run;

/* Rename the variables name */
data ABC_BIKES_MOD;
    set ABC_BIKES;
    rename 'Product Id'n = Product_id
           'Compare At Price'n = Compare_at_price
           'Product Type'n = Product_type;
run;

data Woolywheels_MOD;
    set Woolywheels;
    rename 'Product Id'n = Product_Id
           'Compare At Price'n = Compare_At_Price
           'Product Type'n = Product_Type;
run;

/*
Create new dataset 
Change Variable Type of Price and Compare_At_Price and label
Create new column: Store
*/
* ABC_Bikes;
data ABC_BIKES_MOD_2;
    set ABC_BIKES_MOD;
    Prices = input(price, 8.1);
    keep Product_Id Name Product_Type Prices Compare_At_Price Vendor;
run;

data ABC_BIKES_MOD_3;
    set ABC_BIKES_MOD_2;
    length Compare_Price $8;
    if Compare_At_Price = 'nan' then Compare_Price = '0';
    else Compare_Price = Compare_At_Price;
    Compare_Prices = input(Compare_Price, 8.1);
    if Compare_Prices = 0 then Compare_Prices = Prices;
    if Product_Type = ' ' then delete;
    Store = 'ABC Bikes';
    format Prices Best. Compare_Prices Best. Store $9.;
    keep Product_Id Name Product_Type Prices Compare_Prices Vendor Store;
    label Prices = 'Price' Compare_Prices = 'Price Before Discount' Store = 'Store';
run;

data ABC_BIKES_MOD_4;
    set ABC_BIKES_MOD_3;
    length Product_Types $17;
    if Product_Type in ( 'Accessories',
    'Administration',
    'Gift Card',
    'Health & Beauty > Massage',
    'Nutrition',
    'Parts',
    'Roasted Coffee',
    'Rubber',
    'Sports & Fitness > Fitness Accessories',
    'Workshop'
    ) then do product_Types = 'Accessories'; end;
    else if Product_Type in ( 'Clothing',
    'Clothing Winter',
    'Shoes'
    ) then do Product_Types = 'Clothes'; end;
    else if Product_Type = 'Helmets' then do Product_Types = 'Helmets'; end;
    else do Product_Types = 'Bikes'; end;
    format Product_Types $17.;
    keep Product_Id Name Product_Types Prices Compare_Prices Vendor Store;
    label Product_Types = 'Product Types';
run;

proc contents data=ABC_BIKES_MOD_4;
run;

*Woolywheels;
data Woolywheels_MOD_2;
    set Woolywheels_MOD;
    Prices = input(Price, 8.1);
    format prices Best.;
    keep Product_Id Name Product_Type Prices Compare_At_Price Vendor;
    label Prices = 'Price';
run;

data Woolywheels_MOD_3;
    set Woolywheels_MOD_2;
    length Compare_Price $8;
    if Compare_At_Price = 'nan' then Compare_Price = '0';
    else Compare_Price = Compare_At_Price;
    Compare_Prices = input(Compare_Price, 8.1);
    if Compare_Prices = 0 then Compare_Prices = Prices;
    if Vendor = '100%' then Vendor = '100 Percent';
    Store = 'Woolywheels';
    if Vendor in ('Specialized Bicycles', 'Specialized') then Vendor = 'Specialized';
    if Vendor in ('Wooly’s Wheels', 'Woolys Wheels', 'woolyswheels.com.au') then Vendor = 'Woolys Wheels';
    else if Vendor in ('Giant', 'Giant Bicycles', 'Giant-Liv') then Vendor = 'Giant';
    format Compare_Prices Best. Store $11.;
    keep Product_Id Name Product_Type Prices Compare_Prices Vendor Store;
    label Prices = 'Price' Compare_Prices = 'Price Before Discount' Store = 'Store';
run;

data Woolywheels_MOD_4;
    set Woolywheels_MOD_3;
    length Product_Types $17;
    if Product_Type in ('Adventure & Gravel Bikes',
    'Childrens Bikes & Scooters',
    'E-Bikes',
    'Fitness and Urban Bikes',
    'Mountain Bikes',
    'Road Bike',
    'Road-Bike',
    'Scooters') then do Product_Types = 'Bikes'; end;
    else if Product_Type in ('Cycling Shoes', 
    'Cycling Socks', 
    'Jacket', 
    'Jersey - MTB', 
    'Jersey - Road',
    'Knicks, Shorts, Tights',
    'Shoe Covers',
    'Short',
    'T-SHIRT',
    'Vests & Jackets',
    'Warmers & Base Layers') then do Product_Types = 'Clothes'; end;
    else if Product_Type = 'Helmets' then do Product_Types = 'Helmets'; end;
    else do Product_Types = 'Accessories'; end;
    format Product_Types $17.;
    keep Product_Id Name Product_Types Prices Compare_Prices Vendor Store;
    label Product_Types = 'Product Types';
run;

proc contents data=Woolywheels_MOD_4;
run;

/* Remove Duplicate */
proc sort data=ABC_BIKES_MOD_4 out=ABC_BIKES_MOD_4_sorted
    dupout=ABC_BIKES_MOD_4_dup
    nodupkey
    ;
    by Name;
run;

proc sort data=Woolywheels_MOD_4 out=Woolywheels_MOD_4_sorted
    dupout=Woolywheels_MOD_4_dup
    nodupkey
    ;
    by Name;
run;

/* Concatenate Datasets */
data Bikes_Stores;
    length Name $113 Store $11;
    set ABC_BIKES_MOD_4_sorted Woolywheels_MOD_4_sorted;
    if Compare_Prices = Prices then do Discount = 0; 
    end;
    else do Discount = (Prices / Compare_Prices);
    end;
    format Name $113. Store $11. Discount percent.;
    label Name = 'Product Name' Discount = 'Discount(%)';
    keep Product_Id Name Product_Types Prices Compare_Prices Vendor Store Discount;
run;

data Bikes_Stores;
    set Bikes_Stores;
    rename Compare_Prices = Original_Prices;
run;

proc contents data=Bikes_Stores;
run;


/* pdf report */
ods pdf file="/export/viya/homes/hsing-yu.hou@alumni.uts.edu.au/assignfolder/bike_stores_analysis_report.pdf" style=HTMLBlue;
ods noproctitle;

title 'Data analysis and reporting';
title2 'Procuct from the ABC Bikes and Woolywheels.';
proc print data=Bikes_Stores(obs=10) label;
footnote 'Sample of 10 observations';
run;

title 'The frequency of each product types in two stores';
footnote;
proc freq data=Bikes_Stores;
    table Store * Product_Types / nocol nopercent norow;
run;

title 'Average prices of four types of product in ABC Bikes and Woolywheels';
title2 'Types include Accessories, Bikes, Helmets, and Clothes';
footnote;
proc means data=Bikes_Stores;
    var Prices;
    class Product_Types Store;
run;

title 'Average Prices of Accessories and Clothes of own brands';
footnote 'ABC Bikes and Woolywheels have their own brands';
proc means data=Bikes_Stores;
    var Prices;
    class Product_Types Vendor;
    where Vendor in ('Woolys Wheels', 'ABC Bikes');
run;

title 'Average prices of bikes of each brand in two stores';
footnote;
proc means data=Bikes_Stores mean;
    var Prices;
    class Store vendor;
    where Product_Types = 'Bikes';
run;

title'The number of bikes of each brand in two stores';
footnote 'Compared to the ABC Bikes, there are less vendors in Woolywheels';
ods graphics / reset width=7.6 in height=4.8in imagemap;
proc sgplot data=WORK.BIKES_STORES (where=(Product_Types='Bikes'));
	vbar Vendor / group=Store groupdisplay=cluster;
	xaxis display=(nolabel);
	yaxis grid;
run;
ods graphics / reset;

title 'Compare the prices of Giant Bikes in two stores';
footnote 'The Mean and Median of Giant Bikes in ABC Bikes are higher than those in Woolywheels';
ods graphics / reset width=6.4in height=4.8in imagemap;
proc sgplot data=WORK.BIKES_STORES (where=(Vendor='Giant'and Product_Types='Bikes'));
	vbox Prices / category=Vendor group=Store;
	yaxis grid;
run;


title 'Compare Prices of Bikes except Giant in two Stores';
footnote 'The Mean and Median of Woolywheels are higher than ABC Bikes';
proc sgplot data=WORK.BIKES_STORES (where=(Product_Types='Bikes' and Vendor <> 'Giant'));
	vbox Prices / category=Product_Types group=Store;
	yaxis grid;
run;
ods graphics / reset;


ods pdf close;


proc export data=Bikes_Stores
    outfile="/export/viya/homes/hsing-yu.hou@alumni.uts.edu.au/assignfolder/Bikes_Stores.xlsx"
    dbms=xlsx
    replace;
run;

