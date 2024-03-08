%let pgm=utl-overall-frequency-of-values-over-all-columns-and-rows-simutaneously-sas-r-python;

Overall frequency of values over all columns and rows simutaneously sas r python;

This is best done with R

   0  sas hash
      Keintz, Mark
      mkeintz@outlook.com
   1  r using table function with stattransfer
   2  r pure sql solution with stattransfer
   3  sas gather macro
   4  python pure sql with stattransfer


github
https://tinyurl.com/44uzxfkm
https://github.com/rogerjdeangelis/utl-overall-frequency-of-values-over-all-columns-and-rows-simutaneously-sas-r-python

macros (stattransfer array do_over varlist untranspose macros)
https://tinyurl.com/y9nfugth
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

see
https://goo.gl/d2FcXi
http://stackoverflow.com/questions/43786211/count-number-of-times-a-value-appears-in-the-entire-dataset-sas


/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/


/************************************************************************************************************************************/
/*                                             |                                                               |                    */
/*             INPUT                           |                        PROCESS                                |      OUTPUT        */
/*                                             |                                                               |                    */
/*  SD1.HAVE total obs=3                       | 0 SAS HASH                                                    |   VALUE    FREQ    */
/*                                             | ==========                                                    |                    */
/*                                             |                                                               |    123       3     */
/*  Obs     XX     YY     ZZ                   | data _null_;                                                  |    234       2     */
/*                                             |                                                               |    345       2     */
/*   1     123    456    234                   |   set sd1.have end=end_of_have;                               |    456       2     */
/*   2     456    123    345                   |                                                               |                    */
/*   3     234    345    123                   |   call missing(value,freq);                                   |                    */
/*                                             |                                                               |                    */
/*  Some of the solutions use a macro array    |   if _n_=1 then do;                                           |                    */
/*                                             |     declare hash h (ordered:'a');                             |                    */
/*  %array(_col,values=%utl_varlist(sd1.have));|       h.definekey('value');                                   |                    */
/*                                             |       h.definedata('value','freq');                           |                    */
/*  %put &=_col1; /*_  COL1 = XX   */          |       h.definedone();                                         |                    */
/*  %put &=_col2; /*  _COL2 = YY   */          |   end;                                                        |                    */
/*  %put &=_col3; /*  _COL3 = ZZ   */          |   array val xx yy zz ;                                        |                    */
/*  %put &=_coln; /*  _COLN = 3    */          |                                                               |                    */
/*                                             |   do over val;                                                |                    */
/*                                             |     if h.find(key:val)^=0 then freq=0;                        |                    */
/*                                             |     freq=freq+1;                                              |                    */
/*                                             |     h.replace(key:val,data:val,data:freq);                    |                    */
/*  Note: In R factors have to be              |   end;                                                        |                    */
/*        converted to character               |                                                               |                    */
/*        Only when using table function       |   if end_of_have then                                         |                    */
/*                                             |        h.output(dataset:'want');                              |                    */
/*  acros used                                 |                                                               |                    */
/*                                             | run;quit;                                                     |                    */
/* gather   Alea Iacta   aleaiacta95@gmail.com |                                                               |                    */
/* array    Ted Clay,    tclay@ashlandhome.net |                                                               |                    */
/* varlist  Søren Lassen s.lassen@post.tele.dk |                                                               |                    */
/*                                             |                                                               |                    */ *
/*                                             | 1 R USING STATTRANSFER                                        |                    */
/*                                             | ======================                                        | TMP.WANT total     */
/*                                             |                                                               |                    */
/*                                             | %utl_rbegin;                                                  | ROWNAMES HAVE FREQ */
/*                                             | parmcards4;                                                   |                    */
/*                                             | library(haven)                                                |    1    123    3   */
/*                                             | have<-as.matrix(                                              |    2    234    2   */
/*                                             |   read_sas("d:/sd1/have.sas7bdat"));                          |    3    345    2   */
/*                                             | want <- as.data.frame(table(have));                           |    4    456    2   */
/*                                             | want$have<-as.character(want$have);                           |                    */
/*                                             | source("c:/temp/fn_tosas9.R")                                 |                    */
/*                                             | fn_tosas9(dataf=want)                                         |                    */
/*                                             | ;;;;                                                          |                    */
/*                                             | %utl_rend;                                                    |                    */
/*                                             |                                                               |                    */
/*                                             | libname tmp "c:/temp";                                        |                    */
/*                                             | proc print data=tmp.want;                                     |                    */
/*                                             | run;quit;                                                     |                    */
/*                                             |                                                               |                    */
/*                                             |                                                               |                    */
/*                                             |                                                               |                    */
/*                                             | 2 R PURE SQL SOLUTION STATTRANSFER                            | WANT               */
/*                                             | ==================================                            |                    */
/*                                             |                                                               | ROWNAMES  VAL CNT  */
/*                                             | %utl_submit_r64x("                                            |                    */
/*                                             | library(haven);                                               |     1     123  3   */
/*                                             | library(sqldf);                                               |     2     234  2   */
/*                                             | have<-                                                        |     3     345  2   */
/*                                             |   read_sas('d:/sd1/have.sas7bdat');                           |     4     456  2   */
/*                                             | have;                                                         |                    */
/*                                             | want <- sqldf('                                               |                    */
/*                                             |   select                                                      |                    */
/*                                             |      val                                                      |                    */
/*                                             |     ,count(val) as cnt                                        |                    */
/*                                             |   from                                                        |                    */
/*                                             |     (%do_over(_col,phrase=%str(                               |                    */
/*                                             |        select                                                 |                    */
/*                                             |            ? as val                                           |                    */
/*                                             |        from                                                   |                    */
/*                                             |            have), between=union all))                         |                    */
/*                                             |   group                                                       |                    */
/*                                             |      by val                                                   |                    */
/*                                             |   ');                                                         |                    */
/*                                             | source('c:/temp/fn_tosas9.R');                                |                    */
/*                                             | fn_tosas9(dataf=want);                                        |                    */
/*                                             | ");                                                           |                    */
/*                                             |                                                               |                    */
/*                                             | libname tmp "c:/temp";                                        |                    */
/*                                             | proc print data=tmp.want;                                     |                    */
/*                                             | run;quit;                                                     |                    */
/*                                             |                                                               |                    */
/*                                             |                                                               |                    */
/*                                             | 3 SAS GATHER MACRO STATTRANSFER                               |                    */
/*                                             | ===============================                               |                    */
/*                                             |                                                               | VAL    CNT         */
/*                                             | %utl_gather2(sd1.have,var,val                                 |                    */
/*                                             |  ,,lonTbl,SASFormats=2.);                                     | 123     3          */
/*                                             |                                                               | 234     2          */
/*                                             | proc sql;                                                     | 345     2          */
/*                                             |   create                                                      | 456     2          */
/*                                             |      table want as                                            |                    */
/*                                             |   select                                                      |                    */
/*                                             |      val                                                      |                    */
/*                                             |     ,count(val) as cnt                                        |                    */
/*                                             |   from                                                        | PYTHON             */
/*                                             |      lonTbl                                                   |                    */
/*                                             |   group                                                       |      val  cnt      */
/*                                             |      by val                                                   | 0  123.0    3      */
/*                                             | ;quit;                                                        | 1  234.0    2      */
/*                                             |                                                               | 2  345.0    2      */
/*                                             |                                                               | 3  456.0    2      */
/*                                             |  4 PYTHON PURE SQL STATTRANSFER                               |                    */
/*                                             |  ==============================                               | BACK TO SAS        */
/*                                             |                                                               |                    */
/*                                             |  %utl_submit_py64_310("                                       | Obs    VAL    CNT  */
/*                                             |  import os;                                                   |                    */
/*                                             |  import sys;                                                  |  1     123     3   */
/*                                             |  import subprocess;                                           |  2     234     2   */
/*                                             |  import time;                                                 |  3     345     2   */
/*                                             |  from os import path;                                         |  4     456     2   */
/*                                             |  import pandas as pd;                                         |                    */
/*                                             |  import xport;                                                |                    */
/*                                             |  import xport.v56;                                            |                    */
/*                                             |  import pyreadstat as ps;                                     |                    */
/*                                             |  import numpy as np;                                          |                    */
/*                                             |  from pandasql import sqldf;                                  |                    */
/*                                             |  mysql = lambda q: sqldf(q, globals());                       |                    */
/*                                             |  from pandasql import PandaSQL;                               |                    */
/*                                             |  pdsql = PandaSQL(persist=True);                              |                    */
/*                                             |  sqlite3conn = next(pdsql.conn.gen).connection.connection;    |                    */
/*                                             |  sqlite3conn.enable_load_extension(True);                     |                    */
/*                                             |  sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll');|                    */
/*                                             |  mysql = lambda q: sqldf(q, globals());                       |                    */
/*                                             |  have, meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat');       |                    */
/*                                             |  print(have);                                                 |                    */
/*                                             |  want = pdsql('''                                             |                    */
/*                                             |       select                                                  |                    */
/*                                             |          val                                                  |                    */
/*                                             |         ,count(val) as cnt                                    |                    */
/*                                             |        from                                                   |                    */
/*                                             |         (%do_over(_col,phrase=%str(                           |                    */
/*                                             |            select                                             |                    */
/*                                             |                ? as val                                       |                    */
/*                                             |            from                                               |                    */
/*                                             |                have), between=union all))                     |                    */
/*                                             |       group                                                   |                    */
/*                                             |          by val                                               |                    */
/*                                             |  ''');                                                        |                    */
/*                                             |  print(want);                                                 |                    */
/*                                             |  exec(open('c:/temp/fn_tosas9.py').read());                   |                    */
/*                                             |  fn_tosas9(                                                   |                    */
/*                                             |     want                                                      |                    */
/*                                             |    ,dfstr='want'                                              |                    */
/*                                             |     ,timeest=3                                                |                    */
/*                                             |     );                                                        |                    */
/*                                             |  ");                                                          |                    */
/*                                             |                                                               |                    */
/*                                             |  libname tmp "c:/temp";                                       |                    */
/*                                             |  proc print data=tmp.want;                                    |                    */
/*                                             |  run;quit;                                                    |                    */
/*                                             |                                                               |                    */
/************************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input xx yy zz;
cards4;
123 456 234
456 123 345
234 345 123
;;;;
run;quit;

Some of the solutions use a macro array

%array(_col,values=%utl_varlist(sd1.have));


/**************************************************************************************************************************/
/*                                                                                                                        */
/* Obs     XX     YY     ZZ                                                                                               */
/*                                                                                                                        */
/*  1     123    456    234                                                                                               */
/*  2     456    123    345                                                                                               */
/*  3     234    345    123                                                                                               */
/*                                                                                                                        */
/* %put &=_col1; /*_  COL1 = XX   */                                                                                      */
/* %put &=_col2; /*  _COL2 = YY   */                                                                                      */
/* %put &=_col3; /*  _COL3 = ZZ   */                                                                                      */
/* %put &=_coln; /*  _COLN = 3    */                                                                                      */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                    _               _
 / _ \   ___  __ _ ___  | |__   __ _ ___| |__
| | | | / __|/ _` / __| | `_ \ / _` / __| `_ \
| |_| | \__ \ (_| \__ \ | | | | (_| \__ \ | | |
 \___/  |___/\__,_|___/ |_| |_|\__,_|___/_| |_|

*/

data have;
input xx yy zz;
cards4;
123 456 234
456 123 345
234 345 123
;;;;
run;quit;

data _null_;

  set have end=end_of_have;

  call missing(value,freq);

  if _n_=1 then do;
    declare hash h (ordered:'a');
      h.definekey('value');
      h.definedata('value','freq');
      h.definedone();
  end;
  array val xx yy zz ;

  do over val;
    if h.find(key:val)^=0 then freq=0;
    freq=freq+1;
    h.replace(key:val,data:val,data:freq);
  end;

  if end_of_have then
       h.output(dataset:'want');

run;quit;

/*              _        _   _                        __
/ |  _ __   ___| |_ __ _| |_| |_ _ __ __ _ _ __  ___ / _| ___ _ __
| | | `__| / __| __/ _` | __| __| `__/ _` | `_ \/ __| |_ / _ \ `__|
| | | |    \__ \ || (_| | |_| |_| | | (_| | | | \__ \  _|  __/ |
|_| |_|    |___/\__\__,_|\__|\__|_|  \__,_|_| |_|___/_|  \___|_|

*/


%utl_rbegin;
parmcards4;
library(haven)
have<-as.matrix(
  read_sas("d:/sd1/have.sas7bdat"))
want <- as.data.frame(table(have))
want$have<-as.character(want$have);
want
str(have);
source("c:/temp/fn_tosas9.R")
fn_tosas9(dataf=want)
;;;;
%utl_rend;

libname tmp "c:/temp";
proc print data=tmp.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* Obs    ROWNAMES    HAVE    FREQ                                                                                        */
/*                                                                                                                        */
/*  1         1       123       3                                                                                         */
/*  2         2       234       2                                                                                         */
/*  3         3       345       2                                                                                         */
/*  4         4       456       2                                                                                         */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                                            _
|___ \   _ __   _ __  _   _ _ __ ___   ___  __ _| |
  __) | | `__| | `_ \| | | | `__/ _ \ / __|/ _` | |
 / __/  | |    | |_) | |_| | | |  __/ \__ \ (_| | |
|_____| |_|    | .__/ \__,_|_|  \___| |___/\__, |_|
               |_|                            |_|
*/

%utl_submit_r64x("
library(haven);
library(sqldf);
have<-
  read_sas('d:/sd1/have.sas7bdat');
have;
want <- sqldf('
  select
     val
    ,count(val) as cnt
  from
    (%do_over(_col,phrase=%str(
       select
           ? as val
       from
           have), between=union all))
  group
     by val
  ');
source('c:/temp/fn_tosas9.R');
fn_tosas9(dataf=want);
");

libname tmp "c:/temp";
proc print data=tmp.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* R                                                                                                                      */
/*                                                                                                                        */
/* # A tibble: 3 x 3                                                                                                      */
/*      XX    YY    ZZ                                                                                                    */
/*   <dbl> <dbl> <dbl>                                                                                                    */
/* 1   123   456   234                                                                                                    */
/* 2   456   123   345                                                                                                    */
/* 3   234   345   123                                                                                                    */
/*                                                                                                                        */
/* SAS                                                                                                                    */
/*                                                                                                                        */
/* ROWNAMES    VAL    CNT                                                                                                 */
/*                                                                                                                        */
/*     1       123     3                                                                                                  */
/*     2       234     2                                                                                                  */
/*     3       345     2                                                                                                  */
/*     4       456     2                                                                                                  */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____                               _   _
|___ /   ___  __ _ ___    __ _  __ _| |_| |__   ___ _ __   _ __ ___   __ _  ___ _ __ ___
  |_ \  / __|/ _` / __|  / _` |/ _` | __| `_ \ / _ \ `__| | `_ ` _ \ / _` |/ __| `__/ _ \
 ___) | \__ \ (_| \__ \ | (_| | (_| | |_| | | |  __/ |    | | | | | | (_| | (__| | | (_) |
|____/  |___/\__,_|___/  \__, |\__,_|\__|_| |_|\___|_|    |_| |_| |_|\__,_|\___|_|  \___/
                         |___/
*/

%utl_gather2(sd1.have,var,val,,lonTbl,SASFormats=2.);

/*-- untranspose macro will also work --*/

proc sql;
  create
     table want as
  select
     val
    ,count(val) as cnt
  from
     lonTbl
  group
     by val
;quit;


/**************************************************************************************************************************/
/*                                                                                                                        */
/*  WORK.WANT total obs=4                                                                                                 */
/*                                                                                                                        */
/*  Obs    VAL    CNT                                                                                                     */
/*                                                                                                                        */
/*   1     123     3                                                                                                      */
/*   2     234     2                                                                                                      */
/*   3     345     2                                                                                                      */
/*   4     456     2                                                                                                      */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*  _                 _   _                             _
| || |    _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
| || |_  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
|__   _| | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
   |_|   | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
         |_|    |___/                                |_|
*/


proc datasets lib=work kill nodetails nolist;run;quit;
proc datasets lib=tmp nodetails nolist;delete want;run;quit;

%utlfkil(d:/xpt/res.xpt);

%utl_submit_py64_310("
import os;
import sys;
import subprocess;
import time;
from os import path;
import pandas as pd;
import xport;
import xport.v56;
import pyreadstat as ps;
import numpy as np;
from pandasql import sqldf;
mysql = lambda q: sqldf(q, globals());
from pandasql import PandaSQL;
pdsql = PandaSQL(persist=True);
sqlite3conn = next(pdsql.conn.gen).connection.connection;
sqlite3conn.enable_load_extension(True);
sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll');
mysql = lambda q: sqldf(q, globals());
have, meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat');
print(have);
want = pdsql('''
     select
        val
       ,count(val) as cnt
     from
       (%do_over(_col,phrase=%str(
          select
              ? as val
          from
              have), between=union all))
     group
        by val
''');
print(want);
exec(open('c:/temp/fn_tosas9.py').read());
fn_tosas9(
   want
   ,dfstr='want'
   ,timeest=3
   );
");

libname tmp "c:/temp";
proc print data=tmp.want;
run;quit;


/**************************************************************************************************************************/
/*                                                                                                                        */
/* SUCCESS: The process "st.exe" with PID 19312 has been terminated.                                                      */
/*                                                                                                                        */
/*       XX     YY     ZZ                                                                                                 */
/* 0  123.0  456.0  234.0                                                                                                 */
/* 1  456.0  123.0  345.0                                                                                                 */
/* 2  234.0  345.0  123.0                                                                                                 */
/*                                                                                                                        */
/*      val  cnt                                                                                                          */
/* 0  123.0    3                                                                                                          */
/* 1  234.0    2                                                                                                          */
/* 2  345.0    2                                                                                                          */
/* 3  456.0    2                                                                                                          */
/*                                                                                                                        */
/* OUTPUT                                                                                                                 */
/*                                                                                                                        */
/* Obs    VAL    CNT                                                                                                      */
/*                                                                                                                        */
/*  1     123     3                                                                                                       */
/*  2     234     2                                                                                                       */
/*  3     345     2                                                                                                       */
/*  4     456     2                                                                                                       */
/*                                                                                                                        */
/**************************************************************************************************************************/

REPO
------------------------------------------------------------------------------------------------------------------------------------------
https://github.com/rogerjdeangelis/distinct-counts-for_3200-variables-and_660-thousand-records-using-HASH-SQL-and-proc-freq
https://github.com/rogerjdeangelis/utl-append-and-split-tables-into-two-tables-one-with-common-variables-and-one-without-dosubl-hash
https://github.com/rogerjdeangelis/utl-are-the-files-identical-or-was-the-file-corrupted-durring-transfer-hash
https://github.com/rogerjdeangelis/utl-average-nap-time-for-three-babies-in-and-unsorted-table-using-a-hash-and-r
https://github.com/rogerjdeangelis/utl-count-distinct-compound-keys-using-sql-and-hash-algorithms
https://github.com/rogerjdeangelis/utl-create-a-list-of-male-students-at-achme-high-school-using_a_hash
https://github.com/rogerjdeangelis/utl-create-a-state-diagram-table-hash-corresp-and-transpose
https://github.com/rogerjdeangelis/utl-creating-two-tables-sum-of-weight-by-age-and-by-sex-using-a-hash-of-hashes_hoh
https://github.com/rogerjdeangelis/utl-deduping-six-hundred-million-records-with-one-million-unique-sql-hash
https://github.com/rogerjdeangelis/utl-deleting-multiple-rows-per-subject-with-condition-hash-and-dow
https://github.com/rogerjdeangelis/utl-dosubl-persistent-hash-across-datasteps-and-procedures
https://github.com/rogerjdeangelis/utl-elegant-hash-to-add-missing-weeks-by-customer
https://github.com/rogerjdeangelis/utl-excluding-patients-that-had-same-condition-pre-and-post-clinical-randomization-hash
https://github.com/rogerjdeangelis/utl-fast-efficient-hash-to-eliminate-duplicates-in-unsorted-grouped-data
https://github.com/rogerjdeangelis/utl-fast-join-small_1g-table_with-a-moderate_50gb-tables-hash-sql
https://github.com/rogerjdeangelis/utl-fast-normalization-and-join-using-vvaluex-arrays-sql-hash-untranspose-macro
https://github.com/rogerjdeangelis/utl-hash-applying-business-rules-by-observation-when-data-and-rules-are-in-the-same-table
https://github.com/rogerjdeangelis/utl-hash-filling-in-missing-gender-for-my-patients-appointments
https://github.com/rogerjdeangelis/utl-hash-of-hashes-left-join-four-tables
https://github.com/rogerjdeangelis/utl-hash-vs-summary-min-and-max-for-four-variables-by-region-for-l89-million-obs
https://github.com/rogerjdeangelis/utl-hash_which-columns-have-duplicate-values-across-rows
https://github.com/rogerjdeangelis/utl-in-memory-hash-output-shared-with-dosubl-hash-subprocess
https://github.com/rogerjdeangelis/utl-loop-through-one-table-and-find-data-in-next-table--hash-dosubl-arts-transpose
https://github.com/rogerjdeangelis/utl-make-new-column-with-the-previous-version-of-a-row-wps-hash-lag-and-r-code
https://github.com/rogerjdeangelis/utl-multitasking-the-hash-for-a-very-fast-distinct-ids
https://github.com/rogerjdeangelis/utl-no-need-for-sql-or-sort-merge-use-a-elegant-hash-excel-vlookup
https://github.com/rogerjdeangelis/utl-only-keep-groups-without-duplicated-accounts-hash-sql
https://github.com/rogerjdeangelis/utl-output-the-student-with-the-highest-grade-hash-defer-open
https://github.com/rogerjdeangelis/utl-remove-duplicate-words-from-a-sentence-hash-solution
https://github.com/rogerjdeangelis/utl-replicate-sets-of-rows-across-many-columns-elegant-hash
https://github.com/rogerjdeangelis/utl-sas-fcmp-hash-stored-programs-python-r-functions-to-find-common-words
https://github.com/rogerjdeangelis/utl-sharing-hash-storage-with-two-separate-datasteps-in-the-same-SAS-session
https://github.com/rogerjdeangelis/utl-simple-example-of-a-hash-of-hashes-hoh-to-split_a-table
https://github.com/rogerjdeangelis/utl-simplest-case-of-a-hash-or-sql-lookup
https://github.com/rogerjdeangelis/utl-two-table-join-benchmarks-hash-sortmerge-keyindex-and-sasfile
https://github.com/rogerjdeangelis/utl-two-techniques-for-a-persistent-hash-across-datasteps-and-procedures
https://github.com/rogerjdeangelis/utl-using-a-hash-to-compute-cumulative-sum-without-sorting
https://github.com/rogerjdeangelis/utl_benchmarks_hash_merge_of_two_un-sorted_data_sets_with_some_common_variables
https://github.com/rogerjdeangelis/utl_hash_lookup_with_multiple_keys_nice_simple_example
https://github.com/rogerjdeangelis/utl_hash_merge_of_two_un-sorted_data_sets_with_some_common_variables
https://github.com/rogerjdeangelis/utl_hash_persistent
https://github.com/rogerjdeangelis/utl_how_to_reuse_hash_table_without_reloading_sort_of
https://github.com/rogerjdeangelis/utl_many_to_many_merge_in_hash_datastep_and_sql
https://github.com/rogerjdeangelis/utl_nice_example_of_a_hash_of_hashes_by_paul_and_don
https://github.com/rogerjdeangelis/utl_nice_hash_example_of_rolling_count_of_dates_plus-minus_2_days_of_current_date
https://github.com/rogerjdeangelis/utl_select_ages_less_than_the_median_age_in_a_second_table_paul_dorfman_hash_solution
https://github.com/rogerjdeangelis/utl_simple_one_to_many_join_using_SQL_and_datastep_hashes
https://github.com/rogerjdeangelis/utl_simplified_hash_how_many_of_my_friends_are_in_next_years_math_class
https://github.com/rogerjdeangelis/utl_using_a_hash_to_transpose_and_reorder_a_table
https://github.com/rogerjdeangelis/utl_using_md5hash_to_create_checksums_for_programs_and_binary_files


/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
