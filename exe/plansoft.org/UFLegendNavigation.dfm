object FLegendNavigation: TFLegendNavigation
  Left = 621
  Top = 470
  Width = 521
  Height = 197
  VertScrollBar.Style = ssFlat
  Caption = 'Nawigacja'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object dspL: TLabel
    Left = 16
    Top = 16
    Width = 30
    Height = 16
    Caption = 'dspL'
    ParentShowHint = False
    ShowHint = True
    OnClick = dspLClick
    OnMouseEnter = dspLMouseEnter
    OnMouseLeave = dspLMouseLeave
  end
  object dspG: TLabel
    Left = 16
    Top = 40
    Width = 33
    Height = 16
    Caption = 'dspG'
    ParentShowHint = False
    ShowHint = True
    OnClick = dspLClick
    OnMouseEnter = dspLMouseEnter
    OnMouseLeave = dspLMouseLeave
  end
  object dspR: TLabel
    Left = 16
    Top = 64
    Width = 33
    Height = 16
    Caption = 'dspR'
    ParentShowHint = False
    ShowHint = True
    OnClick = dspLClick
    OnMouseEnter = dspLMouseEnter
    OnMouseLeave = dspLMouseLeave
  end
  object dspS: TLabel
    Left = 16
    Top = 88
    Width = 32
    Height = 16
    Caption = 'dspS'
    ParentShowHint = False
    ShowHint = True
    OnClick = dspLClick
    OnMouseEnter = dspLMouseEnter
    OnMouseLeave = dspLMouseLeave
  end
  object dspF: TLabel
    Left = 16
    Top = 112
    Width = 31
    Height = 16
    Caption = 'dspF'
    ParentShowHint = False
    ShowHint = True
    OnClick = dspLClick
    OnMouseEnter = dspLMouseEnter
    OnMouseLeave = dspLMouseLeave
  end
  object Bcancel: TBitBtn
    Left = 432
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Anuluj'
    TabOrder = 0
    OnClick = BcancelClick
  end
end
