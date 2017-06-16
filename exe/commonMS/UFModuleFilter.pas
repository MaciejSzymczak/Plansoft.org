unit UFModuleFilter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, StrHlder, StrUtils, UUtilityParent,
  ComCtrls, ToolWin;

type
  TFModuleFilter = class(TFormConfig)
    Middle: TGroupBox;
    Preview: TEdit;
    Top: TPanel;
    GroupBox2: TGroupBox;
    Add: TEdit;
    Messages: TStrHolder;
    Advanced: TBitBtn;
    Erase1: TBitBtn;
    Field1: TComboBox;
    Cond1: TComboBox;
    Value1_1: TEdit;
    Value2_1: TEdit;
    Erase2: TBitBtn;
    Field2: TComboBox;
    Cond2: TComboBox;
    Value1_2: TEdit;
    Value2_2: TEdit;
    Erase3: TBitBtn;
    Field3: TComboBox;
    Cond3: TComboBox;
    Value1_3: TEdit;
    Value2_3: TEdit;
    Erase4: TBitBtn;
    Field4: TComboBox;
    Cond4: TComboBox;
    Value1_4: TEdit;
    Value2_4: TEdit;
    Erase5: TBitBtn;
    Field5: TComboBox;
    Cond5: TComboBox;
    Value1_5: TEdit;
    Value2_5: TEdit;
    Erase6: TBitBtn;
    Field6: TComboBox;
    Cond6: TComboBox;
    Value1_6: TEdit;
    Value2_6: TEdit;
    Erase7: TBitBtn;
    Field7: TComboBox;
    Cond7: TComboBox;
    Value1_7: TEdit;
    Value2_7: TEdit;
    Erase8: TBitBtn;
    Field8: TComboBox;
    Cond8: TComboBox;
    Value1_8: TEdit;
    Value2_8: TEdit;
    Erase9: TBitBtn;
    Field9: TComboBox;
    Cond9: TComboBox;
    Value1_9: TEdit;
    Value2_9: TEdit;
    Erase10: TBitBtn;
    Field10: TComboBox;
    Cond10: TComboBox;
    Value1_10: TEdit;
    Value2_10: TEdit;
    Erase11: TBitBtn;
    Field11: TComboBox;
    Cond11: TComboBox;
    Value1_11: TEdit;
    Value2_11: TEdit;
    Erase12: TBitBtn;
    Field12: TComboBox;
    Cond12: TComboBox;
    Value1_12: TEdit;
    Value2_12: TEdit;
    Erase13: TBitBtn;
    Field13: TComboBox;
    Cond13: TComboBox;
    Value1_13: TEdit;
    Value2_13: TEdit;
    Bottom: TPanel;
    Cancel: TBitBtn;
    Active: TCheckBox;
    OK: TBitBtn;
    OD: TOpenDialog;
    SD: TSaveDialog;
    Panel1: TPanel;
    LDateFormat: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    TabSheet10: TTabSheet;
    Open: TBitBtn;
    Save: TBitBtn;
    Bracket1: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn17: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn21: TBitBtn;
    BitBtn22: TBitBtn;
    BitBtn23: TBitBtn;
    BitBtn24: TBitBtn;
    BitBtn25: TBitBtn;
    Operation1: TBitBtn;
    Operation2: TBitBtn;
    Operation3: TBitBtn;
    Operation4: TBitBtn;
    Operation5: TBitBtn;
    Operation6: TBitBtn;
    Operation7: TBitBtn;
    Operation8: TBitBtn;
    Operation9: TBitBtn;
    Operation10: TBitBtn;
    Operation11: TBitBtn;
    Operation12: TBitBtn;
    Operation13: TBitBtn;
    SpeedButton1: TSpeedButton;
    CaseSentensive: TCheckBox;
    procedure Field1Change(Sender: TObject);
    procedure Erase1Click(Sender: TObject);
    procedure Cond1Change(Sender: TObject);
    procedure Value1_1Change(Sender: TObject);
    procedure AddChange(Sender: TObject);
    procedure ActiveClick(Sender: TObject);
    procedure AdvancedClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure CaseSentensiveClick(Sender: TObject);
    procedure Field9DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure OpenClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure Bracket1Click(Sender: TObject);
    procedure Operation1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    flexContextName : string;
    TempCombos : TStrings;
  public
    Fields      : Array[1..13] Of TComboBox;
    Conds       : Array[1..13] Of TComboBox;
    Values1     : Array[1..13] Of TEdit;
    Values2     : Array[1..13] Of TEdit;
    Erases      : Array[1..13] Of TBitBtn;
    Operations  : Array[1..13] Of TBitBtn;
    Columns, FilterSettings : TStrings;
    CanRefresh  : Boolean;

    PRE_UPPERCASE, POST_UPPERCASE, PRE_UPPERCASE_TEXT, POST_UPPERCASE_TEXT, ANY_CHARS, ANY_CHAR, DateFormat, PRE_DATEFORMAT, POST_DATEFORMAT, PRE_DATEFORMAT_TEXT, POST_DATEFORMAT_TEXT : ShortString;
    today : string;

    Procedure FieldChange(T : Integer);
    Procedure CondChange(T : Integer);
    Function  GetExpression(Num : Integer; Wyr, WszystkieZnaki, Pusty, NiePusty, SpojnikAND, SpojnikOR, EmptyString, Miedzy, MiedzyI, Dzisiaj, LocalPRE_UPPERCASE, LocalPOST_UPPERCASE, LocalPRE_DATEFORMAT, LocalPOST_DATEFORMAT, IN_OPERATOR, NotInOperator, notEqual : ShortString) : String;
    Procedure RefreshPreview;
    Procedure CombosToStrings(S : Tstrings);
    Procedure StringsToCombos(S : Tstrings);
    Function  Start(aFilterSettings, aColumns : TStrings; ShowForm : Boolean; aflexContextName : string) : TModalResult;
    Function  GetFieldType(S : String) : ShortString;
    Function  GetFieldTypeForCombo(T : Integer) : ShortString;
    Function  PodajCaptionPola(T : Integer) : ShortString;
  end;
var
  FModuleFilter: TFModuleFilter;

Procedure initializeFilerSettings (aFilterSettings : TStrings; aflexContextName : string);
Function ShowModal(aFilterSettings, aColumns : TStrings; aflexContextName : string) : TModalResult;
Procedure GetSQLAndNotes(aFilterSettings, aColumns : TStrings; aflexContextName : string);

implementation

{$R *.DFM}

Uses DM;

Function ShowModal(aFilterSettings, aColumns : TStrings; aflexContextName : string) : TModalResult;
Begin
 FModuleFilter := TFModuleFilter.Create(Application);

 If dm.DModule.getDBType = 'ORACLE' Then FModuleFilter.today := 'TRUNC(SYSDATE)'
                                    Else FModuleFilter.today := 'date';

 Result := FModuleFilter.Start(aFilterSettings, aColumns, True, aflexContextName);
 FModuleFilter.Free;
End;

Procedure GetSQLAndNotes(aFilterSettings, aColumns : TStrings;  aflexContextName : string );
Begin
 FModuleFilter := TFModuleFilter.Create(Application);

 If dm.DModule.getDBType = 'ORACLE' Then FModuleFilter.today := 'TRUNC(SYSDATE)'
                                    Else FModuleFilter.today := 'date';

 FModuleFilter.Start(aFilterSettings, aColumns, False, aflexContextName);
 FModuleFilter.Free;
End;


Procedure TFModuleFilter.FieldChange(T : Integer);
Var FieldType : ShortString;
begin
  inherited;
  FieldType := GetFieldTypeForCombo(T);
  If FieldType = 'Error' Then Exit;
  If FieldType = 'ftOther' Then Begin
   Info(Messages.Strings[6]+' '+PodajCaptionPola(T)+' '+Messages.Strings[7]);
   Conds[T].Items.Clear;
   CondChange(T);
  End;

  If  FieldType = 'ftString' Then Begin
   Conds[T].Items.Clear;
   Conds[T].Items.Add(Messages.Strings[0]);
   Conds[T].Items.Add(Messages.Strings[1]);
   Conds[T].Items.Add(Messages.Strings[2]);
   Conds[T].Items.Add(Messages.Strings[3]);
   Conds[T].Items.Add(Messages.Strings[4]);
   Conds[T].Items.Add(Messages.Strings[5]);
   Conds[T].Items.Add('Lista wartoœci (A,B,C)');
   Conds[T].Items.Add('<> Ró¿ne');
   Conds[T].Items.Add('<>Lista wartoœci (A,B,C)');
   Conds[T].ItemIndex := 4;
   CondChange(T);
  End
  Else
  If FieldType = 'ftInteger' Then Begin
   Conds[T].Items.Clear;
   Conds[T].Items.Add('<=');
   Conds[T].Items.Add('<');
   Conds[T].Items.Add('=');
   Conds[T].Items.Add('>');
   Conds[T].Items.Add('>=');
   Conds[T].Items.Add('miêdzy');
   Conds[T].ItemIndex := 0;
   CondChange(T);
  End
  Else
  If FieldType = 'ftDate' Then Begin
   Conds[T].Items.Clear;
   Conds[T].Items.Add('Nie póŸniej (<=)');
   Conds[T].Items.Add('Wczeœniej (<)');
   Conds[T].Items.Add('Dok³adnie (=)');
   Conds[T].Items.Add('PóŸniej (>)');
   Conds[T].Items.Add('Nie wczeœniej (>=)');
   Conds[T].Items.Add('Miêdzy');

   Conds[T].Items.Add('Przedwczoraj');
   Conds[T].Items.Add('Wczoraj');
   Conds[T].Items.Add('Dzisiaj');
   Conds[T].Items.Add('Jutro');
   Conds[T].Items.Add('Pojutrze');
   Conds[T].Items.Add('Ostatnich 7 dni');
   Conds[T].Items.Add('Ostatnich n i kolejnych m dni');
   Conds[T].Items.Add('Zaleg³e');
   Conds[T].Items.Add('n do m dni naprzód');

   Conds[T].ItemIndex := 0;
   CondChange(T);
  End
  Else
  If FieldType = 'ftFloat' Then Begin
   Conds[T].Items.Clear;
   Conds[T].Items.Add('<=');
   Conds[T].Items.Add('<');
   Conds[T].Items.Add('=');
   Conds[T].Items.Add('>');
   Conds[T].Items.Add('>=');
   Conds[T].Items.Add('miêdzy');
   Conds[T].ItemIndex := 0;
   CondChange(T);
  End;

  If T < 13   Then Begin
    Fields[T+1].Visible := True;
    Conds[T+1].Visible  := True;
    Values1[T+1].Visible:= True;
    Erases[T+1].Visible := True;
  End;
  If T > 1   Then Begin
    Operations[T-1].Visible := True;
  End;
  If T = 13   Then Begin
    Operations[13].Visible := True;
  End;
end;

procedure TFModuleFilter.Field1Change(Sender: TObject);
Begin
 FieldChange((Sender As TComboBox).Tag);
 RefreshPreview;
End;

procedure TFModuleFilter.Erase1Click(Sender: TObject);
Var T, L : Integer;
begin
  inherited;
  CanRefresh := False;
  T := (Sender As TBitBtn).Tag;
  Fields[T].ItemIndex := -1;
  Values1[T].Text      := '';
  Values2[T].Text      := '';

  For L := T To 13 - 1 Do Begin
    Fields[L].ItemIndex := Fields[L+1].ItemIndex;
    Values1[L].Text      := Values1[L+1].Text;
    Values2[L].Text      := Values2[L+1].Text;
    If Fields[L].ItemIndex <> -1 Then FieldChange(L);
    Conds[L].ItemIndex  := Conds[L+1].ItemIndex;
    If Fields[L].ItemIndex <> -1 Then CondChange(L);
  End;

  Fields[13].ItemIndex  := -1;
  Values1[13].Text      := '';
  Values2[13].Text      := '';
  Conds[13].ItemIndex   := -1;

  For L := 1 To 12 Do Begin
    Fields[L+1].Visible  := Fields[L].ItemIndex <> -1;
    Erases[L+1].Visible  := Fields[L].ItemIndex <> -1;
    Conds[L+1].Visible   := Fields[L].ItemIndex <> -1;
    If Fields[L+1].ItemIndex <> -1 Then CondChange(L+1) Else Begin
      Values1[L+1].Visible  := False;
      Values2[L+1].Visible  := False;
    End;
  End;

  For L := 2 To 13 Do Begin
    Operations[L-1].Visible   := Fields[L].ItemIndex <> -1;
  End;
    Operations[13].Visible   := Fields[13].ItemIndex <> -1;

  CanRefresh := True;
  RefreshPreview;
end;

Function TFModuleFilter.GetExpression;

    Function CondFtString(NazwaPola, S : String; I : Integer; WszystkieZnaki, Pusty, NiePusty, LocalPRE_UPPERCASE, LocalPOST_UPPERCASE, IN_OPERATOR : ShortString) : ShortString;
    var t : integer;
        token, tokens : string;

    Begin
     If (I <> 2) AND (I <> 3) AND (Trim(S)='') Then Begin Result := ''; Exit; End;

     Case I of
      0:S := ''''+S+'''';
      1:S := ''''+WszystkieZnaki+S+'''';
      2:S := S;
      3:S := S;
      4:S := ''''+S+WszystkieZnaki+'''';
      5:S := ''''+WszystkieZnaki+S+WszystkieZnaki+'''';
      //6
      7:S := ''''+S+'''';
      //8
      //Else Info('ftString: 1 Cond poza zakresem Cond='+IntToStr(I));
     End;
     If Not CaseSentensive.Checked Then NazwaPola := LocalPRE_UPPERCASE + NazwaPola + LocalPOST_UPPERCASE;

     If (I <> 2) AND (I <> 3) AND (I <> 6) Then
       If Not CaseSentensive.Checked Then S := LocalPRE_UPPERCASE + S + LocalPOST_UPPERCASE;

     Case I of
      0:Result := NazwaPola+WYR+' '+S;
      1:Result := NazwaPola+WYR+' '+S;
      2:Result := NazwaPola+NiePusty;
      3:Result := NazwaPola+Pusty;
      4:Result := NazwaPola+WYR+' '+S;
      5:Result := NazwaPola+WYR+' '+S;
      6:Begin
          tokens := '';
          For t := 1 To WordCount(S,[',']) Do Begin
           token :=  ExtractWord(t,S,[',']);
           token := '''' + token + '''';
           If Not CaseSentensive.Checked Then token := LocalPRE_UPPERCASE + token + LocalPOST_UPPERCASE;
           tokens := merge(tokens,token,',');
          End;
          tokens := '(' + tokens + ')';
          Result := NazwaPola + IN_OPERATOR + tokens; // @@@
        End;
       7:Result := NazwaPola+notEqual+' '+S;
       8:Begin
           tokens := '';
           For t := 1 To WordCount(S,[',']) Do Begin
            token :=  ExtractWord(t,S,[',']);
            token := '''' + token + '''';
            If Not CaseSentensive.Checked Then token := LocalPRE_UPPERCASE + token + LocalPOST_UPPERCASE;
            tokens := merge(tokens,token,',');
           End;
           tokens := '(' + tokens + ')';
           Result := NazwaPola + NotInOperator + tokens; // @@@
         End;
      //Else Info('ftString: 2 Cond poza zakresem Cond='+IntToStr(I));
     End;
    End;

    Function CondFtInteger(NazwaPola, S1, S2 : ShortString; I : Integer; Miedzy, MiedzyI : ShortString) : ShortString;
    Begin
     If (I in [0,1,2,3,4]) AND (Trim(S1)='') Then
      Begin
       Result := '';
       Exit;
      End;

     If (I  = 5 ) AND ((Trim(S1)='') Or (Trim(s2)='')) Then
      Begin
       Result := '';
       Exit;
      End;

     Case I of
      0:Result := NazwaPola+'<='+S1;
      1:Result := NazwaPola+'<'+S1;
      2:Result := NazwaPola+'='+S1;
      3:Result := NazwaPola+'>'+S1;
      4:Result := NazwaPola+'>='+S1;
      5:Result := NazwaPola+ miedzy +S1 + MiedzyI + S2;
      Else Info('ftInt: Cond poza zakresem Cond='+IntToStr(I));
     End;
    End;

    Function CondFtDate(NazwaPola, S1, S2 : ShortString; I : Integer; Miedzy, MiedzyI, Dzisiaj : ShortString) : ShortString;
    Var OrigS1, OrigS2 : ShortString;
    Begin
     If (I in [0,1,2,3,4]) AND (Trim(S1)='') Then
      Begin
       Result := '';
       Exit;
      End;
     If (I  in [5,12,14] ) AND ((Trim(S1)='') Or (Trim(s2)='')) Then
      Begin
       Result := '';
       Exit;
      End;

       //6Conds[T].Items.Add('Przedwczoraj');
       //7Conds[T].Items.Add('Wczoraj');
       //8Conds[T].Items.Add('Dzisiaj');
       //9Conds[T].Items.Add('Jutro');
       //10Conds[T].Items.Add('Pojutrze');
       //11Conds[T].Items.Add('Ostatnich 7 dni');
       //12Conds[T].Items.Add('Ostatnich n i kolejnych m dni');
       //13Conds[T].Items.Add('Zaleg³e');
       //14Conds[T].Items.Add('n do m dni naprzód');

     OrigS1 := S1; OrigS2 := S2;

     If LocalPRE_DATEFORMAT = 'MSACCESS_FORMAT' Then Begin
       S1 := 'DateSerial(Left('''+S1+''',4),Mid('''+S1+''',6,2),Right('''+S1+''',2))';
       S2 := 'DateSerial(Left('''+S2+''',4),Mid('''+S2+''',6,2),Right('''+S2+''',2))';
     End Else Begin
       S1 := LocalPRE_DATEFORMAT + S1 + LocalPOST_DATEFORMAT;
       S2 := LocalPRE_DATEFORMAT + S2 + LocalPOST_DATEFORMAT;
     End;

     Case I of
      0:Result := NazwaPola+'<='+S1;
      1:Result := NazwaPola+'<'+S1;
      2:Result := NazwaPola+'='+S1;
      3:Result := NazwaPola+'>'+S1;
      4:Result := NazwaPola+'>='+S1;
      5:Result := NazwaPola+ miedzy +S1 + MiedzyI + S2;
      6:Result := NazwaPola+'='+Dzisiaj+'-2';
      7:Result := NazwaPola+'='+Dzisiaj+'-1';
      8:Result := NazwaPola+'='+Dzisiaj;
      9:Result := NazwaPola+'='+Dzisiaj+'+1';
      10:Result := NazwaPola+'='+Dzisiaj+'+2';
      11:Result := NazwaPola+ miedzy +Dzisiaj+'-6' + MiedzyI + Dzisiaj;
      12:Result := NazwaPola+ miedzy +Dzisiaj+'-'+OrigS1+ MiedzyI + Dzisiaj+'+'+OrigS2;
      13:Result := NazwaPola+'<'+Dzisiaj;
      14:Result := NazwaPola+ miedzy +Dzisiaj+'+'+OrigS1+ MiedzyI + Dzisiaj+'+'+OrigS2;
      Else Info('ftDate: Cond poza zakresem Cond='+IntToStr(I));
     End;
    End;

    Function CondFtFloat(NazwaPola, S1, S2 : ShortString; I : Integer; Miedzy, MiedzyI : ShortString) : ShortString;
    Begin
     If (I in [0,1,2,3,4]) AND (Trim(S1)='') Then
      Begin
       Result := '';
       Exit;
      End;
     If (I  = 5 ) AND ((Trim(S1)='') Or (Trim(s2)='')) Then
      Begin
       Result := '';
       Exit;
      End;

     Case I of
      0:Result := NazwaPola+'<='+S1;
      1:Result := NazwaPola+'<'+S1;
      2:Result := NazwaPola+'='+S1;
      3:Result := NazwaPola+'>'+S1;
      4:Result := NazwaPola+'>='+S1;
      5:Result := NazwaPola+ miedzy +S1 + MiedzyI + S2;
      Else Info('ftFloat: Cond poza zakresem Cond='+IntToStr(I));
     End;
    End;

    Function SingleCond(Num,I : Integer; Wyr, WszystkieZnaki, Pusty, NiePusty, Miedzy, MiedzyI, Dzisiaj, LocalPRE_UPPERCASE, LocalPOST_UPPERCASE, IN_OPERATOR : ShortString) : ShortString;
    Var FieldType : ShortString;
    Begin
     FieldType := GetFieldTypeForCombo(I);
     If FieldType = 'Error'   Then Begin Result := ''; Exit; End;
     If FieldType = 'ftOther' Then Begin Result := ''; Exit; End;

     If FieldType = 'ftString' Then Begin
      If Fields[I].ItemIndex <> -1 Then Result := CondFtString(ExtractWord(Num,Columns[Fields[I].ItemIndex],['|']), Values1[I].Text, Conds[I].ItemIndex, WszystkieZnaki, Pusty, NiePusty, LocalPRE_UPPERCASE, LocalPOST_UPPERCASE, IN_OPERATOR)
                                   Else Result := '';
     End
     Else
     If FieldType = 'ftInteger' Then Begin
          If Fields[I].ItemIndex <> -1 Then Result := CondFtInteger(ExtractWord(Num,Columns[Fields[I].ItemIndex],['|']), Values1[I].Text, Values2[I].Text, Conds[I].ItemIndex, Miedzy, MiedzyI)
                                       Else Result := '';
     End
     Else
     If FieldType = 'ftDate' Then Begin
          If Fields[I].ItemIndex <> -1 Then Result := CondFtDate(ExtractWord(Num,Columns[Fields[I].ItemIndex],['|']), Values1[I].Text, Values2[I].Text, Conds[I].ItemIndex, Miedzy, MiedzyI, Dzisiaj)
                                       Else Result := '';
     End
     Else
     If FieldType = 'ftFloat' Then Begin
          If Fields[I].ItemIndex <> -1 Then Result := CondFtFloat(ExtractWord(Num,Columns[Fields[I].ItemIndex],['|']), Values1[I].Text, Values2[I].Text, Conds[I].ItemIndex, Miedzy, MiedzyI)
                                       Else Result := '';
     End;
    End;

    Function GetOperation ( i : Integer) : String;
    Begin
      If i < 1 Then Begin Result := ''; Exit; End;
      If TBitBtn(Operations[i]).Caption =  'i' Then Result := SpojnikAnd Else Result := SpojnikOR;
    End;

Var I : Integer;
begin
  inherited;
  If Not Active.Checked Then Result := EmptyString
  Else Begin
    Result := '';
    For I := 1 To 13 Do Result := Merge(Result, SingleCond(Num, I, Wyr, WszystkieZnaki, Pusty, NiePusty, Miedzy, MiedzyI, Dzisiaj, LocalPRE_UPPERCASE, LocalPOST_UPPERCASE, IN_OPERATOR), GetOperation(i-1) );
    Result := Merge(Result, Trim(Add.Text), GetOperation(13) );
    If Result = '' Then Result := EmptyString;
  End;
end;

Procedure TFModuleFilter.RefreshPreview;
Begin
 If Not CanRefresh Then Exit;
 Preview.Text := GetExpression(1,' =', '...', ' Puste', ' Nie puste', ' i ',' lub ', 'Wszystkie', ' miêdzy ', ' i ', 'Dzisiaj', PRE_UPPERCASE_TEXT, POST_UPPERCASE_TEXT, PRE_DATEFORMAT_TEXT, POST_DATEFORMAT_TEXT,' w ',' nie w ','<>');
End;

Procedure TFModuleFilter.CondChange(T : Integer);
Var FieldType : ShortString;
Begin
 If T = -1 Then Begin
   Exit;
 End;
 FieldType := GetFieldTypeForCombo(T);
 If  FieldType = 'ftString'  Then Begin
   Values1[T].Visible := (Conds[T].ItemIndex  <> 2) And (Conds[T].ItemIndex  <> 3);
   Values2[T].Visible := False;
 End
 Else
 If  FieldType = 'ftInteger' Then Begin
  Values1[T].Visible := True;
  Values2[T].Visible := Conds[T].Itemindex = 5;
 End
 Else
 If  FieldType = 'ftDate' Then Begin
  Values1[T].Visible := False;
  Values2[T].Visible := False;
  If Conds[T].Itemindex in [0,1,2,3,4,5,12,14] Then Values1[T].Visible := True;
  If Conds[T].Itemindex in [5,12,14] Then Values2[T].Visible := True;
 End
 Else
 If  FieldType = 'ftFloat' Then Begin
  Values1[T].Visible := True;
  Values2[T].Visible := Conds[T].Itemindex = 5;
 End;

 RefreshPreview;
End;

procedure TFModuleFilter.Cond1Change(Sender: TObject);
Var T : Integer;
begin
  inherited;
 T := (Sender As TComboBox).Tag;
 CondChange(T);
end;

procedure TFModuleFilter.Value1_1Change(Sender: TObject);
begin
  inherited;
 RefreshPreview;
end;

Procedure TFModuleFilter.CombosToStrings(S : Tstrings);
 Var T : Integer;
 Const BoolToChar : Array[False..True] Of ShortString = ('False', 'True');
Begin
 tempCombos.CommaText := S.Values['Combos.Category:'+flexContextName];
 For T := 1 To 13 Do
   tempCombos[T-1] :=
             IntToStr(Fields[T].ItemIndex) + '|' +
             IntToStr(Conds[T].ItemIndex) + '|' +
             Values1[T].Text + '|' +
             Values2[T].Text + '|' +
             Operations[T].Caption;
 S.Values['Combos.Category:'+flexContextName]   := tempCombos.CommaText;
 S.Values['Additional.Category:'+flexContextName] := Add.Text;
 S.Values['Active.Category:'    +flexContextName] := BoolToChar[Active.Checked];
 S.Values['SQL.Category:'       +flexContextName] := GetExpression(2,' LIKE', ANY_CHARS, ' IS NULL',' IS NOT NULL',' AND ',' OR ', '0=0', ' BETWEEN ', ' AND ', today,PRE_UPPERCASE, POST_UPPERCASE, PRE_DATEFORMAT, POST_DATEFORMAT,' in ',' not in ','<>');
 S.Values['Notes.Category:'     +flexContextName] := GetExpression(1,' =', '...', ' Puste', ' Nie puste', ' i ',' lub ', 'Wszystkie', ' miêdzy ', ' i ', 'dzisiaj', PRE_UPPERCASE_TEXT, POST_UPPERCASE_TEXT, PRE_DATEFORMAT_TEXT, POST_DATEFORMAT_TEXT, '  w ',' nie w ','<>');
End;

Procedure TFModuleFilter.StringsToCombos(S : TStrings);
 Var T : Integer;
Begin
 if S.Values['Combos.Category:'+flexContextName] = '' then
   initializeFilerSettings ( S, flexContextName );

 tempCombos.CommaText := S.Values['Combos.Category:'+flexContextName];
 For T := 1 To 13 Do Begin
  Fields[T].ItemIndex := StrToInt(ExtractWord(1,tempCombos[T-1],['|']));
  If Fields[T].ItemIndex <> -1 Then FieldChange(T);
  Conds[T].ItemIndex  := StrToInt(ExtractWord(2,tempCombos[T-1],['|']));
  If Fields[T].ItemIndex <> -1 Then CondChange(T);
  Values1[T].Text      := ExtractWord(3,tempCombos[T-1],['|']);
  Values2[T].Text      := ExtractWord(4,tempCombos[T-1],['|']);
  Operations[T].Caption      := NVL(ExtractWord(5,tempCombos[T-1],['|']),'i');
 End;
 Add.Text := S.Values['Additional.Category:'  +flexContextName];
 Active.Checked := S.Values['Active.Category:'+flexContextName] <> 'False';
End;

Function TFModuleFilter.Start(aFilterSettings, aColumns : TStrings; ShowForm : Boolean;  aflexContextName : string ) : TModalResult;
  Var I,L : Integer;
Begin
  FModuleFilter.flexContextName := aflexContextName;

  //copy only fit values
  columns := TStringList.Create;
  columns.Clear;
  For L := 0 To aColumns.Count - 1 Do
    //if ExtractWord(5,aColumns[L],['|']) = 'Y' then
      if (ExtractWord(4,aColumns[L],['|']) = 'CATEGORY:DEFAULT') or
         (ExtractWord(4,aColumns[L],['|']) = 'CATEGORY:'+flexContextName) then
              Columns.Add( aColumns[L] );

  FilterSettings  := aFilterSettings;

  ActiveControl := Value1_1;

  Fields[1]    := Field1;
  Fields[2]    := Field2;
  Fields[3]    := Field3;
  Fields[4]    := Field4;
  Fields[5]    := Field5;
  Fields[6]    := Field6;
  Fields[7]    := Field7;
  Fields[8]    := Field8;
  Fields[9]    := Field9;
  Fields[10]   := Field10;
  Fields[11]   := Field11;
  Fields[12]   := Field12;
  Fields[13]   := Field13;

  Conds[1]     := Cond1;
  Conds[2]     := Cond2;
  Conds[3]     := Cond3;
  Conds[4]     := Cond4;
  Conds[5]     := Cond5;
  Conds[6]     := Cond6;
  Conds[7]     := Cond7;
  Conds[8]     := Cond8;
  Conds[9]     := Cond9;
  Conds[10]    := Cond10;
  Conds[11]    := Cond11;
  Conds[12]    := Cond12;
  Conds[13]    := Cond13;

  Values1[1]   := Value1_1;
  Values1[2]   := Value1_2;
  Values1[3]   := Value1_3;
  Values1[4]   := Value1_4;
  Values1[5]   := Value1_5;
  Values1[6]   := Value1_6;
  Values1[7]   := Value1_7;
  Values1[8]   := Value1_8;
  Values1[9]   := Value1_9;
  Values1[10]  := Value1_10;
  Values1[11]  := Value1_11;
  Values1[12]  := Value1_12;
  Values1[13]  := Value1_13;

  Values2[1]   := Value2_1;
  Values2[2]   := Value2_2;
  Values2[3]   := Value2_3;
  Values2[4]   := Value2_4;
  Values2[5]   := Value2_5;
  Values2[6]   := Value2_6;
  Values2[7]   := Value2_7;
  Values2[8]   := Value2_8;
  Values2[9]   := Value2_9;
  Values2[10]  := Value2_10;
  Values2[11]  := Value2_11;
  Values2[12]  := Value2_12;
  Values2[13]  := Value2_13;

  Erases[1]    := Erase1;
  Erases[2]    := Erase2;
  Erases[3]    := Erase3;
  Erases[4]    := Erase4;
  Erases[5]    := Erase5;
  Erases[6]    := Erase6;
  Erases[7]    := Erase7;
  Erases[8]    := Erase8;
  Erases[9]    := Erase9;
  Erases[10]   := Erase10;
  Erases[11]   := Erase11;
  Erases[12]   := Erase12;
  Erases[13]   := Erase13;

  Operations[ 1]    := Operation1;
  Operations[ 2]    := Operation2;
  Operations[ 3]    := Operation3;
  Operations[ 4]    := Operation4;
  Operations[ 5]    := Operation5;
  Operations[ 6]    := Operation6;
  Operations[ 7]    := Operation7;
  Operations[ 8]    := Operation8;
  Operations[ 9]    := Operation9;
  Operations[10]    := Operation10;
  Operations[11]    := Operation11;
  Operations[12]    := Operation12;
  Operations[13]    := Operation13;

  //Color|COLOUR|ftFloat|CATEGORY:DEFAULT|Y
  For I := 1 To 13 Do Begin
   For L := 0 To Columns.Count - 1 Do
     //if ExtractWord(5,Columns[L],['|']) = 'Y' then
          Fields[I].Items.Add(ExtractWord(1,Columns[L],['|']));
  End;

  StringsToCombos(FilterSettings);
  ActiveClick(nil);

  If ShowForm Then Begin
    Result := ShowModal;
    If Result = mrOK Then CombosToStrings(FilterSettings);
  End
  Else Begin
   CombosToStrings(FilterSettings);
  End;
End;

procedure TFModuleFilter.AddChange(Sender: TObject);
begin
  inherited;
 RefreshPreview;
end;

procedure TFModuleFilter.ActiveClick(Sender: TObject);
begin
  inherited;
 Top.Visible := Active.Checked;
end;

Function TFModuleFilter.GetFieldType(S : String) : ShortString;
Begin
 Result := ExtractWord(3,S,['|']);
End;

Function TFModuleFilter.GetFieldTypeForCombo(T : Integer) : ShortString;
Begin
  if Fields[T].ItemIndex = -1 then begin
    Result := 'Error';
  end else 
  Try    Result := GetFieldType(Columns[Fields[T].ItemIndex]);
  Except Result := 'Error'; End;
End;

Function TFModuleFilter.PodajCaptionPola(T : Integer) : ShortString;
Begin
 Try
  Result := Fields[T].Items[Fields[T].ItemIndex];
 Except
  Result := '?';
 End;
End;

procedure TFModuleFilter.AdvancedClick(Sender: TObject);
begin
  inherited;
 INFO(GetExpression(2,' LIKE', ANY_CHARS, ' IS NULL',' IS NOT NULL',' AND ',' OR ', '0=0', ' BETWEEN ', ' AND ', today, PRE_UPPERCASE, POST_UPPERCASE, PRE_DATEFORMAT, POST_DATEFORMAT, ' in ',' not in ','<>'));
end;

Type SetOfChar = Set Of Char;

Function ZawieraInneZnakiNiz(S : ShortString; C : SetOfChar) : Boolean;
Var T : Integer;
Begin
 Result := False;
 For T := 1 To Length(S) Do Begin
   Result := Result Or (Not (S[T] in C));
 End;
End;

procedure TFModuleFilter.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
Var T : Integer;
    FieldType : ShortString;
begin
  inherited;
  If ModalResult = mrOK Then Begin
   With CheckValid Do Begin
    Init(Self);
    For T := 1 To 13 Do Begin
     FieldType := GetFieldTypeForCombo(T);

     If FieldType = 'ftString' Then
       If Values1[T].Visible Then If Pos('''',Values1[T].Text)<>0 Then addError(PodajCaptionPola(T)+Messages.Strings[8]);

     If FieldType = 'ftInteger' Then Begin
       If Values1[T].Visible Then If ZawieraInneZnakiNiz(Values1[T].Text,['0','1','2','3','4','5','6','7','8','9','+','-','e']) Then addError(PodajCaptionPola(T)+Messages.Strings[9]);
       If Values2[T].Visible Then If ZawieraInneZnakiNiz(Values2[T].Text,['0','1','2','3','4','5','6','7','8','9','+','-','e']) Then addError(PodajCaptionPola(T)+Messages.Strings[10]);
     End;

     If FieldType = 'ftFloat' Then Begin
       If Values1[T].Visible Then If ZawieraInneZnakiNiz(Values1[T].Text,['0','1','2','3','4','5','6','7','8','9','+','-','e','.',',']) Then addError(PodajCaptionPola(T)+Messages.Strings[11]);
       If Values2[T].Visible Then If ZawieraInneZnakiNiz(Values2[T].Text,['0','1','2','3','4','5','6','7','8','9','+','-','e','.',',']) Then addError(PodajCaptionPola(T)+Messages.Strings[12]);
       If Values1[T].Visible Then If Pos(',',Values1[T].Text)<>0 Then addError(PodajCaptionPola(T)+Messages.Strings[13]);
       If Values2[T].Visible Then If Pos(',',Values2[T].Text)<>0 Then addError(PodajCaptionPola(T)+Messages.Strings[13]);
     End;

    End;
    CanClose := ShowMessage;
   End;
  End;
end;

procedure TFModuleFilter.FormCreate(Sender: TObject);
begin
  inherited;
 TempCombos := TStringList.Create;
 PRE_UPPERCASE       := GetSystemParam('PRE_UPPERCASE');
 POST_UPPERCASE      := GetSystemParam('POST_UPPERCASE');
 PRE_UPPERCASE_TEXT  := GetSystemParam('PRE_UPPERCASE_TEXT');
 POST_UPPERCASE_TEXT := GetSystemParam('POST_UPPERCASE_TEXT');
 ANY_CHARS           := GetSystemParam('ANY_CHARS');
 ANY_CHAR            := GetSystemParam('ANY_CHAR');
 DateFormat          := GetSystemParam('DateFormat');
 PRE_DATEFORMAT      := GetSystemParam('PRE_DATEFORMAT');
 POST_DATEFORMAT     := GetSystemParam('POST_DATEFORMAT');
 PRE_DATEFORMAT_TEXT := GetSystemParam('PRE_DATEFORMAT_TEXT');
 POST_DATEFORMAT_TEXT:= GetSystemParam('POST_DATEFORMAT_TEXT');

 LDateFormat.Caption := DateFormat;
end;

procedure TFModuleFilter.CaseSentensiveClick(Sender: TObject);
begin
  inherited;
 RefreshPreview;
end;

procedure TFModuleFilter.Field9DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
Var FieldNumber : Integer;
    FieldType   : ShortString;
    W         : ShortString;
    K         : TColor;
begin
  inherited;
   FieldNumber := (Control As TComboBox).Tag;
   Fields[FieldNumber].Canvas.Brush.Color := clWhite;
   Fields[FieldNumber].Canvas.FillRect(Rect);
   Fields[FieldNumber].Canvas.Font.Color := clBlack;
   Fields[FieldNumber].Canvas.TextOut(Rect.Left+40, Rect.Top, Fields[FieldNumber].Items[Index]);

   FieldType := ExtractWord(3,Columns[Index],['|']);
   If FieldType = 'ftString'  Then Begin W := Messages.Strings[14]; K := clGreen;   End Else
   If FieldType = 'ftInteger' Then Begin W := Messages.Strings[15]; K := clBlack;   End Else
   If FieldType = 'ftFloat'   Then Begin W := Messages.Strings[16]; K := clBlue;    End Else
   If FieldType = 'ftDate'    Then Begin W := Messages.Strings[18]; K := clSilver;  End Else
   If FieldType = 'ftOther'   Then Begin W := Messages.Strings[17]; K := clRed;     End Else Begin W := FieldType; K := clRed; End;

   Fields[FieldNumber].Canvas.Font.Style := [fsBold, fsItalic];
   Fields[FieldNumber].Canvas.Font.Color := K;
   Fields[FieldNumber].Canvas.TextOut(Rect.Left, Rect.Top, W);
end;

procedure TFModuleFilter.OpenClick(Sender: TObject);
Var TFile : TextFile;
    S     : String;
    T     : Integer;
begin
  inherited;

 If OD.Execute Then Begin
  AssignFile(TFile, OD.FileName);
  Reset(TFile);
  ReadLn(TFile, S);
  If Columns.CommaText <> S Then Begin
   Info(Messages.Strings[19]);
   CloseFile(TFile);
   Exit;
  End;
  ReadLn(TFile, S);
  FilterSettings.CommaText := S;
  //add settings for current context field value ( is not exists )
  initializeFilerSettings( FilterSettings, flexContextName );
  For T := 2 To 13 Do Begin
   Fields[T].Visible  := False;
   Values1[T].Visible := False;
   Values2[T].Visible := False;
   Conds[T].Visible   := False;
   Erases[T].Visible  := False;
   Operations[T].Visible  := False;
  End;
  Values2[1].Visible := False;

  StringsToCombos(FilterSettings);
  ActiveClick(nil);

  CloseFile(TFile);
 End;
end;

procedure TFModuleFilter.SaveClick(Sender: TObject);
Var TFile : TextFile;
    TempFilterSettings : TStrings;
begin
  inherited;
 If SD.Execute Then Begin
  TempFilterSettings := TStringList.Create;
  initializeFilerSettings(TempFilterSettings, flexContextName);
  CombosToStrings(TempFilterSettings);
  AssignFile(TFile, SD.FileName);
  ReWrite(TFile);
  WriteLn(TFile, Columns.CommaText);
  WriteLn(TFile, TempFilterSettings.CommaText);
  TempFilterSettings.Free;
  CloseFile(TFile);
 End;
end;

procedure TFModuleFilter.PageControl1Change(Sender: TObject);
begin
  inherited;
  Info('change: '+PageControl1.ActivePage.Caption);
end;

procedure TFModuleFilter.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  inherited;
  Info('changing: '+PageControl1.ActivePage.Caption);
end;

procedure TFModuleFilter.Bracket1Click(Sender: TObject);
begin
  inherited;
  If TBitBtn(Sender).Caption = ''  Then Begin TBitBtn(Sender).Caption := '('; Exit; End;
  If TBitBtn(Sender).Caption = '(' Then Begin TBitBtn(Sender).Caption := ')'; Exit; End;
  If TBitBtn(Sender).Caption = ')' Then Begin TBitBtn(Sender).Caption := '';  Exit; End;
end;

procedure TFModuleFilter.Operation1Click(Sender: TObject);
begin
  inherited;
  If TBitBtn(Sender).Caption = 'i'  Then Begin TBitBtn(Sender).Caption := 'lub'; End Else
  If TBitBtn(Sender).Caption = 'lub' Then Begin TBitBtn(Sender).Caption := 'i';  End Else TBitBtn(Sender).Caption := 'i';
  RefreshPreview;
end;

procedure TFModuleFilter.FormShow(Sender: TObject);
begin
  inherited;
  CanRefresh := True;
  RefreshPreview;
end;

Procedure initializeFilerSettings (aFilterSettings : TStrings; aflexContextName : string);
Var TempCombos : TStrings;
Begin
 If aFilterSettings.Values['Combos.Category:'  +aflexContextName] = '' Then Begin
  TempCombos := TStringList.Create;
   While TempCombos.Count < 13 Do Begin
    TempCombos.Add('-1|0|||');
  End;
  aFilterSettings.Add('Combos.Category:'    + aflexContextName + '=' + TempCombos.CommaText );
  aFilterSettings.Add('Active.Category:'    + aflexContextName + '=True');
  aFilterSettings.Add('Additional.Category:'+ aflexContextName + '=');
  aFilterSettings.Add('SQL.Category:'       + aflexContextName + '=0=0');
  aFilterSettings.Add('Notes.Category:'     + aflexContextName + '=-');
  TempCombos.Free;
 End;
End;

procedure TFModuleFilter.FormDestroy(Sender: TObject);
begin
  TempCombos.Free;
end;

procedure TFModuleFilter.SpeedButton1Click(Sender: TObject);
begin
  GroupBox2.Visible := true;
  Middle.Visible := true;
end;

end.
