unit UFGetDisksStatuses;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, Placemnt, ExtCtrls;

type
  TFGetDisksStatuses = class(TForm)
    SG: TStringGrid;
    Storage: TFormStorage;
    Panel1: TPanel;
    BitBtn2: TBitBtn;
    Ref: TBitBtn;
    Timer1: TTimer;
    DYSKI: TEdit;
    Label1: TLabel;
    AutoR: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure RefClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FGetDisksStatuses: TFGetDisksStatuses;

implementation

{$R *.DFM}

procedure TFGetDisksStatuses.FormCreate(Sender: TObject);
begin
 SG.Cells[0,0] := 'Dysk';
 SG.Cells[4,0] := 'Sekt. w klastrze';
 SG.Cells[5,0] := 'Bajtów w sektorze';
 SG.Cells[6,0] := 'Wolne klastry';
 SG.Cells[7,0] := 'Wszystkie klastry';
 SG.Cells[1,0] := 'Wolny obszar ';
 SG.Cells[2,0] := 'Zajêty ';
 SG.Cells[3,0] := 'Ca³y obszar ';

end;

procedure TFGetDisksStatuses.RefClick(Sender: TObject);
Var lpRootPathName        : ShortString;
    _lpSectorsPerCluster   : Cardinal;
    _lpBytesPerSector      : Cardinal;
    _lpNumberOfFreeClusters: Cardinal;
    _lpTotalNumerOfClusters: Cardinal;
    L                     : Cardinal;

    lpSectorsPerCluster   : Extended;
    lpBytesPerSector      : Extended;
    lpNumberOfFreeClusters: Extended;
    lpTotalNumerOfClusters: Extended;

begin
 SG.RowCount := 1;
 For L := 1 To Length(DYSKI.Text) Do Begin
  SG.RowCount := SG.RowCount + 1;
  SG.FixedRows := 1;
  lpRootPathName := DYSKI.Text[L] + ':\' + #0;
  If GetDiskFreeSpace(@lpRootPathName[1],_lpSectorsPerCluster,_lpBytesPerSector,_lpNumberOfFreeClusters,_lpTotalNumerOfClusters) Then Begin

   lpSectorsPerCluster   := _lpSectorsPerCluster;
   lpBytesPerSector      := _lpBytesPerSector;
   lpNumberOfFreeClusters:= _lpNumberOfFreeClusters;
   lpTotalNumerOfClusters:= _lpTotalNumerOfClusters;

   SG.Cells[0,L] := DYSKI.Text[L] + ':\';
   SG.Cells[4,L] :=  FloatToStr(lpSectorsPerCluster);
   SG.Cells[5,L] := FloatToStr(lpBytesPerSector);
   SG.Cells[6,L] := FloatToStr(lpNumberOfFreeClusters);
   SG.Cells[7,L] := FloatToStr(lpTotalNumerOfClusters);
   SG.Cells[1,L] := FloatToStr(lpNumberOfFreeClusters*lpSectorsPerCluster*lpBytesPerSector / (1024*1024))+ ' [MB] ('+ FloatToStr(lpNumberOfFreeClusters*lpSectorsPerCluster*lpBytesPerSector) + ')';
   SG.Cells[2,L] := FloatToStr((lpTotalNumerOfClusters-lpNumberOfFreeClusters)*lpSectorsPerCluster*lpBytesPerSector / (1024*1024))+ '[MB] (' + FloatToStr((lpTotalNumerOfClusters-lpNumberOfFreeClusters)*lpSectorsPerCluster*lpBytesPerSector)+ ')';
   SG.Cells[3,L] := FloatToStr(lpTotalNumerOfClusters*lpSectorsPerCluster*lpBytesPerSector / (1024*1024))+ ' [MB] ('+FloatToStr(lpTotalNumerOfClusters*lpSectorsPerCluster*lpBytesPerSector)+ ')';
  End Else SG.Cells[0,L] := 'b³¹d:'+DYSKI.Text[L] + ':\';
 End;
end;

procedure TFGetDisksStatuses.FormShow(Sender: TObject);
begin
 RefClick(nil);
 FormResize(nil);
end;

Procedure Info(S : String);
Var H : String;
Begin
 S := S + Char(0);
 H := 'INFORMACJA';
 MessageBox(0, @S[1], @H[1], MB_OK + MB_ICONINFORMATION + MB_TASKMODAL);
End;


procedure TFGetDisksStatuses.Timer1Timer(Sender: TObject);
begin
 If AutoR.Checked Then RefClick(nil);
end;

procedure TFGetDisksStatuses.FormResize(Sender: TObject);
begin
// I.Left       := Panel1.Width - 100*3;
 Ref.Left     := Panel1.Width - 100*2;
 BitBtn2.Left := Panel1.Width - 100;
end;


end.
