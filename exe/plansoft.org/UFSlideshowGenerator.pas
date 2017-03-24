unit UFSlideshowGenerator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, Mask, ToolEdit,
  ExtDlgs, UUtilityParent, dm, ComCtrls;

type
  TFSlideshowGenerator = class(TFormConfig)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    OpenPictureDialog1: TOpenPictureDialog;
    MHeaderNoCustomColors: TMemo;
    MFooter: TMemo;
    MItemEasy: TMemo;
    MAdvanced: TMemo;
    MItemAdv: TMemo;
    ModeSwitch: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Image1: TImage;
    Image2: TImage;
    MHeaderCustomColors: TMemo;
    CustomColors: TCheckBox;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSlideshowGenerator: TFSlideshowGenerator;

implementation

{$R *.dfm}

procedure TFSlideshowGenerator.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TFSlideshowGenerator.BitBtn1Click(Sender: TObject);
Var
  Path, ext, outputString    : String;
  SR      : TSearchRec;
  DirList : TStrings;
  tmpFile : textfile;
  counter : integer;
  olGroup : string;
  token, divGroup : string;

begin
  if OpenPictureDialog1.Execute then
  begin
    Path:=ExtractFileDir(OpenPictureDialog1.FileName)+'\'; //Get the path of the selected file
    DirList:=TStringList.Create;
    counter := 0;
    olGroup := '';
    divGroup := '';
    try
          if FindFirst(Path + '*.*', faAnyFile, SR) = 0 then
          begin
            repeat
                If (SR.Name <> '.') And (SR.Name <> '..') Then Begin
                   ext := upperCase(extractFileExt(SR.Name));
                   if (ext = '.JPG') or (ext='.PNG') then begin
                     DirList.Add(SR.Name);
                     if (counter=0) then
                       olGroup := '<li data-target="#myCarousel" data-slide-to="0" class="active"></li>' +#13#10
                     else
                       olGroup := olGroup + '<li data-target="#myCarousel" data-slide-to="'+intToStr(counter)+'"></li>' +#13#10;


                     token := searchAndreplace(iif(ModeSwitch.ActivePageIndex=1, MItemAdv.lines.Text,MItemEasy.lines.Text),'%CLASSNAME%',iif(counter=0,'item active','item'));
                     token := searchAndreplace(token,'%FILENAME%' ,SR.Name);
                     token := searchAndreplace(token,'%TITLE%'    ,'<!--tutaj mo¿esz wstawiæ tytu³ dla swojego zdjêcia-->');
                     token := searchAndreplace(token,'%SUBTITLE%' ,'<!--tutaj mo¿esz wstawiæ podtytu³ dla swojego zdjêcia-->') +#13#10;
                     divGroup := divGroup + token;

                     inc(counter);
                   end;
                End;
            until FindNext(SR) <> 0;
            FindClose(SR);
          end;

     if DirList.Text='' then begin
       info('Wybrany folder nie zawiera zdjêæ. Wybierz folder na dysku zawieraj¹cy pliki jpg oraz png');
       exit;
     end;

     AssignFile(tmpFile,  Path +'index.html');
     rewrite(tmpFile);
     outputString :=
       iif(CustomColors.checked, MHeaderCustomColors.lines.Text,MHeaderNoCustomColors.lines.Text)+
       iif(ModeSwitch.ActivePageIndex=1, MAdvanced.lines.Text,'')+
       '<div class="container">'+#13#10+
       '  <br>'+#13#10+
       '  <div id="myCarousel" class="carousel slide" data-ride="carousel">'+#13#10+
       '    <!-- Indicators -->'+#13#10+
       '    <ol class="carousel-indicators">'+#13#10+
       olGroup +
       '</ol>'+
       '<div class="carousel-inner" role="listbox">'+
       divGroup +
       MFooter.lines.Text;

     writeln(tmpFile, outputString);
     closeFile(tmpFile);
     ExecuteFile(Path +'index.html','','',SW_SHOWMAXIMIZED);


    DirList.Free;
    except
    on e:exception do begin
        info('Ups, coœ posz³o nie tak. SprawdŸ, czy na pewno mo¿esz modyfikowaæ zawartoœæ katalogu, który wybrano');
        raise;
        end;
    end;
  end;
end;

end.
