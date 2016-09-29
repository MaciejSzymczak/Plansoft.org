unit UFDatabaseLogin;

interface

//  uutilityParent.executeFile('IEXPLORE.EXE','www.oracle.com/technology/software/tech/windows/ole_db/htdocs/utilsoft.htm','',SW_MAXIMIZE)

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, StrHlder, UUtilityParent, DB,
  DBTables, DBLists, ComCtrls;

type
  TFDatabaseLogin = class(TFormConfig)
    Panel1: TPanel;
    BAnuluj: TBitBtn;
    Bok: TBitBtn;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label15: TLabel;
    Label5: TLabel;
    getTempDir: TSpeedButton;
    ftphost: TEdit;
    ftpusername: TEdit;
    ftppassword: TEdit;
    ftplocaldir: TEdit;
    LaunchftpClient: TBitBtn;
    ftppassive: TCheckBox;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    OAUserName: TEdit;
    oaRespName: TEdit;
    oaUrl: TEdit;
    Label10: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Password: TEdit;
    UserName: TEdit;
    HostName: TEdit;
    Provider: TEdit;
    AddClass: TSpeedButton;
    Label11: TLabel;
    udlFile: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    BitBtn1: TBitBtn;
    OpenDialog: TOpenDialog;
    BitBtn2: TBitBtn;
    SaveDialog: TSaveDialog;
    SetOracleProvider: TBitBtn;
    Label16: TLabel;
    NLS_LANGUAGE: TEdit;
    setNLSLangPL: TBitBtn;
    setNLSLangUS: TBitBtn;
    BSave: TBitBtn;
    BOpen: TBitBtn;
    sftp: TCheckBox;
    procedure AddClassClick(Sender: TObject);
    procedure getTempDirClick(Sender: TObject);
    procedure LaunchftpClientClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure SetOracleProviderClick(Sender: TObject);
    procedure setNLSLangPLClick(Sender: TObject);
    procedure setNLSLangUSClick(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure BOpenClick(Sender: TObject);
    procedure sftpClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  FDatabaseLogin: TFDatabaseLogin;

Function Login(var aProvider, aHostName, aUserName, aPassword, aNLS_LANGUAGE, audlFile,aftphost,aftpusername,aftppassword,aftplocaldir,aftppassive,asftp,aoaUserName, aoaRespName, aoaUrl : shortString) : TModalResult;




implementation

uses UFAddNewAlias, UFTrickSQL;

{$R *.DFM}

Function Login(var aProvider,aHostName,aUserName, aPassword, aNLS_LANGUAGE,audlFile, aftphost,aftpusername,aftppassword,aftplocaldir,aftppassive,asftp,aoaUserName, aoaRespName, aoaUrl  : shortString) : TModalResult;
Begin
 FDatabaseLogin :=  TFDatabaseLogin.Create(Application);

 With FDatabaseLogin Do Begin

  //UserName.Text := aUserName;
  //Password.Text := aPassword;

  Provider.Text     := aProvider;
  HostName.Text     := aHostName;
  UserName.Text     := aUserName;
  Password.Text     := aPassword;
  NLS_LANGUAGE.Text := aNLS_LANGUAGE;
  ftphost.Text      := aftphost;
  ftpusername.Text  := aftpusername ;
  ftppassword.Text  := aftppassword;
  ftplocaldir.Text  := aftplocaldir;
  ftppassive.checked:= aftppassive = '1';
  sftp.checked      := asftp = '1';
  oaUserName.Text   := aoaUserName;
  oaRespName.Text   := aoaRespName;
  oaUrl.text        := aoaUrl;
  udlFile.Text      := audlFile;

  ActiveControl := HostName;
  Result := ShowModal;

  aProvider     := Provider.Text;
  aHostName     := HostName.Text;
  aUserName     := UserName.Text;
  aPassword     := Password.Text;
  aNLS_LANGUAGE := NLS_LANGUAGE.text;
  aftphost      := ftphost.Text;
  aftpusername  := ftpusername.Text;
  aftppassword  := ftppassword.Text;
  aftplocaldir  := ftplocaldir.Text;
  aftppassive   := iif(ftppassive.checked,'1','0');
  asftp         := iif(sftp.checked,'1','0');
  aoaUserName   := oaUserName.Text;
  aoaRespName   := oaRespName.Text;
  aoaUrl        := oaUrl.text;
  audlFile      := udlFile.Text;

  Free;
 End;
End;

procedure TFDatabaseLogin.AddClassClick(Sender: TObject);
begin
  inherited;
 FAddNewAlias.showModal;
end;

procedure TFDatabaseLogin.getTempDirClick(Sender: TObject);
begin
  ftplocaldir.Text := NVL(sysUtils.GetEnvironmentVariable('TEMP'),'c:\');
end;

procedure TFDatabaseLogin.LaunchftpClientClick(Sender: TObject);
begin
 if not sftp.Checked
  then uutilityparent.ExecuteFileAndWait('ftpclient.exe HOST=' + ftphost.Text + ' USERNAME=' + ftpusername.Text + ' PASSWORD=' + ftppassword.Text + ' TRANSFERTYPE=1 REMOTEDIR= FILENAME= LOCALDIR='+ftplocaldir.Text+' PASSIVE='+ iif(ftppassive.checked,'1','0')+ ' OPERATION=GET' )
  else begin
    //info ('"C:\Program Files\WinSCP3\WinSCP3.exe" sftp://'+ ftpusername.Text +':'+ ftppassword.Text +'@'+ftphost.Text);
    InfoWhenWinscpNotExists;
    uutilityparent.ExecuteFileAndWait('"C:\Program Files\WinSCP3\WinSCP3.exe" sftp://'+ ftpusername.Text +':'+ ftppassword.Text +'@'+ftphost.Text);
  end
end;

procedure TFDatabaseLogin.BitBtn1Click(Sender: TObject);
begin
 openDialog.Filter := 'udl|*.udl|wszystkie|*.*';
 With OpenDialog Do
 If Execute Then
  Begin
    udlFile.Text := FileName;
  End;
end;

procedure TFDatabaseLogin.BitBtn2Click(Sender: TObject);
 Var F : TextFile;
begin
  AssignFile(F, UUtilityParent.ApplicationDir+'\temp.udl');
  ReWrite(F);
  WriteLn(F);
  CloseFile(F);

  if fileExists(UUtilityParent.ApplicationDir+'\temp.udl') then begin
  info (UUtilityParent.ApplicationDir+'\temp.udl');
  uutilityparent.executeFileAndWait(UUtilityParent.ApplicationDir+'\temp.udl');
  info('po');
  end;

  saveDialog.Filter := 'udl|*.udl|wszystkie|*.*';

  if SaveDialog.Execute then begin
   copyFile( pAnsiChar(UUtilityParent.ApplicationDir+'\temp.udl') , pAnsiChar(SaveDialog.filename) ,false);
   udlFile.Text := SaveDialog.filename;
  end;

end;

procedure TFDatabaseLogin.SetOracleProviderClick(Sender: TObject);
begin
  inherited;
  Provider.Text := 'OraOLEDB.Oracle';
end;

procedure TFDatabaseLogin.setNLSLangPLClick(Sender: TObject);
begin
  inherited;
  NLS_LANGUAGE.Text := 'POLISH';
end;

procedure TFDatabaseLogin.setNLSLangUSClick(Sender: TObject);
begin
  inherited;
  NLS_LANGUAGE.Text := 'AMERICAN';
end;

procedure TFDatabaseLogin.BSaveClick(Sender: TObject);
 var res : string;
     F : TextFile;
begin
  saveDialog.InitialDir := nvl(saveDialog.InitialDir, StringsPATH);
  saveDialog.Filter := 'ini|*.ini|wszystkie|*.*';
  if SaveDialog.Execute then begin
  res :=
   '-- initialization file for TrickSQL'+cr+
   '-- Software Factory Maciej Szymczak'+cr+
   ''+cr+
   '--Database login:'+cr+
   iif(provider.Text=''    ,'--PROVIDER='    ,'PROVIDER='+provider.Text)+cr+
   iif(hostName.Text=''    ,'--HOSTNAME='    ,'HOSTNAME='+hostName.Text)+cr+
   iif(userName.Text=''    ,'--USERNAME='    ,'USERNAME='+userName.Text)+cr+
   iif(password.Text=''    ,'--PASSWORD='    ,'PASSWORD='+easyEncrypt( password.Text ))+cr+
   iif(NLS_LANGUAGE.Text='','--NLS_LANGUAGE=','NLS_LANGUAGE='+NLS_LANGUAGE.Text)+cr+
   iif(udlFile.Text=''     ,'--UDLFILE='     ,'UDLFILE='+udlFile.Text)+cr+
   ''+cr+
   '--ftp login'+cr+
   iif(FTPHOST.Text=''    ,'--FTPHOST='    ,'FTPHOST='+FTPHOST.Text)+cr+
   iif(FTPUSERNAME.Text=''    ,'--FTPUSERNAME='    ,'FTPUSERNAME='+FTPUSERNAME.Text)+cr+
   iif(FTPPASSWORD.Text=''    ,'--FTPPASSWORD='    ,'FTPPASSWORD='+easyEncrypt(FTPPASSWORD.Text) )+cr+
   iif(FTPLOCALDIR.Text=''    ,'--FTPLOCALDIR='    ,'FTPLOCALDIR='+FTPLOCALDIR.Text)+cr+
   iif(FTPPASSIVE.checked     ,'FTPPASSIVE=1'    ,'FTPPASSIVE=0')+cr+
   iif(SFTP.checked     ,'SFTP=1'    ,'SFTP=0')+cr+
   ''+cr+
   '--Oracle Applications login'+cr+
   iif(OAUSERNAME.Text=''    ,'--OAUSERNAME='    ,'OAUSERNAME='+OAUSERNAME.Text)+cr+
   iif(OARESPNAME.Text=''    ,'--OARESPNAME='    ,'OARESPNAME='+OARESPNAME.Text)+cr+
   iif(OAURL.Text=''    ,'--OAURL='    ,'OAURL='+FTPUSERNAME.Text)+cr+
   ''+cr+
   '--Other commands:'+cr+
   '--  EXPORT=<SQL STATEMENT;FILE NAME>'+cr+
   '--  REPLACEFILECONTENT'+cr+
   '--  COMMAND';

    AssignFile(F, SaveDialog.filename);
    ReWrite(F);
    WriteLn(F, res);
    CloseFile(F);
    info ('File created');
  end;

end;

procedure TFDatabaseLogin.BOpenClick(Sender: TObject);
begin
  openDialog.InitialDir := nvl(openDialog.InitialDir, StringsPATH);
  openDialog.Filter := 'ini|*.ini|wszystkie|*.*';
  if openDialog.Execute then begin
   with FTrickSQL do begin
    temp.Lines.LoadFromFile(self.openDialog.FileName);
    //info ( temp.Lines.CommaText );
    Provider.Text    := temp.Lines.values['PROVIDER'];
    HOSTNAME.Text    := temp.Lines.values['HOSTNAME'];
    USERNAME.Text    := temp.Lines.values['USERNAME'];
    PASSWORD.Text    := easyDecrypt ( temp.Lines.values['PASSWORD'] );
    NLS_LANGUAGE.Text:= temp.Lines.values['NLS_LANGUAGE'];
    UDLFILE.Text     := temp.Lines.values['UDLFILE'];
    FTPHOST.Text     := temp.Lines.values['FTPHOST'];
    FTPUSERNAME.Text := temp.Lines.values['FTPUSERNAME'];
    FTPPASSWORD.Text := easyDecrypt ( temp.Lines.values['FTPPASSWORD'] );
    FTPLOCALDIR.Text := temp.Lines.values['FTPLOCALDIR'];
    FTPPASSIVE.checked  := temp.Lines.values['FTPPASSIVE']='1';
    sFTP.checked     := temp.Lines.values['SFTP']='1';
    OAUSERNAME.Text  := temp.Lines.values['OAUSERNAME'];
    OARESPNAME.Text  := temp.Lines.values['OARESPNAME'];
    OAURL.Text       := temp.Lines.values['OAURL'];
    //info ('ok');
   end;
  end;
end;

procedure TFDatabaseLogin.sftpClick(Sender: TObject);
begin
  inherited;
 if sftp.Checked then UFTrickSQL.InfoWhenWinscpNotExists;

end;

end.
