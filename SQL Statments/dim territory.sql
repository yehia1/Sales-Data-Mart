use E0_AdventureWorksDW2022
GO

-- dropping the foreign_keys

if exists
	(select * from sys.foreign_keys
	where name = 'fk_fact_sales_dim_territory'
	and parent_object_id = object_id('fact_sales'))

alter table fact_sales
	drop constraint fk_fact_sales_dim_territory;


if exists (select * from sys.objects where name ='dim_territory' and type = 'U')
drop table dim_product
go

create table dim_territory(
	territory_key int not null identity(1,1), --surogate key
	territory_id int not null, --business key (natural)
	territory_name nvarchar(50),
	territory_country nvarchar(400),
	territory_group nvarchar(50),

	--Metadata
	source_system_code tinyint not null,

	--SCD 
	start_date datetime not null DEFAULT (getdate()),
	end_date datetime,
	is_current tinyint not null DEFAULT (1)

	constraint pk_dim_territory
	primary key clustered (territory_key)
);

-- Insert unkown record to handle error
set identity_insert dim_product on

insert into dim_territory (territory_id,territory_name,territory_country,territory_group,
						source_system_code,start_date,end_date,is_current)
values(0,'Unknown','Unknown','Unknown',0,'1900-01-01',null,1)

set identity_insert dim_product off;

-- create foreign key 

if exists
	(select * from sys.tables where name = 'fact_sales')

alter table fact_sales
	add constraint fk_fact_sales_dim_territory
	foreign key (territory_key)
	references dim_territory(territory_key);


--create indexes

if exists (
	select * from sys.indexes
	where name = 'dim_territory_territory_id'
	and object_id = object_id('dim_territory'))

drop index dim_product.dim_territory_territory_id

create index dim_territory_territory_id
	on dim_territory(territory_id)

