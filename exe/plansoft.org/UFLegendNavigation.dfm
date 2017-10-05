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
  DesignSize = (
    513
    160)
  PixelsPerInch = 120
  TextHeight = 16
  object dspL: TLabel
    Left = 200
    Top = 8
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
    Left = 200
    Top = 32
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
    Left = 200
    Top = 56
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
    Left = 200
    Top = 80
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
    Left = 200
    Top = 104
    Width = 31
    Height = 16
    Caption = 'dspF'
    ParentShowHint = False
    ShowHint = True
    OnClick = dspLClick
    OnMouseEnter = dspLMouseEnter
    OnMouseLeave = dspLMouseLeave
  end
  object EditL: TSpeedButton
    Left = 8
    Top = 8
    Width = 65
    Height = 22
    Caption = 'Edytuj'
    Flat = True
    OnClick = dspLClick
  end
  object EditG: TSpeedButton
    Left = 8
    Top = 32
    Width = 65
    Height = 22
    Caption = 'Edytuj'
    Flat = True
    OnClick = dspLClick
  end
  object EditR: TSpeedButton
    Left = 8
    Top = 56
    Width = 65
    Height = 22
    Caption = 'Edytuj'
    Flat = True
    OnClick = dspLClick
  end
  object EditS: TSpeedButton
    Left = 8
    Top = 80
    Width = 65
    Height = 22
    Caption = 'Edytuj'
    Flat = True
    OnClick = dspLClick
  end
  object EditF: TSpeedButton
    Left = 8
    Top = 104
    Width = 65
    Height = 22
    Caption = 'Edytuj'
    Flat = True
    OnClick = dspLClick
  end
  object StatL: TSpeedButton
    Left = 80
    Top = 8
    Width = 105
    Height = 22
    Caption = 'Podsumowanie'
    Flat = True
    OnClick = dspLClick
  end
  object StatG: TSpeedButton
    Left = 80
    Top = 32
    Width = 105
    Height = 22
    Caption = 'Podsumowanie'
    Flat = True
    OnClick = dspLClick
  end
  object StatR: TSpeedButton
    Left = 80
    Top = 56
    Width = 105
    Height = 22
    Caption = 'Podsumowanie'
    Flat = True
    OnClick = dspLClick
  end
  object StatS: TSpeedButton
    Left = 80
    Top = 80
    Width = 105
    Height = 22
    Caption = 'Podsumowanie'
    Flat = True
    OnClick = dspLClick
  end
  object StatF: TSpeedButton
    Left = 80
    Top = 104
    Width = 105
    Height = 22
    Caption = 'Podsumowanie'
    Flat = True
    OnClick = dspLClick
  end
  object Bcancel: TBitBtn
    Left = 432
    Top = 128
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Anuluj'
    TabOrder = 0
    OnClick = BcancelClick
  end
end
