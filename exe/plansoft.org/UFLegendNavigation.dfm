object FLegendNavigation: TFLegendNavigation
  Left = 621
  Top = 470
  Width = 521
  Height = 175
  VertScrollBar.Style = ssFlat
  Caption = 'Nawigacja'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    513
    144)
  PixelsPerInch = 96
  TextHeight = 13
  object dspL: TLabel
    Left = 163
    Top = 7
    Width = 23
    Height = 13
    Caption = 'dspL'
    ParentShowHint = False
    ShowHint = True
    OnClick = dspLClick
    OnMouseEnter = dspLMouseEnter
    OnMouseLeave = dspLMouseLeave
  end
  object dspG: TLabel
    Left = 163
    Top = 26
    Width = 25
    Height = 13
    Caption = 'dspG'
    ParentShowHint = False
    ShowHint = True
    OnClick = dspLClick
    OnMouseEnter = dspLMouseEnter
    OnMouseLeave = dspLMouseLeave
  end
  object dspR: TLabel
    Left = 163
    Top = 46
    Width = 25
    Height = 13
    Caption = 'dspR'
    ParentShowHint = False
    ShowHint = True
    OnClick = dspLClick
    OnMouseEnter = dspLMouseEnter
    OnMouseLeave = dspLMouseLeave
  end
  object dspS: TLabel
    Left = 163
    Top = 65
    Width = 24
    Height = 13
    Caption = 'dspS'
    ParentShowHint = False
    ShowHint = True
    OnClick = dspLClick
    OnMouseEnter = dspLMouseEnter
    OnMouseLeave = dspLMouseLeave
  end
  object dspF: TLabel
    Left = 163
    Top = 85
    Width = 23
    Height = 13
    Caption = 'dspF'
    ParentShowHint = False
    ShowHint = True
    OnClick = dspLClick
    OnMouseEnter = dspLMouseEnter
    OnMouseLeave = dspLMouseLeave
  end
  object EditL: TSpeedButton
    Left = 7
    Top = 7
    Width = 52
    Height = 17
    Caption = 'Edytuj'
    Flat = True
    OnClick = dspLClick
  end
  object EditG: TSpeedButton
    Left = 7
    Top = 26
    Width = 52
    Height = 18
    Caption = 'Edytuj'
    Flat = True
    OnClick = dspLClick
  end
  object EditR: TSpeedButton
    Left = 7
    Top = 46
    Width = 52
    Height = 17
    Caption = 'Edytuj'
    Flat = True
    OnClick = dspLClick
  end
  object EditS: TSpeedButton
    Left = 7
    Top = 65
    Width = 52
    Height = 18
    Caption = 'Edytuj'
    Flat = True
    OnClick = dspLClick
  end
  object EditF: TSpeedButton
    Left = 7
    Top = 85
    Width = 52
    Height = 17
    Caption = 'Edytuj'
    Flat = True
    OnClick = dspLClick
  end
  object StatL: TSpeedButton
    Left = 65
    Top = 7
    Width = 85
    Height = 17
    Caption = 'Podsumowanie'
    Flat = True
    OnClick = dspLClick
  end
  object StatG: TSpeedButton
    Left = 65
    Top = 26
    Width = 85
    Height = 18
    Caption = 'Podsumowanie'
    Flat = True
    OnClick = dspLClick
  end
  object StatR: TSpeedButton
    Left = 65
    Top = 46
    Width = 85
    Height = 17
    Caption = 'Podsumowanie'
    Flat = True
    OnClick = dspLClick
  end
  object StatS: TSpeedButton
    Left = 65
    Top = 65
    Width = 85
    Height = 18
    Caption = 'Podsumowanie'
    Flat = True
    OnClick = dspLClick
  end
  object StatF: TSpeedButton
    Left = 65
    Top = 85
    Width = 85
    Height = 17
    Caption = 'Podsumowanie'
    Flat = True
    OnClick = dspLClick
  end
  object Bcancel: TBitBtn
    Left = 7
    Top = 114
    Width = 61
    Height = 20
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Anuluj'
    TabOrder = 0
    OnClick = BcancelClick
  end
end
