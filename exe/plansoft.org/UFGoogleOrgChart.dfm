inherited FGoogleOrgChart: TFGoogleOrgChart
  Left = 428
  Top = 293
  Width = 478
  Height = 303
  ActiveControl = BSelectORG
  Caption = 'Struktura Uczelni- wykres'
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel [0]
    Left = 9
    Top = 55
    Width = 124
    Height = 16
    Caption = 'Dodaj wyk'#322'adowc'#243'w'
  end
  object Label2: TLabel [1]
    Left = 55
    Top = 110
    Width = 85
    Height = 16
    Caption = 'Dodaj zasoby'
  end
  object Label3: TLabel [2]
    Left = 64
    Top = 82
    Width = 77
    Height = 16
    Caption = 'Dodaj grupy'
  end
  object Label4: TLabel [3]
    Left = 37
    Top = 137
    Width = 109
    Height = 16
    Caption = 'Dodaj przedmioty'
  end
  object Label5: TLabel [4]
    Left = 9
    Top = 9
    Width = 130
    Height = 16
    Caption = 'Wykres dla jednostki'
  end
  inherited Status: TPanel
    Top = 244
    Width = 470
  end
  object Panel1: TPanel
    Left = 0
    Top = 197
    Width = 470
    Height = 47
    Align = alBottom
    TabOrder = 1
    object BOk: TBitBtn
      Left = 366
      Top = 9
      Width = 85
      Height = 29
      Caption = 'Dalej >'
      ModalResult = 1
      TabOrder = 0
    end
    object BCancel: TBitBtn
      Left = 9
      Top = 9
      Width = 86
      Height = 29
      Caption = '<Zamknij'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object L: TComboBox
    Left = 134
    Top = 46
    Width = 187
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
    Left = 134
    Top = 73
    Width = 187
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
    Left = 134
    Top = 101
    Width = 187
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
    Left = 134
    Top = 128
    Width = 187
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
    Left = 7
    Top = 165
    Width = 367
    Height = 19
    Caption = 'Uwzgl'#281'dniaj wszystkie rekordy (ignoruj uprawnienia dost'#281'pu)'
    TabOrder = 6
  end
  object ORGID_VALUE: TEdit
    Left = 135
    Top = 9
    Width = 294
    Height = 24
    ReadOnly = True
    TabOrder = 7
  end
  object BSelectORG: TBitBtn
    Left = 429
    Top = 9
    Width = 27
    Height = 28
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
    Left = 128
    Top = 9
    Width = 138
    Height = 24
    TabOrder = 9
    Visible = False
    OnChange = ORGIDChange
  end
  object map: TMemo
    Left = 333
    Top = 46
    Width = 92
    Height = 74
    Lines.Strings = (
      'Nie=N'
      'Tak-uk'#322'ad zwi'#281'z'#322'y=C'
      'Tak-uk'#322'ad szczeg'#243#322'owy=Y')
    TabOrder = 10
    Visible = False
    WordWrap = False
  end
end
