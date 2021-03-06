select
    *,
    case
        when plan_number <> '' and lot_number = '' then plan_number
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_number
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_number
        when plan_number <> '' then lot_number || '\' || plan_number
        when ( parish_code <> '' or township_code <> '' ) then
            subdivision ||
            case when subdivision <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            portion ||
            case when portion <> '' and allotment <> '' then '~' else '' end ||
            allotment ||
            case when sec <> '' then '~' else '' end ||
            sec ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as spi,
    case
        when plan_numeral <> '' and lot_number = '' then plan_numeral
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_numeral
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_numeral
        when plan_numeral <> '' then lot_number || '\' || plan_numeral
        when ( parish_code <> '' or township_code <> '' ) then
            subdivision ||
            case when subdivision <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            portion ||
            case when portion <> '' and allotment <> '' then '~' else '' end ||
            allotment ||
            case when sec <> '' then '~' else '' end ||
            sec ||
            '\' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as simple_spi
from
(
select
    case
        when auprparc.ass_num in ( 310227 , 199380 , 310227 , 594440 , 594457 , 594465 , 594473 , 594481 , 594499 , 594507 , 594515 , 594523 , 594531 ) then 'NCPR'   
        else cast ( auprparc.ass_num as varchar )
    end as propnum,
    case auprparc.pcl_flg    
        when 'R' then 'A'        
        when 'P' then 'P'        
    end as status,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    case
        when auprparc.ttl_cde in ( 1 , 5 , 51 , 99 ) then
            case
                when trim ( auprparc.ttl_no1 ) is null then 
                    case
                        when trim ( auprparc.ttl_no2 ) is null then '' 
                        else 'P'
                    end
                else ''
            end    
        when auprparc.ttl_cde in ( 11 , 12 ) then 'P'
        else ''
    end as part,
    case auprparc.ttl_cde
        when 1 then 'PS'
        when 2 then 'PC'
        when 3 then 'RP'
        when 4 then 'SP'
        when 5 then 'LP'
        when 8 then 'CP'
        when 18 then 'TP'
        when 51 then 'PS'
        when 52 then 'PC'
        else ''
    end ||
        case    
            when null then ''
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 )        
            else ''
        end as plan_number,
    case auprparc.ttl_cde
        when 1 then 'PS'
        when 2 then 'PC'
        when 3 then 'RP'
        when 4 then 'SP'
        when 5 then 'LP'
        when 8 then 'CP'
        when 18 then 'TP'
        when 51 then 'PS'
        when 52 then 'PC'
        else ''
    end as plan_prefix,
    case    
        when null then ''
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 )        
        else ''
    end as plan_numeral,
    case
        when auprparc.ttl_cde in ( 3 , 4 , 6 , 8 , 16 , 18 ) then ifnull ( trim ( auprparc.ttl_no1 ) , '' )
        when auprparc.ttl_cde in ( 1, 5 , 51 ) then ifnull ( trim ( auprparc.ttl_no1 ) , ifnull ( trim ( auprparc.ttl_no2 ) , '' ) )
        else ''
    end as lot_number,    
    case
        when auprparc.ttl_cde in ( 9 , 10 , 11 , 12 ) then ifnull ( trim ( auprparc.ttl_no1 ) , '' )
        else ''
    end as allotment,
    case
        when trim ( auprparc.ttl_no4 ) = 'NONE' then '' 
        when auprparc.ttl_cde in ( 9 , 10 , 11 ) then ifnull ( trim ( auprparc.ttl_no4 ) , '' )
        else ''
    end as sec,
    '' as block,
    '' as portion,
    case
        when ( auprparc.ttl_cde = 16 ) then trim ( auprparc.ttl_in5 )
        else ''
    end as subdivision,
    case auprparc.udn_cd5
        when 1  then '2311'
        when 2  then '2516'
        when 3  then '2528'
        when 4  then '2761'
        when 5  then '2927'
        when 6  then '3061'
        when 7  then '3164'
        when 8  then '3431'
        when 9  then '3948'
        when 10 then '3797'
        when 12 then '2265'
        when 13 then '2404'
        when 14 then '3095'
        when 15 then '3201'
        when 16 then '3375'
        when 17 then '3552'
        when 18 then '3651'
        else ''
    end as parish_code,
    case auprparc.udn_cd5
        when 1 then '5781'
        when 3 then '5515'
        when 9 then '5791'
        else ''
    end as township_code,
    fmt_ttl as summary,
    '344' as lga_code
from
    authority_auprparc as auprparc
where
    auprparc.pcl_flg in ( 'R' , 'P' )
order by
    ass_num
)