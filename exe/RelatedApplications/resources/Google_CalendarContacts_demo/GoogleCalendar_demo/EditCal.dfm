object EditCalForm: TEditCalForm
  Left = 410
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Edit Calendar'
  ClientHeight = 230
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 20
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object Label2: TLabel
    Left = 16
    Top = 52
    Width = 57
    Height = 13
    Caption = 'Description:'
  end
  object Label3: TLabel
    Left = 16
    Top = 132
    Width = 44
    Height = 13
    Caption = 'Location:'
  end
  object Label4: TLabel
    Left = 16
    Top = 164
    Width = 53
    Height = 13
    Caption = 'Time Zone:'
  end
  object NameEd: TEdit
    Left = 80
    Top = 16
    Width = 289
    Height = 21
    TabOrder = 0
  end
  object DescriptMem: TMemo
    Left = 80
    Top = 48
    Width = 289
    Height = 73
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object LocationEd: TEdit
    Left = 80
    Top = 128
    Width = 289
    Height = 21
    TabOrder = 2
  end
  object TimeZoneEd: TEdit
    Left = 80
    Top = 160
    Width = 289
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 3
  end
  object OKBtn: TButton
    Left = 80
    Top = 200
    Width = 75
    Height = 21
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 232
    Top = 200
    Width = 75
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
end
