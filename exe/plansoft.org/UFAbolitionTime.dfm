inherited FAbolitionTime: TFAbolitionTime
  Left = 369
  Top = 354
  Width = 768
  Height = 296
  Caption = 'Rejestracja us'#322'ugi serwisowej'
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel [0]
    Left = 21
    Top = 55
    Width = 726
    Height = 32
    Caption = 
      'Je'#380'eli wykupili Pa'#324'stwo us'#322'ug'#281' serwisow'#261', w'#243'wczas w polu poni'#380'ej' +
      ' nale'#380'y wpisa'#263' kod otrzymany od dostawcy. '#13#10'Wpisanie kodu spowod' +
      'uje, '#380'e do ko'#324'ca trwania umowy serwisowej b'#281'dzie mo'#380'na korzysta'#263 +
      ' ze wszystkich rozszerze'#324
  end
  object Label4: TLabel [1]
    Left = 21
    Top = 87
    Width = 511
    Height = 32
    Caption = 
      'jakie powstan'#261' w okresie trwania umowy serwisowej.'#13#10'Wpisanie kod' +
      'u na dowolnej stacji roboczej ma wp'#322'yw na pozosta'#322'e stacje roboc' +
      'ze.'
  end
  inherited Status: TPanel
    Top = 237
    Width = 760
  end
  object Panel1: TPanel
    Left = 0
    Top = 191
    Width = 760
    Height = 46
    Align = alBottom
    TabOrder = 1
    object BClose: TBitBtn
      Left = 640
      Top = 9
      Width = 86
      Height = 29
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
    Width = 760
    Height = 38
    Align = alTop
    TabOrder = 2
    object Label3: TLabel
      Left = 82
      Top = 10
      Width = 404
      Height = 16
      Caption = 'Obecnie mo'#380'esz korzysta'#263' z rozszerze'#324', kt'#243're powsta'#322'y do dnia: '
    end
    object abolitionTime: TEdit
      Left = 453
      Top = 7
      Width = 146
      Height = 22
      Color = clBtnFace
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clRed
      Font.Height = -13
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
    Top = 146
    Width = 760
    Height = 45
    Align = alBottom
    TabOrder = 3
    object Label2: TLabel
      Left = 30
      Top = 17
      Width = 292
      Height = 16
      Caption = 'Kod otrzymany od dostawcy oprogramowania: '
    end
    object code: TEdit
      Left = 327
      Top = 8
      Width = 303
      Height = 24
      TabOrder = 0
    end
    object BApply: TBitBtn
      Left = 630
      Top = 8
      Width = 85
      Height = 29
      Caption = 'Zatwierd'#378
      TabOrder = 1
      OnClick = BApplyClick
    end
  end
end
