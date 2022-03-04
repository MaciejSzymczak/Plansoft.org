inherited FTTCheckResults: TFTTCheckResults
  Left = 366
  Top = 214
  Width = 596
  Height = 479
  Caption = 'Brakuj'#261'ce kombinacje zasob'#243'w'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 428
    Width = 588
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 588
    Height = 33
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 446
      Height = 14
      Caption = 
        'W bazie dozwolonych kombinacji zasob'#243'w nie zosta'#322'y odnalezione n' +
        'ast'#281'puj'#261'ce kombinacje:'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 387
    Width = 588
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      588
      41)
    object bClose: TBitBtn
      Left = 504
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Anuluj'
      TabOrder = 0
      Kind = bkCancel
    end
    object bProceed: TBitBtn
      Left = 272
      Top = 8
      Width = 227
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Kontynuuj - dodaj brakuj'#261'ce kombinacje'
      TabOrder = 1
      Kind = bkOK
    end
    object bBrowse: TBitBtn
      Left = 64
      Top = 8
      Width = 203
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Edytuj kombinacje'
      TabOrder = 2
      OnClick = bBrowseClick
    end
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 33
    Width = 588
    Height = 354
    Align = alClient
    DataSource = DataSource
    Options = [dgEditing, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 3
    TitleFont.Charset = EASTEUROPE_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Arial'
    TitleFont.Style = []
  end
  object ADOQuery: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    AfterOpen = ADOQueryAfterOpen
    Parameters = <>
    SQL.Strings = (
      'select *'
      'from tt_check_results_v where found_tt = 0')
    Left = 24
    Top = 64
  end
  object DataSource: TDataSource
    AutoEdit = False
    DataSet = ADOQuery
    Left = 56
    Top = 64
  end
end
