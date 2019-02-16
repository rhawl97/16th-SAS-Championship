data dtg16_6_lag;
set sa1029.dtg16_6;
lag=lag(speed);
run;
data dtg16_6_lag;
set work.dtg16_6_lag;
accel=speed-lag;
run;
DATA des;
set work.dtg16_6_lag;
id=_n_;
keep id accel;
run;
proc sort data = des out=tmmp;
by descending id;
run;

DATA tmmp;
set tmmp;
realaccel = lag(accel);
run;
proc sort data = tmmp out = tmmp;
by id;
run;
data tmmp;
set tmmp;
keep realaccel;
run;
data work.dtg16_6_lag;
merge work.dtg16_6_lag tmmp;
run;
data sa1029.dtg16_6_accel;
set work.dtg16_6_lag;
drop accel;
run;

data sa1029.dtg16_6_rapidac;
set sa1029.dtg16_6_accel;
if speed>=6 and realaccel>=8 then rapidaccel=1;
else rapidaccel = 0;
run;
DATA dtg16_6_raac1;
set sa1029.dtg16_6_rapidac;
if rapidaccel = 1;
run;
DATA dtg16_6_raac1;
set dtg16_6_raac1;
time_lag = lag(time);
time_lag2 = lag(lag(time));
if time - time_lag = 1 or time - time_lag2 = 2 or
time - time_lag = 2
then rapidaccel = 0;
run;

DATA sa1029.dtg16_6_rapidac;
merge sa1029.dtg16_6_rapidac dtg16_6_raac1;
drop time_lag time_lag2;
run;
data sa1029.dtg_rapidac;
set sa1029.dtg16_6_rapidac
sa1029.dtg16_7_rapidac sa1029.dtg16_8_rapidac
sa1029.dtg17_6_rapidac sa1029.dtg17_7_rapidac
sa1029.dtg17_8_rapidac;
run;

data sa1029.dtg16_6_rapidstart;
set sa1029.dtg16_6_accel;
if realaccel>=10 and speed<=5
then rapidstart = 1 ;
else rapidstart = 0 ;
run;
data sa1029.dtg_rapidstart;
set sa1029.dtg16_6_rapidstart
sa1029.dtg16_7_rapidstart
sa1029.dtg16_8_rapidstart
sa1029.dtg17_6_rapidstart
sa1029.dtg17_7_rapidstart
sa1029.dtg17_8_rapidstart;
run;

data sa1029.dtg16_6_rapidkam;
set sa1029.dtg16_6_accel;
if realaccel<=-14 and speed>=6
then rapidkam = 1 ;
else rapidkam = 0 ;
run;
DATA dtg16_6_rakam1;
set sa1029.dtg16_6_rapidkam;
if rapidkam = 1;
run;
DATA dtg16_6_rakam2;
set dtg16_6_rakam1;
time_lag = lag(time);
time_lag2 = lag(lag(time));
if time - time_lag = 1 or time - time_lag2 = 2 or
time - time_lag = 2
then rapidkam = 0; run;

DATA sa1029.dtg16_6_rapidkam;
merge sa1029.dtg16_6_rapidkam dtg16_6_rakam2;
drop time_lag time_lag2;
run;
data sa1029.dtg_rapidkam;
set sa1029.dtg16_6_rapidkam
sa1029.dtg16_7_rapidkam
sa1029.dtg16_8_rapidkam
sa1029.dtg17_6_rapidkam
sa1029.dtg17_7_rapidkam
sa1029.dtg17_8_rapidkam;
run;

data sa1029.dtg16_6_rapidstop;
set sa1029.dtg16_6_accel;
lag_accel = lag(realaccel);
if lag_accel<=-14 and speed<=5
then rapidstop = 1 ;
else rapidstop = 0 ;
run;
data sa1029.dtg_rapidstop;
set sa1029.dtg16_6_rapidstop
sa1029.dtg16_7_rapidstop
sa1029.dtg16_8_rapidstop
sa1029.dtg17_6_rapidstop
sa1029.dtg17_7_rapidstop
sa1029.dtg17_8_rapidstop;
run;

data dtg16_6_rotation;
set sa1029.dtg16_6;
gis_lag1=lag(gis);
gis_lag=lag(gis_lag1);
rotation1=gis-gis_lag1;
rotation=gis-gis_lag;
run;
data sa1029.dtg16_6_rapidrota;
set dtg16_6_rotation;
if speed>=30 and 60<=rotation<=120 then
rapidrotation=1;
else if speed>=30 and -120<=rotation<=-60 then
rapidrotation=1;
else rapidrotation = 0;
run;
DATA des;
set sa1029.dtg16_6_rapidrota;
id=_n_;
run;

DATA des;
set des;
keep id rotation1 rotation;
run;
proc sort data = des out=tmmp;
by descending id;
run;
DATA tmmp;
set tmmp;
rotation_1 = lag(rotation1);
rotation_2 = lag(rotation);
rotation_3 = lag(rotation_2);
run;
proc sort data = tmmp out = tmmp;
by id;
run;

data tmmp;
set tmmp;
keep rotation_1 rotation_3;
run;
data sa1029.dtg16_6_rapidrota;
merge sa1029.dtg16_6_rapidrota tmmp;
run;
data sa1029.dtg16_6_rotation;
set sa1029.dtg16_6_rapidrota;
drop rapidrotation rotation rotation1;
run;
data sa1029.dtg16_6_rapidrota;
set sa1029.dtg16_6_rotation;
if speed>=30 and 60<=rotation_3<=120 then
rapidrotation=1;
else if speed>=30 and -120<=rotation_3<=-60 then
rapidrotation=1;
else rapidrotation = 0;
run;

data sa1029.dtg_rapidrotation;
set sa1029.dtg16_6_rapidrota
sa1029.dtg16_7_rapidrota
sa1029.dtg16_8_rapidrota
sa1029.dtg17_6_rapidrota
sa1029.dtg17_7_rapidrota
sa1029.dtg17_8_rapidrota;
run;

data dtg16_6_turn;
set sa1029.dtg16_6;
lag1=lag(gis);
lag2=lag(lag1);
lag3=lag(lag2);
lag4=lag(lag3);
gis_lag=lag(lag4);
turn=gis-gis_lag;
run;
data sa1029.dtg16_6_uturn;
set dtg16_6_turn;
if speed>=25 and 160<=turn<=180 then uturn=1;
else if speed>=25 and -180<=turn<=-160 then
uturn=1;
else uturn = 0;
run;

DATA des;
set sa1029.dtg16_6_uturn;
id=_n_;
run;
DATA des;
set des;
keep id turn;
run;
proc sort data = des out=tmmp;
by descending id;
run;
DATA tmmp;
set tmmp;
turn_1 = lag(turn);
turn_2 = lag(turn_1);
turn_3 = lag(turn_2);
turn_4 = lag(turn_3);
turn_5 = lag(turn_4);
run;

proc sort data = tmmp out = tmmp;
by id;
run;
data tmmp;
set tmmp;
keep turn_5;
run;
data sa1029.dtg16_6_uturn;
merge sa1029.dtg16_6_uturn tmmp;
run;

Data sa1029.dtg16_6_uturn;
set dtg16_6_turn;
if speed>=25 and 160<=turn_5<=180 then uturn=1;
else if speed>=25 and -180<=turn_5<=-160 then
uturn=1;
else uturn = 0;
run;
data sa1029.dtg_rapiduturn;
set sa1029.dtg16_6_uturn sa1029.dtg16_7_uturn
sa1029.dtg16_8_uturn sa1029.dtg17_6_uturn
sa1029.dtg17_7_uturn sa1029.dtg17_8_uturn;
run;

DATA sa1029.dtg16_6_rapidpass;
set sa1029.dtg16_6_accel;
gis_lag = lag(gis);
gis_lag_by5 = lag(lag(lag(lag(gis))));
if ABS(gis_lag - gis)>=10 and speed >=30 and
ABS(gis_lag_by5 - gis)<=2
and ABS(realaccel) >= 3 then rapidpass =1 ;
else rapidpass = 0;
run;
data sa1029.dtg_rapidpass;
set sa1029.dtg16_6_rapidpass
sa1029.dtg16_7_rapidpass
sa1029.dtg16_8_rapidpass
sa1029.dtg17_6_rapidpass
sa1029.dtg17_7_rapidpass
sa1029.dtg17_8_rapidpass;
run;

DATA sa1029.dtg16_6_rapidchange;
set sa1029.dtg16_6_accel;
gis_lag = lag(gis);
gis_lag_by5 = lag(lag(lag(lag(gis))));
if ABS(gis_lag - gis)>=10 and speed >=30 and
ABS(gis_lag_by5 - gis)<=2
and ABS(realaccel) <= 2 then rapidchange =1 ;
else rapidchange = 0;
run;
data sa1029.dtg_rapidchange;
set sa1029.dtg16_6_rapidchange
sa1029.dtg16_7_rapidchange
sa1029.dtg16_8_rapidchange
sa1029.dtg17_6_rapidchange
sa1029.dtg17_7_rapidchange
sa1029.dtg17_8_rapidchange;
run;

data grid_dtg_rapidstop;
set sa1029.dtg_rapidstop;
if rapidstop=1;
run;
data grid_dtg_rapidstop;
set grid_dtg_rapidstop;
spacingC=100*(1/110000);
spacingR=100*(1/88740);
latmin=37.4249;
latmax=37.704;
lonmin=126.76;
lonmax=127.1855;
c=(latmax-latmin)/spacingC;
r=(lonmax-lonmin)/spacingR;
c=ceil(c);
r=ceil(r);
c1=(lat-latmin)/spacingC;
r1=(lon-lonmin)/spacingR;
c1=ceil(c1);
r1=ceil(r1);
g= r1 + r*(c1-1);
run;

proc freq data=grid_dtg_rapidstop noprint;
table g / nocol norow nopercent out=
sa1029.freq_dtg_rapidstop(drop=percent) sparse;
run;
data sa1029.freq_dtg_rapidstop;
set sa1029.freq_dtg_rapidstop;
g_rapidstop=count;
drop count;
run;

data sa1029.dtg_grid;
merge sa1029.freq_accident_3gu
sa1029.freq_dtg_rapidac
sa1029.freq_dtg_rapidrotation
sa1029.freq_dtg_rapidstart
sa1029.freq_dtg_rapidpass
sa1029.freq_dtg_rapidstop
sa1029.freq_dtg_rapidkam
sa1029.freq_dtg_rapiduturn
sa1029.freq_dtg_rapidchange;
by g;
run;
proc corr data=sa1029.dtg_grid
out=sa1029.corr_dtg_grid;
var g_accident_3gu g_rapidaccel g_rapidstart
g_rapidkam g_rapidstop
g_rapidrotation g_rapiduturn g_rapidpass
g_rapidchange;
run;

data sampling.dtg_rapidac1;
set sa1029.dtg_rapidac;
if rapidaccel=1;
run;
data sampling.dtg_rapidac0;
set sa1029.dtg_rapidac;
if rapidaccel=0;
run;
proc surveyselect
data=sampling.dtg_rapidac0
method= srs
n=103660
out=sampling.rapidacsam;
run;

proc sort data= sampling.rapidacsam;
by time;
run;
proc sort data= sampling.dtg_rapidac1;
by time;
run;
data sampling.rapidac;
set sampling.dtg_rapidac1
sampling.rapidacsam;
by time;
run;

