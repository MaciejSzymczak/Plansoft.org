inherited FAbolitionTime: TFAbolitionTime
  Left = 369
  Top = 354
  Width = 648
  Height = 245
  Caption = 'Rejestracja us'#322'ugi serwisowej'
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel [0]
    Left = 18
    Top = 48
    Width = 586
    Height = 28
    Caption = 
      'Je'#380'eli wykupili Pa'#324'stwo us'#322'ug'#281' serwisow'#261', w'#243'wczas w polu poni'#380'ej' +
      ' nale'#380'y wpisa'#263' kod otrzymany od dostawcy. '#13#10'Wpisanie kodu spowod' +
      'uje, '#380'e do ko'#324'ca trwania umowy serwisowej b'#281'dzie mo'#380'na korzysta'#263 +
      ' ze wszystkich rozszerze'#324
  end
  object Label4: TLabel [1]
    Left = 18
    Top = 76
    Width = 402
    Height = 28
    Caption = 
      'jakie powstan'#261' w okresie trwania umowy serwisowej.'#13#10'Wpisanie kod' +
      'u na dowolnej stacji roboczej ma wp'#322'yw na pozosta'#322'e stacje roboc' +
      'ze.'
  end
  inherited Status: TPanel
    Top = 192
    Width = 640
  end
  object Panel1: TPanel
    Left = 0
    Top = 151
    Width = 640
    Height = 41
    Align = alBottom
    TabOrder = 1
    object BClose: TBitBtn
      Left = 560
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Zamknij'
      Default = True
      TabOrder = 0
      OnClick = BCloseClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 33
    Align = alTop
    TabOrder = 2
    object Label3: TLabel
      Left = 72
      Top = 9
      Width = 322
      Height = 14
      Caption = 'Obecnie mo'#380'esz korzysta'#263' z rozszerze'#324', kt'#243're powsta'#322'y do dnia: '
    end
    object abolitionTime: TEdit
      Left = 396
      Top = 6
      Width = 128
      Height = 22
      Color = clBtnFace
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = 'abolitionTime'
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 112
    Width = 640
    Height = 39
    Align = alBottom
    TabOrder = 3
    object Label2: TLabel
      Left = 26
      Top = 15
      Width = 231
      Height = 14
      Caption = 'Kod otrzymany od dostawcy oprogramowania: '
    end
    object code: TEdit
      Left = 258
      Top = 7
      Width = 265
      Height = 22
      TabOrder = 0
    end
    object BApply: TBitBtn
      Left = 523
      Top = 7
      Width = 75
      Height = 25
      Caption = 'Zatwierd'#378
      TabOrder = 1
      OnClick = BApplyClick
    end
  end
end
