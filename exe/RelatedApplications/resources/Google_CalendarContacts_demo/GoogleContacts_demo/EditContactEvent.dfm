object EditContactEventFrm: TEditContactEventFrm
  Left = 360
  Top = 174
  Width = 403
  Height = 153
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    387
    117)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 20
    Width = 61
    Height = 13
    Caption = 'Event name:'
  end
  object Label2: TLabel
    Left = 16
    Top = 52
    Width = 55
    Height = 13
    Caption = 'Event time:'
  end
  object NameEd: TEdit
    Left = 80
    Top = 16
    Width = 289
    Height = 21
    TabOrder = 0
  end
  object OKBtn: TButton
    Left = 80
    Top = 84
    Width = 75
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 232
    Top = 84
    Width = 75
    Height = 21
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object TimeDTP: TDateTimePicker
    Left = 80
    Top = 48
    Width = 145
    Height = 21
    Date = 40072.531526030090000000
    Time = 40072.531526030090000000
    DateFormat = dfLong
    TabOrder = 3
  end
end
