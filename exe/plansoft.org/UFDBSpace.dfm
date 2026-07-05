inherited FDBSpace: TFDBSpace
  Left = 260
  Top = 200
  Width = 650
  Height = 150
  Caption = 'Dost'#281'pne miejsce'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  inherited Status: TPanel
    Top = 114
    Width = 642
  end
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 642
    Height = 64
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object LUsed: TLabel
      Left = 8
      Top = 42
      Width = 90
      Height = 16
      Caption = 'Wykorzystano: -'
    end
    object LLimit: TLabel
      Left = 180
      Top = 42
      Width = 60
      Height = 16
      Caption = 'Limit: -'
    end
    object LFree: TLabel
      Left = 300
      Top = 42
      Width = 65
      Height = 16
      Caption = 'Wolne: -'
    end
    object UsageBar: TPaintBox
      Left = 8
      Top = 8
      Width = 524
      Height = 26
      OnPaint = UsageBarPaint
    end
    object BDetails: TBitBtn
      Left = 552
      Top = 8
      Width = 80
      Height = 26
      Caption = 'Szczeg'#243#322'y'
      TabOrder = 0
      OnClick = BDetailsClick
    end
  end
  object Grid: TDBGrid
    Left = 0
    Top = 64
    Width = 642
    Height = 320
    Align = alClient
    DataSource = DS
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 2
    Visible = False
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    OnDrawColumnCell = GridDrawColumnCell
  end
  object DS: TDataSource
    DataSet = SegmentsQuery
    Left = 96
    Top = 96
  end
  object SummaryQuery: TADOQuery
    Connection = DModule.ADOConnection
    Parameters = <>
    Left = 32
    Top = 96
  end
  object SegmentsQuery: TADOQuery
    Connection = DModule.ADOConnection
    Parameters = <>
    Left = 160
    Top = 96
  end
end
