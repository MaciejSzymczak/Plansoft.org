object FMain: TFMain
  Left = 192
  Top = 114
  Width = 979
  Height = 98
  Caption = 'Test ADO connection'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 8
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object p: TEdit
    Left = 8
    Top = 8
    Width = 945
    Height = 21
    TabOrder = 1
    Text = 
      'Provider=OraOLEDB.Oracle.1;Password=planner;Persist Security Inf' +
      'o=True;User ID=planner;Data Source=127.0.0.1:1521/xe'
  end
  object ADOConnection: TADOConnection
    Attributes = [xaCommitRetaining]
    ConnectionString = 
      'Provider=OraOLEDB.Oracle;Password=planner;Persist Security Info=' +
      'True;User ID=planner;Data Source=LOCALHOST:1521/XE'
    CursorLocation = clUseServer
    IsolationLevel = ilReadCommitted
    LoginPrompt = False
    Provider = 'OraOLEDB.Oracle'
    Left = 12
    Top = 10
  end
  object ADOQuery: TADOQuery
    Parameters = <>
    Left = 104
    Top = 32
  end
end
