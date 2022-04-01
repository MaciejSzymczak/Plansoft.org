inherited FPulpitSelector: TFPulpitSelector
  Left = 357
  Top = 186
  Width = 747
  Height = 417
  Caption = 'Wyb'#243'r pulpitu'
  PixelsPerInch = 96
  TextHeight = 14
  object Pulpit1: TSpeedButton [0]
    Left = 304
    Top = 128
    Width = 137
    Height = 113
    GroupIndex = 1
    Down = True
    Caption = 'G'#322#243'wny'
    OnClick = Pulpit2Click
  end
  object Pulpit3: TSpeedButton [1]
    Left = 304
    Top = 248
    Width = 137
    Height = 113
    GroupIndex = 1
    Caption = 'Pulpit 3'
    OnClick = Pulpit2Click
  end
  object Pulpit2: TSpeedButton [2]
    Left = 304
    Top = 8
    Width = 137
    Height = 113
    GroupIndex = 1
    Caption = 'Pulpit 2'
    OnClick = Pulpit2Click
  end
  object Pulpit4: TSpeedButton [3]
    Left = 448
    Top = 128
    Width = 137
    Height = 113
    GroupIndex = 1
    Caption = 'Pulpit 4'
    OnClick = Pulpit2Click
  end
  object Pulpit5: TSpeedButton [4]
    Left = 160
    Top = 128
    Width = 137
    Height = 113
    GroupIndex = 1
    Caption = 'Pulpit 5'
    OnClick = Pulpit2Click
  end
  object Pulpit7: TSpeedButton [5]
    Left = 16
    Top = 128
    Width = 137
    Height = 113
    GroupIndex = 1
    Caption = 'Pulpit 7'
    OnClick = Pulpit2Click
  end
  object Pulpit6: TSpeedButton [6]
    Left = 592
    Top = 128
    Width = 137
    Height = 113
    GroupIndex = 1
    Caption = 'Pulpit 6'
    OnClick = Pulpit2Click
  end
  inherited Status: TPanel
    Top = 366
    Width = 739
  end
  object Cancel: TBitBtn
    Left = 592
    Top = 328
    Width = 137
    Height = 33
    Cancel = True
    Caption = 'Anuluj'
    TabOrder = 1
    OnClick = CancelClick
  end
  object FCopy: TCheckBox
    Left = 8
    Top = 8
    Width = 185
    Height = 17
    Caption = 'Sklonuj bie'#380#261'cy pulpit'
    TabOrder = 2
  end
  object Rename: TCheckBox
    Left = 8
    Top = 24
    Width = 105
    Height = 17
    Caption = 'Nazwij pulpit'
    TabOrder = 3
  end
end
