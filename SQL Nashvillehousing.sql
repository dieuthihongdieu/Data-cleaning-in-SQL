/*
Cleaning Data in SQl Queries
*/
select *
from PortfolioProject.dbo.NashvilleHousing
--- Standardize Date format
select SaleDateCoverted, Convert(Date,Saledate)
from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(Date,Saledate)

Alter table NashvilleHousing
Add SaleDateCoverted Date;

Update NashvilleHousing
Set SaleDateCoverted = Convert(Date,Saledate)

--- Populate Property Address Data
select *
from PortfolioProject.dbo.NashvilleHousing
---Where PropertyAddress is null 
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing as a
Join PortfolioProject.dbo.NashvilleHousing as b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing as a
Join PortfolioProject.dbo.NashvilleHousing as b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

--- Break out Address into Individual Columns( Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--- Where PropertyAddress is Null
--- Order by ParcelID
select
SUBSTRING(propertyAddress,1,Charindex(',',PropertyAddress)-1) as Address,
SUBSTRING(propertyAddress,Charindex(',',PropertyAddress)+1,Len(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing
Add PropertySplitAddress NVarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(propertyAddress,1,Charindex(',',PropertyAddress)-1) 

Alter table NashvilleHousing
Add PropertySplitCity NVarchar(255);

Update NashvilleHousing
Set PropertySplitCity  = SUBSTRING(propertyAddress,Charindex(',',PropertyAddress)+1,Len(PropertyAddress))



select *
from PortfolioProject.dbo.NashvilleHousing








select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from PortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing
Add OwnerSplitAddress NVarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

Alter table NashvilleHousing
Add OwnerSplitCity NVarchar(255);

Update NashvilleHousing
Set OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

Alter table NashvilleHousing
Add OwnerSplitState NVarchar(255);

Update NashvilleHousing
Set OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


Select *
from PortfolioProject.dbo.NashvilleHousing

---- Change Y and N to Yes and No, In " Sold as Vacant" field

Select distinct (SoldAsVacant),count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2;

Select SoldAsVacant
, Case When SoldAsVacant ='Y' then 'Yes'
       When SoldAsVacant ='N' then 'No'
       Else SoldAsVacant 
	   End
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant ='Y' then 'Yes'
       When SoldAsVacant ='N' then 'No'
       Else SoldAsVacant 
	   End

--- Remove Duplicates

WITH RowNumCTE AS(
Select *,
    Row_number () OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				        UniqueID
						) row_num
	               
From PortfolioProject.dbo.NashvilleHousing
---- order by ParcelID
)
Delete * 
from RowNumCTE
Where Row_num> 1
--Order by PropertyAddress

---Delete Unused Columns



Select*
From PortfolioProject.dbo.NashvilleHousing

Alter table PortfolioProject.dbo.NashvilleHousing
Drop column Owneraddress, TaxDistrict, PropertyAddress;

Alter table PortfolioProject.dbo.NashvilleHousing
Drop column SaleDate