inherited FGoogleOrgChart: TFGoogleOrgChart
  Left = 428
  Top = 293
  Width = 478
  Height = 303
  ActiveControl = BSelectORG
  Caption = 'Struktura Uczelni- wykres'
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel [0]
    Left = 8
    Top = 48
    Width = 103
    Height = 14
    Caption = 'Dodaj wyk'#322'adowc'#243'w'
  end
  object Label2: TLabel [1]
    Left = 48
    Top = 96
    Width = 66
    Height = 14
    Caption = 'Dodaj zasoby'
  end
  object Label3: TLabel [2]
    Left = 56
    Top = 72
    Width = 58
    Height = 14
    Caption = 'Dodaj grupy'
  end
  object Label4: TLabel [3]
    Left = 32
    Top = 120
    Width = 83
    Height = 14
    Caption = 'Dodaj przedmioty'
  end
  object Label5: TLabel [4]
    Left = 8
    Top = 8
    Width = 99
    Height = 14
    Caption = 'Wykres dla jednostki'
  end
  inherited Status: TPanel
    Top = 252
    Width = 470
  end
  object Panel1: TPanel
    Left = 0
    Top = 210
    Width = 470
    Height = 42
    Align = alBottom
    TabOrder = 1
    object BOk: TBitBtn
      Left = 320
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Dalej >'
      ModalResult = 1
      TabOrder = 0
    end
    object BCancel: TBitBtn
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = '<Zamknij'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object L: TComboBox
    Left = 117
    Top = 40
    Width = 164
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 1
    TabOrder = 2
    Text = 'Tak-uk'#322'ad zwi'#281'z'#322'y'
    Items.Strings = (
      'Nie'
      'Tak-uk'#322'ad zwi'#281'z'#322'y'
      'Tak-uk'#322'ad szczeg'#243#322'owy')
  end
  object G: TComboBox
    Left = 117
    Top = 64
    Width = 164
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 1
    TabOrder = 3
    Text = 'Tak-uk'#322'ad zwi'#281'z'#322'y'
    Items.Strings = (
      'Nie'
      'Tak-uk'#322'ad zwi'#281'z'#322'y'
      'Tak-uk'#322'ad szczeg'#243#322'owy')
  end
  object R: TComboBox
    Left = 117
    Top = 88
    Width = 164
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 1
    TabOrder = 4
    Text = 'Tak-uk'#322'ad zwi'#281'z'#322'y'
    Items.Strings = (
      'Nie'
      'Tak-uk'#322'ad zwi'#281'z'#322'y'
      'Tak-uk'#322'ad szczeg'#243#322'owy')
  end
  object S: TComboBox
    Left = 117
    Top = 112
    Width = 164
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 1
    TabOrder = 5
    Text = 'Tak-uk'#322'ad zwi'#281'z'#322'y'
    Items.Strings = (
      'Nie'
      'Tak-uk'#322'ad zwi'#281'z'#322'y'
      'Tak-uk'#322'ad szczeg'#243#322'owy')
  end
  object showAll: TCheckBox
    Left = 6
    Top = 144
    Width = 321
    Height = 17
    Caption = 'Uwzgl'#281'dniaj wszystkie rekordy (ignoruj uprawnienia dost'#281'pu)'
    TabOrder = 6
  end
  object ORGID_VALUE: TEdit
    Left = 118
    Top = 8
    Width = 257
    Height = 22
    ReadOnly = True
    TabOrder = 7
  end
  object BSelectORG: TBitBtn
    Left = 375
    Top = 8
    Width = 24
    Height = 24
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = BSelectORGClick
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF018B8A7AC385827DA26B6B6B3F00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF01094FFF974392F6FFEEE9DFFF86827FA700000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF020D51FF9B439AFFFF6ADAFFFF5DADF5FF998F7ED900000000000000000000
      00000000000000000000000000000000000000000000000000006B7E690F0041
      FC9F469FFFFF6FDAFFFF50ACFFFF1357FFB9002AFF0A00000000000000000000
      000000000000000000006164682E515459524C4E523F1617180698928B9E7091
      B2FF61D3FFFF4EAAFFFF1657FFB4001FFF070000000000000000000000000000
      000076777A257B7E80C8B3A081FED2B588FDC3AA83FD83817AE566686CEAFFF7
      F0FF6B93BDFF084AFEAF0028FF06000000000000000000000000000000007B7D
      7F188D8A82E6F5CB84FEF5CB84FFF1C885FFF5CE8EFFFCD08CFFAE9E85FE7071
      75F3A9A193BB3956B20A0000000000000000000000000000000000000000767A
      7F95ECCB8EFFF3D192FFEECE92FFEDCC8EFFECC784FFEDC687FFFDD28FFF8783
      7CDB000000010000000000000000000000000000000000000000000000009894
      8BE1FEDFA1FFF2DAA5FFF2DBA7FFF1D79FFFEFD097FFECC886FFF6D298FFC1A9
      87FF5254592A000000000000000000000000000000000000000000000000A7A1
      91F4FFEBB9FFF8ECC6FFF7EBC0FFF5E3B2FFF2DAA3FFEECF94FFF4D093FFCFB6
      8DFF5153583D0000000000000000000000000000000000000000000000009996
      92D0FFF7CBFFFDFAE6FFFDF9E7FFF8EDC5FFF4E0B0FFF0D49BFFFAD594FFAF9F
      85FE6264671A000000000000000000000000000000000000000000000000A0A1
      A56FD5CCB1FFFFFFF2FFFFFFF2FFFBF3D2FFF6E2B4FFF7D99EFFF6D393FF7D7D
      81B800000000000000000000000000000000000000000000000000000000D9D9
      DA04A1A1A2B8D6CFB6FFFFFFDCFFFFF6CAFFFFEBB1FFEDD49CFE8C8983E47677
      7A20000000000000000000000000000000000000000000000000000000000000
      0000EBECED059C9CA07B979893E0A8A397FE97948CF07679809E7C7D7F1A0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000}
  end
  object ORGID: TEdit
    Left = 112
    Top = 8
    Width = 121
    Height = 22
    TabOrder = 9
    Visible = False
    OnChange = ORGIDChange
  end
  object map: TMemo
    Left = 291
    Top = 40
    Width = 81
    Height = 65
    Lines.Strings = (
      'Nie=N'
      'Tak-uk'#322'ad zwi'#281'z'#322'y=C'
      'Tak-uk'#322'ad szczeg'#243#322'owy=Y')
    TabOrder = 10
    Visible = False
    WordWrap = False
  end
end
