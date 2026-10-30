inherited FExportTimetable: TFExportTimetable
  Left = 300
  Top = 150
  Width = 980
  Height = 600
  Caption = 'Zapisz rozk'#322'ad zaj'#281#263' w Excel'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 550
    Width = 972
  end
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 972
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object LPeriod: TLabel
      Left = 12
      Top = 14
      Width = 33
      Height = 14
      Caption = 'Okres'
      FocusControl = BitBtnPER
    end
    object currentPeriod: TEdit
      Left = 104
      Top = 10
      Width = 68
      Height = 22
      ReadOnly = True
      TabOrder = 0
      Visible = False
      OnChange = currentPeriodChange
    end
    object currentPeriod_VALUE: TEdit
      Left = 104
      Top = 10
      Width = 361
      Height = 22
      ReadOnly = True
      TabOrder = 1
      OnClick = BitBtnPERClick
    end
    object BitBtnPER: TBitBtn
      Left = 468
      Top = 9
      Width = 25
      Height = 24
      Hint = 'Wybierz okres'
      Caption = '...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = BitBtnPERClick
    end
    object WholeDatabase: TCheckBox
      Left = 104
      Top = 44
      Width = 600
      Height = 17
      Hint = 'Wszystkie zaj'#281'cia okresu, bez sprawdzania uprawnie'#324' i w'#322'a'#347'cicieli. Tylko dla administratora'
      Caption = 'Ca'#322'a baza danych (wszystkie zaj'#281'cia okresu, bez sprawdzania uprawnie'#324' i w'#322'a'#347'cicieli)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = WholeDatabaseClick
    end
  end
  object BottomPanel: TPanel
    Left = 0
    Top = 505
    Width = 972
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object BExport: TBitBtn
      Left = 12
      Top = 8
      Width = 120
      Height = 29
      Caption = 'Eksportuj'
      Default = True
      TabOrder = 0
      OnClick = BExportClick
    end
    object BClose: TBitBtn
      Left = 140
      Top = 8
      Width = 120
      Height = 29
      Cancel = True
      Caption = 'Zamknij'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pleft: TPanel
    Left = 0
    Top = 81
    Width = 320
    Height = 424
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
    object plefttop: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 49
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Lecturers: TCheckBox
        Left = 8
        Top = 6
        Width = 300
        Height = 17
        Caption = 'Wyk'#322'adowcy'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = LecturersClick
      end
      object lselector: TCheckBox
        Left = 8
        Top = 27
        Width = 300
        Height = 17
        Caption = 'Zaznacz wszystko'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = selectorClick
      end
    end
    object LList: TCheckListBox
      Left = 0
      Top = 49
      Width = 320
      Height = 375
      Align = alClient
      ItemHeight = 14
      TabOrder = 1
    end
  end
  object Splitter1: TSplitter
    Left = 320
    Top = 81
    Height = 424
  end
  object pright: TPanel
    Left = 652
    Top = 81
    Width = 320
    Height = 424
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
    object prighttop: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 49
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Resources: TCheckBox
        Left = 8
        Top = 6
        Width = 300
        Height = 17
        Caption = 'Zasoby'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = LecturersClick
      end
      object rselector: TCheckBox
        Left = 8
        Top = 27
        Width = 300
        Height = 17
        Caption = 'Zaznacz wszystko'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = selectorClick
      end
    end
    object RList: TCheckListBox
      Left = 0
      Top = 49
      Width = 320
      Height = 375
      Align = alClient
      ItemHeight = 14
      TabOrder = 1
    end
  end
  object Splitter2: TSplitter
    Left = 649
    Top = 81
    Height = 424
    Align = alRight
  end
  object pmiddle: TPanel
    Left = 323
    Top = 81
    Width = 326
    Height = 424
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 5
    object pmiddletop: TPanel
      Left = 0
      Top = 0
      Width = 326
      Height = 49
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Groups: TCheckBox
        Left = 8
        Top = 6
        Width = 300
        Height = 17
        Caption = 'Grupy'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = LecturersClick
      end
      object gselector: TCheckBox
        Left = 8
        Top = 27
        Width = 300
        Height = 17
        Caption = 'Zaznacz wszystko'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = selectorClick
      end
    end
    object GList: TCheckListBox
      Left = 0
      Top = 49
      Width = 326
      Height = 375
      Align = alClient
      ItemHeight = 14
      TabOrder = 1
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'xlsx'
    Filter = 'Plik Excel (*.xlsx)|*.xlsx'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Zapisz rozk'#322'ad zaj'#281#263' w Excel'
    Left = 880
    Top = 16
  end
end
