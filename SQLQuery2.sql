--1 get data from NashvilleHousing table from Portfoilio Database
SELECT TOP (100) * FROM NashvilleHousing;

--2 standardize date
SELECT TOP(50)  SaleDate ,CAST(SaleDate  AS DATE ) AS Date FROM NashvilleHousing;

--3 Update SaleDate as Date
UPDATE NashvilleHousing
SET SaleDate = CAST(SaleDate  AS DATE )

--4 Now lets check if SaleDate is updated as Date
SELECT SALEDATE FROM NashvilleHousing;

--5 Now lets try using Alter Statement
ALTER TABLE NashvilleHousing
ADD  SaleDateConverted Date
UPDATE NashvilleHousing
SET SaleDateConverted = CAST(SaleDate  AS DATE) 

SELECT *from NashvilleHousing;

--6. Populate property address data
SELECT * FROM NashvilleHousing
Where PropertyAddress is null 

--7 Checking if Joining same table to eliminate Null Values in PropertyAddress column
SELECT a.ParcelID,a.PropertyAddress,b.parcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM NashvilleHousing a join NashvilleHousing b
ON a.ParcelID = b.ParcelID AND
a.UniqueID <> b.UniqueID 
WHERE a.PropertyAddress is null

-- 8 update propertyAddress to eliminate null if Dublicate UniqueKeys are there in the dataset
UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a join NashvilleHousing b
ON a.ParcelID = b.ParcelID AND
a.UniqueID <> b.UniqueID 
WHERE a.PropertyAddress is null



--9 Breakinout out Adderess into individual columns (Addfress, City, States)
SELECT PropertyAddress,SUBSTRING(PropertyAddress , 1 , CHARINDEX(',' , PropertyAddress) -1)  AS PropertySplitAddress,
 SUBSTRING (PropertyAddress , CHARINDEX(',' , PropertyAddress) +1 , LEN(PropertyAddress) ) AS PropertySplitCity
FROM NashvilleHousing;

--10. Now lets Create two columns Address and State and Update the value from the query we ran above
ALTER TABLE NashvilleHousing
ADD PropertySplitAddress varchar(255)
UPDATE NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress , 1 , CHARINDEX(',' , PropertyAddress) -1)
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitCity VARCHAR(255);
UPDATE  NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress , CHARINDEX(',' , PropertyAddress) +1 , LEN(PropertyAddress) )
FROM NashvilleHousing;


SELECT PropertyAddress,PropertySplitAddress,PropertySplitCity FROM NashvilleHousing;


--11 Spliting HomeAddress into Seprate Column Using PARSENAME
SELECT PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) , 3) AS A_ddress,
PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) , 2) AS S_tate,
PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) , 1) AS C_ity
FROM NashvilleHousing;


ALTER TABLE NashvilleHousing
ADD A_ddress VARCHAR(255);
UPDATE NashvilleHousing
SET A_ddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) , 3)
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD S_tate VARCHAR(255)
UPDATE NashvilleHousing
SET S_tate = PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) , 2)
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD C_ITY VARCHAR(255)
UPDATE NashvilleHousing
SET C_ity = PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) , 1)
FROM NashvilleHousing;

SELECT A_ddress,S_tate,C_ity FROM NashvilleHousing;



-- 12. Change y to yes and n to no in a column called 'sold as vacant'  

SELECT SoldasVacant FROM NashvilleHousing;

SELECT DISTINCT(SoldasVacant),COUNT(SoldasVacant) FROM NashvilleHousing
GROUP BY SoldasVacant
ORDER BY 2;

SELECT SoldasVacant,
CASE WHEN SoldasVacant = 'Y' THEN 'YES'
	 WHEN SoldasVacant = 'N' THEN 'NO'
	 ELSE SoldasVacant
	 END
FROM NashvilleHousing
WHERE SoldasVacant in('y','n');


UPDATE NashvilleHousing
SET SoldasVacant =
CASE WHEN SoldasVacant = 'Y' THEN 'YES'
	 WHEN SoldasVacant = 'N' THEN 'NO'
	 ELSE SoldasVacant
	 END
FROM NashvilleHousing;

SELECT DISTINCT(SoldasVacant),COUNT(SoldasVacant) AS Count_SoldasVacant FROM NashvilleHousing
GROUP BY SoldasVacant
ORDER BY 2;


--13 Removing Dublicates

SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference ORDER BY UniqueID ) AS RowNum
FROM NashvilleHousing
ORDER BY ParcelID;


-- 14 using CTE TO USE WHERE CLAUSE
WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference ORDER BY UniqueID ) AS RowNum
FROM NashvilleHousing)

--DELETE  FROM RowNumCTE
--WHERE RowNum > 1


SELECT * FROM RowNumCTE 
WHERE RowNum > 1
ORDER BY PropertyAddress;


-- 15. DELETE UNUSED COLUMNS
ALTER TABLE portfolioproject.dbo.NashvilleHousing
DROP COLUMN TaxDistrict,OwnerAddress,PropertyAddress

SELECT * FROM portfolioproject.dbo.NashvilleHousing;