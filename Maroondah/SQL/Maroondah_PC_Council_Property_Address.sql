select distinct
    lpaprop.tpklpaprop as propnum,
	cast ( lpaprop.tpklpaprop as integer )  as propnum_int,
	case
        when upper ( lpaaddr.unitprefix ) = 'ATM' then 'ATM'
        when upper ( lpaaddr.unitprefix ) = 'CAR PARK' then 'CARP'
        when upper ( lpaaddr.unitprefix ) = 'FACTORY' then 'FCTY'
        when upper ( lpaaddr.unitprefix ) = 'FLAT' then 'FLAT'
        when upper ( lpaaddr.unitprefix ) = 'KIOSK' then 'KSK'
        when upper ( lpaaddr.unitprefix ) = 'OFFICE' then 'OFFC'
        when upper ( lpaaddr.unitprefix ) = 'SHED' then 'SHED'
        when upper ( lpaaddr.unitprefix ) = 'SHOP' then 'SHOP'
        when upper ( lpaaddr.unitprefix ) = 'SIGN' then 'SIGN'
        when upper ( lpaaddr.unitprefix ) = 'SUITE' then 'SE'
        when upper ( lpaaddr.unitprefix ) = 'UNIT' then 'UNIT'
        when upper ( lpaaddr.unitprefix ) = 'L' then 'LOT'
        when upper ( lpaaddr.unitprefix ) = 'LOT' then 'LOT'
        when upper ( lpaaddr.unitprefix ) = 'ROOM' then 'ROOM'
        else ''
    end as blg_unit_type,   
    '' as blg_unit_prefix_1,
    case
        when lpaaddr.strunitnum = 0 or lpaaddr.strunitnum is null then ''
        else cast ( cast ( lpaaddr.strunitnum as integer ) as varchar )
    end as blg_unit_id_1,
    ifnull ( lpaaddr.strunitsfx , '' ) as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when lpaaddr.endunitnum = 0 or lpaaddr.endunitnum is null then ''
        else cast ( cast ( lpaaddr.endunitnum as integer ) as varchar )
    end as blg_unit_id_2,
    case
       when trim ( lpaaddr.endunitsfx ) = '0' or lpaaddr.endunitsfx is null then ''
       else trim ( lpaaddr.endunitsfx )
    end as blg_unit_suffix_2,
    case
        when upper ( lpaaddr.lvlprefix ) = 'BASEMENT' then 'B'
        when upper ( lpaaddr.lvlprefix ) = 'LEVEL' then 'L'
        when upper ( lpaaddr.lvlprefix ) = 'FLOOR' then 'FL'
        when upper ( lpaaddr.lvlprefix ) = 'GRD FLOOR' then 'G'
        else ''
    end as floor_type,
    '' as floor_prefix_1,
    case
        when upper ( lpaaddr.lvlprefix ) in ( 'FLOOR' , 'LEVEL' ) then trim ( lpaaddr.strlvlnum )
        else ''
    end as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    case
        when upper ( lpaaddr.lvlprefix ) in ( 'FLOOR' , 'LEVEL' ) and trim ( lpaaddr.endlvlnum ) <> '0' then trim ( lpaaddr.endlvlnum )
        else ''
    end as floor_no_2,
    '' as floor_suffix_2,
    ifnull ( upper ( lpapnam.propname ) , '' ) as building_name,
    '' as complex_name,
    case
        when upper ( lpaaddr.prefix ) in ( 'ABOVE' ) then 'ABOVE'
        when upper ( lpaaddr.prefix ) in ( 'BELOW' , 'UNDER' ) then 'BELOW'
        when upper ( lpaaddr.prefix ) in ( 'FRONT' ) then 'FRONT'
        when upper ( lpaaddr.prefix ) in ( 'OFF' ) then 'OFF'
        when upper ( lpaaddr.prefix ) in ( 'OPPOSITE' ) then 'OPPOSITE'
        when upper ( lpaaddr.prefix ) in ( 'REAR' , 'REAR OF' ) then 'REAR'
        else ''
    end as location_descriptor,
    '' as house_prefix_1,
    case
        when lpaaddr.strhousnum = 0 or lpaaddr.strhousnum is null then ''
        else cast ( cast ( lpaaddr.strhousnum as integer ) as varchar )
    end as house_number_1,
    ifnull ( lpaaddr.strhoussfx , '' ) as house_suffix_1,
    '' as house_prefix_2,
    case
        when lpaaddr.endhousnum = 0 or lpaaddr.endhousnum is null then ''
        else cast ( cast ( lpaaddr.endhousnum as integer ) as varchar )
    end as house_number_2,
    ifnull ( lpaaddr.endhoussfx , '' ) as house_suffix_2,
    upper ( replace ( cnacomp.descr,' - ','-' )) as road_name, 
    case
        when cnaqual.descr like '% NORTH' or
            cnaqual.descr like '% SOUTH' or
            cnaqual.descr like '% EAST' or
            cnaqual.descr like '% WEST' then upper ( trim ( substr ( cnaqual.descr , 1 , length ( cnaqual.descr ) - 5 ) ) )
        else upper ( cnaqual.descr )
    end as road_type,
    case
        when upper ( cnaqual.descr ) like '% NORTH' then 'N'
        when upper ( cnaqual.descr ) like '% SOUTH' then 'S'
        when upper ( cnaqual.descr ) like '% EAST' then 'E'
        when upper ( cnaqual.descr ) like '% WEST' then 'W'
        else ''
    end as road_suffix, 
	upper ( lpasubr.suburbname ) as locality_name,
    '' as postcode

from
    PATHWAY_lpaprop as lpaprop left join 
    PATHWAY_lpaadpr as lpaadpr on lpaprop.tpklpaprop = lpaadpr.tfklpaprop left join 
    PATHWAY_lpaaddr as lpaaddr on lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr left join 
    PATHWAY_lpastrt as lpastrt on lpaaddr.tfklpastrt = lpastrt.tpklpastrt left join 
    PATHWAY_cnacomp as cnacomp on lpastrt.tfkcnacomp = cnacomp.tpkcnacomp left join 
    PATHWAY_cnaqual as cnaqual on cnacomp.tfkcnaqual = cnaqual.tpkcnaqual left join 
    PATHWAY_lpaprtp as lpaprtp on lpaprop.tfklpaprtp = lpaprtp.tpklpaprtp left join 
    PATHWAY_lpasubr as lpasubr on lpaaddr.tfklpasubr = lpasubr.tpklpasubr left join
    PATHWAY_lpapnam as lpapnam on lpaprop.tpklpaprop = lpapnam.tfklpaprop 

where
    lpaprop.status in ('A', 'C') and 
    lpaaddr.addrtype = 'P' and
    lpaprtp.abbrev <> 'BASE' and
    lpaprop.tfklpacncl = 12