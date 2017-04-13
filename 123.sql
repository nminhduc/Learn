select banmo,ho_opera_table, groupid, hfl_deptid, sum(soluong) as soluong, sum(sumservprice) as sumservprice, 
	sum(loai1) as loai1,
	sum(loai2) as loai2, sum(loai3) as loai3, sum(loaidb) as loaidb, sum(loainsoi) as loainsoi
from 
(
select ho_opera_table, banmo,
	deptid, 
	(select hfg_name from hms_feegroup where hfg_id=groupid) as hfl_deptid,docno, hp_surname||' '||hp_midname||' '||hp_firstname as patname, 
	date(orderdate) as orderdate,    	   
	groupid,pcmsname, unit, sum(soluong) as soluong,  sum(loai1) as loai1,
	sum(loai2) as loai2, sum(loai3) as loai3, sum(loaidb) as loaidb, sum(loainsoi) as loainsoi,  
	servprice, insprice,sum(soluong * servprice) as  sumservprice, sum(soluong * insprice) as suminsprice  
from (   		
	select ho_opera_table, hst_name as banmo,  ho_deptid as deptid, date(ho_orderdate) as orderdate,
		ho_docno  as docno,
		hfl_deptid,hfl_groupid as groupid,hfl_name as pcmsname,hfl_unit as unit,   	
		sum(ho_qty) as soluong, 
		case when hfl_groupid = 'B4100' then sum(ho_qty) else 0 end as loai1, 
		case when hfl_groupid = 'B4200' then sum(ho_qty) else 0 end as loai2, 
		case when hfl_groupid = 'B4300' then sum(ho_qty) else 0 end as loai3,
		case when hfl_groupid = 'B4400' then sum(ho_qty) else 0 end as loaidb,
		case when hfl_groupid = 'B4500' then sum(ho_qty) else 0 end as loainsoi, 
		hfl_servprice as servprice, hfl_insprice as insprice  	
	from hms_operation   		
	left join hms_feelist on (hfl_feeid=ho_itemid)  	
	left join hms_surgery_table on(ho_opera_table=hst_idx)
	where  date(ho_orderdate) between date('2014/05/01 00:01:00') and date('2014/05/31 23:59:00')  
		and ho_status in('T', 'S') 		
		--and ho_pdeptid='GMHS'
		and ho_deptid = 'GMHS'
		--and ho_opera_table >0
		and substr(hfl_groupid, 1, 2) = 'B4'
		--and ho_payment != 'P'
		and ho_docno  in (select hpo_docno from hms_pharmacyorder where hpo_stockid = 54 and date(hpo_orderdate) between date('2014/05/01 00:01:00') and date('2014/05/31 23:59:00')  )
		--and ho_drugoid not in  (select hpo_orderid from hms_pharmacyorder where hpo_stockid = 54 and date(hpo_orderdate) between date('2014/05/01 00:01:00') and date('2014/05/31 23:59:00')  )
	group by hfl_deptid,groupid,pcmsname,hfl_unit,servprice, insprice, docno, orderdate, ho_deptid, ho_opera_table , banmo
) as tb1   
left join hms_doc on (docno = hd_docno)  
left join hms_patient on (hp_patientno = hd_patientno)  
where 1=1   
group by hfl_deptid,groupid,pcmsname,unit, servprice, insprice, docno, patname, orderdate, deptid, banmo, ho_opera_table
order by ho_opera_table,  groupid
) as tbltong
Group by ho_opera_table, groupid, hfl_deptid, banmo
order by ho_opera_table,banmo, hfl_deptid

