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
    cast ( auprparc.ass_num as varchar ) as propnum,
    case 
        when auprparc.pcl_flg = 'R' then 'A'
        when auprparc.pcl_flg = 'P' then 'P'
    end as status,
    auprparc.pcl_num as crefno,
    case       
        when auprparc.ttl_cde = 2 then 'P'
        when auprparc.ttl_cde = 4 then 'p'
        when auprparc.ttl_cde = 6 then 'P'        
        when auprparc.ttl_cde = 8 then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde in ( 13 , 14 ) then 'RP'
        when auprparc.ttl_cde = 3 then 'PS'
        when auprparc.ttl_cde = 11 then 'PC'
        when auprparc.ttl_cde = 5 then 'LP'
        when auprparc.ttl_cde = 16 then 'CS'
        when auprparc.ttl_cde = 1 then 'TP'
        when auprparc.ttl_cde = 15 then 'SP'
        when auprparc.ttl_cde = 17 then 'CP'        
        when auprparc.ttl_cde = 2 then 'TP'
        when auprparc.ttl_cde = 4 then 'PS'
        when auprparc.ttl_cde = 6 then 'LP'
        when auprparc.ttl_cde = 12 then 'PC'
        else ''
    end ||
        case
            when auprparc.ttl_cde in ( '7' , '8') then ''
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
            else ''
        end as plan_number,
    case
        when auprparc.ttl_cde in ( 13 , 14 ) then 'RP'
        when auprparc.ttl_cde = 3 then 'PS'
        when auprparc.ttl_cde = 11 then 'PC'
        when auprparc.ttl_cde = 5 then 'LP'
        when auprparc.ttl_cde = 16 then 'CS'
        when auprparc.ttl_cde = 1 then 'TP'
        when auprparc.ttl_cde = 15 then 'SP'
        when auprparc.ttl_cde = 17 then 'CP'        
        when auprparc.ttl_cde = 2 then 'TP'
        when auprparc.ttl_cde = 4 then 'PS'
        when auprparc.ttl_cde = 6 then 'LP'
        when auprparc.ttl_cde = 12 then 'PC'
        else ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde in ( '7' , '8') then ''
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
        else ''
    end as plan_numeral,
    case
        when auprparc.ttl_no1 = '0' then ''
        when auprparc.ttl_cde <> 7 then ifnull ( trim ( replace ( auprparc.ttl_no1 , 'PT' , '' ) ) , '' )
        else ''
    end as lot_number,
    case
        when auprparc.ttl_no1 = '0' then ''
        when auprparc.ttl_cde in ( '7' , '8') then ifnull ( trim ( replace ( auprparc.ttl_no1 , 'PT' , '' ) ) , '' )
        else ''
    end as allotment,
    case
        when auprparc.ttl_cde in ( '7' , '8') then ifnull ( trim ( auprparc.ttl_no3 ) , '' )
        else ''
    end as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when auprparc.ttl_cde in ( '7' , '8') then ifnull ( trim ( replace ( auprparc.ttl_no5 , 'NUA' , '' ) ) , '' )
        else ''
    end as parish_code,
    '' as township_code,
    fmt_ttl as summary,
    '341' as lga_code
from
    authority_auprparc as auprparc
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num not in ( '' , '0' )
order by
    ass_num
)