inherited FDBSpace: TFDBSpace
  Left = 260
  Top = 200
  Width = 650
  Height = 150
  Caption = 'Dost'#281'pne miejsce'
  Font.Charset = DEFAULT_CHARSET
  Font.Name = 'Tahoma'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Status: TPanel
    Top = 100
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
      Width = 80
      Height = 13
      Caption = 'Wykorzystano: -'
    end
    object LLimit: TLabel
      Left = 180
      Top = 42
      Width = 32
      Height = 13
      Caption = 'Limit: -'
    end
    object LFree: TLabel
      Left = 300
      Top = 42
      Width = 41
      Height = 13
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
    Height = 36
    Align = alClient
    DataSource = DS
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Visible = False
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
