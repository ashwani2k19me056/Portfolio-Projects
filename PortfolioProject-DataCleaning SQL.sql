CREATE DATABASE Housing;

SELECT * FROM dbo.[National Housing];

--Standardize Date Format
SELECT SaleDate2, CONVERT(Date,SaleDate)
FROM dbo.[National Housing];

UPDATE [National Housing]
SET SaleDate= CONVERT(Date,SaleDate);

ALTER TABLE dbo.[National Housing]
ADD SaleDate2 DATE;

UPDATE [National Housing]
SET SaleDate2 = CONVERT(Date,SaleDate);

--Property Address

SELECT PropertyAddress
From [National Housing]
WHERE PropertyAddress IS NULL

SELECT *
From [National Housing]
WHERE PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [National Housing] a
JOIN [National Housing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a 
SET PropertyAddress =ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [National Housing] a
JOIN [National Housing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Breaking Property Address into Address, City and State

SELECT PropertyAddress
From [National Housing]

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM [National Housing]

ALTER TABLE [National Housing]
ADD PropertySplitAddress NVARCHAR(255);

UPDATE [National Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE [National Housing]
ADD PropertySplitCity NVARCHAR(255);

UPDATE [National Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT*
FROM [National Housing]

--OWNER ADDRESS

SELECT OwnerAddress
FROM [National Housing]

--USING PARSE

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM [National Housing];

ALTER TABLE [National Housing]
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE [National Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE [National Housing]
ADD OwnerSplitCITY NVARCHAR(255);

UPDATE [National Housing]
SET OwnerSplitCITY = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE [National Housing]
ADD OwnerSplitSTATE NVARCHAR(255);

UPDATE [National Housing]
SET OwnerSplitSTATE = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT * 
FROM [National Housing]

--Replacing Y as yes And N as No

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [National Housing]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant 
	 END
FROM [National Housing]

UPDATE [National Housing]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant 
	 END

SELECT *
FROM [National Housing]


--Remove Duplicates

WITH RowNumCTE AS (
SELECT *,
 ROW_NUMBER() OVER (
      PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				    UniqueID
					) row_num

FROM [National Housing]
--ORDER BY ParcelID
)

SELECT *
FROM RowNumCTE
WHERE row_num>1

--DELETE ROWS

ALTER TABLE [National Housing]
DROP COLUMN PropertyAddress, OwnerAddress, SaleDate2

SELECT *
FROM [National Housing]



