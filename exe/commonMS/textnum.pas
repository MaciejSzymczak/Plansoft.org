unit textnum;
{ (c) Marcin Wieczorek ( T-1000 ) }
interface

function getstrnum(e:extended):string;

implementation

const jednosci:array[0..19]of string[20]=
      ('','jeden','dwa','trzy','cztery','pi��','sze��','siedem',
       'osiem','dziewi��','dziesi��','jedena�cie','dwana�cie',
       'trzyna�cie','czterna�cie','pi�tna�cie','szesna�cie',
       'siedemna�cie','osiemna�cie','dziewi�tna�cie');
      dziesiatki:array[0..9]of string[20]=
      ('','dziesi��','dwadzie�cia','trzydzie�ci','czterdzie�ci',
       'pi��dziesi�t','sze��dziesi�t','siedemdziesi�t',
       'osiemdziesi�t','dziewi��dziesi�t');
      setki:array[0..9]of string[20]=
      ('','sto','dwie�cie','trzysta','czterysta','pi��set',
       'sze��set','siedemset','osiemset','dziewi��set');
      tysiace:array[0..9]of string[20]=
      ('tysi�cy','tysi�c','tysi�ce','tysi�ce','tysi�ce','tysi�cy',
       'tysi�cy','tysi�cy','tysi�cy','tysi�cy');
      zlote:array[0..9]of string[20]=
      ('z�otych','z�otych','z�ote','z�ote','z�ote','z�otych','z�otych',
       'z�otych','z�otych','z�otych');
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
  s:=s+'tysi�cy '
 else
  if n1000<>0 then
   if (n1000 mod 10=1)and(n1000<>1)then
    s:=s+'tysi�cy'+' '
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
  zloty:='z�otych';exit;
 end;
 if n=1 then zloty:='z�oty'
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
 else s:=s+'zero z�otych';

 if n2<>0 then
  s:=s+tekst(n2)+grosz(n2)
 else s:=s+' zero groszy'; 
 getstrnum:=s;
end;

end.