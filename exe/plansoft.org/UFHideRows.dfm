object FHideRows: TFHideRows
  Left = 400
  Top = 150
  BorderStyle = bsDialog
  Caption = 'Widoczno'#347#263' wierszy'
  ClientHeight = 460
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object CheckListBox1: TCheckListBox
    Left = 8
    Top = 8
    Width = 320
    Height = 408
    ItemHeight = 13
    TabOrder = 0
  end
  object SpeedButton1: TSpeedButton
    Left = 96
    Top = 424
    Width = 65
    Height = 26
    Caption = 'Ok'
    Flat = True
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 176
    Top = 424
    Width = 65
    Height = 26
    Caption = 'Anuluj'
    Flat = True
    OnClick = SpeedButton2Click
  end
end
