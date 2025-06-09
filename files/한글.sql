SELECT add_vertica_options( 'EE', 'ENABLE_JOIN_SPILL' );

copy dtsch.fta_dpayslip  from local '/PROD_CL_DB_Backup/poc_data/dtsch/fta_dpayslip_0.sam'  delimiter '^F' enclosed by '"' NULL 'NULL' exceptions '/home/vertica/fta_dpayslip_0.exe' rejected data '/home/vertica/fta_dpayslip_0.rej' ;

copy dtsch.fta_dpayslip from local '/PROD_CL_DB_Backup/poc_data/dtsch/fta_dpayslip_1.sam'  delimiter '^F' enclosed by '"' NULL 'NULL' exceptions '/home/vertica/fta_dpayslip_1.exe' rejected data '/home/vertica/fta_dpayslip_1.rej' ;

