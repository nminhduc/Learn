--select sum(cost)
--from
--(
 SELECT  hd_docno as docno,ngayduyephi,hfi_receiver,(select su_name from sys_user where hfi_receiver = su_userid limit 1) as user, hfi_object,
 	trim(hp_surname||' '||hp_midname||' '||hp_firstname) as pname,
 	date_part('year', hp_birthdate) as birthyear,
	(select distinct ss_desc from sys_sel where ss_id='sys_sex' and ss_code=hp_sex) as sex, 
	date(hd_admitdate) as examdate, 
 	hd_icd as icd10,
 	hfi_recvno as invoiceno,
 	sum(cost-glivec-drugfeevt)/1000 as cost,
	sum(cost-glivec)/1000 as noglivec,
 	sum(examfee)/1000 as examfee ,
	sum(0)/1000 as giuongfee,
	sum(drugfee)/1000 as drugfee,
 	sum(hhvsfee)/1000 as hhvsfee, 
 	sum(sinhhoafee)/1000 as sinhhoafee, 
 	sum(vtthfee)/1000 as vtthfee, 
 	sum(sieuam)/1000 as sieuam,
 	sum(xquang)/1000 as xquang,
 	sum(xetnghiemtebao)/1000 as xetnghiemtebao, 
 	sum(0)/1000 as gpblfee,
 	sum(noisoifee)/1000 as noisoifee, 
 	sum(dientiemfee)/1000 as dientiemfee, 
 	sum(cnhhfee)/1000 as cnhhfee, 
 	sum(thuthuatfee)/1000 as thuthuatfee, 
 	sum(tieuphaufee)/1000 as tieuphaufee, 
 	sum(maufee)/1000 as maufee,
 	sum(0)/1000 as thuocngoaidm,
 	sum(dongyfee)/1000 as dongyfee, 
 	sum(0)/1000 as vsttruongfee, 
 	sum(0)/1000 as hoichan, 
 	sum(CT32fee)/1000 as CT32fee, 
 	sum(CT64fee)/1000 as CT64fee, 
 	sum(MRIfee)/1000 as MRIfee, 
 	sum(spect)/1000 as spect, 
 	sum(otherfee)/1000 as otherfee ,
 	sum(discount)/1000 as inspaid ,
 	sum(patdebt)/1000 as patdebt, 
 	sum(patpaid)/1000 as patpaid 
 FROM (
     SELECT 
 	hfe_deptid,hfi_recvdate,date(hfi_recvdate) as ngayduyephi, hfi_receiver,hfi_object, 
 	hfi_class,
 	hfi_docno,hfi_recvno, 
 	hfe_group as groupid,
 	hfe_qty as qty,
 	hfe_unitprice	as unitprice,
 	hfe_cost  as cost,
 	hfe_difcost as difcost,
 	hfe_qty*hfe_unitprice-hfe_difcost as inscost,
	case when substr(hfe_group, 1, 2) in ('A1', 'A3') and hfe_itemid in ('GLI00001', 'GLI00002') then hfe_cost else 0 end as glivec,
 	case when hfe_group='D0000' then hfe_cost when hfe_group = 'D0002' then hfe_cost else 0 end as examfee,
 	case when substr(hfe_group, 1, 2) in ('A1', 'A3') and hfe_itemid not in ('GLI00001', 'GLI00002') then hfe_cost else 0 end as drugfee,
 	case when substr(hfe_group, 1, 2) in ('A1', 'A3') and hfe_itemid in ('NOL00002') then hfe_cost else 0 end as drugfeevt,
 	case when substr(hfe_group, 1, 3) in ('B11', 'B15') then hfe_cost else 0 end as hhvsfee,
 	case when substr(hfe_group, 1, 3) in ('B12', 'B13') then hfe_cost else 0 end as sinhhoafee,
 	case when substr(hfe_group, 1, 2)='A9' then hfe_cost else 0 end as vtthfee,
 	case when substr(hfe_group, 1, 3)in ('B24', 'B25') then hfe_cost else 0 end as sieuam,
 	case when substr(hfe_group, 1, 3)='B21' then hfe_cost else 0 end as xquang,
 	case when substr(hfe_group, 1, 3)='B1E' then hfe_cost else 0 end as xetnghiemtebao,
 	case when substr(hfe_group, 1, 2)='B3'then hfe_cost else 0 end as noisoifee,
 	case when substr(hfe_group, 1, 3)='B33'then hfe_cost else 0 end as dientiemfee,
 	case when substr(hfe_group, 1, 3)='B35'then hfe_cost else 0 end as cnhhfee,
	case when substr(hfe_group, 1, 3)='B26'then hfe_cost else 0 end as thuthuatfee,
	case when substr(hfe_group, 1, 3)='B57'then hfe_cost else 0 end as tieuphaufee,
	case when substr(hfe_group, 1, 2)='A2'then hfe_cost else 0 end as maufee,
	case when substr(hfe_group, 1, 2)='A3'then hfe_cost else 0 end as dongyfee,
	case when substr(hfe_group, 1, 3)='B27'then hfe_cost else 0 end as CT32fee,
	case when substr(hfe_group, 1, 3)='B22' and hfe_itemid not in ('B2200040') then hfe_cost else 0 end as CT64fee,
	case when  hfe_itemid  in ('B2200040') then hfe_cost else 0 end as hoichan,
	case when substr(hfe_group, 1, 3)='A23'then hfe_cost else 0 end as MRIfee,
	case when substr(hfe_group, 1, 3)='B1C'then hfe_cost else 0 end as spect,
 	case when hfe_group='F0000' then hfe_cost else 0 end as otherfee,
 	hfe_discount as discount,
 	hfe_patpaid as patpaid,
 	hfe_difpaid as difpaid,
 	hfe_patdebt as patdebt
    FROM hms_fee_invoice
    LEFT JOIN hmsv_fee ON(hfe_docno=hfi_docno and hfe_invoiceno = hfi_invoiceno)
    LEFT JOIN sys_dept ON(sd_id = hfe_deptid) 
    WHERE 1=1
     and sd_type ='KB' 
    and hfi_type ='P'
    and  hfi_class in('E','O') 
    and hfe_cost > 0 
    and hfi_recvdate between timestamp '2014-10-11 00:01' and timestamp '2014-10-20 23:00'
    and hfi_docno = 143042241 
   -- and hfi_receiver = 'huongthuy'
    -- %s  %s %s
 ) as tbl
LEFT JOIN hms_doc ON(hfi_docno=hd_docno)
LEFT JOIN hms_patient ON(hd_patientno=hp_patientno)
LEFT JOIN hms_object ON(ho_id=hd_object)
WHERE 1= 1
 GROUP BY docno, pname, birthyear, sex, icd10, invoiceno, examdate , hfi_recvdate, ngayduyephi, hfi_receiver, user, hfi_object
 HAVING sum(cost) > 0
 ORDER BY ngayduyephi, invoiceno, pname 
 --) as tong