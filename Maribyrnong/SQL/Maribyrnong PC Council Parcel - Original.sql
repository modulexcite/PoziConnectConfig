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
    case auprparc.pcl_flg
        when 'R' then 'A'
        when 'P' then 'P'
    end as status,
    '' as crefno,
    case
        when auprparc.ttl_no1 like '%PT%' then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde = 2 then 'RP'
        when auprparc.ttl_cde = 3 then 'PS'
        when auprparc.ttl_cde = 4 then 'CP'
        when auprparc.ttl_cde = 6 then 'LP'
        when auprparc.ttl_cde = 7 then 'CS'
        when auprparc.ttl_cde = 8 then 'TP'
        when auprparc.ttl_cde = 9 then 'SP'
        when auprparc.ttl_cde = 10 then 'CP'
        when auprparc.ttl_cde = 1 then
            case
                when auprparc.fmt_ttl like '%CP%' then 'CP'
                when auprparc.fmt_ttl like '%LP%' then 'LP'
                when auprparc.fmt_ttl like '%PC%' then 'PC'
                when auprparc.fmt_ttl like '%PS%' then 'PS'
                when auprparc.fmt_ttl like '%RP%' then 'RP'
                when auprparc.fmt_ttl like '%SP%' then 'SP'
                when auprparc.fmt_ttl like '%TP%' then 'TP'
                else ''
            end
        else ''
    end ||
        case
            when auprparc.ttl_cde = 11 then ''
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
            else ''
        end as plan_number,
    case
        when auprparc.ttl_cde = 2 then 'RP'
        when auprparc.ttl_cde = 3 then 'PS'
        when auprparc.ttl_cde = 4 then 'CP'
        when auprparc.ttl_cde = 6 then 'LP'
        when auprparc.ttl_cde = 7 then 'CS'
        when auprparc.ttl_cde = 8 then 'TP'
        when auprparc.ttl_cde = 9 then 'SP'
        when auprparc.ttl_cde = 10 then 'CP'
        when auprparc.ttl_cde = 1 then
            case
                when auprparc.fmt_ttl like '%CP%' then 'CP'
                when auprparc.fmt_ttl like '%LP%' then 'LP'
                when auprparc.fmt_ttl like '%PC%' then 'PC'
                when auprparc.fmt_ttl like '%PS%' then 'PS'
                when auprparc.fmt_ttl like '%RP%' then 'RP'
                when auprparc.fmt_ttl like '%SP%' then 'SP'
                when auprparc.fmt_ttl like '%TP%' then 'TP'
                else ''
            end
        else ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde = 11 then ''
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
        else ''
    end as plan_numeral,
    case
        when auprparc.ttl_no1 = '0' then ''
        when auprparc.ttl_cde <> 11 then ifnull ( trim ( replace ( auprparc.ttl_no1 , 'PT' , '' ) ) , '' )
        else ''
    end as lot_number,
    case
        when auprparc.ttl_no1 = '0' then ''
        when auprparc.ttl_cde = 11 then ifnull ( trim ( replace ( auprparc.ttl_no1 , 'PT' , '' ) ) , '' )
        else ''
    end as allotment,
    case
        when auprparc.ttl_cde = 11 then ifnull ( trim ( auprparc.ttl_no2 ) , '' )
        else ''
    end as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when auprparc.ttl_cde = 11 then ifnull ( trim ( replace ( auprparc.ttl_no5 , 'NUA' , '' ) ) , '' )
        else ''
    end as parish_code,
    case
        when auprparc.ttl_no5 = '3416B' then '3416B'
        when auprparc.ttl_no5 = '3416C' then '3416C'
        when auprparc.ttl_no5 = '3416D' then '3416D'
        else ''
    end as township_code,
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