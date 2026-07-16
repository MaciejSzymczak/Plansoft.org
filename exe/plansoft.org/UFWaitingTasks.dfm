inherited FWaitingTasks: TFWaitingTasks
  Left = 260
  Top = 200
  Width = 650
  Height = 400
  Caption = 'Oczekuj'#261'ce zadania'
  Font.Charset = DEFAULT_CHARSET
  Font.Name = 'Tahoma'
  KeyPreview = True
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  inherited Status: TPanel
    Top = 350
    Width = 642
  end
  object Grid: TDBGrid
    Left = 0
    Top = 0
    Width = 642
    Height = 350
    Align = alClient
    DataSource = DS
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DS: TDataSource
    DataSet = Query
    Left = 96
    Top = 96
  end
  object Query: TADOQuery
    Connection = DModule.ADOConnection
    Parameters = <>
    Left = 32
    Top = 96
  end
  object RefreshTimer: TTimer
    Interval = 300000
    Enabled = False
    OnTimer = RefreshTimerTimer
    Left = 160
    Top = 96
  end
end
