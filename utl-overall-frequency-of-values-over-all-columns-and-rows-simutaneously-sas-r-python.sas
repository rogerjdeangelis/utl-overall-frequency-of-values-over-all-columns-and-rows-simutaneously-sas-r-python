%let pgm=utl-overall-frequency-of-values-over-all-columns-and-rows-simutaneously-sas-r-python;

Overall frequency of values over all columns and rows simutaneously sas r python;

This is best done with R

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
/*                                             |                                                               |                    */
/*  SD1.HAVE total obs=3                       | 1 R USING STATTRANSFER                                        |                    */
/*                                             | ======================                                        | TMP.WANT total     */
/*                                             |                                                               |                    */
/*  Obs     XX     YY     ZZ                   | %utl_rbegin;                                                  | ROWNAMES HAVE FREQ */
/*                                             | parmcards4;                                                   |                    */
/*   1     123    456    234                   | library(haven)                                                |    1    123    3   */
/*   2     456    123    345                   | have<-as.matrix(                                              |    2    234    2   */
/*   3     234    345    123                   |   read_sas("d:/sd1/have.sas7bdat"));                          |    3    345    2   */
/*                                             | want <- as.data.frame(table(have));                           |    4    456    2   */
/*  Some of the solutions use a macro array    | want$have<-as.character(want$have);                           |                    */
/*                                             | source("c:/temp/fn_tosas9.R")                                 |                    */
/*  %array(_col,values=%utl_varlist(sd1.have));| fn_tosas9(dataf=want)                                         |                    */
/*                                             | ;;;;                                                          |                    */
/*  %put &=_col1; /*_  COL1 = XX   */          | %utl_rend;                                                    |                    */
/*  %put &=_col2; /*  _COL2 = YY   */          |                                                               |                    */
/*  %put &=_col3; /*  _COL3 = ZZ   */          | libname tmp "c:/temp";                                        |                    */
/*  %put &=_coln; /*  _COLN = 3    */          | proc print data=tmp.want;                                     |                    */
/*                                             | run;quit;                                                     |                    */
/*                                             |                                                               |                    */
/*                                             |                                                               |                    */
/*                                             |                                                               |                    */
/*  Note: In R factors have to be              | 2 R PURE SQL SOLUTION STATTRANSFER                            | WANT               */
/*        converted to character               | ==================================                            |                    */
/*        Only when using table function       |                                                               | ROWNAMES  VAL CNT  */
/*                                             | %utl_submit_r64x("                                            |                    */
/* Macros used                                 | library(haven);                                               |     1     123  3   */
/*                                             | library(sqldf);                                               |     2     234  2   */
/* gather   Alea Iacta   aleaiacta95@gmail.com | have<-                                                        |     3     345  2   */
/* array    Ted Clay,    tclay@ashlandhome.net |   read_sas('d:/sd1/have.sas7bdat');                           |     4     456  2   */
/* varlist  Søren Lassen s.lassen@post.tele.dk | have;                                                         |                    */
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

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
