

set identity_insert sales.salesorderheader on


insert into sales.salesorderheader
(SalesOrderID,OrderDate,DueDate,ShipDate,CustomerID,BillToAddressID,ShipToAddressID,ShipMethodID)
values
(1,'20190918','20190918','20190918',11019,921,921,5),
(2,'20190918','20190918','20190918',11019,921,921,5),
(3,'20190918','20190918','20190918',11019,921,921,5),
(4,'20190918','20190918','20190918',11019,921,921,5),
(5,'20190918','20190918','20190918',11019,921,921,5);
set identity_insert sales.salesorderheader off

set identity_insert sales.salesorderdetail on

insert into sales.salesorderdetail
(salesorderid,SalesOrderDetailID,ProductID,OrderQty,UnitPrice,SpecialOfferID)
VALUES
(1,1,771,1,1,1),
(2,1,771,1,1,1),
(3,1,771,1,1,1),
(4,1,771,1,1,1),
(5,1,771,1,1,1);


set identity_insert sales.salesorderdetail off



