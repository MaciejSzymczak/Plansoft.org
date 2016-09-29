unit textnum;
{ (c) Marcin Wieczorek ( T-1000 ) }
interface

function getstrnum(e:extended):string;

implementation

const jednosci:array[0..19]of string[20]=
      ('','jeden','dwa','trzy','cztery','piêæ','szeœæ','siedem',
       'osiem','dziewiêæ','dziesiêæ','jedenaœcie','dwanaœcie',
       'trzynaœcie','czternaœcie','piêtnaœcie','szesnaœcie',
       'siedemnaœcie','osiemnaœcie','dziewiêtnaœcie');
      dziesiatki:array[0..9]of string[20]=
      ('','dziesiêæ','dwadzieœcia','trzydzieœci','czterdzieœci',
       'piêædziesi¹t','szeœædziesi¹t','siedemdziesi¹t',
       'osiemdziesi¹t','dziewiêædziesi¹t');
      setki:array[0..9]of string[20]=
      ('','sto','dwieœcie','trzysta','czterysta','piêæset',
       'szeœæset','siedemset','osiemset','dziewiêæset');
      tysiace:array[0..9]of string[20]=
      ('tysiêcy','tysi¹c','tysi¹ce','tysi¹ce','tysi¹ce','tysiêcy',
       'tysiêcy','tysiêcy','tysiêcy','tysiêcy');
      zlote:array[0..9]of string[20]=
      ('z³otych','z³otych','z³ote','z³ote','z³ote','z³otych','z³otych',
       'z³otych','z³otych','z³otych');
      grosze:array[0..9]of string[20]=
      ('groszy','groszy','grosze','grosze','grosze','groszy','groszy',
       'groszy','groszy','groszy');

procedure split(n:longint;var n1,n10,n100,n1000:longint);
begin
 n1:=n mod 10;
 n:=n div 10;
 n10:=n mod 10;
 n:=n div 10;
 n100:=n mod 10;
 n:=n div 10;
 n1000:=n;
end;

function tysiac(n:longint):string;
var n1,n10,n100,n1000:longint;
    s:string;
begin
 split(n,n1,n10,n100,n1000);
 s:='';

 if n100<>0 then
  s:=s+setki[n100]+' ';

 if n10>=2 then
  s:=s+dziesiatki[n10]+' ';

 n:=n1+10*n10;
 if n<>0 then
  if n<20 then
   s:=s+jednosci[n]+' '
  else
   if n mod 10=0 then
    s:=s+jednosci[n1]
   else
    s:=s+jednosci[n1]+' ';

 tysiac:=s;
end;

function tekst(n:longint):string;
var n1,n10,n100,n1000:longint;
    s:string;
begin
 split(n,n1,n10,n100,n1000);
 s:=tysiac(n1000);
 if (n1000 mod 100>=10)and(n1000 mod 100<20)then
  s:=s+'tysiêcy '
 else
  if n1000<>0 then
   if (n1000 mod 10=1)and(n1000<>1)then
    s:=s+'tysiêcy'+' '
   else
    s:=s+tysiace[n1000 mod 10]+' ';
 s:=s+tysiac(n1+10*n10+100*n100);
 tekst:=s;
end;

function zloty(n:longint):string;
begin
 if n=0 then exit;
 if (n>=10)and(n<20)then
 begin
  zloty:='z³otych';exit;
 end;
 if n=1 then zloty:='z³oty'
 else zloty:=zlote[n mod 10];
end;

function grosz(n:longint):string;
begin
 if n=0 then exit;
 if (n>=10)and(n<20)then
 begin
  grosz:='groszy';exit;
 end;
 if n=1 then grosz:='grosz'
 else grosz:=grosze[n mod 10];
end;

function getstrnum(e:extended):string;
var dupa : extended;
    n1,n2:int64;
    s:string;
begin
 dupa := system.trunc(e);
 n1   := system.round(dupa);
 n2:=round(frac(e)*100);
 if n2=100 then
 begin
  n2:=0;Inc(n1);
 end;
 s:='';
 if n1<>0 then
  s:=s+tekst(n1)+zloty(n1)+' '
 else s:=s+'zero z³otych';

 if n2<>0 then
  s:=s+tekst(n2)+grosz(n2)
 else s:=s+' zero groszy'; 
 getstrnum:=s;
end;

end.