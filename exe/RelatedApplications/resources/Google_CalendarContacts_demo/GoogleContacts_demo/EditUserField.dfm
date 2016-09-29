object EditUserFieldFrm: TEditUserFieldFrm
  Left = 360
  Top = 174
  Width = 403
  Height = 154
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
    118)
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
    Width = 30
    Height = 13
    Caption = 'Value:'
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
    Top = 85
    Width = 75
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 232
    Top = 85
    Width = 75
    Height = 21
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object ValueEd: TEdit
    Left = 80
    Top = 48
    Width = 289
    Height = 21
    TabOrder = 1
  end
end
