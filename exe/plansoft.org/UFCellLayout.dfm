object FCellLayout: TFCellLayout
  Left = 681
  Top = 227
  VertScrollBar.Style = ssFlat
  AlphaBlendValue = 250
  BorderStyle = bsNone
  Caption = 'FCellLayout'
  ClientHeight = 294
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 377
    Height = 289
    Pen.Mode = pmMask
    Shape = stRoundRect
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 154
    Height = 40
    Caption = 'Kolorowanie'
    TabOrder = 0
    OnMouseMove = GroupBox2MouseMove
    object selectFill: TSpeedButton
      Left = 123
      Top = 14
      Width = 23
      Height = 22
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
    object CellColor: TComboBox
      Left = 9
      Top = 14
      Width = 112
      Height = 22
      Hint = 'Kolorowanie ze wzgl'#281'du na'
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      ItemIndex = 2
      MaxLength = 255
      TabOrder = 0
      Text = 'Zasoby'
      OnChange = CellColorChange
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
    Left = 167
    Top = 7
    Width = 201
    Height = 250
    Caption = 'Rozmiary'
    TabOrder = 1
    OnMouseMove = GroupBox1MouseMove
    object Image1: TImage
      Left = 142
      Top = 24
      Width = 15
      Height = 116
      Transparent = True
      OnClick = Image1Click
    end
    object BCellReset: TSpeedButton
      Left = 8
      Top = 119
      Width = 65
      Height = 25
      Caption = 'Przywr'#243#263
      Flat = True
      OnClick = BCellResetClick
    end
    object BCellFont: TSpeedButton
      Left = 8
      Top = 144
      Width = 65
      Height = 25
      Caption = 'Czcionka'
      Flat = True
      OnClick = BCellFontClick
    end
    object ForcedCellHeight: TTrackBar
      Left = 160
      Top = 24
      Width = 33
      Height = 121
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
      Left = 8
      Top = 16
      Width = 137
      Height = 17
      Caption = 'Chc'#281' ustali'#263' szeroko'#347#263
      TabOrder = 1
      OnClick = ForceCellWidthClick
    end
    object ForcedCellWidth: TTrackBar
      Left = 1
      Top = 32
      Width = 129
      Height = 33
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
      Left = 144
      Top = 144
      Width = 17
      Height = 17
      TabOrder = 3
      OnClick = ForceCellHeightClick
    end
  end
  object descriptions: TGroupBox
    Left = 10
    Top = 47
    Width = 152
    Height = 210
    Caption = 'Opisy w siatce'
    TabOrder = 2
    OnMouseMove = descriptionsMouseMove
    object D1: TComboBox
      Left = 8
      Top = 15
      Width = 137
      Height = 22
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      ItemIndex = 10
      MaxLength = 255
      TabOrder = 0
      Text = '<dummy>'
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
      Left = 8
      Top = 39
      Width = 137
      Height = 22
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      ItemIndex = 0
      MaxLength = 255
      TabOrder = 1
      Text = '<dummy>'
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
      Left = 8
      Top = 63
      Width = 137
      Height = 22
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      ItemIndex = 2
      MaxLength = 255
      TabOrder = 2
      Text = '<dummy>'
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
      Left = 8
      Top = 87
      Width = 137
      Height = 22
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      ItemIndex = 6
      MaxLength = 255
      TabOrder = 3
      Text = '<dummy>'
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
      Left = 8
      Top = 111
      Width = 137
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
      Left = 7
      Top = 135
      Width = 137
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
      Left = 7
      Top = 159
      Width = 137
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
      Left = 7
      Top = 183
      Width = 137
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
  object HideTheSameDesc: TCheckBox
    Left = 96
    Top = 264
    Width = 193
    Height = 17
    Caption = 'Ukryj takie same opisy'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = HideTheSameDescClick
  end
  object cellTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = cellTimerTimer
    Left = 248
    Top = 72
  end
end
