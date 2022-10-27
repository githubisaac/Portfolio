
-- Cleaning data in SQL queries.

select
	*
from 
	PortfolioProject1..nashvillehousing


---------------------------------------------------------------------------------------------------
-- Standardize Date Format.

select
	saledate
	,CONVERT(date,saledate)
from 
	PortfolioProject1..nashvillehousing


Update NashvilleHousing
SET saledate = CONVERT(date,saledate)


alter table nashvillehousing
add SaleDateConverted date 


Update NashvilleHousing
SET saledateconverted = CONVERT(date,saledate)


select
	SaleDateConverted
from 
	PortfolioProject1..nashvillehousing


---------------------------------------------------------------------------------------------------
-- Populate Property Address data.

select
	*
from 
	PortfolioProject1..nashvillehousing
where 
	propertyaddress is null


select
	*
from 
	PortfolioProject1..nashvillehousing
order by
	parcelid
-- Shows that even if it has multiple uniqueIDs and SaleDates, ONE parcelID has ONE associated address, not multiple addresses.


-- If there is not an address listed in one of the listings, self join the matching parcelID that does have an address listed.
select
	a.parcelid
	,a.propertyaddress
	,b.parcelid
	,b.propertyaddress
from 
	PortfolioProject1..nashvillehousing a
join 
	PortfolioProject1..nashvillehousing b
on 
	a.parcelid=b.parcelid
and
	a.uniqueid<>b.uniqueid
where
	a.propertyaddress is null


-- Let's get an address down for each listing. Filling in the address for parcels missing the address.
select
	a.parcelid
	,a.propertyaddress
	,b.parcelid
	,b.propertyaddress
	,ISNULL(a.PropertyAddress,b.PropertyAddress)
from 
	PortfolioProject1..nashvillehousing a
join 
	PortfolioProject1..nashvillehousing b
on 
	a.parcelid=b.parcelid
and
	a.uniqueid<>b.uniqueid
where
	a.propertyaddress is null


update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from 
	PortfolioProject1..nashvillehousing a
join 
	PortfolioProject1..nashvillehousing b
on 
	a.parcelid=b.parcelid
and
	a.uniqueid<>b.uniqueid
where
	a.propertyaddress is null


---------------------------------------------------------------------------------------------------
-- Breaking out addresses into individual columns (address, city, state).


select
	propertyaddress
from 
	PortfolioProject1..nashvillehousing


-- First I separate out the street address from the full address.
select 
	SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1) StreetAddress
from 
	PortfolioProject1..nashvillehousing


-- Separate out the city as well
select 
	SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1) StreetAddress
	,SUBSTRING(propertyaddress,charindex(',',propertyaddress)+2,LEN(propertyaddress)) City
from 
	PortfolioProject1..nashvillehousing


-- Time to create two new columns to put the separated info into.
alter table PortfolioProject1..nashvillehousing
add PropertyStreetAddress nvarchar(255)


alter table PortfolioProject1..nashvillehousing
add PropertyCity nvarchar(255)


update PortfolioProject1..nashvillehousing
set propertystreetaddress = SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)


update PortfolioProject1..nashvillehousing
set propertycity = SUBSTRING(propertyaddress,charindex(',',propertyaddress)+2,LEN(propertyaddress))


-- Check it's there
select
	*
from 
	PortfolioProject1..nashvillehousing


-- Time to do the same for OwnerAddress. Owner address has state listed, whereas PropertyAddress did not.
select 
	owneraddress
from
	PortfolioProject1..nashvillehousing


select
	PARSENAME(replace(owneraddress,',','.'),3) street
	,ltrim(PARSENAME(replace(owneraddress,',','.'),2)) city 
	,ltrim(PARSENAME(replace(owneraddress,',','.'),1)) state
from
	PortfolioProject1..nashvillehousing


-- Once again, creating new columns to put separated OwnerAddress info into.
alter table PortfolioProject1..nashvillehousing
add OwnerStreetAddress nvarchar(255)


alter table PortfolioProject1..nashvillehousing
add OwnerCity nvarchar(255)


alter table PortfolioProject1..nashvillehousing
add OwnerState nvarchar(255)


update PortfolioProject1..nashvillehousing
set ownerstreetaddress = PARSENAME(replace(owneraddress,',','.'),3)


update PortfolioProject1..nashvillehousing
set ownercity = ltrim(PARSENAME(replace(owneraddress,',','.'),2))


update PortfolioProject1..nashvillehousing
set ownerstate = ltrim(PARSENAME(replace(owneraddress,',','.'),1))


-- Check it's there.
select
	*
from 
	PortfolioProject1..nashvillehousing


---------------------------------------------------------------------------------------------------
-- Make "Sold As Vacant" field consistent. Raw data had both 'Yes' & 'Y' in the same column, same for no's.
select
	distinct(SoldAsVacant)
from 
	PortfolioProject1..nashvillehousing


select
	SoldAsVacant
	,COUNT(*) Count
from 
	PortfolioProject1..nashvillehousing
group by 
	SoldAsVacant
order by
	Count
-- 'Yes' and 'No' are much more used to I'm going go convert to those.


select
	soldasvacant OGsoldasvacant
	,(case
		when 
			soldasvacant='Y'
		then
			'Yes'
		when
			soldasvacant='N'
		then
			'No'
	else	
		soldasvacant
	end) UpdatedYesNo
from 
	PortfolioProject1..nashvillehousing


update PortfolioProject1..nashvillehousing
set SoldAsVacant = (case
						when 
							soldasvacant='Y'
						then
							'Yes'
						when
							soldasvacant='N'
						then
							'No'
					else	
						soldasvacant
					end)


-- Check it worked
select
	SoldAsVacant
	,COUNT(*) Count
from 
	PortfolioProject1..nashvillehousing
group by 
	SoldAsVacant


---------------------------------------------------------------------------------------------------
-- Remove duplicates


-- This query lets me see there do exist some listings with a 'second row' aka a duplicate.
select
	*
	,ROW_NUMBER() over
	(partition by
		parcelid
		,propertyaddress
		,saledate
		,saleprice
		,legalreference
	order by
		uniqueid) rownum
from 
	PortfolioProject1..nashvillehousing
order by
	ParcelID


with RowNumCTE as(
select
	*
	,ROW_NUMBER() over
	(partition by
		parcelid
		,propertyaddress
		,saledate
		,saleprice
		,legalreference
	order by
		uniqueid) rownum
from 
	PortfolioProject1..nashvillehousing
--order by
--	UniqueID
)
select
	*
from
	RowNumCTE
where 
	rownum>1
order by parcelid
-- Shows 104 duplicates. Time to delete them (I understand in most all jobs you never delete data but in this case I am).


-- Deleting duplicates
with RowNumCTE as(
select
	*
	,ROW_NUMBER() over
	(partition by
		parcelid
		,propertyaddress
		,saledate
		,saleprice
		,legalreference
	order by
		uniqueid) rownum
from 
	PortfolioProject1..nashvillehousing
)
delete
from
	RowNumCTE
where 
	rownum>1
-- Now I run the prior query to make sure they're gone.


---------------------------------------------------------------------------------------------------
-- Delete unused columns

alter table PortfolioProject1..nashvillehousing
drop column
	saledate
	,propertyaddress
	,owneraddress

select 
	*
from 
	PortfolioProject1..nashvillehousing