unit AutoCreate;

interface

Uses QForms;

procedure RES_HINTSCreate;
Procedure RES_HINTSShowModalAsBrowser;
Function  RES_HINTSShowModalAsSelect(VAR ID : ShortString) : TModalResult;
Procedure RES_HINTSFree;

procedure FIN_LOOKUP_VALUESCreate;
Procedure FIN_LOOKUP_VALUESShowModalAsBrowser;
Function  FIN_LOOKUP_VALUESShowModalAsSelect(pCON_LOOKUP_TYPE : ShortString; var ID : ShortString) : TModalResult;
Function  FIN_LOOKUP_VALUESShowModalAsMultiSelectExt(pCON_LOOKUP_TYPE : ShortString; var ID : ShortString) : TModalResult;
Procedure FIN_LOOKUP_VALUESFree;

procedure FIN_LINESCreate;
Procedure FIN_LINESShowModalAsBrowser (pCON_HEADER_ID : shortString);
Function  FIN_LINESShowModalAsSelect(var ID : ShortString) : TModalResult;
Procedure FIN_LINESFree;

procedure FIN_DOCSCreate;
Procedure FIN_DOCSShowModalAsBrowser( pCON_BATCH_ID, pCON_PARTY_FROM_ID, pCON_PARTY_TO_ID : shortString  );
Function  FIN_DOCSShowModalAsSelect(var ID : ShortString) : TModalResult;
Procedure FIN_DOCSFree;

procedure FIN_BATCHESCreate;
Procedure FIN_BATCHESShowModalAsBrowser;
Function  FIN_BATCHESShowModalAsSelect(var ID : ShortString) : TModalResult;
Procedure FIN_BATCHESFree;

procedure FIN_PARTIESCreate;
Procedure FIN_PARTIESShowModalAsBrowser ( pCON_FEEDER_SYSTEM_REF : shortString );
Function  FIN_PARTIESShowModalAsSelect(var ID : ShortString) : TModalResult;
Procedure FIN_PARTIESFree;


procedure LECTURERSCreate;
Procedure LECTURERSShowModalAsBrowser    (aCON_ORGUNI_ID : String);
Function  LECTURERSShowModalAsSelect     (var ID : ShortString; aCON_ORGUNI_ID : String; available,availableDsp : string ) : TModalResult;
Function  LECTURERSShowModalAsMultiSelect(var ID : String; aCON_ORGUNI_ID : String; available,availableDsp : string ) : TModalResult;
function LECTURERSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Procedure LECTURERSFree;

procedure GROUPSCreate;
Procedure GROUPSShowModalAsBrowser (aCON_ORGUNI_ID : String);
Function  GROUPSShowModalAsSelect     (var ID : ShortString; aCON_ORGUNI_ID : String; available,availableDsp : string ) : TModalResult;
Function  GROUPSShowModalAsMultiselect(var ID : String;  aCON_ORGUNI_ID : String; available,availableDsp : string ) : TModalResult;
function  GROUPSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Procedure GROUPSFree;

procedure ROOMSCreate(aCON_RESCAT_ID : ShortString);
Procedure ROOMSShowModalAsBrowser(aCON_RESCAT_ID : ShortString; aCON_ORGUNI_ID : String);
procedure ROOMSInit(aCON_RESCAT_ID : ShortString; aCON_ORGUNI_ID : String; available,availableDsp : string );
Function  ROOMSShowModalAsSelect     (aCON_RESCAT_ID : ShortString; aCON_ORGUNI_ID : String; var ID : ShortString; available,availableDsp : string ) : TModalResult;
Function  ROOMSShowModalAsMultiselect(aCON_RESCAT_ID : ShortString; aCON_ORGUNI_ID : String; var ID : String; available,availableDsp : string ) : TModalResult;
function  ROOMSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Procedure ROOMSFree;

procedure SUBJECTSCreate;
Procedure SUBJECTSShowModalAsBrowser (aCON_ORGUNI_ID : String);
Function  SUBJECTSShowModalAsSelect(var ID : ShortString;aCON_ORGUNI_ID : String) : TModalResult;
function  SUBJECTSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Procedure SUBJECTSFree;

procedure FORMSCreate;
Procedure FORMSShowModalAsBrowser(aCON_TYPE_ID : ShortString);
Function  FORMSShowModalAsSelect(var ID : ShortString;aCON_TYPE_ID : ShortString) : TModalResult;
function  FORMSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Procedure FORMSFree;

procedure PERIODSCreate;
Procedure PERIODSShowModalAsBrowser;
Function  PERIODSShowModalAsSelect(var ID : ShortString) : TModalResult;
function  PERIODSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Procedure PERIODSFree;

procedure RESERVATIONS_KINDSCreate;
Procedure RESERVATIONS_KINDSShowModalAsBrowser;
Function RESERVATIONS_KINDSShowModalAsSelect(var ID : ShortString) : TModalResult;
Procedure RESERVATIONS_KINDSFree;

procedure CLASSESCreate;
Procedure CLASSESShowModalAsBrowser(aLEC_ID, aGRO_ID, aROM_ID, aPERIOD_ID, aSUB_ID, aFOR_ID, aPLA_ID : shortString; aSelectedDates, aHideEdit : boolean);
Function  CLASSESShowModalAsSelect(var ID : ShortString) : TModalResult;
Procedure CLASSESFree;

procedure CLASSES_HISTORYCreate;
Procedure CLASSES_HISTORYShowModalAsBrowser(aLEC_ID, aGRO_ID, aROM_ID, aPERIOD_ID, aSUB_ID, aFOR_ID, aPLA_ID : shortString; aSelectedDates, aHideEdit : boolean);
Function  CLASSES_HISTORYShowModalAsSelect(var ID : ShortString) : TModalResult;
Procedure CLASSES_HISTORYFree;

procedure PLANNERSCreate;
Procedure PLANNERSShowModalAsBrowser;
Function  PLANNERSShowModalAsSelect(var ID : ShortString) : TModalResult;
function  PLANNERSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Procedure PLANNERSFree;

procedure RESOURCE_CATEGORIESCreate;
Procedure RESOURCE_CATEGORIESShowModalAsBrowser;
Function  RESOURCE_CATEGORIESShowModalAsSelect(var ID : ShortString) : TModalResult;
Procedure RESOURCE_CATEGORIESFree;

procedure ORG_UNITSCreate;
Procedure ORG_UNITSShowModalAsBrowser;
Function  ORG_UNITSShowModalAsSelect(var ID : ShortString) : TModalResult;
Procedure ORG_UNITSFree;

//procedure FORM_FORMULASCreate;
//Procedure FORM_FORMULASShowModalAsBrowser;
//Function  FORM_FORMULASShowModalAsSelect(var ID : ShortString) : TModalResult;
//Procedure FORM_FORMULASFree;

Procedure CONSOLIDATIONShowModalAsBrowser (aconsolidationKind : integer);
Procedure FDataDiagramShowModalAsBrowser;

procedure VALUE_SETSCreate;
Procedure VALUE_SETSShowModalAsBrowser;
Function  VALUE_SETSShowModalAsSelect(var ID : ShortString) : TModalResult;
Procedure VALUE_SETSFree;

procedure LOOKUPSCreate;
Procedure LOOKUPSShowModalAsBrowser(aCON_value_set_ID : string);
Function  LOOKUPSShowModalAsSelect(var ID : ShortString; aCON_value_set_ID : string) : TModalResult;
Procedure LOOKUPSFree;

procedure FLEX_COL_USAGECreate;
Procedure FLEX_COL_USAGEShowModalAsBrowser;
Function  FLEX_COL_USAGEShowModalAsSelect(var ID : ShortString) : TModalResult;
Procedure FLEX_COL_USAGEFree;

procedure TT_RESCAT_COMBINATIONSCreate;
Procedure TT_RESCAT_COMBINATIONSShowModalAsBrowser;
Function  TT_RESCAT_COMBINATIONSShowModalAsSelect(var ID : ShortString) : TModalResult;
Procedure TT_RESCAT_COMBINATIONSFree;

procedure TT_COMBINATIONSCreate;
Procedure TT_COMBINATIONSShowModalAsBrowser;
Function  TT_COMBINATIONSShowModalAsSelect(var ID : ShortString) : TModalResult;
Function  TT_COMBINATIONSShowModalAsMultiSelect(var ID : String) : TModalResult;
Procedure TT_COMBINATIONSFree;

procedure GRIDSCreate;
Procedure GRIDSShowModalAsBrowser;
Function GRIDSShowModalAsSelect(var ID : ShortString) : TModalResult;
Procedure GRIDSFree;

//===========================================================================================================================

implementation

Uses UUtilityParent, UFBrowseLECTURERS, UFBrowseGROUPS, UFBrowseROOMS, UFBrowseSUBJECTS, UFBrowseFORMS, UFBrowsePERIODS, UFBrowseRESERVATIONS_KINDS,
     UFBrowseCLASSES, UFBrowseCLASSES_HISTORY, UFBrowsePLANNERS, UFBrowseRESOURCE_CATEGORIES, UFBrowseORG_UNITS, UFBrowseFORM_FORMULAS, UFConsolidation, UFDataDiagram, UFBrowseVALUE_SETS
     ,UFBrowseLOOKUPS, UFBrowseFLEX_COL_USAGE, UFBrowseTT_RESCAT_COMBINATIONS, UFBrowseTT_COMBINATIONS, UFBrowseFIN_PARTIES, UFBrowseFIN_BATCHES, UFBrowseFIN_DOCS, UFBrowseFIN_LINES, UFBrowseFIN_LOOKUP_VALUES, dm,
     UFBrowseGRIDS, UFBrowseRES_HINTS, SysUtils;

procedure RES_HINTSCreate;
begin
If Not Assigned(FBrowseRES_HINTS) Then FBrowseRES_HINTS := TFBrowseRES_HINTS.Create(Application);
end;

Procedure RES_HINTSShowModalAsBrowser;
Begin
 RES_HINTSCreate;
 FBrowseRES_HINTS.ShowModalAsBrowser('');;
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then RES_HINTSFree;
End;

Function RES_HINTSShowModalAsSelect(VAR ID : ShortString) : TModalResult;
Begin
 RES_HINTSCreate;
 Result := FBrowseRES_HINTS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then RES_HINTSFree;
End;

Procedure RES_HINTSFree;
Begin
 If Assigned(FBrowseRES_HINTS) Then If FBrowseRES_HINTS.Visible Then Exit;
 If Assigned(FBrowseRES_HINTS) Then FBrowseRES_HINTS.Free;
 FBrowseRES_HINTS := Nil;
End;


procedure FIN_LOOKUP_VALUESCreate;
begin
 If Not Assigned(FBrowseFIN_LOOKUP_VALUES) Then FBrowseFIN_LOOKUP_VALUES := TFBrowseFIN_LOOKUP_VALUES.Create(Application);
end;

Procedure FIN_LOOKUP_VALUESShowModalAsBrowser;
Begin
 FIN_LOOKUP_VALUESCreate;
 FBrowseFIN_LOOKUP_VALUES.CON_LOOKUP_TYPE.visible := true;
 FBrowseFIN_LOOKUP_VALUES.con_clear.Visible := true;
 FBrowseFIN_LOOKUP_VALUES.con_label.Visible := true;
 FBrowseFIN_LOOKUP_VALUES.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FIN_LOOKUP_VALUESFree;
End;

Function FIN_LOOKUP_VALUESShowModalAsSelect(pCON_LOOKUP_TYPE : ShortString; var ID : ShortString) : TModalResult;
Begin
 if not elementEnabled('"Modu³ finanse i s³owniki"','2012.06.03', false) then begin exit; end;
 FIN_LOOKUP_VALUESCreate;
 FBrowseFIN_LOOKUP_VALUES.CON_LOOKUP_TYPE.Text := pCON_LOOKUP_TYPE;
 FBrowseFIN_LOOKUP_VALUES.CON_LOOKUP_TYPE.visible := false;
 FBrowseFIN_LOOKUP_VALUES.con_clear.Visible := false;
 FBrowseFIN_LOOKUP_VALUES.con_label.Visible := false;
 Result := FBrowseFIN_LOOKUP_VALUES.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FIN_LOOKUP_VALUESFree;
End;


Function FIN_LOOKUP_VALUESShowModalAsMultiselectExt(pCON_LOOKUP_TYPE : ShortString; var ID : ShortString) : TModalResult;
Begin
 FIN_LOOKUP_VALUESCreate;
 FBrowseFIN_LOOKUP_VALUES.CON_LOOKUP_TYPE.Text := pCON_LOOKUP_TYPE;
 FBrowseFIN_LOOKUP_VALUES.CON_LOOKUP_TYPE.visible := false;
 FBrowseFIN_LOOKUP_VALUES.con_clear.Visible := false;
 FBrowseFIN_LOOKUP_VALUES.con_label.Visible := false;
 Result := FBrowseFIN_LOOKUP_VALUES.ShowModalAsMultiselectExt(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FIN_LOOKUP_VALUESFree;
End;


Procedure FIN_LOOKUP_VALUESFree;
Begin
 If Assigned(FBrowseFIN_LOOKUP_VALUES) Then If FBrowseFIN_LOOKUP_VALUES.Visible Then Exit;
 If Assigned(FBrowseFIN_LOOKUP_VALUES) Then FBrowseFIN_LOOKUP_VALUES.Free;
 FBrowseFIN_LOOKUP_VALUES := Nil;
End;

procedure FIN_LINESCreate;
begin
 If Not Assigned(FBrowseFIN_LINES) Then FBrowseFIN_LINES := TFBrowseFIN_LINES.Create(Application);
end;

Procedure FIN_LINESShowModalAsBrowser(pCON_HEADER_ID : shortString);
Begin
 FIN_LINESCreate;
 FBrowseFIN_LINES.CON_HEADER_ID.Text := pCON_HEADER_ID;
 FBrowseFIN_LINES.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FIN_LINESFree;
End;

Function FIN_LINESShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 FIN_LINESCreate;
 Result := FBrowseFIN_LINES.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FIN_LINESFree;
End;

Procedure FIN_LINESFree;
Begin
 If Assigned(FBrowseFIN_LINES) Then If FBrowseFIN_LINES.Visible Then Exit;
 If Assigned(FBrowseFIN_LINES) Then FBrowseFIN_LINES.Free;
 FBrowseFIN_LINES := Nil;
End;

procedure FIN_DOCSCreate;
begin
 If Not Assigned(FBrowseFIN_DOCS) Then FBrowseFIN_DOCS := TFBrowseFIN_DOCS.Create(Application);
end;

Procedure FIN_DOCSShowModalAsBrowser ( pCON_BATCH_ID, pCON_PARTY_FROM_ID, pCON_PARTY_TO_ID : shortString );
Begin
 FIN_DOCSCreate;
 with FBrowseFIN_DOCS do begin
   CON_BATCH_ID.Text      := pCON_BATCH_ID;
   CON_PARTY_FROM_ID.Text := pCON_PARTY_FROM_ID;
   CON_PARTY_TO_ID.Text   := pCON_PARTY_TO_ID;
   ShowModalAsBrowser('');
 end;
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FIN_DOCSFree;
End;

Function FIN_DOCSShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 FIN_DOCSCreate;
 Result := FBrowseFIN_DOCS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FIN_DOCSFree;
End;

Procedure FIN_DOCSFree;
Begin
 If Assigned(FBrowseFIN_DOCS) Then If FBrowseFIN_DOCS.Visible Then Exit;
 If Assigned(FBrowseFIN_DOCS) Then FBrowseFIN_DOCS.Free;
 FBrowseFIN_DOCS := Nil;
End;

procedure FIN_BATCHESCreate;
begin
 If Not Assigned(FBrowseFIN_BATCHES) Then FBrowseFIN_BATCHES := TFBrowseFIN_BATCHES.Create(Application);
end;

Procedure FIN_BATCHESShowModalAsBrowser;
Begin
 FIN_BATCHESCreate;
 FBrowseFIN_BATCHES.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FIN_BATCHESFree;
End;

Function FIN_BATCHESShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 FIN_BATCHESCreate;
 Result := FBrowseFIN_BATCHES.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FIN_BATCHESFree;
End;

Procedure FIN_BATCHESFree;
Begin
 If Assigned(FBrowseFIN_BATCHES) Then If FBrowseFIN_BATCHES.Visible Then Exit;
 If Assigned(FBrowseFIN_BATCHES) Then FBrowseFIN_BATCHES.Free;
 FBrowseFIN_BATCHES := Nil;
End;

procedure FIN_PARTIESCreate;
begin
 If Not Assigned(FBrowseFIN_PARTIES) Then FBrowseFIN_PARTIES := TFBrowseFIN_PARTIES.Create(Application);
end;

Procedure FIN_PARTIESShowModalAsBrowser ( pCON_FEEDER_SYSTEM_REF : shortString );
Begin
 FIN_PARTIESCreate;
 FBrowseFIN_PARTIES.CON_FEEDER_SYSTEM_REF.Text := pCON_FEEDER_SYSTEM_REF;
 FBrowseFIN_PARTIES.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FIN_PARTIESFree;
End;

Function FIN_PARTIESShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 FIN_PARTIESCreate;
 Result := FBrowseFIN_PARTIES.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FIN_PARTIESFree;
End;

Procedure FIN_PARTIESFree;
Begin
 If Assigned(FBrowseFIN_PARTIES) Then If FBrowseFIN_PARTIES.Visible Then Exit;
 If Assigned(FBrowseFIN_PARTIES) Then FBrowseFIN_PARTIES.Free;
 FBrowseFIN_PARTIES := Nil;
End;

procedure TT_RESCAT_COMBINATIONSCreate;
begin
 If Not Assigned(FBrowseTT_RESCAT_COMBINATIONS) Then FBrowseTT_RESCAT_COMBINATIONS := TFBrowseTT_RESCAT_COMBINATIONS.Create(Application);
end;

Procedure TT_RESCAT_COMBINATIONSShowModalAsBrowser;
Begin
 TT_RESCAT_COMBINATIONSCreate;
 FBrowseTT_RESCAT_COMBINATIONS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then TT_RESCAT_COMBINATIONSFree;
End;

Function TT_RESCAT_COMBINATIONSShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 TT_RESCAT_COMBINATIONSCreate;
 Result := FBrowseTT_RESCAT_COMBINATIONS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then TT_RESCAT_COMBINATIONSFree;
End;

Procedure TT_RESCAT_COMBINATIONSFree;
Begin
 If Assigned(FBrowseTT_RESCAT_COMBINATIONS) Then If FBrowseTT_RESCAT_COMBINATIONS.Visible Then Exit;
 If Assigned(FBrowseTT_RESCAT_COMBINATIONS) Then FBrowseTT_RESCAT_COMBINATIONS.Free;
 FBrowseTT_RESCAT_COMBINATIONS := Nil;
End;

procedure LECTURERSCreate;
begin
    If Not Assigned(FBrowseLECTURERS) Then FBrowseLECTURERS := TFBrowseLECTURERS.Create(Application);
    if FBrowseLECTURERS.flexEnabled then FBrowseLECTURERS.flexSynchronize;
end;

Procedure LECTURERSShowModalAsBrowser (aCON_ORGUNI_ID : String);
Begin
 LECTURERSCreate;
 FBrowseLECTURERS.available            := '0=0';
 FBrowseLECTURERS.availableDsp.caption := '';
 FBrowseLECTURERS.CON_ORGUNI_ID.Text := aCON_ORGUNI_ID;
 FBrowseLECTURERS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then LECTURERSFree;
End;

Function LECTURERSShowModalAsSelect(var ID : ShortString; aCON_ORGUNI_ID : String; available,availableDsp : string ) : TModalResult;
Begin
 LECTURERSCreate;
 FBrowseLECTURERS.available            := available;
 FBrowseLECTURERS.availableDsp.caption := availableDsp;
 FBrowseLECTURERS.CON_ORGUNI_ID.Text := aCON_ORGUNI_ID;
 Result := FBrowseLECTURERS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then LECTURERSFree;
End;

Function LECTURERSShowModalAsMultiselect(var ID : String; aCON_ORGUNI_ID : String; available,availableDsp : string ) : TModalResult;
Begin
 LECTURERSCreate;
 FBrowseLECTURERS.available            := available;
 FBrowseLECTURERS.availableDsp.caption := availableDsp;
 FBrowseLECTURERS.CON_ORGUNI_ID.Text := aCON_ORGUNI_ID;
 Result := FBrowseLECTURERS.ShowModalAsMultiselect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then LECTURERSFree;
End;

function LECTURERSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Begin
 LECTURERSCreate;
 Result := FBrowseLECTURERS.ShowModalAsSingleRecord(Action,ID);
 LECTURERSFree;
End;


Procedure LECTURERSFree;
Begin
 If Assigned(FBrowseLECTURERS) Then If FBrowseLECTURERS.Visible Then Exit;
 If Assigned(FBrowseLECTURERS) Then FBrowseLECTURERS.Free;
 FBrowseLECTURERS := Nil;
End;

procedure GROUPSCreate;
begin
    If Not Assigned(FBrowseGROUPS) Then FBrowseGROUPS := TFBrowseGROUPS.Create(Application);
    if FBrowseGROUPS.flexEnabled then FBrowseGROUPS.flexSynchronize;
end;

Procedure GROUPSShowModalAsBrowser;
Begin
 GROUPSCreate;
 FBrowseGROUPS.available            := '0=0';
 FBrowseGROUPS.availableDsp.caption := '';
 FBrowseGROUPS.CON_ORGUNI_ID.Text := aCON_ORGUNI_ID;
 FBrowseGROUPS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then GROUPSFree;
End;

Function GROUPSShowModalAsSelect(var ID : ShortString; aCON_ORGUNI_ID : String; available,availableDsp : string ) : TModalResult;
Begin
 GROUPSCreate;
 FBrowseGROUPS.available            := available;
 FBrowseGROUPS.availableDsp.caption := availableDsp;
 FBrowseGROUPS.CON_ORGUNI_ID.Text := aCON_ORGUNI_ID;
 Result := FBrowseGROUPS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then GROUPSFree;
End;

Function GROUPSShowModalAsMultiselect(var ID : String; aCON_ORGUNI_ID : String; available,availableDsp : string ) : TModalResult;
Begin
 GROUPSCreate;
 FBrowseGROUPS.available            := available;
 FBrowseGROUPS.availableDsp.caption := availableDsp;
 FBrowseGROUPS.CON_ORGUNI_ID.Text := aCON_ORGUNI_ID;
 Result := FBrowseGROUPS.ShowModalAsMultiselect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then GROUPSFree;
End;

function GROUPSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Begin
 GROUPSCreate;
 Result := FBrowseGROUPS.ShowModalAsSingleRecord(Action,ID);
 GROUPSFree;
End;


Procedure GROUPSFree;
Begin
If Assigned(FBrowseGROUPS) Then If FBrowseGROUPS.Visible Then Exit;
 If Assigned(FBrowseGROUPS) Then FBrowseGROUPS.Free;
 FBrowseGROUPS := Nil;
End;

procedure ROOMSCreate(aCON_RESCAT_ID : shortString);
var isReal : boolean;
begin
  If Not Assigned(FBrowseROOMS) Then FBrowseROOMS := TFBrowseROOMS.Create(Application);

  With FBrowseROOMS do begin
   isReal := StringToInt(aCON_RESCAT_ID)>0;
   GroupGeolocation.visible := isReal;
   CON_RESCAT_ID_VALUE.visible := isReal;
   CategoryLabel.visible := isReal;
   ClearCategory.visible := isReal;
   ttEnabled.visible := isReal;
   btools.visible := isReal;
   LabelRESCAT_ID.visible := isReal;
   RESCAT_ID_VALUE.visible := isReal;
   BSelectRESCAT_ID.visible := isReal;
   BClearRESCAT_ID.visible := isReal;
   if aCON_RESCAT_ID='-9' then Caption := 'Kalendarze' else Caption := 'Zasoby';
  end;
end;

Procedure ROOMSShowModalAsBrowser(aCON_RESCAT_ID : ShortString; aCON_ORGUNI_ID : String);
Begin
 ROOMSCreate(aCON_RESCAT_ID);
 FBrowseROOMS.available            := '0=0';
 FBrowseROOMS.availableDsp.caption := '';
 FBrowseROOMS.CON_RESCAT_ID.Text := aCON_RESCAT_ID;
 FBrowseROOMS.CON_ORGUNI_ID.Text := aCON_ORGUNI_ID;
 FBrowseROOMS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then ROOMSFree;
End;

procedure ROOMSInit(aCON_RESCAT_ID : ShortString; aCON_ORGUNI_ID : String; available,availableDsp : string );
Begin
 ROOMSCreate(aCON_RESCAT_ID);
 FBrowseROOMS.available            := available;
 FBrowseROOMS.availableDsp.caption := availableDsp;
 FBrowseROOMS.CON_RESCAT_ID.Text   := aCON_RESCAT_ID;
 //flexSynchronize needs the parameter available
 FBrowseROOMS.CON_ORGUNI_ID.Text := aCON_ORGUNI_ID;
 if FBrowseROOMS.flexEnabled then FBrowseROOMS.flexSynchronize;
End;

Function ROOMSShowModalAsSelect(aCON_RESCAT_ID : ShortString; aCON_ORGUNI_ID : String; var ID : ShortString; available,availableDsp : string ) : TModalResult;
Begin
 ROOMSCreate(aCON_RESCAT_ID);
 FBrowseROOMS.available            := available;
 FBrowseROOMS.availableDsp.caption := availableDsp;
 FBrowseROOMS.CON_RESCAT_ID.Text := aCON_RESCAT_ID;
 FBrowseROOMS.CON_ORGUNI_ID.Text := aCON_ORGUNI_ID;

 Result := FBrowseROOMS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then ROOMSFree;
End;

Function ROOMSShowModalAsMultiselect(aCON_RESCAT_ID : ShortString; aCON_ORGUNI_ID : String; var ID : String; available,availableDsp : string ) : TModalResult;
Begin
 ROOMSCreate(aCON_RESCAT_ID);
 FBrowseROOMS.available            := available;
 FBrowseROOMS.availableDsp.caption := availableDsp;
 FBrowseROOMS.CON_RESCAT_ID.Text := aCON_RESCAT_ID;
 FBrowseROOMS.CON_ORGUNI_ID.Text := aCON_ORGUNI_ID;
 Result := FBrowseROOMS.ShowModalAsMultiselect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then ROOMSFree;
End;

function  ROOMSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Begin
 ROOMSCreate('');
 Result := FBrowseROOMS.ShowModalAsSingleRecord(Action,ID);
 ROOMSFree;
End;

Procedure ROOMSFree;
Begin
If Assigned(FBrowseROOMS) Then If FBrowseROOMS.Visible Then Exit;
 If Assigned(FBrowseROOMS) Then FBrowseROOMS.Free;
 FBrowseROOMS := Nil;
End;


procedure SUBJECTSCreate;
begin
    If Not Assigned(FBrowseSUBJECTS) Then FBrowseSUBJECTS := TFBrowseSUBJECTS.Create(Application);
    if FBrowseSUBJECTS.flexEnabled then FBrowseSUBJECTS.flexSynchronize;
end;

Procedure SUBJECTSShowModalAsBrowser;
Begin
 SUBJECTSCreate;
 FBrowseSUBJECTS.CON_ORGUNI_ID.Text := aCON_ORGUNI_ID;
 FBrowseSUBJECTS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then SUBJECTSFree;
End;

Function SUBJECTSShowModalAsSelect(var ID : ShortString;aCON_ORGUNI_ID : String) : TModalResult;
Begin
 SUBJECTSCreate;
 FBrowseSUBJECTS.CON_ORGUNI_ID.Text := aCON_ORGUNI_ID;
 Result := FBrowseSUBJECTS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then SUBJECTSFree;
End;

function SUBJECTSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Begin
 SUBJECTSCreate;
 Result := FBrowseSUBJECTS.ShowModalAsSingleRecord(Action,ID);
 SUBJECTSFree;
End;

Procedure SUBJECTSFree;
Begin
If Assigned(FBrowseSUBJECTS) Then If FBrowseSUBJECTS.Visible Then Exit;
 If Assigned(FBrowseSUBJECTS) Then FBrowseSUBJECTS.Free;
 FBrowseSUBJECTS := Nil;
End;

procedure PERIODSCreate;
begin
    If Not Assigned(FBrowsePERIODS) Then FBrowsePERIODS := TFBrowsePERIODS.Create(Application);
    if fBrowsePERIODS.flexEnabled then fBrowsePERIODS.flexSynchronize;
end;

Procedure PERIODSShowModalAsBrowser;
Begin
 PERIODSCreate;
 FBrowsePERIODS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then PERIODSFree;
End;

Function PERIODSShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 PERIODSCreate;
 Result := FBrowsePERIODS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then PERIODSFree;
End;

function PERIODSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Begin
 PERIODSCreate;
 Result := FBrowsePERIODS.ShowModalAsSingleRecord(Action,ID);
 PERIODSFree;
End;

Procedure PERIODSFree;
Begin
If Assigned(FBrowsePERIODS) Then If FBrowsePERIODS.Visible Then Exit;
 If Assigned(FBrowsePERIODS) Then FBrowsePERIODS.Free;
 FBrowsePERIODS := Nil;
End;

procedure RESERVATIONS_KINDSCreate;
begin
If Not Assigned(FBrowseRESERVATIONS_KINDS) Then FBrowseRESERVATIONS_KINDS := TFBrowseRESERVATIONS_KINDS.Create(Application);
end;

Procedure RESERVATIONS_KINDSShowModalAsBrowser;
Begin
 RESERVATIONS_KINDSCreate;
 FBrowseRESERVATIONS_KINDS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then RESERVATIONS_KINDSFree;
End;

Function RESERVATIONS_KINDSShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 RESERVATIONS_KINDSCreate;
 Result := FBrowseRESERVATIONS_KINDS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then RESERVATIONS_KINDSFree;
End;

Procedure RESERVATIONS_KINDSFree;
Begin
If Assigned(FBrowseRESERVATIONS_KINDS) Then If FBrowseRESERVATIONS_KINDS.Visible Then Exit;
 If Assigned(FBrowseRESERVATIONS_KINDS) Then FBrowseRESERVATIONS_KINDS.Free;
 FBrowseRESERVATIONS_KINDS := Nil;
End;

procedure CLASSESCreate;
begin
If Not Assigned(FBrowseCLASSES) Then FBrowseCLASSES := TFBrowseCLASSES.Create(Application);
end;

Procedure CLASSESShowModalAsBrowser(aLEC_ID, aGRO_ID, aROM_ID, aPERIOD_ID, aSUB_ID, aFOR_ID, aPLA_ID : shortString; aSelectedDates, aHideEdit : boolean);
var IsBlankDateFrom : boolean;
var IsBlankDateTo : boolean;
Begin
 CLASSESCreate;
 With FBrowseCLASSES do begin

  CanRefresh := false;

  IsBlankDateFrom := DateToOracle(FDAY_FROM.Date) = 'TO_DATE(''1899.12.30'',''YYYY.MM.DD'')';
  IsBlankDateTo   := DateToOracle(FDAY_TO.Date) = 'TO_DATE(''1899.12.30'',''YYYY.MM.DD'')';

  if IsBlankDateFrom then FDAY_FROM.Date := now();
  if IsBlankDateTo then FDAY_TO.Date := now();

  ComboSortOrderChange(nil);
  CanRefresh := true;


  GenericFilter.CONL.Text := aLEC_ID;
  GenericFilter.CONG.Text := aGRO_ID;
  GenericFilter.conResCat1.Text := aROM_ID;
  GenericFilter.CONPERIOD.Text := aPERIOD_ID;
  GenericFilter.CONS.Text := aSUB_ID;
  GenericFilter.CONF.Text := aFOR_ID;
  GenericFilter.CONPLA.Text := aPLA_ID;

  GenericFilter.LFilterType.Text := iif(aLEC_ID<>'','e','a');
  GenericFilter.GFilterType.Text := iif(aGRO_ID<>'','e','a');
  GenericFilter.SFilterType.Text := iif(aSUB_ID<>'','e','a');
  GenericFilter.FFilterType.Text := iif(aFOR_ID<>'','e','a');
  GenericFilter.PERFilterType.Text := iif(aPERIOD_ID<>'','e','a');

  classesTableName := 'CLASSES';
  ChSelectedDates.checked := aSelectedDates;
  GetTableName;

  HideEdit := aHideEdit;
  ShowModalAsBrowser('');
 end;
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then CLASSESFree;
End;

Function CLASSESShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 CLASSESCreate;
 Result := FBrowseCLASSES.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then CLASSESFree;
End;

Procedure CLASSESFree;
Begin
If Assigned(FBrowseCLASSES) Then If FBrowseCLASSES.Visible Then Exit;
 If Assigned(FBrowseCLASSES) Then FBrowseCLASSES.Free;
 FBrowseCLASSES := Nil;
End;

procedure CLASSES_HISTORYCreate;
begin
If Not Assigned(FBrowseCLASSES_HISTORY) Then FBrowseCLASSES_HISTORY := TFBrowseCLASSES_HISTORY.Create(Application);
end;

Procedure CLASSES_HISTORYShowModalAsBrowser(aLEC_ID, aGRO_ID, aROM_ID, aPERIOD_ID, aSUB_ID, aFOR_ID, aPLA_ID : shortString; aSelectedDates, aHideEdit : boolean);
Begin
 CLASSES_HISTORYCreate;
 With FBrowseCLASSES_HISTORY do begin

  CanRefresh := false;
  historyFrom.Date := now();
  historyTo.Date := now();

  ComboSortOrderChange(nil);
  CanRefresh := true;

  GenericFilter.CONL.Text := aLEC_ID;
  GenericFilter.CONG.Text := aGRO_ID;
  GenericFilter.conResCat1.Text := aROM_ID;
  GenericFilter.CONPERIOD.Text := aPERIOD_ID;
  GenericFilter.CONS.Text := aSUB_ID;
  GenericFilter.CONF.Text := aFOR_ID;
  GenericFilter.CONPLA.Text := aPLA_ID;

  GenericFilter.LFilterType.Text := iif(aLEC_ID<>'','e','a');
  GenericFilter.GFilterType.Text := iif(aGRO_ID<>'','e','a');
  GenericFilter.SFilterType.Text := iif(aSUB_ID<>'','e','a');
  GenericFilter.FFilterType.Text := iif(aFOR_ID<>'','e','a');
  GenericFilter.PERFilterType.Text := iif(aPERIOD_ID<>'','e','a');

  classesTableName := 'CLASSES_HISTORY';
  ChSelectedDates.checked := aSelectedDates;
  GetTableName;

  PanelHistory.visible := true;
  HideEdit := aHideEdit;
  ShowModalAsBrowser('');
 end;
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then CLASSES_HISTORYFree;
End;

Function CLASSES_HISTORYShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 CLASSES_HISTORYCreate;
 Result := FBrowseCLASSES_HISTORY.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then CLASSES_HISTORYFree;
End;

Procedure CLASSES_HISTORYFree;
Begin
If Assigned(FBrowseCLASSES_HISTORY) Then If FBrowseCLASSES_HISTORY.Visible Then Exit;
 If Assigned(FBrowseCLASSES_HISTORY) Then FBrowseCLASSES_HISTORY.Free;
 FBrowseCLASSES_HISTORY := Nil;
End;


procedure PLANNERSCreate;
begin
If Not Assigned(FBrowsePLANNERS) Then FBrowsePLANNERS := TFBrowsePLANNERS.Create(Application);
end;

Procedure PLANNERSShowModalAsBrowser;
Begin
 PLANNERSCreate;
 FBrowsePLANNERS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then PLANNERSFree;
End;

Function PLANNERSShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 PLANNERSCreate;
 Result := FBrowsePLANNERS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then PLANNERSFree;
End;

function PLANNERSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Begin
 PLANNERSCreate;
 Result := FBrowsePLANNERS.ShowModalAsSingleRecord(Action,ID);
 PLANNERSFree;
End;


Procedure PLANNERSFree;
Begin
 If Assigned(FBrowsePLANNERS) Then If FBrowsePLANNERS.Visible Then Exit;
 If Assigned(FBrowsePLANNERS) Then FBrowsePLANNERS.Free;
 FBrowsePLANNERS := Nil;
End;

procedure RESOURCE_CATEGORIESCreate;
begin
If Not Assigned(FBrowseRESOURCE_CATEGORIES) Then FBrowseRESOURCE_CATEGORIES := TFBrowseRESOURCE_CATEGORIES.Create(Application);
end;

Procedure RESOURCE_CATEGORIESShowModalAsBrowser;
Begin
 RESOURCE_CATEGORIESCreate;
 FBrowseRESOURCE_CATEGORIES.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then RESOURCE_CATEGORIESFree;
End;

Function RESOURCE_CATEGORIESShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 RESOURCE_CATEGORIESCreate;
 Result := FBrowseRESOURCE_CATEGORIES.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then RESOURCE_CATEGORIESFree;
End;

Procedure RESOURCE_CATEGORIESFree;
Begin
 If Assigned(FBrowseRESOURCE_CATEGORIES) Then If FBrowseRESOURCE_CATEGORIES.Visible Then Exit;
 If Assigned(FBrowseRESOURCE_CATEGORIES) Then FBrowseRESOURCE_CATEGORIES.Free;
 FBrowseRESOURCE_CATEGORIES := Nil;
End;

procedure ORG_UNITSCreate;
begin
If Not Assigned(FBrowseORG_UNITS) Then FBrowseORG_UNITS := TFBrowseORG_UNITS.Create(Application);
end;

Procedure ORG_UNITSShowModalAsBrowser;
Begin
 ORG_UNITSCreate;
 If not editOrgUnits Then Begin
  Info('Ta funkcja mo¿e byæ uruchamiana tylko przez u¿ytkownika o uprawnieniach "Edycja struktury organizacyjnej"');
  Exit;
 End;
 FBrowseORG_UNITS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then ORG_UNITSFree;
End;

Function ORG_UNITSShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 ORG_UNITSCreate;
 Result := FBrowseORG_UNITS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then ORG_UNITSFree;
End;

Procedure ORG_UNITSFree;
Begin
 If Assigned(FBrowseORG_UNITS) Then If FBrowseORG_UNITS.Visible Then Exit;
 If Assigned(FBrowseORG_UNITS) Then FBrowseORG_UNITS.Free;
 FBrowseORG_UNITS := Nil;
End;

{
procedure FORM_FORMULASCreate;
begin
If Not Assigned(FBrowseFORM_FORMULAS) Then FBrowseFORM_FORMULAS := TFBrowseFORM_FORMULAS.Create(Application);
end;

Procedure FORM_FORMULASShowModalAsBrowser;
Begin
 FORM_FORMULASCreate;
 If not isAdmin Then Begin
  Info('Ta funkcja mo¿e byæ uruchamiana tylko przez u¿ytkownika o uprawnieniach administratora');
  Exit;
 End;
 FBrowseFORM_FORMULAS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FORM_FORMULASFree;
End;

Function FORM_FORMULASShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 FORM_FORMULASCreate;
 Result := FBrowseFORM_FORMULAS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FORM_FORMULASFree;
End;

Procedure FORM_FORMULASFree;
Begin
 If Assigned(FBrowseFORM_FORMULAS) Then If FBrowseFORM_FORMULAS.Visible Then Exit;
 If Assigned(FBrowseFORM_FORMULAS) Then FBrowseFORM_FORMULAS.Free;
 FBrowseFORM_FORMULAS := Nil;
End;
}

Procedure CONSOLIDATIONShowModalAsBrowser (aconsolidationKind : integer);
Begin
 FConsolidation := TFConsolidation.Create(Application);
 FConsolidation.consolidationKind.ItemIndex := aconsolidationKind;
 if aconsolidationKind <> -1 then FConsolidation.BNextClick(nil);
 FConsolidation.ShowModal;
 FConsolidation.Free;
End;

Procedure FDataDiagramShowModalAsBrowser;
Begin
 FDataDiagram := TFDataDiagram.Create(Application);
 FDataDiagram.ShowModal;
 FDataDiagram.Free;
End;

procedure VALUE_SETSCreate;
begin
If Not Assigned(FBrowseVALUE_SETS) Then FBrowseVALUE_SETS := TFBrowseVALUE_SETS.Create(Application);
end;

Procedure VALUE_SETSShowModalAsBrowser;
Begin
 VALUE_SETSCreate;
 FBrowseVALUE_SETS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then VALUE_SETSFree;
End;

Function VALUE_SETSShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 VALUE_SETSCreate;
 Result := FBrowseVALUE_SETS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then VALUE_SETSFree;
End;

Procedure VALUE_SETSFree;
Begin
 If Assigned(FBrowseVALUE_SETS) Then If FBrowseVALUE_SETS.Visible Then Exit;
 If Assigned(FBrowseVALUE_SETS) Then FBrowseVALUE_SETS.Free;
 FBrowseVALUE_SETS := Nil;
End;

procedure LOOKUPSCreate;
begin
If Not Assigned(FBrowseLOOKUPS) Then FBrowseLOOKUPS := TFBrowseLOOKUPS.Create(Application);
end;

Procedure LOOKUPSShowModalAsBrowser(aCON_value_set_ID : string);
Begin
 LOOKUPSCreate;
 FBrowseLOOKUPS.CON_value_set_ID.Text := aCON_value_set_ID;
 FBrowseLOOKUPS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then LOOKUPSFree;
End;

Function LOOKUPSShowModalAsSelect(var ID : ShortString; aCON_value_set_ID : string) : TModalResult;
Begin
 LOOKUPSCreate;
 FBrowseLOOKUPS.CON_value_set_ID.Text := aCON_value_set_ID;
 Result := FBrowseLOOKUPS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then LOOKUPSFree;
End;

Procedure LOOKUPSFree;
Begin
 If Assigned(FBrowseLOOKUPS) Then If FBrowseLOOKUPS.Visible Then Exit;
 If Assigned(FBrowseLOOKUPS) Then FBrowseLOOKUPS.Free;
 FBrowseLOOKUPS := Nil;
End;


procedure FORMSCreate;
begin
    If Not Assigned(FBrowseFORMS) Then FBrowseFORMS := TFBrowseFORMS.Create(Application);
    if FBrowseFORMS.flexEnabled then FBrowseFORMS.flexSynchronize;
end;

Procedure FORMSShowModalAsBrowser;
Begin
 FORMSCreate;
 with FBrowseFORMS do begin
  CON_type_ID.Text := aCON_type_ID;
  CON_TYPE_ID_VALUE.Enabled := aCON_type_ID = '';
  BC.enabled                := aCON_type_ID = '';
  BR.Enabled                := aCON_type_ID = '';
  BALL.Enabled                   := aCON_type_ID = '';
  BitBtn3.Enabled                := aCON_type_ID = '';
  ShowModalAsBrowser('');
 end;
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FORMSFree;
End;

Function FORMSShowModalAsSelect;
Begin
 FORMSCreate;
 with FBrowseFORMS do begin
  CON_type_ID.Text := aCON_type_ID;
  CON_TYPE_ID_VALUE.Enabled := aCON_type_ID = '';
  BC.Enabled                     := aCON_type_ID = '';
  BR.Enabled                     := aCON_type_ID = '';
  BALL.Enabled                   := aCON_type_ID = '';
  BitBtn3.Enabled                := aCON_type_ID = '';
 end;
  Result := FBrowseFORMS.showModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FORMSFree;
End;

function FORMSShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Begin
 FORMSCreate;
 Result := FBrowseFORMS.ShowModalAsSingleRecord(Action,ID);
 FORMSFree;
End;


Procedure FORMSFree;
Begin
 If Assigned(FBrowseFORMS) Then If FBrowseFORMS.Visible Then Exit;
 If Assigned(FBrowseFORMS) Then FBrowseFORMS.Free;
 FBrowseFORMS := Nil;
End;

procedure FLEX_COL_USAGECreate;
begin
If Not Assigned(FBrowseFLEX_COL_USAGE) Then FBrowseFLEX_COL_USAGE := TFBrowseFLEX_COL_USAGE.Create(Application);
end;

Procedure FLEX_COL_USAGEShowModalAsBrowser;
Begin
 FLEX_COL_USAGECreate;
 FBrowseFLEX_COL_USAGE.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FLEX_COL_USAGEFree;
End;

Function FLEX_COL_USAGEShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 FLEX_COL_USAGECreate;
 Result := FBrowseFLEX_COL_USAGE.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then FLEX_COL_USAGEFree;
End;

Procedure FLEX_COL_USAGEFree;
Begin
 If Assigned(FBrowseFLEX_COL_USAGE) Then If FBrowseFLEX_COL_USAGE.Visible Then Exit;
 If Assigned(FBrowseFLEX_COL_USAGE) Then FBrowseFLEX_COL_USAGE.Free;
 FBrowseFLEX_COL_USAGE := Nil;
End;

procedure TT_COMBINATIONSCreate;
begin
If Not Assigned(FBrowseTT_COMBINATIONS) Then FBrowseTT_COMBINATIONS := TFBrowseTT_COMBINATIONS.Create(Application);
end;

Procedure TT_COMBINATIONSShowModalAsBrowser;
Begin
 TT_COMBINATIONSCreate;
 FBrowseTT_COMBINATIONS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then TT_COMBINATIONSFree;
End;

Function TT_COMBINATIONSShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 TT_COMBINATIONSCreate;
 Result := FBrowseTT_COMBINATIONS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then TT_COMBINATIONSFree;
End;

Function TT_COMBINATIONSShowModalAsMultiSelect(var ID : String) : TModalResult;
Begin
 TT_COMBINATIONSCreate;
 Result := FBrowseTT_COMBINATIONS.ShowModalAsMultiSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then TT_COMBINATIONSFree;
End;


Procedure TT_COMBINATIONSFree;
Begin
 If Assigned(FBrowseTT_COMBINATIONS) Then If FBrowseTT_COMBINATIONS.Visible Then Exit;
 If Assigned(FBrowseTT_COMBINATIONS) Then FBrowseTT_COMBINATIONS.Free;
 FBrowseTT_COMBINATIONS := Nil;
End;

procedure GRIDSCreate;
begin
 If Not Assigned(FBrowseGRIDS) Then FBrowseGRIDS := TFBrowseGRIDS.Create(Application);
end;

Procedure GRIDSShowModalAsBrowser;
Begin
 If not isAdmin Then Begin
  Info('Ta funkcja mo¿e byæ uruchamiana tylko przez u¿ytkownika o uprawnieniach administratora');
  Exit;
 End;

 GRIDSCreate;
 FBrowseGRIDS.ShowModalAsBrowser('');
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then GRIDSFree;
End;

Function GRIDSShowModalAsSelect(var ID : ShortString) : TModalResult;
Begin
 If not isAdmin Then Begin
  Info('Ten modu³ mo¿e byæ uruchamiany tylko przez u¿ytkownika o uprawnieniach administratora');
  Exit;
 End;

 GRIDSCreate;
 Result := FBrowseGRIDS.ShowModalAsSelect(ID);
 If GetSystemParam('SAVERESOURCES') = 'Yes' Then GRIDSFree;
End;

Procedure GRIDSFree;
Begin
 If Assigned(FBrowseGRIDS) Then If FBrowseGRIDS.Visible Then Exit;
 If Assigned(FBrowseGRIDS) Then FBrowseGRIDS.Free;
 FBrowseGRIDS := Nil;
End;

end.
