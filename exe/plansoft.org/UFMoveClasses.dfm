inherited FMoveClasses: TFMoveClasses
  Left = 300
  Top = 150
  Width = 980
  Height = 600
  Caption = 'Przesu'#324' rozk'#322'ad zaj'#281#263
  OnDestroy = FormDestroy
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
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object LDateFrom: TLabel
      Left = 12
      Top = 14
      Width = 50
      Height = 14
      Caption = 'Od dnia'
    end
    object LDateTo: TLabel
      Left = 232
      Top = 14
      Width = 50
      Height = 14
      Caption = 'Do dnia'
    end
    object LNewDateFrom: TLabel
      Left = 12
      Top = 46
      Width = 132
      Height = 14
      Caption = 'Nowa data pocz'#261'tkowa'
    end
    object LShift: TLabel
      Left = 12
      Top = 74
      Width = 940
      Height = 14
      AutoSize = False
      Caption = 'Przesuni'#281'cie'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DateFrom: TDateTimePicker
      Left = 140
      Top = 10
      Width = 89
      Height = 22
      Date = 46330.000000000000000000
      Time = 46330.000000000000000000
      TabOrder = 0
      OnChange = datesChange
    end
    object DateTo: TDateTimePicker
      Left = 290
      Top = 10
      Width = 89
      Height = 22
      Date = 46336.000000000000000000
      Time = 46336.000000000000000000
      TabOrder = 1
      OnChange = datesChange
    end
    object NewDateFrom: TDateTimePicker
      Left = 140
      Top = 42
      Width = 89
      Height = 22
      Date = 46337.000000000000000000
      Time = 46337.000000000000000000
      TabOrder = 2
      OnChange = NewDateFromChange
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
    object BMove: TBitBtn
      Left = 12
      Top = 8
      Width = 120
      Height = 29
      Caption = 'Przesu'#324
      Default = True
      TabOrder = 0
      OnClick = BMoveClick
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
    Top = 97
    Width = 320
    Height = 408
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
    object plefttop: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 78
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object LLecturers: TLabel
        Left = 8
        Top = 6
        Width = 300
        Height = 14
        AutoSize = False
        Caption = 'Wyk'#322'adowcy'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lselector: TCheckBox
        Left = 8
        Top = 56
        Width = 300
        Height = 17
        Caption = 'Zaznacz wszystko'
        TabOrder = 0
      end
      object lfind: TLabel
        Left = 8
        Top = 32
        Width = 72
        Height = 14
        Caption = 'Dowolna fraza'
      end
      object lSearch: TEdit
        Left = 88
        Top = 28
        Width = 224
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        Hint = 'Fragment nazwy, skr'#243'tu, opisu lub atrybutu - jak w oknie przegl'#261'dania. Kilka fraz oddziel przecinkiem'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
    end
    object LList: TCheckListBox
      Left = 0
      Top = 78
      Width = 320
      Height = 330
      Align = alClient
      ItemHeight = 14
      TabOrder = 1
    end
  end
  object Splitter1: TSplitter
    Left = 320
    Top = 97
    Height = 408
  end
  object pright: TPanel
    Left = 652
    Top = 97
    Width = 320
    Height = 408
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
    object prighttop: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 78
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object LResources: TLabel
        Left = 8
        Top = 6
        Width = 300
        Height = 14
        AutoSize = False
        Caption = 'Sale'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object rselector: TCheckBox
        Left = 8
        Top = 56
        Width = 300
        Height = 17
        Caption = 'Zaznacz wszystko'
        TabOrder = 0
      end
      object rfind: TLabel
        Left = 8
        Top = 32
        Width = 72
        Height = 14
        Caption = 'Dowolna fraza'
      end
      object rSearch: TEdit
        Left = 88
        Top = 28
        Width = 224
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        Hint = 'Fragment nazwy, skr'#243'tu, opisu lub atrybutu - jak w oknie przegl'#261'dania. Kilka fraz oddziel przecinkiem'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
    end
    object RList: TCheckListBox
      Left = 0
      Top = 78
      Width = 320
      Height = 330
      Align = alClient
      ItemHeight = 14
      TabOrder = 1
    end
  end
  object Splitter2: TSplitter
    Left = 649
    Top = 97
    Height = 408
    Align = alRight
  end
  object pmiddle: TPanel
    Left = 323
    Top = 97
    Width = 326
    Height = 408
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 5
    object pmiddletop: TPanel
      Left = 0
      Top = 0
      Width = 326
      Height = 78
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object LGroups: TLabel
        Left = 8
        Top = 6
        Width = 300
        Height = 14
        AutoSize = False
        Caption = 'Grupy'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gselector: TCheckBox
        Left = 8
        Top = 56
        Width = 300
        Height = 17
        Caption = 'Zaznacz wszystko'
        TabOrder = 0
      end
      object gfind: TLabel
        Left = 8
        Top = 32
        Width = 72
        Height = 14
        Caption = 'Dowolna fraza'
      end
      object gSearch: TEdit
        Left = 88
        Top = 28
        Width = 230
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        Hint = 'Fragment nazwy, skr'#243'tu, opisu lub atrybutu - jak w oknie przegl'#261'dania. Kilka fraz oddziel przecinkiem'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
    end
    object GList: TCheckListBox
      Left = 0
      Top = 78
      Width = 326
      Height = 330
      Align = alClient
      ItemHeight = 14
      TabOrder = 1
    end
  end
end
