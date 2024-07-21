select count(*) from layoffs;
select distinct count(*) from layoffs;

CREATE TABLE layoffs_staging 
LIKE layoffs;

select * from layoffs;
select * from layoffs_staging;


INSERT INTO layoffs_staging 
SELECT * from layoffs;


select *,
ROW_NUMBER() OVER (
partition by company,location,
industry,total_laid_off,
percentage_laid_off, `date`,stage,country,funds_raised_millions) AS row_num
from layoffs_staging;



WITH duplicate_cte as (
select *,
ROW_NUMBER() OVER (
partition by company,location,
industry,total_laid_off,
percentage_laid_off, `date`,stage,country,funds_raised_millions) AS row_num
from layoffs_staging
)
select * from duplicate_cte
where row_num>1;


select * from layoffs_staging where company='Oda';
select * from layoffs_staging where company='Casper';


CREATE TABLE `layoffs_staging2` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `industry` varchar(255) DEFAULT NULL,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` float DEFAULT NULL,
  `date` date DEFAULT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



select * 
from layoffs_staging2;


insert into layoffs_staging2
select *,
ROW_NUMBER() OVER (
partition by company,location,
industry,total_laid_off,
percentage_laid_off, `date`,stage,
country,funds_raised_millions) AS row_num
from layoffs_staging;

select * from layoffs_staging2;

select * from layoffs_staging2 WHERE row_num>1;

delete from layoffs_staging2 WHERE row_num>1;

SET SQL_SAFE_UPDATES = 0;

delete from layoffs_staging2 WHERE row_num>1;

SELECT company,trim(company) from layoffs_staging2;

update layoffs_staging2
SET company=TRIM(company);

SELECT distinct(industry) from layoffs_staging2 order by 1;

select * 
from layoffs_staging2
where industry like 'Crypto%';

UPDATE layoffs_staging2
set industry='Crypto'
where industry LIKE 'Crypto%';


select distinct location 
from layoffs_staging2
order by 1;

select distinct country,TRIM(TRAILING '.' FROM country)
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where country like 'United States%';

select *
from layoffs_staging2
where country like 'United States%';


update layoffs_staging2
set country=TRIM(TRAILING '.' FROM country)
where country like 'United States%';

select distinct (country) from layoffs_staging2 order by 1;
