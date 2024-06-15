use E0_AdventureWorksDW2022
GO

-- dropping the foreign_keys

if exists
	(select * from sys.foreign_keys
	where name = 'fk_fact_sales_dim_customer'
	and parent_object_id = object_id('fact_sales'))

alter table fact_sales
	drop constraint fk_fact_sales_dim_customer;


if exists (select * from sys.objects where name ='dim_customer' and type = 'U')
drop table dim_product
go

create table dim_customer(
	customer_key int not null identity(1,1), --surogate key
	customer_id int not null, --business key (natural)
	customer_name nvarchar(150),
	address1 nvarchar(100),
	address2 nvarchar(100),
	city nvarchar(30),
	phone nvarchar(25),

	--Metadata
	source_system_code tinyint not null,

	--SCD 
	start_date datetime not null DEFAULT (getdate()),
	end_date datetime,
	is_current tinyint not null DEFAULT (1)

	constraint pk_dim_customer
	primary key clustered (customer_key)
);

-- Insert unkown record to handle error
set identity_insert dim_product on

insert into dim_customer (customer_id,customer_name,address1,address2,city,phone,
						source_system_code,start_date,end_date,is_current)
values(0,'Unknown','Unknown','Unknown','Unknown','Unknown',0,'1900-01-01',null,1)

set identity_insert dim_product off;

-- create foreign key 

if exists
	(select * from sys.tables where name = 'fact_sales')

alter table fact_sales
	add constraint fk_fact_sales_dim_customer
	foreign key (customer_key)
	references dim_customer(customer_key);


--create indexes

if exists (
	select * from sys.indexes
	where name = 'dim_customer_customer_id'
	and object_id = object_id('dim_customer'))

drop index dim_product.dim_customer_customer_id

create index dim_customer_customer_id
	on dim_customer(customer_id)

