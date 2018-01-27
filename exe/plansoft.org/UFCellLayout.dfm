object FCellLayout: TFCellLayout
  Left = 681
  Top = 227
  VertScrollBar.Style = ssFlat
  AlphaBlendValue = 250
  BorderStyle = bsNone
  Caption = 'FCellLayout'
  ClientHeight = 340
  ClientWidth = 476
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 464
    Height = 336
    Pen.Mode = pmMask
    Shape = stRoundRect
  end
  object GroupBox2: TGroupBox
    Left = 10
    Top = 10
    Width = 189
    Height = 49
    Caption = 'Kolorowanie'
    TabOrder = 0
    OnMouseMove = GroupBox2MouseMove
    object selectFill: TSpeedButton
      Left = 151
      Top = 17
      Width = 29
      Height = 27
      Flat = True
      Glyph.Data = {
        46050000424D4605000000000000360000002800000012000000120000000100
        2000000000001005000000000000000000000000000000000000FAFAFA00FAFA
        FA00FAFAFA00FAFAFA00FAFAFA00FAFAFA00FAFAFA00FAFAFA00FAFAFA00FAFA
        FA00FAFAFA00FAFAFA00FAFAFA00FAFAFA00FAFAFA00FAFAFA00FAFAFA00FAFA
        FA00FAFAFA000000FF000000FF000000FF000000FF000000FF000000FF000000
        FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
        FF000000FF00FAFAFA00FAFAFB000000FF000000FF000000FF000000FF000000
        FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
        FF000000FF000000FF000000FF00FAFAFB00FBFBFB000000FF000000FF000000
        FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
        FF000000FF000000FF000000FF000000FF000000FF00FBFBFB00FBFBFB000000
        FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
        FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00FBFB
        FB00FBFBFB00FBFBFB00FBFBFB00FBFBFB00FBFBFB00FBFBFB00E2DCD9008050
        3000D0A8900060483000DFD9D600FBFBFB00FBFBFB00FBFBFB00C69E8700E3D1
        C700FBFBFB00FBFBFB00FBFBFC00FBFBFC00FBFBFC00FBFBFC00FBFBFC00E2DC
        DA0090584000D0B8A000E0B8A000D0A8900060483000DFD9D700FBFBFC00FBFB
        FC00A0583000C1947B00FBFBFC00FBFBFC00FBFCFC00FBFCFC00FBFCFC00FBFC
        FC00E2DFDA0090584000E0D8D000F0F0F000F0D0C000E0B8A000D0A890006048
        3000DFDAD700FBFCFC00B0604000A0583000E8DCD400FBFCFC00FCFCFC00FCFC
        FC00FCFCFC00E3E1DE0090584000E0D8D000FFF8FF00FFFFFF00F0F0F000F0D0
        C000E0B8A000D0A8900060483000E0DAD700D0704000A0583000B6806200FCFC
        FC00FCFCFC00FCFCFC00FCFCFC00A0705000FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00F0F0F000F0D0C000E0B8A000D0A8900060483000C3775900C070
        4000A0583000FCFCFC00FCFCFC00FCFCFC00FCFCFC00E8E3DE00A0786000FFFF
        FF00FFFFFF00FFFFFF00D0D0D000A0908000C0A09000F0D0C000E0B8A000D0A8
        900060483000C0704000B9725600FCFCFC00FCFCFD00FCFCFD00FCFCFD00FCFC
        FD00E8E3DE00B0807000FFFFFF00FFFFFF00B0A0900070605000A0908000F0F0
        F000F0D0C00070504000F0906000C3774A00E3CDC000FCFCFD00FCFDFD00FCFD
        FD00FCFDFD00FCFDFD00FCFDFD00E8E3DE00B0907000FFFFFF00D0D0D0008060
        5000D0C8C000FFFFFF0080605000D0987000E0907000F5CCB700FCFDFD00FCFD
        FD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD0090786000C098
        8000FFFFFF0080685000E0D8D00090706000ECE4E000FDFDFD00FDFDFD00FDFD
        FD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFD
        FD0090786000ECE6E000C0A0900080686000B0807000F0ECE700FDFDFD00FDFD
        FD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFD
        FD00FDFDFD00FDFDFD00A0807000EAE4E100F0ECEA0090706000FDFDFD00FDFD
        FD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFD
        FD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00E4DCD800A080700090786000E4DC
        D800FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFD
        FD00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
        FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
        FE00FEFEFE00FEFEFE00}
      OnClick = selectFillClick
    end
    object Coloring: TComboBox
      Tag = 67108864
      Left = 11
      Top = 17
      Width = 138
      Height = 22
      Hint = 'Kolorowanie ze wzgl'#281'du na'
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      ItemIndex = 0
      MaxLength = 255
      TabOrder = 0
      Text = 'Wyk'#322'adowcy'
      OnChange = ColoringChange
      Items.Strings = (
        'Wyk'#322'adowcy'
        'Grupy'
        'Zasoby'
        'Przedmioty'
        'Formy'
        'W'#322'a'#347'ciciel'
        'Utworzy'#322
        'Zaj'#281'cia'
        'Brak')
    end
  end
  object GroupBox1: TGroupBox
    Left = 206
    Top = 9
    Width = 247
    Height = 307
    Caption = 'Rozmiary'
    TabOrder = 1
    OnMouseMove = GroupBox1MouseMove
    object Image1: TImage
      Left = 175
      Top = 30
      Width = 18
      Height = 142
      Transparent = True
      OnClick = Image1Click
    end
    object BCellReset: TSpeedButton
      Left = 10
      Top = 146
      Width = 80
      Height = 31
      Caption = 'Przywr'#243#263
      Flat = True
      OnClick = BCellResetClick
    end
    object BCellFont: TSpeedButton
      Left = 10
      Top = 177
      Width = 80
      Height = 31
      Caption = 'Czcionka'
      Flat = True
      OnClick = BCellFontClick
    end
    object ForcedCellHeight: TTrackBar
      Left = 197
      Top = 30
      Width = 41
      Height = 148
      Ctl3D = True
      LineSize = 0
      Max = 100
      Min = 5
      Orientation = trVertical
      ParentCtl3D = False
      ParentShowHint = False
      PageSize = 1
      Position = 5
      ShowHint = True
      TabOrder = 0
      TickStyle = tsManual
      OnChange = ForcedCellHeightChange
    end
    object ForceCellWidth: TCheckBox
      Left = 10
      Top = 20
      Width = 168
      Height = 21
      Caption = 'Chc'#281' ustali'#263' szeroko'#347#263
      TabOrder = 1
      OnClick = ForceCellWidthClick
    end
    object ForcedCellWidth: TTrackBar
      Left = 1
      Top = 39
      Width = 159
      Height = 41
      Ctl3D = True
      LineSize = 0
      Max = 200
      Min = 5
      ParentCtl3D = False
      ParentShowHint = False
      PageSize = 1
      Position = 5
      ShowHint = True
      TabOrder = 2
      TickStyle = tsManual
      OnChange = ForcedCellWidthChange
    end
    object ForceCellHeight: TCheckBox
      Left = 177
      Top = 177
      Width = 21
      Height = 21
      TabOrder = 3
      OnClick = ForceCellHeightClick
    end
  end
  object descriptions: TGroupBox
    Left = 12
    Top = 58
    Width = 187
    Height = 258
    Caption = 'Opisy w siatce'
    TabOrder = 2
    OnMouseMove = descriptionsMouseMove
    object D1: TComboBox
      Tag = 67108864
      Left = 10
      Top = 18
      Width = 168
      Height = 22
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      MaxLength = 255
      TabOrder = 0
      OnChange = D1Change
      Items.Strings = (
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>')
    end
    object D2: TComboBox
      Tag = 67108864
      Left = 10
      Top = 48
      Width = 168
      Height = 22
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      MaxLength = 255
      TabOrder = 1
      OnChange = D1Change
      Items.Strings = (
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>')
    end
    object D3: TComboBox
      Tag = 67108864
      Left = 10
      Top = 78
      Width = 168
      Height = 22
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      MaxLength = 255
      TabOrder = 2
      OnChange = D1Change
      Items.Strings = (
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>')
    end
    object D4: TComboBox
      Tag = 67108864
      Left = 10
      Top = 107
      Width = 168
      Height = 22
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      MaxLength = 255
      TabOrder = 3
      OnChange = D1Change
      Items.Strings = (
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>')
    end
    object D5: TComboBox
      Tag = 67108864
      Left = 10
      Top = 137
      Width = 168
      Height = 22
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      MaxLength = 255
      TabOrder = 4
      OnChange = D1Change
      Items.Strings = (
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>')
    end
    object D6: TComboBox
      Tag = 67108864
      Left = 9
      Top = 166
      Width = 168
      Height = 22
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      MaxLength = 255
      TabOrder = 5
      OnChange = D1Change
      Items.Strings = (
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>')
    end
    object D7: TComboBox
      Tag = 67108864
      Left = 9
      Top = 196
      Width = 168
      Height = 22
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      MaxLength = 255
      TabOrder = 6
      OnChange = D1Change
      Items.Strings = (
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>')
    end
    object D8: TComboBox
      Tag = 67108864
      Left = 9
      Top = 225
      Width = 168
      Height = 22
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      MaxLength = 255
      TabOrder = 7
      OnChange = D1Change
      Items.Strings = (
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>'
        '<dummy>')
    end
  end
  object cellTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = cellTimerTimer
    Left = 248
    Top = 72
  end
end
