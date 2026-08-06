object FLegendNavigation: TFLegendNavigation
  Left = 621
  Top = 300
  Width = 560
  Height = 620
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
  PixelsPerInch = 96
  TextHeight = 13
  object LabelL: TLabel
    Left = 8
    Top = 8
    Width = 57
    Height = 13
    Caption = 'Wyk'#322'adowca'
  end
  object LabelG: TLabel
    Left = 8
    Top = 124
    Width = 32
    Height = 13
    Caption = 'Grupa'
  end
  object LabelR: TLabel
    Left = 8
    Top = 240
    Width = 20
    Height = 13
    Caption = 'Sala'
  end
  object LabelS: TLabel
    Left = 8
    Top = 356
    Width = 48
    Height = 13
    Caption = 'Przedmiot'
  end
  object LabelF: TLabel
    Left = 8
    Top = 472
    Width = 29
    Height = 13
    Caption = 'Forma'
  end
  object ListL: TListBox
    Left = 8
    Top = 26
    Width = 250
    Height = 92
    Style = lbOwnerDrawFixed
    ItemHeight = 28
    OnDrawItem = ListDrawItem
    TabOrder = 0
    OnDblClick = ListDblClick
  end
  object ListG: TListBox
    Left = 8
    Top = 142
    Width = 250
    Height = 92
    Style = lbOwnerDrawFixed
    ItemHeight = 28
    OnDrawItem = ListDrawItem
    TabOrder = 1
    OnDblClick = ListDblClick
  end
  object ListR: TListBox
    Left = 8
    Top = 258
    Width = 250
    Height = 92
    Style = lbOwnerDrawFixed
    ItemHeight = 28
    OnDrawItem = ListDrawItem
    TabOrder = 2
    OnDblClick = ListDblClick
  end
  object ListS: TListBox
    Left = 8
    Top = 374
    Width = 250
    Height = 92
    Style = lbOwnerDrawFixed
    ItemHeight = 28
    OnDrawItem = ListDrawItem
    TabOrder = 3
    OnDblClick = ListDblClick
  end
  object ListF: TListBox
    Left = 8
    Top = 490
    Width = 250
    Height = 92
    Style = lbOwnerDrawFixed
    ItemHeight = 28
    OnDrawItem = ListDrawItem
    TabOrder = 4
    OnDblClick = ListDblClick
  end
  object PanelRowL: TPanel
    Left = 264
    Top = 26
    Width = 270
    Height = 92
    BevelOuter = bvNone
    TabOrder = 5
  end
  object PanelRowG: TPanel
    Left = 264
    Top = 142
    Width = 270
    Height = 92
    BevelOuter = bvNone
    TabOrder = 6
  end
  object PanelRowR: TPanel
    Left = 264
    Top = 258
    Width = 270
    Height = 92
    BevelOuter = bvNone
    TabOrder = 7
  end
  object PanelRowS: TPanel
    Left = 264
    Top = 374
    Width = 270
    Height = 92
    BevelOuter = bvNone
    TabOrder = 8
  end
  object PanelRowF: TPanel
    Left = 264
    Top = 490
    Width = 270
    Height = 92
    BevelOuter = bvNone
    TabOrder = 9
  end
  object Bcancel: TBitBtn
    Left = 8
    Top = 588
    Width = 61
    Height = 20
    Cancel = True
    Caption = 'Anuluj'
    TabOrder = 10
    OnClick = BcancelClick
  end
end