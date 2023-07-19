Create Database NashvilleHousing;

use NashvilleHousing;

SELECT * FROM NV;

---STANDARDIZE DATE FORMATE 

    select saledate from NV;

    select saledate,  CONVERT( DATE,saledate) from NV;

     Update NV 
    SET saledate = CONVERT(DATE,saledate)

 
     ALTER TABLE NV
     Add SalesDateConverted Date;


    UPDATE NV 
    SET SalesDateConverted =CONVERT(DATE,saledate);


----2.POPULATE PROPERTY ADDRESS DATA 
  select * from NV 
  --where PropertyAddress is null
  order by ParcelID

  select a.ParcelID, a.propertyAddress ,b.ParcelID, b.propertyAddress,
  ISNULL(a.propertyAddress,b.propertyAddress)
  from NV a 
  join NV b
  on a.ParcelID = b.ParcelID and
  a.[UniqueID] <> b.[UniqueID]
  where a.propertyAddress is null 



  UPDATE a 
  SET propertyAddress= ISNULL(a.propertyAddress,b.propertyAddress)
  From NV a
  JOIN NV b
  ON a.parcelID =b.parcelID AND a.[UniqueID]<>b.[UniqueID]
  Where a.propertyAddress is null 
   




--3. Breaking out Address into individual Column(Address,  City, state)
 

    Select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)As Address,
    SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 ,LEN(PropertyAddress)) as Address
	From NV



		 
     ALTER TABLE NV
     Add PropertySplitAddress Nvarchar(255);

    UPDATE NV 
    SET PropertyAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)



     ALTER TABLE NV
     Add PropertySplitCity Nvarchar(255);

    UPDATE NV 
    SET PropertySplitCity =   SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 ,LEN(PropertyAddress))
    select * from NV 


---4.OwenerAddress
     
	 SELECT OwnerAddress from NV



  SELECT 
  PARSENAME(REPLACE(OwnerAddress, ',',','),3),
  PARSENAME(REPLACE(OwnerAddress,',',','),2),
  PARSENAME(REPLACE(OwnerAddress,',',','),1)
  FROM NV



  		 
     ALTER TABLE NV
     Add OwnerSplitAddress Nvarchar(255);

    UPDATE NV 
    SET OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress, ',',','),3)


     ALTER TABLE NV
     Add OwnerSplitCity Nvarchar(255)

    UPDATE NV 
    SET OwnerSplitCity =PARSENAME(REPLACE(OwnerAddress,',',','),2)
    select * from NV 

     ALTER TABLE NV
     Add OwnerSplitState Nvarchar(255);

    UPDATE NV 
    SET OwnerSplitState =PARSENAME(REPLACE(OwnerAddress,',',','),1)
    select * from NV ;

---5. CHANGE Y AND N TO YES AND NO in "Sold as vacant" field


     select SoldAsVacant
	     ,CASE WHEN SoldAsVacant= 'Y' THEN 'YES'
		      WHEN SoldAsVacant='N' THEN 'NO'
			  ELSE SoldAsVacant
			  END
			  FROM NV


			  SELECT * FROM NV


			  UPDATE NV
			  SET SoldAsVacant= CASE WHEN SoldAsVacant= 'Y' THEN 'YES'
		      WHEN SoldAsVacant='N' THEN 'NO'
			  ELSE SoldAsVacant
			  END
			 
             select Distinct(SoldAsVacant),count(SoldAsVacant)
             from NV
             GROUP BY SoldAsVacant
             Order by 2

-------REMOVE DUPLICATES------------- 

WITH  CTE AS
(
SELECT *, ROW_NUMBER() OVER(partition by ParcelID, PropertyAddress, SalePrice, LegalReference ORDER BY UniqueID )row_num FROM NV
)
SELECT *
FROM CTE
WHERE row_num >1
--ORDER BY propertyAddress



-----DELETE USED COLUMN-------------

SELECT * FROM NV;
					
ALTER TABLE NV 
DROP COLUMN propertyAddress, OwnerAddress,TaxDistrict, SaleDate;



