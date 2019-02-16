proc import out= work.accident
datafile = "C:\Users\Kim Yuum\Desktop\교통사고 데이터.csv" replace;
getnames = yes;
options validvarname=any;
run;

DATA accident;  /*불필요한 변수 제거*/
set accident;
drop 사망자수 중상자수 경상자수 부상신고자수;
run;

DATA carvscar;  /*사고유형이 차대차인 데이터만 추출해보기*/
set accident;
where 사고유형 contains "차대차";
run;

ods pdf file = "C:\Users\Kim Yuum\Desktop\차대차d.pdf";
PROC FREQ DATA =  carvscar;
tables 사고유형;
run;

DATA accident;   /*사고유형을 차대차, 차대사람, 차량단독으로 분류*/
set accident;
if substr(사고유형, 1, 6) = "차대차" then 사고유형분류 = substr(사고유형, 1, 6);
else if substr(사고유형, 1, 8) = "차대사람" then 사고유형분류 = substr(사고유형, 1, 8) ;
else if substr(사고유형, 1, 8) = "차량단독" then 사고유형분류 = substr(사고유형, 1, 8);
drop 사고유형;
run;

proc export data = accident
outfile = "C:\Users\Kim Yuum\Desktop\accident.csv" replace;
run;



PROC FREQ data= accident;  /*카이제곱검정을 통한 연관성 분석*/ /*발생요일 변수를 다른 변수로 바꿔 검정가능*/
	tables 사고유형분류*발생요일 / chisq expected cellchi2 nocol nopercent relrisk;
run;


/**************경위도경위도**************************/
proc import out= work.accident
datafile = "C:\Users\Kim Yuum\Desktop\교통사고데이터변환.csv" replace;
getnames = yes;
options validvarname=any;
run;

PROC IMPORT out =  work.year2016   /*2016년 교통사고 공공데이터 불러오기(위경도 포함)*/
datafile = "C:\Users\Kim Yuum\Desktop\2016년.csv";
getnames = yes;
run;

DATA year2016;  /*2016 서울시 교통사고 데이터만 추출*/
set year2016; 
if 발생지시도 = "서울" ;
run;

PROC IMPORT out =  work.year2017 /*2017년 교통사고 공공데이터 불러오기(위경도 포함)*/
datafile = "C:\Users\Kim Yuum\Desktop\2017년.csv";
getnames = yes;
run;

DATA year2017;  /*2017 서울시 교통사고 데이터만 추출*/
set year2017;
if 발생지시도 = "서울";
run;

DATA year20162017;  /*2016년 데이터와 2017년 데이터 합치기*/
set year2016 year2017;
run;

DATA year20162017;
set year20162017;
rename 발생년월일시 = 발생일시;
run;

DATA year20162017;
set year20162017;
keep  발생일시 사망자수 중상자수 경상자수 경도 위도;
run;

proc sort data = year20162017;
by 발생일시 사망자수 중상자수 경상자수;
RUN;
proc sort data= accident;
by 발생일시 사망자수 중상자수 경상자수;
run;

DATA final;
set accident year20162017;
by 발생일시 사망자수 중상자수 경상자수 ;
run;

DATA final;
merge accident(in=ac) year20162017(in=ye);
by 발생일시 사망자수 중상자수 경상자수;
if ye;
run;

proc freq data = final_1;
tables 부상신고자수;
run;

DATA final_1;
set final;
if 부상신고자수 = . then delete  ;
run;

proc export data=final_1
outfile = "C:\Users\Kim Yuum\Desktop\accident_final.csv" replace;
run;

/*****시군구별 빈도표******/
proc import out= work.dtg  /**택시**/
datafile = "C:\Users\Kim Yuum\Desktop\DTG.csv" replace;
getnames = yes;
run;

ods pdf file = "C:\Users\Kim Yuum\Desktop\DTG시군구별.pdf";
proc freq data = dtg;
tables sig_cd;
run;

/**교차점**/
proc import out= work.roads
datafile = "C:\Users\Kim Yuum\Desktop\교차점.csv" replace;
getnames = yes;
run;

proc freq data = roads;
tables sig_cd * sig_cd_2;
run;

/**주거지역**/
proc import out = work.homes
datafile = "C:\Users\Kim Yuum\Desktop\주거지역.csv" replace;
getnames = yes;
run;

proc freq data=homes;
tables VAR4;
run;

/**횡단보도**/
proc import out = work.hdbd
datafile = "C:\Users\Kim Yuum\Desktop\횡단보도.csv" replace;
getnames = yes;
run;

proc freq data= hdbd;
tables GU_CDE;
run;

proc import out = work.accident_freq
datafile = "C:\Users\Kim Yuum\Desktop\구별 빈도.csv" replace;
getnames = yes;
run;

proc import out = work.code
datafile = "C:\Users\Kim Yuum\Desktop\서울시 행정구역 시군구 위치정보.csv" replace;
getnames = yes;
run;

DATA accident_freq;
set accident_freq;
rename VAR1 = VAR7;
run;

DATA code;
set code;
rename VAR2 = VAR8;
run;

proc sort data= code;
by VAR7;
RUN;

DATA mergeff;
merge accident_freq code;
by VAR7;
run;

LIBNAME yum "C:\Users\Kim Yuum\Desktop";
DATA yum.accidentcode;
	set mergeff;
run;

/****구별 빈도 총정리 상관분석*****/
proc import out = work.correlation
datafile = "C:\Users\Kim Yuum\Desktop\구별 빈도 데이터 총정리.csv" replace;
getnames = yes;
options validvarname=any;
run;

proc corr data = correlation;
var 교량빈도 자동차전용도로 주거지역 횡단보도 험프 운행제한시설물 버스정류장 어린이보호구역 CCTV ;
with 사고빈도;
run;


/********교차점********/

proc import out= work.accident
datafile = "C:\Users\Kim Yuum\Desktop\교통사고데이터변환.csv" replace;
getnames = yes;
options validvarname=any;
run;

proc import out= work.roads
datafile = "C:\Users\Kim Yuum\Desktop\교차점.csv" replace;
getnames = yes;
options validvarname=any;
run;

DATA accient_required;
set accident;
keep 발생시군구 위도 경도;
run;

proc sort data = roads;

DATA roadslonlat;
merge accident_required roads;
by ;

/***cctv****/
proc import out= work.cctv
datafile = "C:\Users\Kim Yuum\Desktop\cctv.csv" replace;
getnames = yes;
options validvarname=any;
run;


proc freq data=abce;
tables 소재지도로명주소;
run;

DATA abce;
set abc;
if substr(소재지도로명주소, 12, 4) = "중구" then 소재지도로명주소 = "중구";
else if substr(소재지도로명주소, 12, 8) = "동대문구" then 소재지도로명주소 = "동대문구";
else if substr(소재지도로명주소, 12, 8) = "서대문구" then 소재지도로명주소 = "서대문구";
else if substr(소재지도로명주소, 12, 8) = "영등포구" then 소재지도로명주소 = "영등포구";
else 소재지도로명주소=substr(소재지도로명주소, 12, 7);
run;

DATA abcs;
set abc;
where 소재지도로명주소 contains "서하";
run;

proc import out= work.cctv
datafile = "C:\Users\Kim Yuum\Desktop\cctv위치정보.csv" replace;
getnames = yes;
options validvarname=any;
run;

DATA cctvc;
set cctv;
if 설치목적구분  = "교통단";
run;

proc import out= work.cctv
datafile = "C:\Users\Kim Yuum\Desktop\cctv.csv" replace;
getnames = yes;
options validvarname=any;
run;

DATA cctv;
set cctv;
if 설치목적구분 = "교통";

proc import out= work.test17_8
datafile = "C:\Users\Kim Yuum\Desktop\seventeeneight.csv" replace;
getnames = yes;
options validvarname=any;
run;

PROC FACTOR DATA=test17_8 OUTSTAT=test17_8
          SIMPLE CORR SCREE MINEIGEN= 1 ROTATE= VARIMAX
          REORDER SCORE PLOT;                

    VAR 교량빈도 자동차전용도로 주거지역 cctv 횡단보도 험프 운행제한시설물 버스정류장 어린이보호구역;
RUN;

proc import out= work.test20_5
datafile = "C:\Users\Kim Yuum\Desktop\twentyvsfive.csv" replace;
getnames = yes;
options validvarname=any;
run;

PROC FACTOR DATA=test20_5 OUTSTAT=test20_5
          SIMPLE CORR SCREE MINEIGEN= 1 ROTATE= VARIMAX
          REORDER SCORE PLOT;                

    VAR 교량빈도 자동차전용도로 주거지역 cctv 횡단보도 험프 운행제한시설물 버스정류장 어린이보호구역;
RUN;
