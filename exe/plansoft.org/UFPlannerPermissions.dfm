inherited FPlannerPermissions: TFPlannerPermissions
  Left = 234
  Top = 117
  Width = 1214
  Height = 665
  Caption = 'Uprawnienia do obiekt'#243'w'
  KeyPreview = True
  WindowState = wsMaximized
  PixelsPerInch = 120
  TextHeight = 16
  object Label7: TLabel [0]
    Left = 238
    Top = 64
    Width = 624
    Height = 64
    Caption = 
      'Naci'#347'nij przycisk Od'#347'wie'#380', aby od'#347'wie'#380'y'#263' zawarto'#347#263' okna.'#13#10#13#10'Zani' +
      'm naci'#347'niesz przycisk Od'#347'wie'#380', w panelu Znajd'#378' mo'#380'esz wpisa'#263' naz' +
      'wy poszukiwanych obiekt'#243'w.'#13#10'Skr'#243'ci to znacznie czas od'#347'wie'#380'ania ' +
      'zawarto'#347'ci okna.'
  end
  object Label8: TLabel [1]
    Left = 238
    Top = 146
    Width = 748
    Height = 16
    Caption = 
      'Mo'#380'esz te'#380' zaznaczy'#263' pole wyboru Od'#347'wie'#380' automatycznie, w'#243'wczas ' +
      'zawarto'#347#263' okna b'#281'dzie od'#347'wie'#380'ana automatycznie.'
  end
  inherited Status: TPanel
    Top = 606
    Width = 1206
  end
  object Panel1: TPanel
    Left = 0
    Top = 559
    Width = 1206
    Height = 47
    Align = alBottom
    TabOrder = 1
    object DeleteClass: TSpeedButton
      Left = 46
      Top = 9
      Width = 32
      Height = 32
      Hint = 'Usu'#324
      AllowAllUp = True
      Flat = True
      Glyph.Data = {
        3A030000424D3A03000000000000420000002800000013000000130000000100
        100003000000F802000000000000000000000000000000000000007C0000E003
        00001F0000001863186318631863186318631863186318631863186318631863
        1863186318631863186318630000186318631863186318631863186318631863
        1863186318631863186318631863186318631863000018631863186318631863
        0000000000000000000000000000000000000000000000001863186300001863
        1863186318631863FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0000
        18631863000018631863186318631863FF7FFF7F00000000FF7F000000000000
        0000FF7FFF7F000018631863000018631863186318631863FF7FFF7FFF7FFF7F
        FF7FFF7FFF7FFF7FFF7FFF7FFF7F000018631863000018631863186318631863
        FF7FFF7FFF7FFF7F00000000FF7F000000000000FF7F00001863186300001863
        1863186318631863FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0000
        18631863000018631863186318631863FF7FFF7FFF7FFF7F00000000FF7F0000
        00000000FF7F000018631863000018631863186318631863FF7FFF7FFF7FFF7F
        FF7FFF7FFF7FFF7FFF7FFF7FFF7F000018631863000018631863186318631863
        FF7FFF7F00000000FF7F0000000000000000FF7FFF7F00001863186300001863
        007C004000401863FF7FFF7F007C00400040FF7FFF7FFF7FFF7FFF7FFF7F0000
        18631863000018631863007C00400040FF7F007C00400040FF7FFF7FFF7FFF7F
        0000000000000000186318630000186318631863007C0040007C00400040FF7F
        FF7FFF7FFF7FFF7F0000FF7F000018631863186300001863186318631863007C
        00400040FF7FFF7FFF7FFF7FFF7FFF7F00000000186318631863186300001863
        186318630040007C007C00400040FF7FFF7FFF7FFF7FFF7F0000186318631863
        186318630000186318630040007C007C1863007C004000401863186318631863
        18631863186318631863186300001863007C007C007C186318631863007C0040
        0040186318631863186318631863186318631863000018631863186318631863
        186318631863186318631863186318631863186318631863186318630000}
      ParentShowHint = False
      ShowHint = True
      OnClick = DeleteClassClick
    end
    object AddClass: TSpeedButton
      Left = 9
      Top = 9
      Width = 32
      Height = 32
      Hint = 'Dodaj'
      AllowAllUp = True
      Flat = True
      Glyph.Data = {
        36040000424D3604000000000000420000002800000015000000170000000100
        100003000000F403000000000000000000000000000000000000007C0000E003
        00001F0000001863186318631863186318631863186318631863186318631863
        1863186318631863186318631863186300001863186318631863186318631863
        1863186318631863186318631863186318631863186318631863186300001863
        1863186318631863186318631863186318631863186318631863186318631863
        1863186318631863000018631863186318631863186318631863186318631863
        1863186318631863186318631863186318631863000018631863186318631863
        1863000000000000000000000000000000000000000000000000186318631863
        0000186318631863186318631863FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
        FF7FFF7F00001863186318630000186318631863186318631863FF7FFF7F0000
        0000FF7F0000000000000000FF7FFF7F00001863186318630000186318631863
        186318631863FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F00001863
        186318630000186318631863186318631863FF7FFF7FFF7FFF7F00000000FF7F
        000000000000FF7F00001863186318630000186318631863186318631863FF7F
        FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F000018631863186300001863
        18631863186318631863FF7FFF7FFF7FFF7F00000000FF7F000000000000FF7F
        0000186318631863000018631863186318631863E00310421042FF7FFF7FFF7F
        FF7FFF7FFF7FFF7FFF7FFF7F0000186318631863000018631863186318631863
        E0030002104200000000FF7F0000000000000000FF7FFF7F0000186318631863
        000018631863186318631863E00300021042FF7FFF7FFF7FFF7FFF7FFF7FFF7F
        FF7FFF7F0000186318631863000018631863000210421042E003000210421042
        10421042FF7FFF7FFF7F0000000000000000186318631863000018631863E003
        00020002000200020002000200020002FF7FFF7FFF7F0000FF7F000018631863
        18631863000018631863E003E003E003E00300020002E003E003E003FF7FFF7F
        FF7F0000000018631863186318631863000018631863186318631863E0030002
        1042FF7FFF7FFF7FFF7FFF7FFF7F000018631863186318631863186300001863
        1863186318631863E00300021042186318631863186318631863186318631863
        1863186318631863000018631863186318631863E003E003E003186318631863
        1863186318631863186318631863186318631863000018631863186318631863
        1863186318631863186318631863186318631863186318631863186318631863
        0000186318631863186318631863186318631863186318631863186318631863
        1863186318631863186318630000186318631863186318631863186318631863
        1863186318631863186318631863186318631863186318630000}
      ParentShowHint = False
      ShowHint = True
      OnClick = AddClassClick
    end
    object invertClass: TSpeedButton
      Left = 81
      Top = 9
      Width = 32
      Height = 32
      Hint = 'Zmie'#324' na przeciwne'
      AllowAllUp = True
      Flat = True
      Glyph.Data = {
        66030000424D6603000000000000360000002800000010000000110000000100
        18000000000030030000CE0E0000D80E00000000000000000000C0C0C0C0C0C0
        C0C0C00040800040807F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
        7FC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000408000408000408000408000
        40800040800040800040800040800040807F7F7FC0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0004080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0040
        807F7F7FC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0004080FFFFFF00000000000000
        0000000000000000000000FFFFFF0040807F7F7FC0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0004080FFFFFF0000000000FF0000FF0000FF0000FF000000FFFFFF0040
        807F7F7FC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0004080FFFFFF00000000000000
        0000000000000000000000FFFFFF0040807F7F7FC0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0004080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0040
        807F7F7FC0C0C0C0C0C0C0C0C0C0C0C0C0C0C000408000408000408000408000
        40800040800040800040800040800040807F7F7FC0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0004080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00040
        807F7F7FC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0004080C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C00000007F7F7F7F7F7FC0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000007F7F
        7F7F7F7FC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C00040807F7F7F7F7F7F7F7F7FC0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C00040800040800040800040800040800040800040800040807F7F7F7F7F
        7F7F7F7FC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C00040807F7F7F7F7F7F7F7F7FC0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0004080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000007F7F
        7F7F7F7FC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0004080004080C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C00040807F7F7FC0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C00040800040800040800040800040800040800040800040800040800040
        80004080C0C0C0C0C0C0}
      ParentShowHint = False
      ShowHint = True
      OnClick = invertClassClick
    end
    object BOK: TBitBtn
      Left = 118
      Top = 9
      Width = 85
      Height = 29
      Cancel = True
      Caption = 'Zamknij'
      ModalResult = 1
      TabOrder = 0
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object MarkSymbol: TRadioGroup
      Left = 208
      Top = 2
      Width = 168
      Height = 38
      Caption = 'Symbol zaznaczania'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Subtelny'
        'Wyra'#378'ny')
      TabOrder = 1
      OnClick = MarkSymbolClick
    end
    object DescLen: TRadioGroup
      Left = 376
      Top = 2
      Width = 155
      Height = 38
      Caption = 'D'#322'ugo'#347#263' opis'#243'w'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Kr'#243'tkie'
        'D'#322'ugie')
      TabOrder = 2
      OnClick = DescLenClick
    end
    object btransfer: TBitBtn
      Left = 539
      Top = 9
      Width = 130
      Height = 29
      Caption = 'Transfer uprawnie'#324
      TabOrder = 3
      OnClick = btransferClick
    end
  end
  object mainPage: TPageControl
    Left = 0
    Top = 0
    Width = 1008
    Height = 559
    ActivePage = TabSheetL
    Align = alClient
    TabOrder = 2
    Visible = False
    object TabSheetL: TTabSheet
      Caption = 'Wyk'#322'adowcy'
      object LGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 1000
        Height = 528
        Align = alClient
        DefaultColWidth = 20
        DefaultRowHeight = 20
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goThumbTracking]
        PopupMenu = PopupMenu
        TabOrder = 0
        OnDblClick = LGridDblClick
        OnDrawCell = LGridDrawCell
        OnKeyDown = LGridKeyDown
      end
    end
    object TabSheetG: TTabSheet
      Caption = 'Grupy'
      ImageIndex = 1
      object GGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 991
        Height = 622
        Align = alClient
        DefaultColWidth = 20
        DefaultRowHeight = 20
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
        PopupMenu = PopupMenu
        TabOrder = 0
        OnDblClick = LGridDblClick
        OnDrawCell = LGridDrawCell
        OnKeyDown = LGridKeyDown
      end
    end
    object TabSheetR: TTabSheet
      Caption = 'Zasoby'
      ImageIndex = 2
      object RGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 991
        Height = 622
        Align = alClient
        DefaultColWidth = 20
        DefaultRowHeight = 20
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
        PopupMenu = PopupMenu
        TabOrder = 0
        OnDblClick = LGridDblClick
        OnDrawCell = LGridDrawCell
        OnKeyDown = LGridKeyDown
      end
    end
    object TabSheetSub: TTabSheet
      Caption = 'Przedmioty'
      ImageIndex = 3
      object SUBGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 991
        Height = 622
        Align = alClient
        DefaultColWidth = 20
        DefaultRowHeight = 20
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
        PopupMenu = PopupMenu
        TabOrder = 0
        OnDblClick = LGridDblClick
        OnDrawCell = LGridDrawCell
        OnKeyDown = LGridKeyDown
      end
    end
    object TabSheetFor: TTabSheet
      Caption = 'Formy zaj'#281#263
      ImageIndex = 4
      object FORGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 991
        Height = 622
        Align = alClient
        DefaultColWidth = 20
        DefaultRowHeight = 20
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
        PopupMenu = PopupMenu
        TabOrder = 0
        OnDblClick = LGridDblClick
        OnDrawCell = LGridDrawCell
        OnKeyDown = LGridKeyDown
      end
    end
    object TabSheetROL: TTabSheet
      Caption = 'Autoryzacje'
      ImageIndex = 5
      object ROLGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 991
        Height = 619
        Align = alClient
        DefaultColWidth = 20
        DefaultRowHeight = 20
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
        PopupMenu = PopupMenu
        TabOrder = 0
        OnDblClick = LGridDblClick
        OnDrawCell = LGridDrawCell
        OnKeyDown = LGridKeyDown
      end
    end
  end
  object Panel2: TPanel
    Left = 1008
    Top = 0
    Width = 198
    Height = 559
    Align = alRight
    TabOrder = 3
    object FindPane: TGroupBox
      Left = 1
      Top = 1
      Width = 196
      Height = 557
      Align = alClient
      Caption = 'Znajd'#378
      Enabled = False
      TabOrder = 0
      object Szukaj: TLabel
        Left = 16
        Top = 64
        Width = 93
        Height = 16
        Caption = 'Szukaj planisty'
      end
      object Label1: TLabel
        Left = 14
        Top = 18
        Width = 90
        Height = 16
        Caption = 'Szukaj zasobu'
      end
      object Psearch: TEdit
        Left = 11
        Top = 82
        Width = 164
        Height = 24
        TabOrder = 1
        OnChange = PsearchChange
        OnKeyDown = RowSearchKeyDown
      end
      object RowSearch: TEdit
        Left = 11
        Top = 37
        Width = 164
        Height = 24
        TabOrder = 0
        OnChange = PsearchChange
        OnKeyDown = RowSearchKeyDown
      end
      object chRefresh: TCheckBox
        Left = 9
        Top = 119
        Width = 184
        Height = 19
        Caption = 'Od'#347'wie'#380'aj automatycznie'
        TabOrder = 2
        OnClick = chRefreshClick
      end
      object brefresh: TBitBtn
        Left = 9
        Top = 146
        Width = 86
        Height = 29
        Caption = 'Od'#347'wie'#380
        TabOrder = 3
        Visible = False
        OnClick = brefreshClick
      end
    end
  end
  object Brefresh2: TBitBtn
    Left = 485
    Top = 192
    Width = 165
    Height = 56
    Caption = 'Od'#347'wie'#380
    TabOrder = 4
    OnClick = brefreshClick
  end
  object PopupMenu: TPopupMenu
    Left = 300
    Top = 225
    object Zmie1: TMenuItem
      Caption = 'Zmie'#324
      OnClick = AddClassClick
    end
    object Dugieopisy1: TMenuItem
      Caption = 'D'#322'ugie opisy'
      OnClick = Dugieopisy1Click
    end
    object Krtkieopisy1: TMenuItem
      Caption = 'Kr'#243'tkie opisy'
      OnClick = Krtkieopisy1Click
    end
  end
end
