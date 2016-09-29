unit UFModuleSummary;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids,Db,Math, DBTables,DBGrids, StrHlder,UFModuleSummaryDlgOptions,UFModuleSummaryConfig,
  ExtCtrls,UFModuleSummaryFields, Menus, dm, ADODB;

type
  TFModuleSummary = class(TForm)
    MainGrid: TStringGrid;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    StrHolder1: TStrHolder;
    Panel1: TPanel;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    MenuForWeb: TPopupMenu;
    Dodajpole1: TMenuItem;
    Usupole1: TMenuItem;
    Opcje1: TMenuItem;
    Opcje2: TMenuItem;
    Opcje3: TMenuItem;
    SHAte: TStrHolder;
    Q1: TADOQuery;
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure MainGridDblClick(Sender: TObject);
    procedure Opcje3Click(Sender: TObject);
    procedure Dodajpole1Click(Sender: TObject);
    procedure Usupole1Click(Sender: TObject);
    procedure Opcje1Click(Sender: TObject);
    procedure Opcje2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
type
 TKratka=record
  FieldName : String;
  OriginFieldName : String;
  Key : integer;
 end;
 TKratkaKonfig=record
  Caption : String;
  FunctionName : String;
 end;


function MyShowTotal(F : Pointer; Q : TADOQuery; G : TDBGrid; MyFullPath : string) : Boolean;

var
  FModuleSummary: TFModuleSummary;
  MQ : TADOQuery;
  MG : TDBGrid;
  KR : array[0..80] of TKratka;
  //EKP : array[0..80] of TKratkaKonfig;
  LK : integer=0;
  //LKK : integer=0;

implementation
 uses UFBrowseParent;
 var
  FBrowseParent : TFBrowseParent;

procedure SetAte(Q : TADOQuery);
var
  i,k,j,l : integer;
  w,p : string;
begin
  FModuleSummary.SHAte.Clear;
  i:=0;j:=0;w:='';p:='';
 if (Pos('SELECT',UpperCase(Q.SQL.Strings[0]))<>0) and (Pos('FROM ',UpperCase(Q.SQL.Strings[0]))=0) then
  begin
  while i<Q.SQL.Count do
   begin
    if Pos('SELECT',UpperCase(Q.SQL.Strings[i]))<>0 then
     begin
       k:=Pos('SELECT',UpperCase(Q.SQL.Strings[i]));
       w:=Copy(Q.SQL.Strings[i],k+6,Length(Q.SQL.Strings[i])-k+1);
       j:=j+1;
       i:=Q.SQL.Count;
     end
    else
     begin
      j:=j+1;
      i:=i+1;
     end;
   end;
  i:=0;l:=0;
  while i<Q.SQL.Count do
   begin
    if Pos('FROM',UpperCase(Q.SQL.Strings[i]))<>0 then
     begin
       k:=Pos('FROM',UpperCase(Q.SQL.Strings[i]));
       p:=Copy(Q.SQL.Strings[i],1,k-1);
       l:=l+1;
       i:=Q.SQL.Count;
     end
    else
     begin
      l:=l+1;
      i:=i+1;
     end;
   end;
  FModuleSummary.SHAte.Strings.Add(w);
  for i:=j to l-2 do
   begin
    FModuleSummary.SHAte.Strings.Add(Q.SQL.Strings[i]);
   end;
  FModuleSummary.SHAte.Strings.Add(p);
  end
 else
  begin
    j:=Pos('SELECT',UpperCase(Q.SQL.Strings[0]));
    //l:=Pos('FROM',UpperCase(Q.SQL.Strings[0]));
    w:=Copy(Q.SQL.Strings[0],j+6,Length(Q.SQL.Strings[0])-j+6+1);
    FModuleSummary.SHAte.Strings.Add(w)
  end;

end;

function ExtractOigin( Q : TADOQuery; K : string) : string;
var
 i,l,j : integer;
 w : Boolean;
 temp : string;
 temp1 : array [1..300] of char;
 temp2 : array [1..300] of char;
begin
 SetAte(Q);
 i:=0;j:=0;w:=False;
 while i<FModuleSummary.SHAte.Strings.Count do
  begin
   if Pos(UpperCase(K),UpperCase(FModuleSummary.SHAte.Strings[i]))<>0 then
    begin
     l:=Pos(UpperCase(K),UpperCase(FModuleSummary.SHAte.Strings[i]));
     w:=True;
     i:=FModuleSummary.SHAte.Strings.Count
    end
   else
    begin
     j:=j+1;
     i:=i+1;
    end;
  end;
 if w then
  begin
   temp:=Copy(UpperCase(FModuleSummary.SHAte.Strings[j]),1,l-1);
   i:=Length(temp);
   StrPCopy(@temp1, temp);
   l:=1;
   for j:=1 to i do
    if temp1[j]<>Chr(9) then
     begin
       temp2[l]:=temp1[j];
       l:=l+1;
     end;
   temp2[l]:=#0;
   Result:=StrPas(@temp2);
  end
 else
   Result:='';
end;

function CheckQuery( var Mfile : TextFile ; NumberOfField : integer ) : Boolean;
var
 i,j : integer;
 s : string;
 w : Boolean;
 wp : Boolean;
begin
 wp:=True;
 for i:=1 to  NumberOfField do
  begin
   readln(Mfile,s);
   j:=0;
   w:=False;
   while j<MQ.FieldCount do
    begin
     if MQ.Fields[j].FieldName=s then
      begin
       w:=True;
       j:=MQ.FieldCount;
      end;
     j:=j+1;
    end;
   if w=False then
    wp:=False;
  end;
  if wp then
   Result:=True
  else
   Result:=False;
end;

function LoadTotalFromFile(MyFullPath : string ): Boolean;
var
 i,k,g : integer;
 fi : TextFile;
 s : string;
 w : Boolean;
begin
 try
  AssignFile(fi,MyFullPath);
  Reset(fi);
  readln(fi,s);
  if CheckQuery(fi,StrToInt(s)) then
   begin
    readln(fi,s);
    LKK:=StrToInt(s);
    FModuleSummary.MainGrid.ColCount:=LKK+2;
    if LKK>0 then
     begin
      for i:=0 to LKK-1 do
       begin
        readln(fi,s);
        EKP[i].Caption:=s;
        readln(fi,s);
        EKP[i].FunctionName:=s;
        FModuleSummary.MainGrid.cells[2+i,0]:=EKP[i].Caption;
        FModuleSummary.MainGrid.ColWidths[2+i]:=110;
       end;
     end;
    readln(fi,s);
    LK:=StrToInt(s);
    readln(fi,s);
    FModuleSummary.MainGrid.RowCount:=StrToInt(s);
    g:=1;
    for i:=0 to LK-1 do
     begin
      readln(fi,s);
      KR[i].FieldName:=s;
      readln(fi,s);
      if s='1' then
       begin
        FModuleSummary.MainGrid.Cells[0,g]:=KR[i].FieldName;
        //FModuleSummary.MainGrid.Cells[1,i+1]:=MQ.Fields[i].DisplayLabel;
        k:=0;
        W:=False;
        while k<MG.FieldCount do
         begin
          if KR[i].FieldName=MG.Columns[k].FieldName then
           begin
            FModuleSummary.MainGrid.cells[1,g]:=MG.Columns[k].Title.Caption;
            k:=MQ.FieldCount;
            g:=g+1;
            w:=True;
           end;
          k:=k+1;
         end;
        if not w then
         begin
          FModuleSummary.MainGrid.cells[1,g]:=KR[i].FieldName;
          g:=g+1;
         end;
       end;
      readln(fi,s);
      KR[i].Key:=StrToInt(s);
     end;
    Close(fi);
    Result:=True;
   end
  else
   begin
    ShowMessage('Plik konfiguracyjny nie odpowiada temu formularzowi.');
    Result:=False;
   end;
 except
  Result:=False;
 end;
end;

function SaveTotalToFile( MyFullPath : string ): Boolean;
var
 i,j : integer;
 fi : TextFile;
 w : Boolean;
begin
 try
  AssignFile(fi,MyFullPath);
  Rewrite(fi);
  writeln(fi,MQ.FieldCount);
  for i:=0 to MQ.FieldCount-1 do
   begin
    writeln(fi,MQ.Fields[i].FieldName);
   end;
  writeln(fi,LKK);
  if LKK>0 then
   begin
    for i:=0 to LKK-1 do
     begin
      writeln(fi,EKP[i].Caption);
      writeln(fi,EKP[i].FunctionName);
     end;
   end;
  writeln(fi,LK);
  writeln(fi,FModuleSummary.MainGrid.RowCount);
  for i:=0 to LK-1 do
   begin
    writeln(fi,KR[i].FieldName);
    j:=0;w:=False;
    while j<FModuleSummary.MainGrid.RowCount-1 do
     begin
      if FModuleSummary.MainGrid.cells[0,j+1]=KR[i].FieldName then
       begin
        w:=True;
        j:=FModuleSummary.MainGrid.RowCount;
       end;
      j:=j+1;
     end;
     if w then
      writeln(fi,'1')
     else
      writeln(fi,'0');
    writeln(fi,KR[i].Key);
   end;
  Close(fi);
  Result:=True;
 except
  Result:=False;
 end;
end;

function MyShowTotal(F : Pointer; Q : TADOQuery; G : TDBGrid; MyFullPath : string) : Boolean;
var
 i,j : integer;
 w : Boolean;
begin
 FBrowseParent := F;
 try
  MQ:=Q;
  MG:=G;
  for i:=0 to Q.FieldCount-1 do
   begin
    w:=False;
    for j:=0 to G.FieldCount-1 do
     begin
      if Q.Fields[i].FieldName=G.Columns[j].FieldName then
       begin
        Q.Fields[i].DisplayLabel:=G.Columns[j].Title.Caption;
        w:=True;
       end;
     end;
    if not w then
     Q.Fields[i].DisplayLabel:=Q.Fields[i].FieldName;
   end;
  FModuleSummary:=TFModuleSummary.Create(nil);
  FModuleSummary.MainGrid.cells[0,0]:='Kolumna tabeli';
  FModuleSummary.MainGrid.ColWidths[0]:=1;
  FModuleSummary.MainGrid.cells[1,0]:='Etykieta pola';
  FModuleSummary.MainGrid.ColWidths[1]:=200;
  if not (LoadTotalFromFile(MyFullPath)) then
   begin
    FModuleSummary.MainGrid.cells[2,0]:='Suma';
    FModuleSummary.MainGrid.ColWidths[2]:=110;
    EKP[0].Caption:='Suma';
    EKP[0].FunctionName:='SUM';
    FModuleSummary.MainGrid.cells[3,0]:='Œrednia';
    FModuleSummary.MainGrid.ColWidths[3]:=110;
    EKP[1].Caption:='Œrednia';
    EKP[1].FunctionName:='AVG';
    FModuleSummary.MainGrid.cells[4,0]:='Wariancja';
    FModuleSummary.MainGrid.ColWidths[4]:=110;
    EKP[2].Caption:='Wariancja';
    EKP[2].FunctionName:='VARIANCE';
    FModuleSummary.MainGrid.cells[5,0]:='Odchylenie std.';
    FModuleSummary.MainGrid.ColWidths[5]:=110;
    EKP[3].Caption:='Odchylenie std.';
    EKP[3].FunctionName:='STDDEV';
    FModuleSummary.MainGrid.cells[6,0]:='Min';
    FModuleSummary.MainGrid.ColWidths[6]:=110;
    EKP[4].Caption:='Min';
    EKP[4].FunctionName:='MIN';
    FModuleSummary.MainGrid.cells[7,0]:='Max';
    FModuleSummary.MainGrid.ColWidths[7]:=110;
    EKP[5].Caption:='Max';
    EKP[5].FunctionName:='MAX';
    FModuleSummary.MainGrid.ColCount:=8;
    LKK:=6;
    j:=1;
    for i:=0 to Q.FieldCount-1 do
     begin
      if (Q.Fields[i].DataType=ftInteger) or (Q.Fields[i].DataType=ftWord) or (Q.Fields[i].DataType=ftFloat) then
       begin
        FModuleSummary.MainGrid.cells[0,j]:=Q.Fields[i].FieldName;
        FModuleSummary.MainGrid.cells[1,j]:=Q.Fields[i].DisplayLabel;
        //k:=0;
        //while k<G.FieldCount do
         //begin
          //if Q.Fields[i].FieldName=G.Columns.Items[k].FieldName then
           //begin
            //FModuleSummary.MainGrid.cells[1,j]:=Q.Fields[k].DisplayLabel;
            //k:=G.FieldCount;
           //end;
           //k:=k+1;
         //end;
        KR[j-1].FieldName:=Q.Fields[i].FieldName;
        KR[j-1].Key:=126;
        j:=j+1;
       end;
     end;
    LK:=j-1;
    FModuleSummary.MainGrid.RowCount:=j;
   end;
  FModuleSummary.ShowModal;
  SaveTotalToFile(MyFullPath);
  Result:=True;
 except
  FModuleSummary.Destroy;
  Result:=False;
 end;
end;
{$R *.DFM}

procedure TFModuleSummary.BitBtn4Click(Sender: TObject);
begin
 try
  if FModuleSummary.MainGrid.Row>0 then
   MyShowOpcje(FModuleSummary.MainGrid.Cells[1,FModuleSummary.MainGrid.Row])
  else
   ShowMessage('Dla tego wiersza nie mo¿na ustawiæ opcji');
 except
 end;
end;

procedure TFModuleSummary.BitBtn1Click(Sender: TObject);
begin
 if SaveDialog1.Execute then
  begin
   SaveTotalToFile(SaveDialog1.FileName);
  end;
end;

procedure TFModuleSummary.BitBtn2Click(Sender: TObject);
begin
 if OpenDialog1.Execute then
  begin
   LoadTotalFromFile(OpenDialog1.FileName);
  end;
end;

procedure OdswiezWiersz( P : integer);
var
 i,k,j,key,l,y : integer;
 field : string;
 w : string;
begin
  i:=0;W:='';
  while i<MQ.SQL.Count do
   begin
    if Pos('FROM',UpperCase(MQ.SQL.Strings[i]))<>0 then
     begin
       k:=Pos('FROM',UpperCase(MQ.SQL.Strings[i]));
       w:=Copy(MQ.SQL.Strings[i],k,Length(MQ.SQL.Strings[i])-k+1);
       j:=0;
       while j<LK do
        begin
         if KR[j].FieldName=FModuleSummary.MainGrid.cells[0,p] then
          begin
           key:=KR[j].Key;
           field:=KR[j].FieldName;
          end;
         j:=j+1;
        end;
      FModuleSummary.Q1.SQL.Clear;
      FModuleSummary.Q1.SQL.Add('select  ');
      for l:=0 to LKK-1 do
       begin
        if (key AND round(Power(2,l+1))=round(Power(2,l+1))) then FModuleSummary.Q1.SQL.Add('NVL('+EKP[l].FunctionName+'('+FBrowseParent.DecodeFieldName(field)+'),0) S'+IntTOStr(l)+',');
       end;
      FModuleSummary.Q1.SQL.Add('''ss'''+' '+w);
      for j:=i+1 to MQ.SQL.Count-1 do
       begin
        FModuleSummary.Q1.SQL.Add(MQ.SQL.Strings[j]);
       end;
      FModuleSummary.Q1.Connection := MQ.Connection;
      try
       j:=0;y:=0;
       while j<FModuleSummary.Q1.SQL.Count do
       begin
        if Pos('ORDER BY',UpperCase(FModuleSummary.Q1.SQL.Strings[j]))<>0 then
         begin
           //t:=Pos('ORDER BY',UpperCase(FModuleSummary.Q1.SQL.Strings[j]));
           j:=FModuleSummary.Q1.SQL.Count;
         end
        else
         begin
          y:=y+1;
          j:=j+1;
         end;
       end;
       for j:=y to FModuleSummary.Q1.SQL.Count-1 do
        begin
         FModuleSummary.Q1.SQL.Strings[j]:='';
        end;
      FModuleSummary.Q1.Open;
      for l:=0 to LKK-1 do
       begin
        if (key AND round(Power(2,l+1))=round(Power(2,l+1))) then FModuleSummary.MainGrid.cells[2+l,p]:=FormatFloat('0.00',FModuleSummary.Q1.FieldByName('S'+IntToStr(l)).AsFloat);
       end;
      FModuleSummary.Q1.Close;
      except
       on E : EDBEngineError do
        begin
         if (E.Errors[0].ErrorCode=10038) and  (E.Errors[0].SubCode=54) then
          begin
           FModuleSummary.Q1.Close;
           FModuleSummary.Q1.SQL.Clear;
           FModuleSummary.Q1.SQL.Add('select  ');
           for l:=0 to LKK-1 do
            begin
             if (key AND round(Power(2,l+1))=round(Power(2,l+1))) then FModuleSummary.Q1.SQL.Add('NVL('+EKP[l].FunctionName+'('+ExtractOigin(MQ,field)+'),0) S'+IntTOStr(l)+',');
            end;
           FModuleSummary.Q1.SQL.Add('''ss'''+' '+w);
           for j:=i+1 to MQ.SQL.Count-1 do
            begin
             FModuleSummary.Q1.SQL.Add(MQ.SQL.Strings[j]);
            end;
            try
             while j<FModuleSummary.Q1.SQL.Count do
              begin
               if Pos('ORDER BY',UpperCase(FModuleSummary.Q1.SQL.Strings[j]))<>0 then
                begin
                 //t:=Pos('ORDER BY',UpperCase(FModuleSummary.Q1.SQL.Strings[j]));
                 j:=FModuleSummary.Q1.SQL.Count;
                end
               else
                begin
                 y:=y+1;
                 j:=j+1;
                end;
              end;
             for j:=y to FModuleSummary.Q1.SQL.Count-1 do
              begin
               FModuleSummary.Q1.SQL.Strings[j]:='';
              end;
             FModuleSummary.Q1.Open;
             for l:=0 to LKK-1 do
              begin
               if (key AND round(Power(2,l+1))=round(Power(2,l+1))) then FModuleSummary.MainGrid.cells[2+l,p]:=FormatFloat('0.00',FModuleSummary.Q1.FieldByName('S'+IntToStr(l)).AsFloat);
              end;
             FModuleSummary.Q1.Close;
            except
             on E1 : EDBEngineError do
               ShowMessage('Pole zapytania: '+field+', etykieta pola:'+FModuleSummary.MainGrid.cells[1,p]+'    B³¹d : '+E.Message);
            end;
          end
         else
          ShowMessage('Pole zapytania: '+field+', etykieta pola:'+FModuleSummary.MainGrid.cells[1,p]+'    B³¹d : '+E.Message);
        end;
      end;
      i:=MQ.SQL.Count;
     end
    else
     i:=i+1;
   end;
end;

procedure TFModuleSummary.BitBtn5Click(Sender: TObject);
var
 p,g : integer;
begin
 g:=FModuleSummary.MainGrid.RowCount-1;
 for p:=1 to g do
  begin
   try
    OdswiezWiersz(p);
   except
   end;
 end;
end;

procedure TFModuleSummary.BitBtn6Click(Sender: TObject);
var
 i : integer;
begin
 if MyShowKonfigOpcje then
  begin
   FModuleSummary.MainGrid.ColCount:=LKK+2;
   for i:=0 to LKK-1 do
    begin
     FModuleSummary.MainGrid.cells[i+2,0]:=EKP[i].Caption;
     FModuleSummary.MainGrid.ColWidths[i+2]:=110;
     FModuleSummary.MainGrid.Width:=FModuleSummary.MainGrid.Width+110;
    end;
    FModuleSummary.MainGrid.Repaint;
  end;
end;



procedure TFModuleSummary.BitBtn8Click(Sender: TObject);
var
 i : integer;
begin
 if FModuleSummary.MainGrid.Row>0 then
  begin
   for i:=FModuleSummary.MainGrid.Row to FModuleSummary.MainGrid.RowCount-2 do
    begin
     FModuleSummary.MainGrid.cells[0,i]:=FModuleSummary.MainGrid.cells[0,i+1];
     FModuleSummary.MainGrid.cells[1,i]:=FModuleSummary.MainGrid.cells[1,i+1]
    end;
   FModuleSummary.MainGrid.cells[0,FModuleSummary.MainGrid.RowCount-1]:='';
   FModuleSummary.MainGrid.cells[1,FModuleSummary.MainGrid.RowCount-1]:='';
   FModuleSummary.MainGrid.RowCount:=FModuleSummary.MainGrid.RowCount-1;
   if FModuleSummary.MainGrid.RowCount=1 then
    begin
     FModuleSummary.BitBtn8.Enabled:=False;
     FModuleSummary.BitBtn5.Enabled:=False;
     FModuleSummary.MenuForWeb.Items[1].Enabled:=False;
     FModuleSummary.MenuForWeb.Items[3].Enabled:=False;
    end;
  end;
end;

procedure TFModuleSummary.BitBtn7Click(Sender: TObject);
begin
 if MyShowPola(MQ,FModuleSummary.MainGrid) then
  begin
   FModuleSummary.MainGrid.FixedRows:=1;
   FModuleSummary.BitBtn8.Enabled:=True;
   FModuleSummary.MenuForWeb.Items[1].Enabled:=True;
   FModuleSummary.BitBtn5.Enabled:=True;
   FModuleSummary.MenuForWeb.Items[3].Enabled:=True;
  end;
end;

procedure TFModuleSummary.MainGridDblClick(Sender: TObject);
begin
 BitBtn4Click(self);
end;

procedure TFModuleSummary.Opcje3Click(Sender: TObject);
begin
 BitBtn4Click(nil);
end;

procedure TFModuleSummary.Dodajpole1Click(Sender: TObject);
begin
 BitBtn7Click(Nil);
end;

procedure TFModuleSummary.Usupole1Click(Sender: TObject);
begin
 BitBtn8Click(Nil);
end;

procedure TFModuleSummary.Opcje1Click(Sender: TObject);
begin
 BitBtn6Click(Nil);
end;

procedure TFModuleSummary.Opcje2Click(Sender: TObject);
begin
 BitBtn5Click(Nil);
end;

end.
