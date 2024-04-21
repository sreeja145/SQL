
/* Problem Statement:
- For pairs of brands in the same year (e.g. apple/samsung/2020 and samsung/apple/2020) 
    - if custom1 = custom3 and custom2 = custom4 : then keep only one pair

- For pairs of brands in the same year 
    - if custom1 != custom3 OR custom2 != custom4 : then keep both pairs

- For brands that do not have pairs in the same year : keep those rows as well
*/

drop table if exists brands;
use tests;
create table Brands( brand1 varchar(20), brand2 varchar(20), year int,custom1 int, custom2 int,
custom3 int, custom4 int);

insert into brands values('apple', 'samsung', 2020, 1,2,1,2),
('samsung','apple',2020,1,2,1,2),
('apple','samsung',2021,1,2,5,3),
('samsung','apple', 2021,5,3,1,2),
('google', null, 2020,5,9,null,null),
('oneplus','nothing',2020,5,9,6,3);

select * from brands;

select *, case when length(brand1)<length(brand2) then concat(brand1, brand2,year)
else concat(brand2,brand1,year) end as pair_id from Brands;

with cte as (select *, case when length(brand1)<length(brand2) then concat(brand1, brand2,year)
else concat(brand2,brand1,year) end as pair_id from Brands),
cte_rn as (select *, row_number() over(partition by pair_id order by pair_id) as rn from cte)


select brand1, brand2,year, custom1,custom2,custom3,custom4 from cte_rn where rn=1 or (custom1<>custom3 and custom2<>custom4)

