
select
    lga_code as lga_code,
    '' as new_sub,
    property_pfi as property_pfi,
    '' as parcel_pfi,
    '' as address_pfi,
    spi as spi,
    plan_number as plan_number,
    lot_number as lot_number,
    '' as base_propnum,
    propnum as propnum,
    '' as crefno,
    '' as hsa_flag,
    '' as hsa_unit_id,
    '' as blg_unit_type,
    '' as blg_unit_prefix_1,
    '' as blg_unit_id_1,
    '' as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    '' as blg_unit_id_2,
    '' as blg_unit_suffix_2,
    '' as floor_type,
    '' as floor_prefix_1,
    '' as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    '' as floor_no_2,
    '' as floor_suffix_2,
    '' as building_name,
    '' as complex_name,
    '' as location_descriptor,
    '' as house_prefix_1,
    '' as house_number_1,
    '' as house_suffix_1,
    '' as house_prefix_2,
    '' as house_number_2,
    '' as house_suffix_2,
    '' as access_type,
    '' as new_road,
    '' as road_name,
    '' as road_type,
    '' as road_suffix,
    '' as locality_name,
    '' as distance_related_flag,
    '' as is_primary,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    'A' as edit_code,
    comments as comments

from (

select
    vp.lga_code as lga_code,
    case
        when ( select num_parcels_in_prop from PC_Vicmap_Parcel_Property_Parcel_Count t where t.spi = vp.spi ) > 1 then property_pfi
        else ''
    end as property_pfi,
    case
        when ( select num_parcels_in_prop from PC_Vicmap_Parcel_Property_Parcel_Count t where t.spi = vp.spi ) > 1 then ''
        else vp.spi
    end as spi,
    case
        when ( select num_parcels_in_prop from PC_Vicmap_Parcel_Property_Parcel_Count t where t.spi = vp.spi ) > 1 then ''
        else ifnull ( vp.plan_number , '' )
    end as plan_number,
    case
        when ( select num_parcels_in_prop from PC_Vicmap_Parcel_Property_Parcel_Count t where t.spi = vp.spi ) > 1 then ''
        else ifnull ( vp.lot_number , '' )
    end as lot_number,
    cp.propnum as propnum,
    'parcel ' || vp.spi ||': adding propnum ' || cp.propnum || ' as multi-assessment' as comments
from
    PC_Vicmap_Parcel vp,
    PC_Council_Parcel cp
where
    vp.spi <> '' and
    cp.propnum not in ( '' , 'NCPR' ) and
    vp.spi = cp.spi and
    ( vp.propnum = '' or vp.propnum not in ( select t.propnum from PC_Council_Parcel t ) ) and
    ( select t.num_props from PC_Council_Parcel_Property_Count t where t.spi = cp.spi ) > 1
)