
-- theo ban 
select sum(hfe_cost) as tongPT, soban, 
	0 as tongtronggoi, 0 as sobantronggoi

from (
	select ho_docno, hfe_unitprice, hfe_cost, ho_opera_table as soban
	from hms_operation 
	where ho_pdeptid ='GMHS'
	and date(ho_orderdate) between date('2014/06/01') and date('2014/06/30')  
	and ho_status in ('S', 'T')
	order by ho_opera_table, ho_docno
) as tbltong
group by soban
union all
--trong goi
select 
	sum(thanhtien) as tongtronggoi, hpo_docno
from (

select hpo_docno,  hpol_name, hpol_unitprice as gia, hpol_orderqty as soluong, hpol_orderqty*hpol_unitprice as thanhtien, hpo_stockid
 from hms_pharmacyorder 
left join hms_pharmacyorder_line ON (hpo_orderid = hpol_orderid)
 where 1= 1
 -- hpo_docno = 143017960  
 and hpo_type = 'M' and hpo_deptid = 'GMHS'
  and  hpo_stockid = 54
  and date(hpo_orderdate) between date('2014-06-01') and date('2014-06-30')

  union all
  select ho_docno, hfe_unitprice as gia, ho_qty as soluong, hfe_cost, ho_opera_table as soban
	from hms_operation 
	where ho_pdeptid ='GMHS'
	and date(ho_orderdate) between date('2014/06/01') and date('2014/06/30')  
	and ho_status in ('S', 'T')
	order by ho_opera_table, ho_docno
  

  ) as tbl
  group by hpo_docno
  order by hpo_docno
 
 




