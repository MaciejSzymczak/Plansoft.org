program Planowanie;

{%ToDo 'Planowanie.todo'}

uses
  UUtilityParent in '..\CommonMS\UUtilityParent.pas',
  Forms,
  SysUtils,
  DateUtils,
  UFMain in 'UFMain.pas' {FMain},
  DM in 'DM.pas' {DModule: TDataModule},
  AutoCreate in 'AutoCreate.pas',
  UFReadString in '..\CommonMS\UFReadString.pas',
  UFormConfig in '..\CommonMS\UFormConfig.pas' {FormConfig},
  UFBrowseParent in '..\CommonMS\UFBrowseParent.pas' {FBrowseParent},
  UFDatabaseError in '..\CommonMS\UFDatabaseError.pas' {FDatabaseError},
  UCommon in 'UCommon.pas',
  UFInfoParent in '..\CommonMS\UFInfoParent.pas' {FInfoParent},
  UFToolSelectColumns in '..\CommonMS\UFToolSelectColumns.pas' {FToolSelectColumns},
  UFInfo in 'UFInfo.pas' {FInfo},
  UFModuleOleExport in '..\CommonMS\UFModuleOleExport.pas' {FModuleOleExport},
  UFModuleSummarySQL in '..\CommonMS\UFModuleSummarySQL.pas' {FModuleSummarySQL},
  UFModuleConfigure in '..\CommonMS\UFModuleConfigure.pas' {FModuleConfigure},
  UFModuleCrossCombination in '..\CommonMS\UFModuleCrossCombination.pas' {FModuleCrossCombination},
  UFModuleFilter in '..\CommonMS\UFModuleFilter.pas' {FModuleFilter},
  UFModulePrint in '..\CommonMS\UFModulePrint.pas' {FModulePrint},
  UFModulePrintAdvanced in '..\CommonMS\UFModulePrintAdvanced.pas' {FModulePrintAdvanced},
  UFModuleSummary in '..\CommonMS\UFModuleSummary.pas' {FModuleSummary},
  UFModuleSummaryConfig in '..\CommonMS\UFModuleSummaryConfig.pas' {FModuleSummaryConfig},
  UFModuleSummaryDlgOptions in '..\CommonMS\UFModuleSummaryDlgOptions.pas' {FModuleSummaryDlgOptions},
  UFModuleSummaryFields in '..\CommonMS\UFModuleSummaryFields.pas' {FModuleSummaryFields},
  UFModuleChart in '..\CommonMS\UFModuleChart.pas' {FModuleChart},
  UFBrowseLECTURERS in 'UFBrowseLECTURERS.pas' {FBrowseLECTURERS},
  uFBrowseGROUPS in 'uFBrowseGROUPS.pas' {FBrowseGROUPS},
  UFBrowseROOMS in 'UFBrowseROOMS.pas' {FBrowseROOMS},
  UFBrowseSUBJECTS in 'UFBrowseSUBJECTS.pas' {FBrowseSUBJECTS},
  uFBrowseFORMS in 'uFBrowseFORMS.pas' {FBrowseFORMS},
  uFBrowsePERIODS in 'uFBrowsePERIODS.pas' {FBrowsePERIODS},
  UUtilities in 'UUtilities.pas',
  UFDetails in 'UFDetails.pas' {FDetails},
  UFBrowseRESERVATIONS_KINDS in 'UFBrowseRESERVATIONS_KINDS.pas' {FBrowseRESERVATIONS_KINDS},
  UFShowConflicts in 'UFShowConflicts.pas' {FShowConflicts},
  UFBrowseCLASSES in 'UFBrowseCLASSES.pas' {FBrowseCLASSES},
  UFLegend in 'UFLegend.pas' {FLegend},
  UFLookupWindow in '..\CommonMS\UFLookupWindow.pas' {FLookupWindow},
  UFSettings in 'UFSettings.pas' {FSettings},
  UFBrowsePLANNERS in 'UFBrowsePLANNERS.pas' {FBrowsePLANNERS},
  UFPlannerPermissions in 'UFPlannerPermissions.pas' {FPlannerPermissions},
  UFWWWGenerator in 'UFWWWGenerator.pas' {FWWWGenerator},
  UFMatrix in 'UFMatrix.pas' {FMatrix},
  textnum in '..\CommonMS\textnum.pas',
  UFEksport in '..\CommonMS\UFEksport.pas' {FEksport},
  UFIntro in '..\CommonMS\UFIntro.pas' {FIntro},
  UFCharASCI in '..\CommonMS\UFCharASCI.pas' {FCharASCI},
  UFLogFileSettings in '..\CommonMS\UFLogFileSettings.pas' {FLogFileSettings},
  UFMemoryStatus in '..\CommonMS\UFMemoryStatus.pas' {FMemoryStatus},
  UFPackManyFiles in '..\CommonMS\UFPackManyFiles.pas' {FPackManyFiles},
  UFExp in 'UFExp.pas' {FExp},
  UFImp in 'UFImp.pas' {FImp},
  UFProgramSettings in 'UFProgramSettings.pas' {FProgramSettings},
  UFBrowseRESOURCE_CATEGORIES in 'UFBrowseRESOURCE_CATEGORIES.pas' {FBrowseRESOURCE_CATEGORIES},
  UFBrowseORG_UNITS in 'UFBrowseORG_UNITS.pas' {FBrowseORG_UNITS},
  UFBrowseFORM_FORMULAS in 'UFBrowseFORM_FORMULAS.pas' {FBrowseFORM_FORMULAS},
  UFConsolidation in 'UFConsolidation.pas' {FConsolidation},
  UFDataDiagram in 'UFDataDiagram.pas' {FDataDiagram},
  UFDatabaseLogin in 'UFDatabaseLogin.pas' {FDatabaseLogin},
  UFBrowseVALUE_SETS in '..\CommonMS\UFBrowseVALUE_SETS.pas' {FBrowseVALUE_SETS},
  UFBrowseLOOKUPS in '..\CommonMS\UFBrowseLOOKUPS.pas' {FBrowseLOOKUPS},
  UFChangePassword in 'UFChangePassword.pas' {FChangePassword},
  UFToolWindow in 'UFToolWindow.pas' {FToolWindow},
  UFCopyClasses in 'UFCopyClasses.pas' {FCopyClasses},
  UFPurgeData in 'UFPurgeData.pas' {FPurgeData},
  UFlex in 'UFlex.pas' {Flex: TFrame},
  UFFlexNewAttribute in '..\CommonMS\UFFlexNewAttribute.pas' {FFlexNewAttribute},
  UFBrowseFLEX_COL_USAGE in 'UFBrowseFLEX_COL_USAGE.pas' {FBrowseFLEX_COL_USAGE},
  UFprogressBar in 'UFprogressBar.pas' {FprogressBar},
  UFTTCheckResults in 'UFTTCheckResults.pas' {FTTCheckResults},
  UFTTCombinations in 'UFTTCombinations.pas' {FTTCombinations},
  UFBrowseTT_RESCAT_COMBINATIONS in 'UFBrowseTT_RESCAT_COMBINATIONS.pas' {FBrowseTT_RESCAT_COMBINATIONS},
  UFBrowseTT_COMBINATIONS in 'UFBrowseTT_COMBINATIONS.pas' {FBrowseTT_COMBINATIONS},
  UFGenericFilter in 'UFGenericFilter.pas' {FGenericFilter: TFrame},
  UFMassImport in 'UFMassImport.pas' {FMassImport},
  UFAbolitionTime in 'UFAbolitionTime.pas' {FAbolitionTime},
  UFBrowseFIN_PARTIES in 'UFBrowseFIN_PARTIES.pas' {FBrowseFIN_PARTIES},
  UFBrowseFIN_BATCHES in 'UFBrowseFIN_BATCHES.pas' {FBrowseFIN_BATCHES},
  UFBrowseFIN_DOCS in 'UFBrowseFIN_DOCS.pas' {FBrowseFIN_DOCS},
  UFBrowseFIN_LINES in 'UFBrowseFIN_LINES.pas' {FBrowseFIN_LINES},
  UFBrowseFIN_LOOKUP_VALUES in 'UFBrowseFIN_LOOKUP_VALUES.pas' {FBrowseFIN_LOOKUP_VALUES},
  UFIN_LINESGenerator in 'UFIN_LINESGenerator.pas' {FFIN_LINESGenerator},
  GoogleCal in 'GoogleCal.pas',
  UFBrowseGRIDS in 'UFBrowseGRIDS.pas' {FBrowseGRIDS},
  UWeeklyTable in 'UWeeklyTable.pas',
  UFGrouping in 'UFGrouping.pas' {FGrouping},
  UFKPI in 'UFKPI.pas' {FKPI},
  UFGoogleMap in 'UFGoogleMap.pas' {FGoogleMap},
  UFTransfer in 'UFTransfer.pas' {FTransfer},
  UFDatesSelector in 'UFDatesSelector.pas' {FDatesSelector},
  UFGoogleOrgChart in 'UFGoogleOrgChart.pas' {FGoogleOrgChart},
  UFSlideshowGenerator in 'UFSlideshowGenerator.pas' {FSlideshowGenerator},
  UFPattern in 'UFPattern.pas' {FPattern},
  UFBrowseRES_HINTS in 'UFBrowseRES_HINTS.pas' {FBrowseRES_HINTS},
  UFActionTree in 'UFActionTree.pas' {FActionTree},
  UFCellLayout in 'UFCellLayout.pas' {FCellLayout},
  UFSalectDaysOfWeek in 'UFSalectDaysOfWeek.pas' {FSelectDaysOfWeek};

{$R *.RES}

procedure checkLicence;
var todayMarker : integer;
    installDate : integer;
    daysRemaining : integer;
    lastDateRun   : string;
    installMarker : string;
    licenseType   : string;
begin
  lastDateRun := nvl( encGetSystemParam('lastDateRun') , '0');

  if extractFileName(SysUtils.lowercase(Application.exeName)) <> 'planowanie.exe' then begin
   serror('Wykryto próbê ominiêcia zabezpieczeñ programu (1). Uruchomienie programu nie bêdzie mo¿liwe do czasu, gdy nie zostan¹ przywrócone poprzednie ustawienia. Application.exeName= ' + Application.exeName );
   dmodule.CloseDBConnection;
   halt;
  end;

  if lastDateRun > UUtilityParent.DateToYYYYMMDD_HHMMSSMI(now)  then begin
    serror('Zmieniono datê systemow¹ na tym komputerze, uruchomienie programu nie bêdzie mo¿liwe do czasu, gdy nie zostan¹ przywrócone poprzednie ustawienia');
    dmodule.CloseDBConnection;
    halt;
  end else begin
    encSetSystemParam('lastDateRun',UUtilityParent.DateToYYYYMMDD_HHMMSSMI(now));
    todayMarker := datetimeToTimeStamp ( DateUtils.Today ).Date;
    //encSetSystemParam('licenseType', '120DAYS' + ';' + UUtilityParent.GetTerminalName, 'Planowanie');

    licenseType := encGetSystemParam('licenseType');

    if strIsEmpty(licenseType) then begin
     encSetSystemParam('installMarker', intToStr(todayMarker) + ';' + UUtilityParent.GetTerminalName, 'Planowanie');
     encSetSystemParam('licenseType', '120DAYS' + ';' + UUtilityParent.GetTerminalName, 'Planowanie');
     licenseType := encGetSystemParam('licenseType');
     //serror('Aby korzystaæ z programu, musisz najpier uruchomiæ program aktywuj¹cy, za pomoc¹ którego wybierzesz rodzaj licencji. Skontaktuj siê z dostawc¹ oprogramowania.');
     //halt;
    end;

    if getTerminalName <> extractWord(2,licenseType,[';']) then begin
     serror('Wykryto próbê ominiêcia zabezpieczeñ programu (2). Uruchomienie programu nie bêdzie mo¿liwe do czasu, gdy nie zostan¹ przywrócone poprzednie ustawienia. getTerminalName='+getTerminalName+' licenseType=' + licenseType);
     dmodule.CloseDBConnection;
     halt;
    end;

    licenseType := extractWord(1, encGetSystemParam('licenseType'),[';']);

    if licenseType =  'NOLIMIT' then begin
    end else begin  //'120DAYS'
       installMarker := encGetSystemParam('installMarker');

       if getTerminalName <> extractWord(2,installMarker,[';']) then begin
        serror('Wykryto próbê ominiêcia zabezpieczeñ programu (3). Uruchomienie programu nie bêdzie mo¿liwe do czasu, gdy nie zostan¹ przywrócone poprzednie ustawienia. getTerminalName='+getTerminalName+' installMarker='+installMarker);
        dmodule.CloseDBConnection;
        halt;
       end;

      installDate := strToInt ( nvl( extractWord(1,installMarker,[';']), '0') );
      daysRemaining := installDate + 120 - todayMarker;
      if daysRemaining > 0 then begin
        info('Uruchomiono demonstracyjn¹ wersjê programu Planowanie. Mo¿esz korzystaæ z tej wersji programu jeszcze przez nastêpuj¹c¹ liczbê dni: ' + intToStr(daysRemaining));
      end else begin
        warning('Uruchomiono demonstracyjn¹ wersjê programu Planowanie. Nie mo¿esz ju¿ korzystaæ z tej wersji programu, poniewa¿ minê³o 120 dni od dnia, kiedy program zosta³ zainstalowany. Skontaktuj siê z dostawc¹ oprogramowania');
        //dmodule.CloseDBConnection;
        Application.Terminate;
      end;
    end;
 end;
end;


//////////////////////////////////////////////////////////////////////////////////////////
{
    procedure PatchINT3;
    var
      NOP : Byte;
      NTDLL: THandle;
      BytesWritten: DWORD;
      Address: Pointer;
    begin
      if Win32Platform <> VER_PLATFORM_WIN32_NT then Exit;
      NTDLL := GetModuleHandle('NTDLL.DLL');
      if NTDLL = 0 then Exit;
      Address := GetProcAddress(NTDLL, 'DbgBreakPoint');
      if Address = nil then Exit;
      try
        if Char(Address^) <> #$CC then Exit;
        NOP := $90;
        if WriteProcessMemory(GetCurrentProcess, Address, @NOP, 1, BytesWritten) and
          (BytesWritten = 1) then
          FlushInstructionCache(GetCurrentProcess, Address, 1);
    except
        //Do not panic if you see an EAccessViolation here, it is perfectly harmless!
        on EAccessViolation do ;
        else raise;
      end;
    end;
}
begin
  {
  problem occured when debugging a application without breakpoints and stops the program. Below information displayed on CPU window:
  And runing the App with windows XP & delphi 7.Anybody got any idea and what is going on? Please share the solution for this problem.
  ntdll.DbgBreakPoint:
  7C90120E CC int 3
  7C90120F C3 ret  <-----------stops here
  7C901210 8BFF mov,edi,edi
  workaround:
  http://www.howtodothings.com/computers/a898-ntdlldbguserbreakpoint.html
  }
  //PatchINT3;

  checkLicence;
  Application.Initialize;
  Application.CreateForm(TDModule, DModule);
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFDetails, FDetails);
  Application.CreateForm(TFShowConflicts, FShowConflicts);
  Application.CreateForm(TFSettings, FSettings);
  Application.CreateForm(TFProgramSettings, FProgramSettings);
  Application.CreateForm(TFMatrix, FMatrix);
  Application.CreateForm(TFEksport, FEksport);
  Application.CreateForm(TFCharASCI, FCharASCI);
  Application.CreateForm(TFLogFileSettings, FLogFileSettings);
  Application.CreateForm(TFExp, FExp);
  Application.CreateForm(TFImp, FImp);
  Application.CreateForm(TFDatabaseLogin, FDatabaseLogin);
  Application.CreateForm(TFChangePassword, FChangePassword);
  Application.CreateForm(TFToolWindow, FToolWindow);
  Application.CreateForm(TFCopyClasses, FCopyClasses);
  Application.CreateForm(TFPurgeData, FPurgeData);
  Application.CreateForm(TFFlexNewAttribute, FFlexNewAttribute);
  Application.CreateForm(TFprogressBar, FprogressBar);
  Application.CreateForm(TFTTCheckResults, FTTCheckResults);
  Application.CreateForm(TFMassImport, FMassImport);
  Application.CreateForm(TFAbolitionTime, FAbolitionTime);
  Application.CreateForm(TFFIN_LINESGenerator, FFIN_LINESGenerator);
  Application.CreateForm(TFGrouping, FGrouping);
  Application.CreateForm(TFDatesSelector, FDatesSelector);
  Application.CreateForm(TFGoogleOrgChart, FGoogleOrgChart);
  Application.CreateForm(TFSlideshowGenerator, FSlideshowGenerator);
  Application.CreateForm(TFPattern, FPattern);
  Application.CreateForm(TFActionTree, FActionTree);
  Application.CreateForm(TFCellLayout, FCellLayout);
  Application.CreateForm(TFSelectDaysOfWeek, FSelectDaysOfWeek);
  Application.Run;
end.
