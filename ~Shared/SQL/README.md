# Pozi Connect M1 SQL

Pozi Connect compares Council's property data with Vicmap datasets to generate a spreadsheet called the M1. The M1 contains all property and address changes from individual Victorian councils to be submitted to the Department of Environment and Primary Industries (DEPI) for updating the state-wide Vicmap property and address datasets.

The rules and processes for submitting M1s are controlled by the DEPI. The full documentation is found [here](http://www.dse.vic.gov.au/__data/assets/pdf_file/0006/150927/M1_V12_Documentation_27112012.pdf)  (PDF, 4.3 MB).

## Edit Criteria

Pozi Connect generates records to populate the M1 based on multiple comparison queries, each of which is designed to satisfy the criteria for the following 'edit codes'.

DEPI provides the following summary of the edit codes. Each code letter links to the documentation of how Pozi Connect interprets these rules.

Edit Code | Description
:--------:|------------
[**B**](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20B%20Edits.md) | Only to be used when removing a primary property from the base or retiring the whole base. Refer to the worked examples on conditions for use. 
[**C**](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20C%20Edits.md) | Only updating the parcel based Council Reference number (Crefno). This edit code can be used to populate or null a Crefno. 
[**E**](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20E%20Edits.md) | Updates both property and address details for a given record. It requires that the Property Details and Address – Road and Locality Information columns are populated as required. 
[**P**](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20P%20Edits.md) | Updates property details for a given record. It requires that the Property Details are populated as required including propnum and Crefno (if used by LGA). If Crefno is left blank the existing CREFNO value in the parcel table will be retained. 
[**S**](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20S%20Edits.md) | Updates address details for a given record. It requires that the Address – Road and Locality Information columns are populated as required including the Address – Location attributes for creating spatially located address points. 
[**Z**](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20Z%20Edits.md) | Only used to remove secondary addresses. It will not remove a primary distance based address. Refer to the worked examples on conditions for use. 
[**A**](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20A%20Edits.md) | Only used to add a property to either create a Multi Assessment or add a further multi assessment record. 
[**R**](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20R%20Edits.md) | Only used to remove a property from a Multi Assessment. The last record on a multi assessment cannot be retired.

## Preparing the Data

The following tables, used by Pozi Connect in generating the M1s, have been generated by earlier Pozi Connect extraction and processing tasks. (See the SQL files in this folder and ~Shared\SQL and {Council Name}\SQL folders for further details.)

 Table                       | Derived from                | Query
-----------------------------|-----------------------------|-------------------
 PC Vicmap Parcel            | Vicmap Parcel and Property  | ~Shared\SQL\PC Vicmap Parcel from SHP.sql
 PC Vicmap Property Address  | Vicmap Property and Address | ~Shared\SQL\PC Vicmap Property Address from SHP.sql
 PC Council Parcel           | Council's property system   | {Council Name}\SQL\\{Council Name} PC Council Parcel.sql
 PC Council Property Address | Council's property system   | {Council Name}\SQL\\{Council Name} PC Council Property Parcel.sql

Pozi Connect also generates supplementary tables based on the above tables that contain counts of properties in parcels, parcels in properties, etc, to assist with determining the eligibility of certain types of edits.

Table                                   | Description
----------------------------------------|-----------------------------
PC Council Parcel Property Count        | List of Council parcels, with a count of the number of properties that share each parcel
PC Council Property Count               | List of Council properties, with a count of the number of property/address records for each property
PC Council Property Parcel Count        | List of Council properties, with a count of the number of parcels in each property
PC Vicmap Parcel Property Count         | List of Vicmap parcels, with a count of the number of properties that share each parcel
PC Vicmap Parcel Property Parcel Count  | List of Vicmap parcels, with a count of the number of other parcels it shares its property with (ie, a count of more than one identifies that parcel as being part of a *multi-parcel* property
PC Vicmap Property Parcel Count         | List of Vicmap properties, with a count of the number of parcels in each property

## Notes about this new version

The rules and process outline above are part of a 'second generation' of the Pozi Connect M1 logic. This new approach generates records based on separate queries designed to satisfy the criteria for each edit code.

This is fundamentally different from the 'first generation' method of generating records based on different property 'scenarios' and trying to determine the attributes, rules and edit codes afterwards.

It is expected this new approach makes the logic simpler and more transparent, and give us more control over the output. It also reduces the amount of council-specific configuration as the bulk of the processing logic is common across all councils.
