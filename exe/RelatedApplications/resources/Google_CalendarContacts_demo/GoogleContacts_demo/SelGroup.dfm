object SelGroupForm: TSelGroupForm
  Left = 404
  Top = 140
  Width = 331
  Height = 382
  Caption = 'Select a group'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    315
    346)
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 44
    Top = 310
    Width = 75
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 196
    Top = 310
    Width = 75
    Height = 21
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object SelGroupLB: TListBox
    Left = 8
    Top = 8
    Width = 298
    Height = 290
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 2
    OnDblClick = SelGroupLBDblClick
  end
end
