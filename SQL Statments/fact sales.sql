use E0_AdventureWorksDW2022
go

if exists (select * from sys.tables where name = 'fact_sales')
	drop table fact_sales;

create table fact_sales(
	product_key int not null,
	customer_key int not null,
	territory_key int not null,
	order_date_key int not null,
	sales_order_id int not null,
	line_number int not null,
	quantity int,
	unit_price money,
	unit_cost money,
	tax_amount money,
	freight money,
	extended_sales money,
	extended_cost money,
	created_at datetime not null default(getdate()),

	CONSTRAINT pk_fact_sales
	primary key clustered (sales_order_id,line_number),

	CONSTRAINT fk_fact_sales_dim_product
	FOREIGN key (product_key) REFERENCES dim_product(product_key),

	CONSTRAINT fk_fact_sales_dim_customer
	FOREIGN key (customer_key) REFERENCES dim_customer(customer_key),

	CONSTRAINT fk_fact_sales_dim_territory FOREIGN KEY (territory_key)
    REFERENCES dim_territory(territory_key),

    CONSTRAINT fk_fact_sales_dim_date 
	FOREIGN KEY (order_date_key) REFERENCES dim_date(date_key)
);

-- Create Indexes
IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_product'
                  AND object_id = object_id('fact_sales'))
  DROP INDEX fact_sales.fact_sales_dim_product;

CREATE INDEX fact_sales_dim_product
  ON fact_sales(product_key);

IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_customer'
                  AND object_id = object_id('fact_sales'))
  DROP INDEX fact_sales.fact_sales_dim_customer;

CREATE INDEX fact_sales_dim_customer
  ON fact_sales(customer_key);

IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_territory'
                  AND object_id = object_id('fact_sales'))
  DROP INDEX fact_sales.fact_sales_dim_territory;

CREATE INDEX fact_sales_dim_territory
  ON fact_sales(territory_key);

IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'fact_sales_dim_date'
                  AND object_id = object_id('fact_sales'))
  DROP INDEX fact_sales.fact_sales_dim_date;

CREATE INDEX fact_sales_dim_date
  ON fact_sales(order_date_key); 