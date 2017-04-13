--copy 
--(
--select sum(soluong)
--from
--(

select ngay,  docno, phieu, khoa, pname, yearofbirth, age, sex,issuedate,  drugname,pmi_id,  unit, 
	sum(qty) as soluong, sum(hoantra) as hoantra,  sum(money) as money, unitprice
	
from
(
 SELECT hd_docno as docno, hpo_sheetidx as phieu, hpo_deptid as khoa, pmi_id,  date(hpo_issuedate) as ngay, 
 	trim(hp_surname||' '||hp_midname||' '||hp_firstname) as pname,
 	date_part('year', hp_birthdate) as yearofbirth,
 	hms_getage(date(hd_admitdate), hp_birthdate) as age,
 	hp_sex as sex,
 	date(hpo_issuedate) as issuedate, pmi_name as drugname, 
	pmi_unit as unit, 
	hpol_issueqty as qty,
	hpol_returnqty as hoantra,
--	hpol_orderqty as qty, 
	pmsi_vatprice as unitprice,
	sum(hpol_issueqty*pmsi_vatprice) as money
 FROM hms_patient
 LEFT JOIN hms_doc ON(hd_patientno=hp_patientno)
 LEFT JOIN hms_pharmacyorder ON(hpo_docno=hd_docno)
 LEFT JOIN hms_pharmacyorder_line ON(hpo_orderid=hpol_orderid)
 LEFT JOIN pms_stockitems ON(pmsi_id=hpol_sitemid) 
 LEFT JOIN pms_items ON(pmi_id=pmsi_itemid) 
 WHERE   1=1
	 and hpo_stockid=3 
	--and hpo_status = 'I' 
	and date(hpo_issuedate) between date('2014-05-01') and date('2014-05-31') 
	and pmi_id in ('GLI00002')   
	and hpo_deptid = 'NOI3' 
	and hpo_sheetidx = 'DT14000225' 
	and hpo_docno = 143009873
GROUP BY docno, pname, yearofbirth, age, sex, drugname, qty, unit, unitprice, phieu, issuedate, hpo_deptid, pmi_id, ngay
--having hpol_issueqty>0 
 ORDER BY issuedate, phieu
 
 ) as tbl
 GROUP BY docno,  phieu, khoa, pname, yearofbirth, age, sex,issuedate,  drugname, unit, unitprice, pmi_id, ngay
 ORDER BY  phieu, khoa, pname


 --) as tong
 --) to '/tmp/GlivecT6.txt'