proc import out= work.accident
datafile = "C:\Users\Kim Yuum\Desktop\������ ������.csv" replace;
getnames = yes;
options validvarname=any;
run;

DATA accident;  /*���ʿ��� ���� ����*/
set accident;
drop ����ڼ� �߻��ڼ� ����ڼ� �λ�Ű��ڼ�;
run;

DATA carvscar;  /*��������� �������� �����͸� �����غ���*/
set accident;
where ������� contains "������";
run;

ods pdf file = "C:\Users\Kim Yuum\Desktop\������d.pdf";
PROC FREQ DATA =  carvscar;
tables �������;
run;

DATA accident;   /*��������� ������, ������, �����ܵ����� �з�*/
set accident;
if substr(�������, 1, 6) = "������" then ��������з� = substr(�������, 1, 6);
else if substr(�������, 1, 8) = "������" then ��������з� = substr(�������, 1, 8) ;
else if substr(�������, 1, 8) = "�����ܵ�" then ��������з� = substr(�������, 1, 8);
drop �������;
run;

proc export data = accident
outfile = "C:\Users\Kim Yuum\Desktop\accident.csv" replace;
run;



PROC FREQ data= accident;  /*ī������������ ���� ������ �м�*/ /*�߻����� ������ �ٸ� ������ �ٲ� ��������*/
	tables ��������з�*�߻����� / chisq expected cellchi2 nocol nopercent relrisk;
run;


/**************������������**************************/
proc import out= work.accident
datafile = "C:\Users\Kim Yuum\Desktop\���������ͺ�ȯ.csv" replace;
getnames = yes;
options validvarname=any;
run;

PROC IMPORT out =  work.year2016   /*2016�� ������ ���������� �ҷ�����(���浵 ����)*/
datafile = "C:\Users\Kim Yuum\Desktop\2016��.csv";
getnames = yes;
run;

DATA year2016;  /*2016 ����� ������ �����͸� ����*/
set year2016; 
if �߻����õ� = "����" ;
run;

PROC IMPORT out =  work.year2017 /*2017�� ������ ���������� �ҷ�����(���浵 ����)*/
datafile = "C:\Users\Kim Yuum\Desktop\2017��.csv";
getnames = yes;
run;

DATA year2017;  /*2017 ����� ������ �����͸� ����*/
set year2017;
if �߻����õ� = "����";
run;

DATA year20162017;  /*2016�� �����Ϳ� 2017�� ������ ��ġ��*/
set year2016 year2017;
run;

DATA year20162017;
set year20162017;
rename �߻�����Ͻ� = �߻��Ͻ�;
run;

DATA year20162017;
set year20162017;
keep  �߻��Ͻ� ����ڼ� �߻��ڼ� ����ڼ� �浵 ����;
run;

proc sort data = year20162017;
by �߻��Ͻ� ����ڼ� �߻��ڼ� ����ڼ�;
RUN;
proc sort data= accident;
by �߻��Ͻ� ����ڼ� �߻��ڼ� ����ڼ�;
run;

DATA final;
set accident year20162017;
by �߻��Ͻ� ����ڼ� �߻��ڼ� ����ڼ� ;
run;

DATA final;
merge accident(in=ac) year20162017(in=ye);
by �߻��Ͻ� ����ڼ� �߻��ڼ� ����ڼ�;
if ye;
run;

proc freq data = final_1;
tables �λ�Ű��ڼ�;
run;

DATA final_1;
set final;
if �λ�Ű��ڼ� = . then delete  ;
run;

proc export data=final_1
outfile = "C:\Users\Kim Yuum\Desktop\accident_final.csv" replace;
run;

/*****�ñ����� ��ǥ******/
proc import out= work.dtg  /**�ý�**/
datafile = "C:\Users\Kim Yuum\Desktop\DTG.csv" replace;
getnames = yes;
run;

ods pdf file = "C:\Users\Kim Yuum\Desktop\DTG�ñ�����.pdf";
proc freq data = dtg;
tables sig_cd;
run;

/**������**/
proc import out= work.roads
datafile = "C:\Users\Kim Yuum\Desktop\������.csv" replace;
getnames = yes;
run;

proc freq data = roads;
tables sig_cd * sig_cd_2;
run;

/**�ְ�����**/
proc import out = work.homes
datafile = "C:\Users\Kim Yuum\Desktop\�ְ�����.csv" replace;
getnames = yes;
run;

proc freq data=homes;
tables VAR4;
run;

/**Ⱦ�ܺ���**/
proc import out = work.hdbd
datafile = "C:\Users\Kim Yuum\Desktop\Ⱦ�ܺ���.csv" replace;
getnames = yes;
run;

proc freq data= hdbd;
tables GU_CDE;
run;

proc import out = work.accident_freq
datafile = "C:\Users\Kim Yuum\Desktop\���� ��.csv" replace;
getnames = yes;
run;

proc import out = work.code
datafile = "C:\Users\Kim Yuum\Desktop\����� �������� �ñ��� ��ġ����.csv" replace;
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

/****���� �� ������ ����м�*****/
proc import out = work.correlation
datafile = "C:\Users\Kim Yuum\Desktop\���� �� ������ ������.csv" replace;
getnames = yes;
options validvarname=any;
run;

proc corr data = correlation;
var ������ �ڵ������뵵�� �ְ����� Ⱦ�ܺ��� ���� �������ѽü��� ���������� ��̺�ȣ���� CCTV ;
with ����;
run;


/********������********/

proc import out= work.accident
datafile = "C:\Users\Kim Yuum\Desktop\���������ͺ�ȯ.csv" replace;
getnames = yes;
options validvarname=any;
run;

proc import out= work.roads
datafile = "C:\Users\Kim Yuum\Desktop\������.csv" replace;
getnames = yes;
options validvarname=any;
run;

DATA accient_required;
set accident;
keep �߻��ñ��� ���� �浵;
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
tables ���������θ��ּ�;
run;

DATA abce;
set abc;
if substr(���������θ��ּ�, 12, 4) = "�߱�" then ���������θ��ּ� = "�߱�";
else if substr(���������θ��ּ�, 12, 8) = "���빮��" then ���������θ��ּ� = "���빮��";
else if substr(���������θ��ּ�, 12, 8) = "���빮��" then ���������θ��ּ� = "���빮��";
else if substr(���������θ��ּ�, 12, 8) = "��������" then ���������θ��ּ� = "��������";
else ���������θ��ּ�=substr(���������θ��ּ�, 12, 7);
run;

DATA abcs;
set abc;
where ���������θ��ּ� contains "����";
run;

proc import out= work.cctv
datafile = "C:\Users\Kim Yuum\Desktop\cctv��ġ����.csv" replace;
getnames = yes;
options validvarname=any;
run;

DATA cctvc;
set cctv;
if ��ġ��������  = "�����";
run;

proc import out= work.cctv
datafile = "C:\Users\Kim Yuum\Desktop\cctv.csv" replace;
getnames = yes;
options validvarname=any;
run;

DATA cctv;
set cctv;
if ��ġ�������� = "����";

proc import out= work.test17_8
datafile = "C:\Users\Kim Yuum\Desktop\seventeeneight.csv" replace;
getnames = yes;
options validvarname=any;
run;

PROC FACTOR DATA=test17_8 OUTSTAT=test17_8
          SIMPLE CORR SCREE MINEIGEN= 1 ROTATE= VARIMAX
          REORDER SCORE PLOT;                

    VAR ������ �ڵ������뵵�� �ְ����� cctv Ⱦ�ܺ��� ���� �������ѽü��� ���������� ��̺�ȣ����;
RUN;

proc import out= work.test20_5
datafile = "C:\Users\Kim Yuum\Desktop\twentyvsfive.csv" replace;
getnames = yes;
options validvarname=any;
run;

PROC FACTOR DATA=test20_5 OUTSTAT=test20_5
          SIMPLE CORR SCREE MINEIGEN= 1 ROTATE= VARIMAX
          REORDER SCORE PLOT;                

    VAR ������ �ڵ������뵵�� �ְ����� cctv Ⱦ�ܺ��� ���� �������ѽü��� ���������� ��̺�ȣ����;
RUN;
