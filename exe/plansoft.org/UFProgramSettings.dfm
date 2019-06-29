inherited FProgramSettings: TFProgramSettings
  Left = 297
  Top = 226
  Width = 929
  Height = 696
  Caption = 'Ustawienia konfiguracyjne'
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 645
    Width = 921
  end
  object Panel1: TPanel
    Left = 0
    Top = 604
    Width = 921
    Height = 41
    Align = alBottom
    TabOrder = 1
    object BZamknij: TBitBtn
      Left = 727
      Top = 5
      Width = 75
      Height = 28
      Hint = 'Zamknij bie'#380#261'ce okno'
      Cancel = True
      Caption = 'Zamknij'
      Default = True
      ModalResult = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
        F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
        000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
        338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
        45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
        3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
        F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
        000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
        338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
        4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
        8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
        333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
        0000}
      NumGlyphs = 2
    end
  end
  object Pages: TPageControl
    Left = 0
    Top = 0
    Width = 921
    Height = 604
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 2
    OnChange = PagesChange
    object TabSheet1: TTabSheet
      Caption = 'Ustawienia pami'#281'ci'
      object Label1: TLabel
        Left = 16
        Top = 384
        Width = 359
        Height = 14
        Caption = 
          'Rozmiar pami'#281'ci potrzebny do przechowania pojedynczego zaj'#281'cia [' +
          'Bajty]'
      end
      object Label2: TLabel
        Left = 16
        Top = 408
        Width = 210
        Height = 14
        Caption = 'Maksymalna liczba buforowanych arkuszy:'
      end
      object Example: TLabel
        Left = 16
        Top = 432
        Width = 662
        Height = 15
        Caption = 
          'Przybli'#380'ony rozmiar bufora: 180 dni * 8 godz. * ... * 80 * 3 ( t' +
          'rzy osobne zestawy arkuszy dla wyk'#322'adowcy, grupy i sali) = '
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Memo1: TMemo
        Left = 8
        Top = 8
        Width = 785
        Height = 353
        BorderStyle = bsNone
        Color = clBtnFace
        Lines.Strings = (
          
            'W celu przyspieszenia dzia'#322'ania programu oraz w celu zredukowani' +
            'a ruchu w sieci du'#380'a cz'#281#347#263' danych pobieranych z serwera jest'
          
            'buforowana lokalnie. Dla sprawnego dzia'#322'ania programu Planowanie' +
            ' zaleca si'#281' zarezerowanie odpowiedniej liczby pami'#281'ci operacyjne' +
            'j (RAM).'
          
            'Za pomoc'#261' tego formularza mo'#380'esz okre'#347'li'#263' rozmiar pami'#281'ci zareze' +
            'rowanej dla programu.'
          
            'Poni'#380'ej podano wskaz'#243'wki, kt'#243'rymi nale'#380'y si'#281' kierowa'#263' podczas ok' +
            're'#347'lania rozmiaru bufora.'
          ''
          
            'Rozmiar bufora powinien by'#263' ustawiony optymalnie w zale'#380'no'#347'ci od' +
            ': liczby dost'#281'pnej pami'#281'ci operacyjnej, liczby dni w semestrze, ' +
            'liczby '
          'godzin w ci'#261'gu dnia, '
          'liczby danych wy'#347'wietlanych na ekranie jednocze'#347'nie.'
          
            'Ustawienie zbyt ma'#322'ego bufora danych spowoduje, '#380'e uk'#322'ad tabeli ' +
            'krzy'#380'owej zacznie dzia'#322'a'#263' za wolno.'
          
            'Ustawienie za du'#380'ego bufora spowoduje, '#380'e zabraknie wolnych zaso' +
            'b'#243'w dla systemu operacyjnego.'
          ''
          
            'Liczb'#281' bajt'#243'w potrzebnych dla przechowania informacji na temat z' +
            'aj'#281#263' okre'#347'lonego wyk'#322'adowcy, grupy lub sali (tzw. rozmiar arkusz' +
            'a) mo'#380'na '
          'wyliczy'#263' za '
          'pomoc'#261' wzoru:'
          ''
          
            'ROZMIAR ARKUSZA = liczba dni w semestrze * liczba zaj'#281#263' w ci'#261'gu ' +
            'dnia * rozmiar pami'#281'ci potrzebny do przechowania pojedynczego za' +
            'j'#281'cia.'
          ''
          
            'W celu p'#322'ynnego dzia'#322'ania widoku tabeli krzy'#380'owej liczba arkuszy' +
            ' powinna wynosi'#263' co najmniej tyle, ile  jednocze'#347'nie wy'#347'wietlany' +
            'ch b'#281'dzie '
          'wierszy na '
          'ekranie.'
          ''
          
            'Z drugiej strony wolne zasoby komputera (tzn. ilo'#347#263' wolnej pami'#281 +
            'ci fizycznej) nigdy nie powinnny zmniejszy'#263' si'#281' poni'#380'ej 10%.'
          
            'Je'#380'eli liczba zasob'#243'w spad'#322'a poni'#380'ej 10%, w'#243'wczas zmniesz bufor ' +
            'danych zarezerowany dla programu.'
          
            'Je'#380'eli po wykonaniu tej czynno'#347'ci liczba wolnych zasob'#243'w nadal j' +
            'est mniejsza, ni'#380' 10%, rekomenduje si'#281' rozszerzenie pami'#281'ci oper' +
            'acyjnej '
          'komputera.'
          ''
          
            'Program nie zarezwuje od razu ca'#322'ego zadeklarowanego obszaru pam' +
            'i'#281'ci, lecz rozszerza bufor danych adekwatnie do potrzeb.'
          
            'Je'#380'eli chcesz na bie'#380#261'co '#347'ledzi'#263' ilo'#347#263' wolnych zasob'#243'w komputera' +
            ', naci'#347'nij przycisk "Uruchom monitor pami'#281'ci"')
        ReadOnly = True
        TabOrder = 0
      end
      object info: TEdit
        Left = 436
        Top = 376
        Width = 57
        Height = 22
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
        Text = 'info'
      end
      object MaxNumberOfSheets: TEdit
        Left = 436
        Top = 400
        Width = 57
        Height = 22
        TabOrder = 2
        Text = '80'
        OnChange = MaxNumberOfSheetsChange
      end
      object BRunMonitor: TButton
        Left = 16
        Top = 451
        Width = 171
        Height = 28
        Caption = 'Uruchom monitor pami'#281'ci'
        TabOrder = 3
        OnClick = BRunMonitorClick
      end
    end
    object TabNumbering: TTabSheet
      Caption = 'Godziny zaj'#281#263
      ImageIndex = 1
      object Label21: TLabel
        Left = 216
        Top = 136
        Width = 381
        Height = 14
        Caption = 
          'Funkcjonalnosc definiowania siatki godzinowej przeniesiono do me' +
          'nu Slowniki.'
      end
      object BGrid: TBitBtn
        Left = 304
        Top = 168
        Width = 185
        Height = 129
        Caption = 'Siatka godzinowa'
        TabOrder = 0
        OnClick = BGridClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Profil Klienta'
      ImageIndex = 3
      object Label3: TLabel
        Left = 48
        Top = 16
        Width = 270
        Height = 14
        Caption = 'Wybierz profil odpowiadaj'#261'cy prowadzonej dzia'#322'alno'#347'ci'
      end
      object Label4: TLabel
        Left = 168
        Top = 48
        Width = 91
        Height = 14
        Caption = 'Liczba pojedyncza'
      end
      object Label5: TLabel
        Left = 296
        Top = 48
        Width = 67
        Height = 14
        Caption = 'Liczba mnoga'
      end
      object Label6: TLabel
        Left = 80
        Top = 72
        Width = 29
        Height = 14
        Caption = 'Okres'
      end
      object Label7: TLabel
        Left = 80
        Top = 160
        Width = 40
        Height = 14
        Caption = 'Zas'#243'b 1'
      end
      object Label8: TLabel
        Left = 80
        Top = 184
        Width = 40
        Height = 14
        Caption = 'Zas'#243'b 2'
      end
      object Label10: TLabel
        Left = 80
        Top = 240
        Width = 55
        Height = 14
        Caption = 'Kategoria 1'
      end
      object Label11: TLabel
        Left = 80
        Top = 264
        Width = 55
        Height = 14
        Caption = 'Kategoria 2'
      end
      object Label12: TLabel
        Left = 80
        Top = 96
        Width = 35
        Height = 14
        Caption = 'Zaj'#281'cie'
      end
      object Label13: TLabel
        Left = 80
        Top = 120
        Width = 37
        Height = 14
        Caption = 'Planista'
      end
      object Label9: TLabel
        Left = 424
        Top = 48
        Width = 86
        Height = 14
        Caption = 'Kogo? Co? widz'#281
      end
      object Label14: TLabel
        Left = 552
        Top = 48
        Width = 105
        Height = 14
        Caption = 'Kogo? Czego? nie ma'
      end
      object profileType: TComboBox
        Left = 328
        Top = 8
        Width = 249
        Height = 19
        Style = csOwnerDrawFixed
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Uczelnia wy'#380'sza'
        OnChange = profileTypeChange
        Items.Strings = (
          'Uczelnia wy'#380'sza'
          'Rejestracja pacjent'#243'w'
          'Rejestracja czasu pracy'
          'Inny')
      end
      object profileObjectNamePeriod: TEdit
        Left = 168
        Top = 64
        Width = 121
        Height = 24
        TabOrder = 1
      end
      object profileObjectNamePeriods: TEdit
        Left = 296
        Top = 64
        Width = 121
        Height = 24
        TabOrder = 2
      end
      object profileObjectNameL: TEdit
        Left = 168
        Top = 152
        Width = 121
        Height = 24
        TabOrder = 5
      end
      object profileObjectNameLs: TEdit
        Left = 296
        Top = 152
        Width = 121
        Height = 24
        TabOrder = 6
      end
      object profileObjectNameG: TEdit
        Left = 168
        Top = 176
        Width = 121
        Height = 24
        TabOrder = 9
      end
      object profileObjectNameGs: TEdit
        Left = 296
        Top = 176
        Width = 121
        Height = 24
        TabOrder = 10
      end
      object profileObjectNameC1s: TEdit
        Left = 296
        Top = 232
        Width = 121
        Height = 24
        TabOrder = 14
      end
      object profileObjectNameC1: TEdit
        Left = 168
        Top = 232
        Width = 121
        Height = 24
        TabOrder = 13
      end
      object profileObjectNameC2s: TEdit
        Left = 296
        Top = 256
        Width = 121
        Height = 24
        TabOrder = 18
      end
      object profileObjectNameC2: TEdit
        Left = 168
        Top = 256
        Width = 121
        Height = 24
        TabOrder = 17
      end
      object profileObjectNameClasses: TEdit
        Left = 296
        Top = 88
        Width = 121
        Height = 24
        TabOrder = 22
      end
      object profileObjectNameClass: TEdit
        Left = 168
        Top = 88
        Width = 121
        Height = 24
        TabOrder = 21
      end
      object profileObjectNamePlanner: TEdit
        Left = 168
        Top = 112
        Width = 121
        Height = 24
        TabOrder = 25
      end
      object profileObjectNamePlanners: TEdit
        Left = 296
        Top = 112
        Width = 121
        Height = 24
        TabOrder = 26
      end
      object profileObjectNamePeriodacc: TEdit
        Left = 424
        Top = 64
        Width = 121
        Height = 24
        TabOrder = 4
      end
      object profileObjectNameClassacc: TEdit
        Left = 424
        Top = 88
        Width = 121
        Height = 24
        TabOrder = 23
      end
      object profileObjectNamePlanneracc: TEdit
        Left = 424
        Top = 112
        Width = 121
        Height = 24
        TabOrder = 28
      end
      object profileObjectNameLacc: TEdit
        Left = 424
        Top = 152
        Width = 121
        Height = 24
        TabOrder = 7
      end
      object profileObjectNameGacc: TEdit
        Left = 424
        Top = 176
        Width = 121
        Height = 24
        TabOrder = 11
      end
      object profileObjectNameC1acc: TEdit
        Left = 424
        Top = 232
        Width = 121
        Height = 24
        TabOrder = 15
      end
      object profileObjectNameC2acc: TEdit
        Left = 424
        Top = 256
        Width = 121
        Height = 24
        TabOrder = 19
      end
      object profileObjectNamePeriodgen: TEdit
        Left = 552
        Top = 64
        Width = 121
        Height = 24
        TabOrder = 3
      end
      object profileObjectNameClassgen: TEdit
        Left = 552
        Top = 88
        Width = 121
        Height = 24
        TabOrder = 24
      end
      object profileObjectNamePlannergen: TEdit
        Left = 552
        Top = 112
        Width = 121
        Height = 24
        TabOrder = 27
      end
      object profileObjectNameLgen: TEdit
        Left = 552
        Top = 152
        Width = 121
        Height = 24
        TabOrder = 8
      end
      object profileObjectNameGgen: TEdit
        Left = 552
        Top = 176
        Width = 121
        Height = 24
        TabOrder = 12
      end
      object profileObjectNameC1gen: TEdit
        Left = 552
        Top = 232
        Width = 121
        Height = 24
        TabOrder = 16
      end
      object profileObjectNameC2gen: TEdit
        Left = 552
        Top = 256
        Width = 121
        Height = 24
        TabOrder = 20
      end
      object Button1: TButton
        Left = 600
        Top = 288
        Width = 75
        Height = 25
        Caption = 'Zatwierd'#378
        TabOrder = 29
        OnClick = Button1Click
      end
    end
    object TabClassDesc: TTabSheet
      Caption = 'Opis dla zaj'#281'cia'
      ImageIndex = 4
      object Label15: TLabel
        Left = 16
        Top = 48
        Width = 31
        Height = 14
        Caption = 'Opis 1'
      end
      object Label16: TLabel
        Left = 16
        Top = 72
        Width = 31
        Height = 14
        Caption = 'Opis 2'
      end
      object Label17: TLabel
        Left = 16
        Top = 96
        Width = 31
        Height = 14
        Caption = 'Opis 3'
      end
      object Label18: TLabel
        Left = 16
        Top = 120
        Width = 31
        Height = 14
        Caption = 'Opis 4'
      end
      object Label20: TLabel
        Left = 112
        Top = 24
        Width = 35
        Height = 14
        Caption = 'Nazwa'
      end
      object Label19: TLabel
        Left = 304
        Top = 24
        Width = 107
        Height = 14
        Caption = 'Nazwa / wyk'#322'adowca'
      end
      object SpeedButton1: TSpeedButton
        Left = 278
        Top = 16
        Width = 23
        Height = 22
        Flat = True
        Glyph.Data = {
          76060000424D7606000000000000360000002800000014000000140000000100
          2000000000004006000000000000000000000000000000000000FFFEFE00FEFE
          FF00FFFEFD00FDFCF900FFFFFF00FDFEFB00EEDBC300E6BB8500DAA56A00D499
          6000D7955D00D19C6500D8A97900E3C1A400E5E2DB00F2F8FA00FEFDFC00FFFF
          FE00FEFEFE00FEFEFE00F8FDFE00FFFEF600F6FAFC00F6FFFF00F0DFC400DE9F
          5600E2883300ED8F3600F59B3E00FAA04300FC9F4600F7A04100F2983C00E188
          4000CE884F00D9B39000DAE6E600F6F9FB00FBFFF900F9FDFE00F8FEFC00F6FB
          F900FFFFFC00E7C68D00D8872A00F79D3500FFAA5300FFAA5900FFAD5700FFAE
          5500FFAF5500FFB05A00FFB25F00FFB36100FCAA5800E0864500C5926A00D4DA
          CD00FCF2F800FEFEFF00FCFCF700F6FFFF00E1BE8900E58A1E00FEAC4C00FDAD
          5600FDA94E00FEAA4F00F7AA5800ECAA5C00F0AB5B00F7AE5E00FCAF6000FEB1
          6200FBB56600FDB96E00F09A3F00CD876200D6D5D700F3FBF400FDFFFF00E7D3
          AA00D7882500FFAE5500FAAC5700FCAB5300FEAE5500FBAA5200ECBB7E00F6ED
          D100F5EDDD00EFCE9200F3AF5F00FFB36700FDB66400F7B56900FCBF7300EA95
          4C00BE936E00E4E5E200F8F5E600E4943000F8A94900FAAD5900FEAD5500FCAE
          5700FAB05D00FAAC5400E6C39200FDFFFF00FBFFFF00F2D6AB00F5AC6400FCB7
          6C00FBB96900FFB56F00F5B57600F9C37500E0884700E1B29C00E0C49800EF92
          2800FDB26200FAAC5D00FEAF5D00FCB05F00FCB36000FDB15E00F3BB7800F7DD
          AE00F4DDB900F7C48B00FEB06A00FBBA6E00F9BB7200FEB97500FABB7500FBC0
          7C00F4AD6600CE8A5F00DEA65800F8A34900FEB16100FDB06100FEB26300FDB3
          6300FDB46400FDB36A00FBB46800F3B06300EEAE6A00F2B46F00FFB97200FCBB
          7100FABB7900FEBB7B00FBBD7B00FBBF7C00FFC28000D1895200EA9E2F00FEB0
          5E00FDB16400FEB36200FEB46700FDB56800FEB86900FAB36600F2CD9D00F9F1
          DF00F9F0E200F3D6AA00F5B37700FBBE7D00FBBD7E00FDBE7F00FDC07F00FDC0
          7F00FEC98900E4975100EC9C3000FEB66100FBB66300FEB36800FEB56900FDB7
          6C00FEBA7000F9B76C00F0C5A000F8FFFF00F6FFFF00F9F4E700E6BE9200FBBC
          7D00FFC28100FBC08300FBC18300FCC28400FECB8F00EAA15800E99C3700FFB8
          6600FBB56C00FEB66E00FEB96D00FEBA7200FDBB7500FCBD7700F6B67800F2DB
          B600FCFFFA00FBFEFF00FBF4E300F2C69700FAC08300FBC38600FBC48800FCC5
          8800FECE9300E9A15B00E59C3B00FEB86800FCB57600FDBA7000FDBB7200FCBC
          7600FBBD7900FCBD7B00FFC27600F5BB7B00F2DABE00FAFDFC00FCFFFF00FAF2
          E100F2C49000FEC58900FDC58D00FCC58C00FED19700E29A5900E8A74D00F7B1
          5F00FEBB7A00FDBE7000FCBE7800FBBF7A00FCC07E00FABB7B00F3C07C00FFC1
          8200F5BA8000F8E9D700F6FEFE00F6FFFC00F2D6AD00FCC48A00FEC99200FDC8
          9100FFCF9800D2905200EAC38300EDA14300FBC28500FCBB7C00FDC17B00FCC2
          7700F1C79800F6DFBF00EDC99B00F3C38B00F3C58E00FAECDA00FAFDFE00F9FE
          FE00F3D8BA00FBC29600F8CD9300FDCDA100F8BF8300CF935C00F3F1DF00DF9A
          3200FFC17100F6C08900FBC08500FEC07C00EECA9C00FBFFFF00FCFCF700F7F2
          E500F6F5ED00FAFEFE00F9FFFF00FCFCF200F4D0A700FBCC9500FCC7A000FFDB
          A200DC954F00E9C5A300F9FFFF00EDCE9400E2973400FCCC8C00FBC28A00FEC0
          8400F4C89400F3EDE200F9F9F700FCFFFE00F9FFFF00FAFBF900FAF5E800F0D8
          B800F8CA9A00FECE9600FEDCAE00E5AE6B00DC9B6B00FEFDF600FCFCFC00FDFF
          FD00DEB97200EA9D3400FFCD8F00FCCB9200FBC39100F5C49300F7CD9E00F9D4
          AC00F9D6B000F7D2AF00F7CC9E00FACB9500FFCEA500FFDCB300EBB36900D292
          5B00F7F2EB00FFFCFF00FFFDFD00FCFCFE00FFFFFB00E4BE7D00D9983B00F8C1
          7000FCD29D00FDD1A100FECD9D00FBCB9E00F9CC9F00FED09F00FCD6AB00FCDA
          B100FCD09B00DDA25700D39D6400FBF2E900F8FFFF00FEFCFC00FEFEFE00FEFE
          FD00FDFDFE00FFFFFF00ECDEB300D4A64E00E29E4900EFB46700F8C67D00FACC
          8D00F5CB9600F6C88D00F2BD7500E4A65800D5994D00E0C29200FBFFF200F3FE
          FF00F6FDFB00FEFEFB00FEFFFE00FEFEFE00FEFEFD00F8FDFA00FCFFFF00FCFB
          FE00EEDDB100E4BD7800DEAE6500DCA85600E4AB5000DAA96200E2B47500EACF
          A200F8F5EB00FFFFFF00FAFCFE00FAFCFD00FFFEFC00FEFEFB00}
        OnClick = SpeedButton1Click
      end
      object Label31: TLabel
        Left = 480
        Top = 24
        Width = 89
        Height = 15
        Caption = 'Kopiuj warto'#347#263' z'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object pClassDesc4GlobalPlural: TEdit
        Left = 56
        Top = 112
        Width = 193
        Height = 24
        TabOrder = 3
      end
      object pClassDesc3GlobalPlural: TEdit
        Left = 56
        Top = 88
        Width = 193
        Height = 24
        TabOrder = 2
      end
      object pClassDesc2GlobalPlural: TEdit
        Left = 56
        Top = 64
        Width = 193
        Height = 24
        TabOrder = 1
      end
      object pClassDesc1GlobalPlural: TEdit
        Left = 56
        Top = 40
        Width = 193
        Height = 24
        TabOrder = 0
      end
      object pClassDesc1GlobalSingular: TEdit
        Left = 256
        Top = 40
        Width = 193
        Height = 24
        TabOrder = 4
        OnChange = pClassDesc1GlobalSingularChange
      end
      object pClassDesc2GlobalSingular: TEdit
        Left = 256
        Top = 64
        Width = 193
        Height = 24
        TabOrder = 5
        OnChange = pClassDesc1GlobalSingularChange
      end
      object pClassDesc3GlobalSingular: TEdit
        Left = 256
        Top = 88
        Width = 193
        Height = 24
        TabOrder = 6
        OnChange = pClassDesc1GlobalSingularChange
      end
      object pClassDesc4GlobalSingular: TEdit
        Left = 256
        Top = 112
        Width = 193
        Height = 24
        TabOrder = 7
        OnChange = pClassDesc1GlobalSingularChange
      end
      object CopyField1: TComboBox
        Left = 450
        Top = 40
        Width = 143
        Height = 22
        Style = csOwnerDrawFixed
        DropDownCount = 25
        ItemHeight = 16
        MaxLength = 255
        TabOrder = 8
        Items.Strings = (
          '<nie dotyczy>'
          'Nazwa kalendarza'
          'Przedmiot'
          'Forma')
      end
      object CopyField2: TComboBox
        Left = 450
        Top = 64
        Width = 143
        Height = 22
        Style = csOwnerDrawFixed
        DropDownCount = 25
        ItemHeight = 16
        MaxLength = 255
        TabOrder = 9
        Items.Strings = (
          '<nie dotyczy>'
          'Nazwa kalendarza'
          'Przedmiot'
          'Forma')
      end
      object CopyField3: TComboBox
        Left = 450
        Top = 88
        Width = 143
        Height = 22
        Style = csOwnerDrawFixed
        DropDownCount = 25
        ItemHeight = 16
        MaxLength = 255
        TabOrder = 10
        Items.Strings = (
          '<nie dotyczy>'
          'Nazwa kalendarza'
          'Przedmiot'
          'Forma')
      end
      object CopyField4: TComboBox
        Left = 450
        Top = 112
        Width = 143
        Height = 22
        Style = csOwnerDrawFixed
        DropDownCount = 25
        ItemHeight = 16
        MaxLength = 255
        TabOrder = 11
        Items.Strings = (
          '<nie dotyczy>'
          'Nazwa kalendarza'
          'Przedmiot'
          'Forma')
      end
    end
    object SAdvanced: TTabSheet
      Caption = 'Zaawansowane'
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 329
        Height = 41
        Caption = 'Diagnostyka'
        TabOrder = 0
        object SQLLog: TCheckBox
          Left = 8
          Top = 16
          Width = 145
          Height = 17
          Caption = 'Rejestruj zapytania SQL'
          TabOrder = 0
          OnClick = SQLLogClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 56
        Width = 553
        Height = 209
        Caption = 'Rozmiar czcionki'
        TabOrder = 1
        object Label22: TLabel
          Left = 16
          Top = 24
          Width = 67
          Height = 14
          Caption = 'Pola edycyjne'
        end
        object Label23: TLabel
          Left = 16
          Top = 48
          Width = 70
          Height = 14
          Caption = 'Pozosta'#322'e pola'
        end
        object Label24: TLabel
          Left = 16
          Top = 172
          Width = 305
          Height = 14
          Caption = 'Aby zobaczy'#263' zmiany zamknij program i uruchom go ponownie'
          OnClick = BGridClick
        end
        object Label25: TLabel
          Left = 16
          Top = 92
          Width = 207
          Height = 14
          Caption = 'Rozmiar czcionki mo'#380'na r'#243'wnie'#380' zmienia'#263':'
          OnClick = BGridClick
        end
        object Label26: TLabel
          Left = 32
          Top = 108
          Width = 265
          Height = 14
          Caption = 'Zmieniaj'#261'c systemow'#261' czcionk'#281' w systemie Windows'
          OnClick = BGridClick
        end
        object Label27: TLabel
          Left = 32
          Top = 124
          Width = 356
          Height = 14
          Caption = 
            'Ustawiaj'#261'c domy'#347'ln'#261' czcionk'#281' dla siatki rekord'#243'w w okna s'#322'owniko' +
            'wych'
          OnClick = BGridClick
        end
        object Label28: TLabel
          Left = 32
          Top = 140
          Width = 246
          Height = 14
          Caption = 'Zmieniaj'#261'c rozmiar siatki w oknie g'#322#243'wnym Aplikacji'
          OnClick = BGridClick
        end
        object Label29: TLabel
          Left = 16
          Top = 188
          Width = 469
          Height = 14
          Caption = 
            'Pami'#281'taj, '#380'e ustawienie zbyt du'#380'ej czcionki spowoduje, '#380'e tekst ' +
            'nie b'#281'dzie mie'#347'ci'#322' si'#281' na ekranie.'
          OnClick = BGridClick
        end
        object Label30: TLabel
          Left = 224
          Top = 24
          Width = 228
          Height = 14
          Caption = '8-czcionka normalna, 11-du'#380'a, 13-bardzo du'#380'a'
        end
        object EditFontSize: TEdit
          Left = 136
          Top = 16
          Width = 81
          Height = 24
          TabOrder = 0
          Text = 'EditFontSize'
        end
        object FontSize: TEdit
          Left = 136
          Top = 40
          Width = 81
          Height = 24
          TabOrder = 1
          Text = 'FontSize'
        end
      end
      object tablefilterjs: TMemo
        Left = 567
        Top = 176
        Width = 89
        Height = 73
        Lines.Strings = (
          '/*===================================================='
          #9'- HTML Table Filter Generator v1.6'
          #9'- By Max Guglielmi'
          #9'- mguglielmi.free.fr/scripts/TableFilter/?l=en'
          #9'- please do not change this comment'
          #9'- don'#39't forget to give some credit... it'#39's always'
          #9'good for the author'
          #9'- Special credit to Cedric Wartel and '
          #9'cnx.claude@free.fr for contribution and '
          #9'inspiration'
          '=====================================================*/'
          ''
          '// global vars'
          'var TblId, SearchFlt, SlcArgs;'
          'TblId = new Array(), SlcArgs = new Array();'
          ''
          ''
          'function setFilterGrid(id)'
          '/*===================================================='
          #9'- Checks if id exists and is a table'
          #9'- Then looks for additional params '
          #9'- Calls fn that generates the grid'
          '=====================================================*/'
          '{'#9
          #9'var tbl = grabEBI(id);'
          #9'var ref_row, fObj;'
          #9'if(tbl != null && tbl.nodeName.toLowerCase() == "table")'
          #9'{'#9#9#9#9#9#9
          #9#9'if(arguments.length>1)'
          #9#9'{'
          #9#9#9'for(var i=0; i<arguments.length; i++)'
          #9#9#9'{'
          #9#9#9#9'var argtype = typeof arguments[i];'
          #9#9#9#9
          #9#9#9#9'switch(argtype.toLowerCase())'
          #9#9#9#9'{'
          #9#9#9#9#9'case "number":'
          #9#9#9#9#9#9'ref_row = arguments[i];'
          #9#9#9#9#9'break;'
          #9#9#9#9#9'case "object":'
          #9#9#9#9#9#9'fObj = arguments[i];'
          #9#9#9#9#9'break;'
          #9#9#9#9'}//switch'
          #9#9#9#9#9#9#9
          #9#9#9'}//for'
          #9#9'}//if'
          #9#9
          #9#9'ref_row == undefined ? ref_row=2 : ref_row=(ref_row+2);'
          #9#9'var ncells = getCellsNb(id,ref_row);'
          #9#9'tbl.tf_ncells = ncells;'
          #9#9'if(tbl.tf_ref_row==undefined) tbl.tf_ref_row = ref_row;'
          #9#9'tbl.tf_Obj = fObj;'
          #9#9'if( !hasGrid(id) ) AddGrid(id);'#9#9
          #9'}//if tbl!=null'
          '}'
          ''
          'function AddGrid(id)'
          '/*===================================================='
          #9'- adds a row containing the filtering grid'
          '=====================================================*/'
          '{'#9
          #9'TblId.push(id);'
          #9'var t = grabEBI(id);'
          #9'var f = t.tf_Obj, n = t.tf_ncells;'#9
          #9'var inpclass, fltgrid, displayBtn, btntext, enterkey;'
          #9'var modfilter_fn, display_allText, on_slcChange;'
          #9'var displaynrows, totrows_text, btnreset, btnreset_text;'
          #9'var sort_slc, displayPaging, pagingLength, displayLoader;'
          #9'var load_text, exactMatch, alternateBgs, colOperation;'
          #9'var rowVisibility, colWidth, bindScript;'
          #9
          
            #9'f!=undefined && f["grid"]==false ? fltgrid=false : fltgrid=true' +
            ';//enables/disables filter grid'
          
            #9'f!=undefined && f["btn"]==true ? displayBtn=true : displayBtn=f' +
            'alse;//show/hides filter'#39's validation button'
          
            #9'f!=undefined && f["btn_text"]!=undefined ? btntext=f["btn_text"' +
            '] : btntext="go";//defines button text'
          
            #9'f!=undefined && f["enter_key"]==false ? enterkey=false : enterk' +
            'ey=true;//enables/disables enter key'
          
            #9'f!=undefined && f["mod_filter_fn"] ? modfilter_fn=true : modfil' +
            'ter_fn=false;//defines alternative fn'
          
            #9'f!=undefined && f["display_all_text"]!=undefined ? display_allT' +
            'ext=f["display_all_text"] : display_allText="";//defines 1st opt' +
            'ion text'
          
            #9'f!=undefined && f["on_change"]==false ? on_slcChange=false : on' +
            '_slcChange=true;//enables/disables onChange event on combo-box '
          
            #9'f!=undefined && f["rows_counter"]==true ? displaynrows=true : d' +
            'isplaynrows=false;//show/hides rows counter'
          
            #9'f!=undefined && f["rows_counter_text"]!=undefined ? totrows_tex' +
            't=f["rows_counter_text"] : totrows_text="Displayed rows: ";//def' +
            'ines rows counter text'
          
            #9'f!=undefined && f["btn_reset"]==true ? btnreset=true : btnreset' +
            '=false;//show/hides reset link'
          
            #9'f!=undefined && f["btn_reset_text"]!=undefined ? btnreset_text=' +
            'f["btn_reset_text"] : btnreset_text="Reset";//defines reset text'
          
            #9'f!=undefined && f["sort_select"]==true ? sort_slc=true : sort_s' +
            'lc=false;//enables/disables select options sorting'
          
            #9'f!=undefined && f["paging"]==true ? displayPaging=true : displa' +
            'yPaging=false;//enables/disables table paging'
          
            #9'f!=undefined && f["paging_length"]!=undefined ? pagingLength=f[' +
            '"paging_length"] : pagingLength=10;//defines table paging length'
          
            #9'f!=undefined && f["loader"]==true ? displayLoader=true : displa' +
            'yLoader=false;//enables/disables loader'
          
            #9'f!=undefined && f["loader_text"]!=undefined ? load_text=f["load' +
            'er_text"] : load_text="Loading...";//defines loader text'
          
            #9'f!=undefined && f["exact_match"]==true ? exactMatch=true : exac' +
            'tMatch=false;//enables/disbles exact match for search'
          
            #9'f!=undefined && f["alternate_rows"]==true ? alternateBgs=true :' +
            ' alternateBgs=false;//enables/disbles rows alternating bg colors'
          
            #9'f!=undefined && f["col_operation"] ? colOperation=true : colOpe' +
            'ration=false;//enables/disbles column operation(sum,mean)'
          
            #9'f!=undefined && f["rows_always_visible"] ? rowVisibility=true :' +
            ' rowVisibility=false;//makes a row always visible'
          
            #9'f!=undefined && f["col_width"] ? colWidth=true : colWidth=false' +
            ';//defines widths of columns'
          
            #9'f!=undefined && f["bind_script"] ? bindScript=true : bindScript' +
            '=false;'
          #9
          
            #9'// props are added to table in order to be easily accessible fr' +
            'om other fns'
          #9't.tf_fltGrid'#9#9#9'='#9'fltgrid;'
          #9't.tf_displayBtn'#9#9#9'= '#9'displayBtn;'
          #9't.tf_btnText'#9#9#9'='#9'btntext;'
          #9't.tf_enterKey'#9#9#9'= '#9'enterkey;'
          #9't.tf_isModfilter_fn'#9#9'= '#9'modfilter_fn;'
          #9't.tf_display_allText '#9'= '#9'display_allText;'
          #9't.tf_on_slcChange '#9#9'= '#9'on_slcChange;'
          #9't.tf_rowsCounter '#9#9'= '#9'displaynrows;'
          #9't.tf_rowsCounter_text'#9'= '#9'totrows_text;'
          #9't.tf_btnReset '#9#9#9'= '#9'btnreset;'
          #9't.tf_btnReset_text '#9#9'= '#9'btnreset_text;'
          #9't.tf_sortSlc '#9#9#9'='#9'sort_slc;'
          #9't.tf_displayPaging '#9#9'= '#9'displayPaging;'
          #9't.tf_pagingLength '#9#9'= '#9'pagingLength;'
          #9't.tf_displayLoader'#9#9'= '#9'displayLoader;'
          #9't.tf_loadText'#9#9#9'= '#9'load_text;'
          #9't.tf_exactMatch '#9#9'= '#9'exactMatch;'
          #9't.tf_alternateBgs'#9#9'='#9'alternateBgs;'
          #9't.tf_startPagingRow'#9#9'= '#9'0;'
          #9
          
            #9'if(modfilter_fn) t.tf_modfilter_fn = f["mod_filter_fn"];// used' +
            ' by DetectKey fn'
          ''
          #9'if(fltgrid)'
          #9'{'
          #9#9'var fltrow = t.insertRow(0); //adds filter row'
          #9#9'fltrow.className = "fltrow";'
          #9#9'for(var i=0; i<n; i++)// this loop adds filters'
          #9#9'{'
          #9#9#9'var fltcell = fltrow.insertCell(i);'
          #9#9#9'//fltcell.noWrap = true;'
          
            #9#9#9'i==n-1 && displayBtn==true ? inpclass = "flt_s" : inpclass = ' +
            '"flt";'
          #9#9#9
          
            #9#9#9'if(f==undefined || f["col_"+i]==undefined || f["col_"+i]=="no' +
            'ne") '
          #9#9#9'{'
          #9#9#9#9'var inptype;'
          
            #9#9#9#9'(f==undefined || f["col_"+i]==undefined) ? inptype="text" : ' +
            'inptype="hidden";//show/hide input'#9
          
            #9#9#9#9'var inp = createElm( "input",["id","flt"+i+"_"+id],["type",i' +
            'nptype],["class",inpclass] );'#9#9#9#9#9
          #9#9#9#9'inp.className = inpclass;// for ie<=6'
          #9#9#9#9'fltcell.appendChild(inp);'
          #9#9#9#9'if(enterkey) inp.onkeypress = DetectKey;'
          #9#9#9'}'
          #9#9#9'else if(f["col_"+i]=="select")'
          #9#9#9'{'
          
            #9#9#9#9'var slc = createElm( "select",["id","flt"+i+"_"+id],["class"' +
            ',inpclass] );'
          #9#9#9#9'slc.className = inpclass;// for ie<=6'
          #9#9#9#9'fltcell.appendChild(slc);'
          #9#9#9#9'PopulateOptions(id,i);'
          #9#9#9#9'if(displayPaging)//stores arguments for GroupByPage() fn'
          #9#9#9#9'{'
          #9#9#9#9#9'var args = new Array();'
          #9#9#9#9#9'args.push(id); args.push(i); args.push(n);'
          
            #9#9#9#9#9'args.push(display_allText); args.push(sort_slc); args.push(' +
            'displayPaging);'
          #9#9#9#9#9'SlcArgs.push(args);'
          #9#9#9#9'}'
          #9#9#9#9'if(enterkey) slc.onkeypress = DetectKey;'
          #9#9#9#9'if(on_slcChange) '
          #9#9#9#9'{'
          
            #9#9#9#9#9'(!modfilter_fn) ? slc.onchange = function(){ Filter(id); } ' +
            ': slc.onchange = f["mod_filter_fn"];'
          #9#9#9#9'} '
          #9#9#9'}'
          #9#9#9
          #9#9#9'if(i==n-1 && displayBtn==true)// this adds button'
          #9#9#9'{'
          #9#9#9#9'var btn = createElm('
          #9#9#9#9#9#9#9#9#9#9'"input",'
          #9#9#9#9#9#9#9#9#9#9'["id","btn"+i+"_"+id],["type","button"],'
          #9#9#9#9#9#9#9#9#9#9'["value",btntext],["class","btnflt"] '
          #9#9#9#9#9#9#9#9#9');'
          #9#9#9#9'btn.className = "btnflt";'
          #9#9#9#9
          #9#9#9#9'fltcell.appendChild(btn);'
          
            #9#9#9#9'(!modfilter_fn) ? btn.onclick = function(){ Filter(id); } : ' +
            'btn.onclick = f["mod_filter_fn"];'#9#9#9#9#9
          #9#9#9'}//if'#9#9
          #9#9#9
          #9#9'}// for i'#9#9
          #9'}//if fltgrid'
          ''
          #9'if(displaynrows || btnreset || displayPaging || displayLoader)'
          #9'{'
          #9#9
          #9#9'/*** div containing rows # displayer + reset btn ***/'
          
            #9#9'var infdiv = createElm( "div",["id","inf_"+id],["class","inf"]' +
            ' );'
          
            #9#9'infdiv.className = "inf";// setAttribute method for class attr' +
            'ibute doesn'#39't seem to work on ie<=6'
          #9#9't.parentNode.insertBefore(infdiv, t);'
          #9#9
          #9#9'if(displaynrows)'
          #9#9'{'
          #9#9#9'/*** left div containing rows # displayer ***/'
          #9#9#9'var totrows;'
          #9#9#9'var ldiv = createElm( "div",["id","ldiv_"+id] );'
          
            #9#9#9'displaynrows ? ldiv.className = "ldiv" : ldiv.style.display =' +
            ' "none";'
          
            #9#9#9'displayPaging ? totrows = pagingLength : totrows = getRowsNb(' +
            'id);'
          #9#9#9
          
            #9#9#9'var totrows_span = createElm( "span",["id","totrows_span_"+id' +
            '],["class","tot"] ); // tot # of rows displayer'
          #9#9#9'totrows_span.className = "tot";//for ie<=6'
          #9#9#9'totrows_span.appendChild( createText(totrows) );'
          #9#9
          #9#9#9'var totrows_txt = createText(totrows_text);'
          #9#9#9'ldiv.appendChild(totrows_txt);'
          #9#9#9'ldiv.appendChild(totrows_span);'
          #9#9#9'infdiv.appendChild(ldiv);'
          #9#9'}'
          #9#9
          #9#9'if(displayLoader)'
          #9#9'{'
          #9#9#9'/*** div containing loader  ***/'
          
            #9#9#9'var loaddiv = createElm( "div",["id","load_"+id],["class","lo' +
            'ader"] );'
          #9#9#9'loaddiv.className = "loader";// for ie<=6'
          #9#9#9'loaddiv.style.display = "none";'
          #9#9#9'loaddiv.appendChild( createText(load_text) );'#9
          #9#9#9'infdiv.appendChild(loaddiv);'
          #9#9'}'
          #9#9#9#9
          #9#9'if(displayPaging)'
          #9#9'{'
          #9#9#9'/*** mid div containing paging displayer ***/'
          #9#9#9'var mdiv = createElm( "div",["id","mdiv_"+id] );'
          
            #9#9#9'displayPaging ? mdiv.className = "mdiv" : mdiv.style.display ' +
            '= "none";'#9#9#9#9#9#9
          #9#9#9'infdiv.appendChild(mdiv);'
          #9#9#9
          #9#9#9'var start_row = t.tf_ref_row;'
          #9#9#9'var row = grabTag(t,"tr");'
          #9#9#9'var nrows = row.length;'
          
            #9#9#9'var npages = Math.ceil( (nrows - start_row)/pagingLength );//' +
            'calculates page nb'
          #9#9#9
          #9#9#9'var slcPages = createElm( "select",["id","slcPages_"+id] );'
          #9#9#9'slcPages.onchange = function(){'
          #9#9#9#9'if(displayLoader) showLoader(id,"");'
          #9#9#9#9't.tf_startPagingRow = this.value;'
          #9#9#9#9'GroupByPage(id);'
          #9#9#9#9'if(displayLoader) showLoader(id,"none");'
          #9#9#9'}'
          #9#9#9
          #9#9#9'var pgspan = createElm( "span",["id","pgspan_"+id] );'
          #9#9#9'grabEBI("mdiv_"+id).appendChild( createText(" Page ") );'
          #9#9#9'grabEBI("mdiv_"+id).appendChild(slcPages);'
          #9#9#9'grabEBI("mdiv_"+id).appendChild( createText(" of ") );'
          #9#9#9'pgspan.appendChild( createText(npages+" ") );'
          #9#9#9'grabEBI("mdiv_"+id).appendChild(pgspan);'#9
          #9#9#9
          
            #9#9#9'for(var j=start_row; j<nrows; j++)//this sets rows to validRo' +
            'w=true'
          #9#9#9'{'
          #9#9#9#9'row[j].setAttribute("validRow","true");'
          #9#9#9'}//for j'
          #9#9#9
          #9#9#9'setPagingInfo(id);'
          #9#9#9'if(displayLoader) showLoader(id,"none");'
          #9#9'}'
          #9#9
          #9#9'if(btnreset && fltgrid)'
          #9#9'{'
          #9#9#9'/*** right div containing reset button **/'#9
          #9#9#9'var rdiv = createElm( "div",["id","reset_"+id] );'
          
            #9#9#9'btnreset ? rdiv.className = "rdiv" : rdiv.style.display = "no' +
            'ne";'
          #9#9#9
          #9#9#9'var fltreset = createElm( '#9'"a",'
          
            #9#9#9#9#9#9#9#9#9#9'["href","javascript:clearFilters('#39'"+id+"'#39');Filter('#39'"+i' +
            'd+"'#39');"] );'
          #9#9#9'fltreset.appendChild(createText(btnreset_text));'
          #9#9#9'rdiv.appendChild(fltreset);'
          #9#9#9'infdiv.appendChild(rdiv);'
          #9#9'}'
          #9#9
          #9'}//if displaynrows etc.'
          #9
          #9'if(colWidth)'
          #9'{'
          #9#9't.tf_colWidth = f["col_width"];'
          #9#9'setColWidths(id);'
          #9'}'
          #9
          #9'if(alternateBgs && !displayPaging)'
          #9#9'setAlternateRows(id);'
          #9
          #9'if(colOperation)'
          #9'{'
          #9#9't.tf_colOperation = f["col_operation"];'
          #9#9'setColOperation(id);'
          #9'}'
          #9
          #9'if(rowVisibility)'
          #9'{'
          #9#9't.tf_rowVisibility = f["rows_always_visible"];'
          #9#9'if(displayPaging) setVisibleRows(id);'
          #9'}'
          #9
          #9'if(bindScript)'
          #9'{'
          #9#9't.tf_bindScript = f["bind_script"];'
          #9#9'if('#9't.tf_bindScript!=undefined &&'
          #9#9#9't.tf_bindScript["target_fn"]!=undefined )'
          #9#9'{//calls a fn if defined  '
          #9#9#9't.tf_bindScript["target_fn"].call(null,id);'
          #9#9'}'
          #9'}//if bindScript'
          '}'
          ''
          'function PopulateOptions(id,cellIndex)'
          '/*===================================================='
          #9'- populates select'
          #9'- adds only 1 occurence of a value'
          '=====================================================*/'
          '{'
          #9'var t = grabEBI(id);'
          #9'var ncells = t.tf_ncells, opt0txt = t.tf_display_allText;'
          #9'var sort_opts = t.tf_sortSlc, paging = t.tf_displayPaging;'
          #9'var start_row = t.tf_ref_row;'
          #9'var row = grabTag(t,"tr");'
          #9'var OptArray = new Array();'
          #9'var optIndex = 0; // option index'
          #9'var currOpt = new Option(opt0txt,"",false,false); //1st option'
          #9'grabEBI("flt"+cellIndex+"_"+id).options[optIndex] = currOpt;'
          #9
          #9'for(var k=start_row; k<row.length; k++)'
          #9'{'
          #9#9'var cell = getChildElms(row[k]).childNodes;'
          #9#9'var nchilds = cell.length;'
          #9#9'var isPaged = row[k].getAttribute("paging");'
          #9#9
          #9#9'if(nchilds == ncells){// checks if row has exact cell #'
          #9#9#9
          #9#9#9'for(var j=0; j<nchilds; j++)// this loop retrieves cell data'
          #9#9#9'{'
          #9#9#9#9'if(cellIndex==j)'
          #9#9#9#9'{'
          #9#9#9#9#9'var cell_data = getCellText(cell[j]);'
          #9#9#9#9#9'// checks if celldata is already in array'
          #9#9#9#9#9'var isMatched = false;'
          #9#9#9#9#9'for(w in OptArray)'
          #9#9#9#9#9'{'
          #9#9#9#9#9#9'if( cell_data == OptArray[w] ) isMatched = true;'
          #9#9#9#9#9'}'
          #9#9#9#9#9'if(!isMatched) OptArray.push(cell_data);'
          #9#9#9#9'}//if cellIndex==j'
          #9#9#9'}//for j'
          #9#9'}//if'
          #9'}//for k'
          #9
          #9'if(sort_opts) OptArray.sort();'
          #9'for(y in OptArray)'
          #9'{'
          #9#9'optIndex++;'
          #9#9'var currOpt = new Option(OptArray[y],OptArray[y],false,false);'
          #9#9'grabEBI("flt"+cellIndex+"_"+id).options[optIndex] = currOpt;'#9#9
          #9'}'
          #9#9
          '}'
          ''
          'function Filter(id)'
          '/*===================================================='
          #9'- Filtering fn'
          #9'- gets search strings from SearchFlt array'
          #9'- retrieves data from each td in every single tr'
          #9'and compares to search string for current'
          #9'column'
          #9'- tr is hidden if all search strings are not '
          #9'found'
          '=====================================================*/'
          '{'#9
          #9'showLoader(id,"");'
          #9'SearchFlt = getFilters(id);'
          #9'var t = grabEBI(id);'
          #9't.tf_Obj!=undefined ? fprops = t.tf_Obj : fprops = new Array();'
          #9'var SearchArgs = new Array();'
          #9'var ncells = getCellsNb(id);'
          #9'var totrows = getRowsNb(id), hiddenrows = 0;'
          #9'var ematch = t.tf_exactMatch;'
          #9'var showPaging = t.tf_displayPaging;'
          #9
          #9'for(var i=0; i<SearchFlt.length; i++)'
          
            #9#9'SearchArgs.push( (grabEBI(SearchFlt[i]).value).toLowerCase() )' +
            ';'
          #9
          #9'var start_row = t.tf_ref_row;'
          #9'var row = grabTag(t,"tr");'
          #9
          #9'for(var k=start_row; k<row.length; k++)'
          #9'{'
          #9#9'/*** if table already filtered some rows are not visible ***/'
          #9#9'if(row[k].style.display == "none") row[k].style.display = "";'
          #9#9
          #9#9'var cell = getChildElms(row[k]).childNodes;'
          #9#9'var nchilds = cell.length;'
          ''
          #9#9'if(nchilds == ncells)// checks if row has exact cell #'
          #9#9'{'
          #9#9#9'var cell_value = new Array();'
          #9#9#9'var occurence = new Array();'
          #9#9#9'var isRowValid = true;'
          #9#9#9#9
          #9#9#9'for(var j=0; j<nchilds; j++)// this loop retrieves cell data'
          #9#9#9'{'
          #9#9#9#9'var cell_data = getCellText(cell[j]).toLowerCase();'
          #9#9#9#9'cell_value.push(cell_data);'
          #9#9#9#9
          #9#9#9#9'if(SearchArgs[j]!="")'
          #9#9#9#9'{'
          #9#9#9#9#9'var num_cell_data = parseFloat(cell_data);'
          #9#9#9#9#9
          
            #9#9#9#9#9'if(/<=/.test(SearchArgs[j]) && !isNaN(num_cell_data)) // fi' +
            'rst checks if there is an operator (<,>,<=,>=)'
          #9#9#9#9#9'{'
          
            #9#9#9#9#9#9'num_cell_data <= parseFloat(SearchArgs[j].replace(/<=/,"")' +
            ') ? occurence[j] = true : occurence[j] = false;'
          #9#9#9#9#9'}'
          #9#9#9#9#9
          #9#9#9#9#9'else if(/>=/.test(SearchArgs[j]) && !isNaN(num_cell_data))'
          #9#9#9#9#9'{'
          
            #9#9#9#9#9#9'num_cell_data >= parseFloat(SearchArgs[j].replace(/>=/,"")' +
            ') ? occurence[j] = true : occurence[j] = false;'
          #9#9#9#9#9'}'
          #9#9#9#9#9
          #9#9#9#9#9'else if(/</.test(SearchArgs[j]) && !isNaN(num_cell_data))'
          #9#9#9#9#9'{'
          
            #9#9#9#9#9#9'num_cell_data < parseFloat(SearchArgs[j].replace(/</,"")) ' +
            '? occurence[j] = true : occurence[j] = false;'
          #9#9#9#9#9'}'
          #9#9#9#9#9#9#9#9#9#9
          #9#9#9#9#9'else if(/>/.test(SearchArgs[j]) && !isNaN(num_cell_data))'
          #9#9#9#9#9'{'
          
            #9#9#9#9#9#9'num_cell_data > parseFloat(SearchArgs[j].replace(/>/,"")) ' +
            '? occurence[j] = true : occurence[j] = false;'
          #9#9#9#9#9'}'#9#9#9#9#9
          #9#9#9#9#9
          #9#9#9#9#9'else '
          #9#9#9#9#9'{'#9#9#9#9#9#9
          #9#9#9#9#9#9'// Improved by Cedric Wartel (cwl)'
          
            #9#9#9#9#9#9'// automatic exact match for selects and special character' +
            's are now filtered'
          #9#9#9#9#9#9'// modif cwl : exact match automatique sur les select'
          #9#9#9#9#9#9'var regexp;'
          
            #9#9#9#9#9#9'if(ematch || fprops["col_"+j]=="select") regexp = new RegE' +
            'xp('#39'(^)'#39'+regexpEscape(SearchArgs[j])+'#39'($)'#39',"gi");'
          
            #9#9#9#9#9#9'else regexp = new RegExp(regexpEscape(SearchArgs[j]),"gi")' +
            ';'
          #9#9#9#9#9#9'occurence[j] = regexp.test(cell_data);'
          #9#9#9#9#9'}'
          #9#9#9#9'}//if SearchArgs'
          #9#9#9'}//for j'
          #9#9#9
          #9#9#9'for(var z=0; z<ncells; z++)'
          #9#9#9'{'
          #9#9#9#9'if(SearchArgs[z]!="" && !occurence[z]) isRowValid = false;'
          #9#9#9'}//for t'
          #9#9#9
          #9#9'}//if'
          #9#9
          #9#9'if(!isRowValid)'
          #9#9'{ '
          #9#9#9'row[k].style.display = "none"; hiddenrows++; '
          #9#9#9'if( showPaging ) row[k].setAttribute("validRow","false");'
          #9#9'} else {'
          #9#9#9'row[k].style.display = ""; '
          #9#9#9'if( showPaging ) row[k].setAttribute("validRow","true");'
          #9#9'}'
          #9#9
          #9'}// for k'
          #9
          #9't.tf_nRows = parseInt( getRowsNb(id) )-hiddenrows;'
          
            #9'if( !showPaging ) applyFilterProps(id);//applies filter props a' +
            'fter filtering process'
          
            #9'if( showPaging ){ t.tf_startPagingRow=0; setPagingInfo(id); }//' +
            'starts paging process'#9
          '}'
          ''
          'function setPagingInfo(id)'
          '/*===================================================='
          #9'- Paging fn'
          #9'- calculates page # according to valid rows'
          #9'- refreshes paging select according to page #'
          #9'- Calls GroupByPage fn'
          '=====================================================*/'
          '{'#9
          #9'var t = grabEBI(id);'
          #9'var start_row = parseInt( t.tf_ref_row );//filter start row'
          #9'var pagelength = t.tf_pagingLength;'
          #9'var row = grabTag(t,"tr");'#9
          #9'var mdiv = grabEBI("mdiv_"+id);'
          #9'var slcPages = grabEBI("slcPages_"+id);'
          #9'var pgspan = grabEBI("pgspan_"+id);'
          #9'var nrows = 0;'
          #9
          
            #9'for(var j=start_row; j<row.length; j++)//counts rows to be grou' +
            'ped '
          #9'{'
          #9#9'if(row[j].getAttribute("validRow") == "true") nrows++;'
          #9'}//for j'
          #9
          #9'var npg = Math.ceil( nrows/pagelength );//calculates page nb'
          #9'pgspan.innerHTML = npg; //refresh page nb span '
          #9'slcPages.innerHTML = "";//select clearing shortcut'
          #9
          #9'if( npg>0 )'
          #9'{'
          #9#9'mdiv.style.visibility = "visible";'
          #9#9'for(var z=0; z<npg; z++)'
          #9#9'{'
          #9#9#9'var currOpt = new Option((z+1),z*pagelength,false,false);'
          #9#9#9'slcPages.options[z] = currOpt;'
          #9#9'}'
          #9'} else {/*** if no results paging select is hidden ***/'
          #9#9'mdiv.style.visibility = "hidden";'
          #9'}'
          #9
          #9'GroupByPage(id);'
          '}'
          ''
          'function GroupByPage(id)'
          '/*===================================================='
          #9'- Paging fn'
          #9'- Displays current page rows'
          '=====================================================*/'
          '{'
          #9'showLoader(id,"");'
          #9'var t = grabEBI(id);'
          #9'var start_row = parseInt( t.tf_ref_row );//filter start row'
          #9'var pagelength = parseInt( t.tf_pagingLength );'
          
            #9'var paging_start_row = parseInt( t.tf_startPagingRow );//paging' +
            ' start row'
          #9'var paging_end_row = paging_start_row + pagelength;'
          #9'var row = grabTag(t,"tr");'
          #9'var nrows = 0;'
          #9'var validRows = new Array();//stores valid rows index'
          #9
          #9'for(var j=start_row; j<row.length; j++)'
          #9'//this loop stores valid rows index in validRows Array'
          #9'{'
          #9#9'var isRowValid = row[j].getAttribute("validRow");'
          #9#9'if(isRowValid=="true") validRows.push(j);'
          #9'}//for j'
          ''
          #9'for(h=0; h<validRows.length; h++)'
          #9'//this loop shows valid rows of current page'
          #9'{'
          #9#9'if( h>=paging_start_row && h<paging_end_row )'
          #9#9'{'
          #9#9#9'nrows++;'
          #9#9#9'row[ validRows[h] ].style.display = "";'
          #9#9'} else row[ validRows[h] ].style.display = "none";'
          #9'}//for h'
          #9
          #9't.tf_nRows = parseInt(nrows);'
          
            #9'applyFilterProps(id);//applies filter props after filtering pro' +
            'cess'
          '}'
          ''
          'function applyFilterProps(id)'
          '/*===================================================='
          #9'- checks fns that should be called'
          #9'after filtering and/or paging process'
          '=====================================================*/'
          '{'
          #9't = grabEBI(id);'
          #9'var rowsCounter = t.tf_rowsCounter;'
          #9'var nRows = t.tf_nRows;'
          #9'var rowVisibility = t.tf_rowVisibility;'
          #9'var alternateRows = t.tf_alternateBgs;'
          #9'var colOperation = t.tf_colOperation;'
          #9
          
            #9'if( rowsCounter ) showRowsCounter( id,parseInt(nRows) );//refre' +
            'shes rows counter'
          
            #9'if( rowVisibility ) setVisibleRows(id);//shows rows always visi' +
            'ble'
          #9'if( alternateRows ) setAlternateRows(id);//alterning row colors'
          
            #9'if( colOperation  ) setColOperation(id);//makes operation on a ' +
            'col'
          #9'showLoader(id,"none");'
          '}'
          ''
          'function hasGrid(id)'
          '/*===================================================='
          #9'- checks if table has a filter grid'
          #9'- returns a boolean'
          '=====================================================*/'
          '{'
          #9'var r = false, t = grabEBI(id);'
          #9'if(t != null && t.nodeName.toLowerCase() == "table")'
          #9'{'
          #9#9'for(i in TblId)'
          #9#9'{'
          #9#9#9'if(id == TblId[i]) r = true;'
          #9#9'}// for i'
          #9'}//if'
          #9'return r;'
          '}'
          ''
          'function getCellsNb(id,nrow)'
          '/*===================================================='
          #9'- returns number of cells in a row'
          #9'- if nrow param is passed returns number of cells '
          #9'of that specific row'
          '=====================================================*/'
          '{'
          '  '#9'var t = grabEBI(id);'
          #9'var tr;'
          #9'if(nrow == undefined) tr = grabTag(t,"tr")[0];'
          #9'else  tr = grabTag(t,"tr")[nrow];'
          #9'var n = getChildElms(tr);'
          #9'return n.childNodes.length;'
          '}'
          ''
          'function getRowsNb(id)'
          '/*===================================================='
          #9'- returns total nb of filterable rows starting '
          #9'from reference row if defined'
          '=====================================================*/'
          '{'
          #9'var t = grabEBI(id);'
          #9'var s = t.tf_ref_row;'
          #9'var ntrs = grabTag(t,"tr").length;'
          #9'return parseInt(ntrs-s);'
          '}'
          ''
          'function getFilters(id)'
          '/*===================================================='
          #9'- returns an array containing filters ids'
          #9'- Note that hidden filters are also returned'
          '=====================================================*/'
          '{'
          #9'var SearchFltId = new Array();'
          #9'var t = grabEBI(id);'
          #9'var tr = grabTag(t,"tr")[0];'
          #9'var enfants = tr.childNodes;'
          #9'if(t.tf_fltGrid)'
          #9'{'
          #9#9'for(var i=0; i<enfants.length; i++) '
          #9#9#9'SearchFltId.push(enfants[i].firstChild.getAttribute("id"));'#9#9
          #9'}'
          #9'return SearchFltId;'
          '}'
          ''
          'function clearFilters(id)'
          '/*===================================================='
          #9'- clears grid filters'
          '=====================================================*/'
          '{'
          #9'SearchFlt = getFilters(id);'
          #9'for(i in SearchFlt) grabEBI(SearchFlt[i]).value = "";'
          '}'
          ''
          'function showLoader(id,p)'
          '/*===================================================='
          #9'- displays/hides loader div'
          '=====================================================*/'
          '{'
          #9'var loader = grabEBI("load_"+id);'
          #9'if(loader != null && p=="none")'
          
            #9#9'setTimeout("grabEBI('#39'load_"+id+"'#39').style.display = '#39'"+p+"'#39'",15' +
            '0);'
          #9'else if(loader != null && p!="none") loader.style.display = p;'
          '}'
          ''
          'function showRowsCounter(id,p)'
          '/*===================================================='
          #9'- Shows total number of filtered rows'
          '=====================================================*/'
          '{'
          #9'var totrows = grabEBI("totrows_span_"+id);'
          
            #9'if(totrows != null && totrows.nodeName.toLowerCase() == "span" ' +
            ') '
          #9#9'totrows.innerHTML = p;'
          '}'
          ''
          'function getChildElms(n)'
          '/*===================================================='
          #9'- checks passed node is a ELEMENT_NODE nodeType=1'
          #9'- removes TEXT_NODE nodeType=3  '
          '=====================================================*/'
          '{'
          #9'if(n.nodeType == 1)'
          #9'{'
          #9#9'var enfants = n.childNodes;'
          #9#9'for(var i=0; i<enfants.length; i++)'
          #9#9'{'
          #9#9#9'var child = enfants[i];'
          #9#9#9'if(child.nodeType == 3) n.removeChild(child);'
          #9#9'}'
          #9#9'return n;'#9
          #9'}'
          '}'
          ''
          'function getCellText(n)'
          '/*===================================================='
          #9'- returns text + text of child nodes of a cell'
          '=====================================================*/'
          '{'
          #9'var s = "";'
          #9'var enfants = n.childNodes;'
          #9'for(var i=0; i<enfants.length; i++)'
          #9'{'
          #9#9'var child = enfants[i];'
          #9#9'if(child.nodeType == 3) s+= child.data;'
          #9#9'else s+= getCellText(child);'
          #9'}'
          #9'return s;'
          '}'
          ''
          'function getColValues(id,colindex,num)'
          '/*===================================================='
          #9'- returns an array containing cell values of'
          #9'a column'
          #9'- needs following args:'
          #9#9'- filter id (string)'
          #9#9'- column index (number)'
          #9#9'- a boolean set to true if we want only '
          #9#9'numbers to be returned'
          '=====================================================*/'
          '{'
          #9'var t = grabEBI(id);'
          #9'var row = grabTag(t,"tr");'
          #9'var nrows = row.length;'
          #9'var start_row = parseInt( t.tf_ref_row );//filter start row'
          #9'var ncells = getCellsNb( id,start_row );'
          #9'var colValues = new Array();'
          #9
          #9'for(var i=start_row; i<nrows; i++)//iterates rows'
          #9'{'
          #9#9'var cell = getChildElms(row[i]).childNodes;'
          #9#9'var nchilds = cell.length;'
          #9
          #9#9'if(nchilds == ncells)// checks if row has exact cell #'
          #9#9'{'
          #9#9#9'for(var j=0; j<nchilds; j++)// this loop retrieves cell data'
          #9#9#9'{'
          #9#9#9#9'if(j==colindex && row[i].style.display=="" )'
          #9#9#9#9'{'
          #9#9#9#9#9'var cell_data = getCellText( cell[j] ).toLowerCase();'
          
            #9#9#9#9#9'(num) ? colValues.push( parseFloat(cell_data) ) : colValues' +
            '.push( cell_data );'
          #9#9#9#9'}//if j==k'
          #9#9#9'}//for j'
          #9#9'}//if nchilds == ncells'
          #9'}//for i'
          #9'return colValues;'#9
          '}'
          ''
          'function setColWidths(id)'
          '/*===================================================='
          #9'- sets widths of columns'
          '=====================================================*/'
          '{'
          #9'if( hasGrid(id) )'
          #9'{'
          #9#9'var t = grabEBI(id);'
          #9#9't.style.tableLayout = "fixed";'
          #9#9'var colWidth = t.tf_colWidth;'
          #9#9'var start_row = parseInt( t.tf_ref_row );//filter start row'
          #9#9'var row = grabTag(t,"tr")[0];'
          #9#9'var ncells = getCellsNb(id,start_row);'
          #9#9'for(var i=0; i<colWidth.length; i++)'
          #9#9'{'
          #9#9#9'for(var k=0; k<ncells; k++)'
          #9#9#9'{'
          #9#9#9#9'cell = row.childNodes[k];'
          #9#9#9#9'if(k==i) cell.style.width = colWidth[i];'
          #9#9#9'}//var k'
          #9#9'}//for i'
          #9'}//if hasGrid'
          '}'
          ''
          'function setVisibleRows(id)'
          '/*===================================================='
          #9'- makes a row always visible'
          '=====================================================*/'
          '{'
          #9'if( hasGrid(id) )'
          #9'{'
          #9#9'var t = grabEBI(id);'#9#9
          #9#9'var row = grabTag(t,"tr");'
          #9#9'var nrows = row.length;'
          #9#9'var showPaging = t.tf_displayPaging;'
          #9#9'var visibleRows = t.tf_rowVisibility;'
          #9#9'for(var i=0; i<visibleRows.length; i++)'
          #9#9'{'
          #9#9#9'if(visibleRows[i]<=nrows)//row index cannot be > nrows'
          #9#9#9'{'
          #9#9#9#9'if(showPaging)'
          #9#9#9#9#9'row[ visibleRows[i] ].setAttribute("validRow","true");'
          #9#9#9#9'row[ visibleRows[i] ].style.display = "";'
          #9#9#9'}//if'
          #9#9'}//for i'
          #9'}//if hasGrid'
          '}'
          ''
          'function setAlternateRows(id)'
          '/*===================================================='
          #9'- alternates row colors for better readability'
          '=====================================================*/'
          '{'
          #9'if( hasGrid(id) )'
          #9'{'
          #9#9'var t = grabEBI(id);'#9#9
          #9#9'var row = grabTag(t,"tr");'
          #9#9'var nrows = row.length;'
          #9#9'var start_row = parseInt( t.tf_ref_row );//filter start row'
          #9#9'var visiblerows = new Array();'
          
            #9#9'for(var i=start_row; i<nrows; i++)//visible rows are stored in' +
            ' visiblerows array'
          #9#9#9'if( row[i].style.display=="" ) visiblerows.push(i);'
          #9#9
          #9#9'for(var j=0; j<visiblerows.length; j++)//alternates bg color'
          
            #9#9#9'(j % 2 == 0) ? row[ visiblerows[j] ].className = "even" : row' +
            '[ visiblerows[j] ].className = "odd";'
          #9#9
          #9'}//if hasGrid'
          '}'
          ''
          'function setColOperation(id)'
          '/*===================================================='
          #9'- Calculates values of a column'
          #9'- params are stored in '#39'colOperation'#39' table'#39's'
          #9'attribute'
          #9#9'- colOperation["id"] contains ids of elements '
          #9#9'showing result (array)'
          #9#9'- colOperation["col"] contains index of '
          #9#9'columns (array)'
          #9#9'- colOperation["operation"] contains operation'
          #9#9'type (array, values: sum, mean)'
          #9#9'- colOperation["write_method"] array defines '
          #9#9'which method to use for displaying the '
          #9#9'result (innerHTML, setValue, createTextNode).'
          #9#9'Note that innerHTML is the default value.'
          #9#9
          #9'!!! to be optimised'
          '=====================================================*/'
          '{'
          #9'if( hasGrid(id) )'
          #9'{'
          #9#9'var t = grabEBI(id);'
          #9#9'var labelId = t.tf_colOperation["id"];'
          #9#9'var colIndex = t.tf_colOperation["col"];'
          #9#9'var operation = t.tf_colOperation["operation"];'
          #9#9'var outputType =  t.tf_colOperation["write_method"];'
          #9#9'var precision = 2;//decimal precision'
          #9#9
          #9#9'if( (typeof labelId).toLowerCase()=="object" '
          #9#9#9'&& (typeof colIndex).toLowerCase()=="object" '
          #9#9#9'&& (typeof operation).toLowerCase()=="object" )'
          #9#9'{'
          #9#9#9'var row = grabTag(t,"tr");'
          #9#9#9'var nrows = row.length;'
          #9#9#9'var start_row = parseInt( t.tf_ref_row );//filter start row'
          #9#9#9'var ncells = getCellsNb( id,start_row );'
          #9#9#9'var colvalues = new Array();'
          #9#9#9#9#9#9
          
            #9#9#9'for(var k=0; k<colIndex.length; k++)//this retrieves col valu' +
            'es'
          #9#9#9'{'
          #9#9#9#9'colvalues.push( getColValues(id,colIndex[k],true) );'#9#9#9
          #9#9#9'}//for k'
          #9#9#9
          #9#9#9'for(var i=0; i<colvalues.length; i++)'
          #9#9#9'{'
          #9#9#9#9'var result=0, nbvalues=0;'
          #9#9#9#9'for(var j=0; j<colvalues[i].length; j++ )'
          #9#9#9#9'{'
          #9#9#9#9#9'var cvalue = colvalues[i][j];'
          #9#9#9#9#9'if( !isNaN(cvalue) )'
          #9#9#9#9#9'{'
          #9#9#9#9#9#9'switch( operation[i].toLowerCase() )'
          #9#9#9#9#9#9'{'
          #9#9#9#9#9#9#9'case "sum":'
          #9#9#9#9#9#9#9#9'result += parseFloat( cvalue );'
          #9#9#9#9#9#9#9'break;'
          #9#9#9#9#9#9#9'case "mean":'
          #9#9#9#9#9#9#9#9'nbvalues++;'
          #9#9#9#9#9#9#9#9'result += parseFloat( cvalue );'
          #9#9#9#9#9#9#9'break;'
          #9#9#9#9#9#9#9'//add cases for other operations'
          #9#9#9#9#9#9'}//switch'
          #9#9#9#9#9'}'
          #9#9#9#9'}//for j'
          #9#9#9#9
          #9#9#9#9'switch( operation[i].toLowerCase() )'
          #9#9#9#9'{'
          #9#9#9#9#9'case "mean":'
          #9#9#9#9#9#9'result = result/nbvalues;'
          #9#9#9#9#9'break;'
          #9#9#9#9'}'
          #9#9#9#9
          
            #9#9#9#9'if(outputType != undefined && (typeof outputType).toLowerCas' +
            'e()=="object")'
          #9#9#9#9'//if outputType is defined'
          #9#9#9#9'{'
          #9#9#9#9#9'result = result.toFixed( precision );'
          #9#9#9#9#9'if( grabEBI( labelId[i] )!=undefined )'
          #9#9#9#9#9'{'
          #9#9#9#9#9#9'switch( outputType[i].toLowerCase() )'
          #9#9#9#9#9#9'{'
          #9#9#9#9#9#9#9'case "innerhtml":'
          #9#9#9#9#9#9#9#9'grabEBI( labelId[i] ).innerHTML = result;'
          #9#9#9#9#9#9#9'break;'
          #9#9#9#9#9#9#9'case "setvalue":'
          #9#9#9#9#9#9#9#9'grabEBI( labelId[i] ).value = result;'
          #9#9#9#9#9#9#9'break;'
          #9#9#9#9#9#9#9'case "createtextnode":'
          #9#9#9#9#9#9#9#9'var oldnode = grabEBI( labelId[i] ).firstChild;'
          #9#9#9#9#9#9#9#9'var txtnode = createText( result );'
          #9#9#9#9#9#9#9#9'grabEBI( labelId[i] ).replaceChild( txtnode,oldnode );'
          #9#9#9#9#9#9#9'break;'
          #9#9#9#9#9#9#9'//other cases could be added'
          #9#9#9#9#9#9'}//switch'
          #9#9#9#9#9'}'
          #9#9#9#9'} else {'
          #9#9#9#9#9'try'
          #9#9#9#9#9'{'
          
            #9#9#9#9#9#9'grabEBI( labelId[i] ).innerHTML = result.toFixed( precisio' +
            'n );'
          #9#9#9#9#9'} catch(e){ }//catch'
          #9#9#9#9'}//else'
          #9#9#9#9
          #9#9#9'}//for i'
          ''
          #9#9'}//if typeof'
          #9'}//if hasGrid'
          '}'
          ''
          'function grabEBI(id)'
          '/*===================================================='
          #9'- this is just a getElementById shortcut'
          '=====================================================*/'
          '{'
          #9'return document.getElementById( id );'
          '}'
          ''
          'function grabTag(obj,tagname)'
          '/*===================================================='
          #9'- this is just a getElementsByTagName shortcut'
          '=====================================================*/'
          '{'
          #9'return obj.getElementsByTagName( tagname );'
          '}'
          ''
          'function regexpEscape(s)'
          '/*===================================================='
          #9'- escapes special characters [\^$.|?*+() '
          #9'for regexp'
          #9'- Many thanks to Cedric Wartel for this fn'
          '=====================================================*/'
          '{'
          #9'// traite les caract'#269'res sp'#233'ciaux [\^$.|?*+()'
          #9'//remplace le carct'#269're c par \c'
          #9'function escape(e)'
          #9'{'
          #9#9'a = new RegExp('#39'\\'#39'+e,'#39'g'#39');'
          #9#9's = s.replace(a,'#39'\\'#39'+e);'
          #9'}'
          ''
          
            #9'chars = new Array('#39'\\'#39','#39'['#39','#39'^'#39','#39'$'#39','#39'.'#39','#39'|'#39','#39'?'#39','#39'*'#39','#39'+'#39','#39'('#39','#39')'#39')' +
            ';'
          #9'//chars.each(escape); // no prototype framework here...'
          #9'for(e in chars) escape(chars[e]);'
          #9'return s;'
          '}'
          ''
          'function createElm(elm)'
          '/*===================================================='
          #9'- returns an html element with its attributes'
          #9'- accepts the following params:'
          #9#9'- a string defining the html element '
          #9#9'to create'
          #9#9'- an undetermined # of arrays containing the'
          #9#9'couple "attribute name","value" ["id","myId"]'
          '=====================================================*/'
          '{'
          #9'var el = document.createElement( elm );'#9#9
          #9'if(arguments.length>1)'
          #9'{'
          #9#9'for(var i=0; i<arguments.length; i++)'
          #9#9'{'
          #9#9#9'var argtype = typeof arguments[i];'
          #9#9#9'switch( argtype.toLowerCase() )'
          #9#9#9'{'
          #9#9#9#9'case "object":'
          #9#9#9#9#9'if( arguments[i].length==2 )'
          #9#9#9#9#9'{'#9#9#9#9#9#9#9
          #9#9#9#9#9#9'el.setAttribute( arguments[i][0],arguments[i][1] );'
          #9#9#9#9#9'}//if array length==2'
          #9#9#9#9'break;'
          #9#9#9'}//switch'
          #9#9'}//for i'
          #9'}//if args'
          #9'return el;'#9
          '}'
          ''
          'function createText(node)'
          '/*===================================================='
          #9'- this is just a document.createTextNode shortcut'
          '=====================================================*/'
          '{'
          #9'return document.createTextNode( node );'
          '}'
          ''
          'function DetectKey(e)'
          '/*===================================================='
          #9'- common fn that detects return key for a given'
          #9'element (onkeypress attribute on input)'
          '=====================================================*/'
          '{'
          #9'var evt=(e)?e:(window.event)?window.event:null;'
          #9'if(evt)'
          #9'{'
          #9#9'var key=(evt.charCode)?evt.charCode:'
          #9#9#9'((evt.keyCode)?evt.keyCode:((evt.which)?evt.which:0));'
          #9#9'if(key=="13")'
          #9#9'{'
          #9#9#9'var cid, leftstr, tblid, CallFn, Match;'#9#9
          #9#9#9'cid = this.getAttribute("id");'
          #9#9#9'leftstr = this.getAttribute("id").split("_")[0];'
          #9#9#9'tblid = cid.substring(leftstr.length+1,cid.length);'
          #9#9#9't = grabEBI(tblid);'
          
            #9#9#9'(t.tf_isModfilter_fn) ? t.tf_modfilter_fn.call() : Filter(tbl' +
            'id);'
          #9#9'}//if key'
          #9'}//if evt'#9
          '}'
          ''
          'function importScript(scriptName,scriptPath)'
          '{'
          #9'var isImported = false; '
          #9'var scripts = grabTag(document,"script");'
          ''
          #9'for (var i=0; i<scripts.length; i++)'
          #9'{'
          #9#9'if(scripts[i].src.match(scriptPath))'
          #9#9'{ '
          #9#9#9'isImported = true;'#9
          #9#9#9'break;'
          #9#9'}'
          #9'}'
          ''
          #9'if( !isImported )//imports script if not available'
          #9'{'
          #9#9'var head = grabTag(document,"head")[0];'
          #9#9'var extScript = createElm('#9'"script",'
          #9#9#9#9#9#9#9#9#9'["id",scriptName],'
          #9#9#9#9#9#9#9#9#9'["type","text/javascript"],'
          #9#9#9#9#9#9#9#9#9'["src",scriptPath]'#9');'
          #9#9'head.appendChild(extScript);'
          #9'}'
          '}//fn importScript'
          ''
          ''
          ''
          '/*===================================================='
          #9'- Below a collection of public functions '
          #9'for developement purposes'
          #9'- all public methods start with prefix '#39'TF_'#39
          #9'- These methods can be removed safely if not'
          #9'needed'
          '=====================================================*/'
          ''
          'function TF_GetFilterIds()'
          '/*===================================================='
          #9'- returns an array containing filter grids ids'
          '=====================================================*/'
          '{'
          #9'try{ return TblId }'
          
            #9'catch(e){ alert('#39'TF_GetFilterIds() fn: could not retrieve any i' +
            'ds'#39'); }'
          '}'
          ''
          'function TF_HasGrid(id)'
          '/*===================================================='
          #9'- checks if table has a filter grid'
          #9'- returns a boolean'
          '=====================================================*/'
          '{'
          #9'return hasGrid(id);'
          '}'
          ''
          'function TF_GetFilters(id)'
          '/*===================================================='
          #9'- returns an array containing filters ids of a'
          #9'specified grid'
          '=====================================================*/'
          '{'
          #9'try'
          #9'{'
          #9#9'var flts = getFilters(id);'
          #9#9'return flts;'
          #9'} catch(e) {'
          #9#9'alert('#39'TF_GetFilters() fn: table id not found'#39');'
          #9'}'
          #9
          '}'
          ''
          'function TF_GetStartRow(id)'
          '/*===================================================='
          #9'- returns starting row index for filtering'
          #9'process'
          '=====================================================*/'
          '{'
          #9'try'
          #9'{'
          #9#9'var t = grabEBI(id);'
          #9#9'return t.tf_ref_row;'
          #9'} catch(e) {'
          #9#9'alert('#39'TF_GetStartRow() fn: table id not found'#39');'
          #9'}'
          '}'
          ''
          'function TF_GetColValues(id,colindex,num)'
          '/*===================================================='
          #9'- returns an array containing cell values of'
          #9'a column'
          #9'- needs following args:'
          #9#9'- filter id (string)'
          #9#9'- column index (number)'
          #9#9'- a boolean set to true if we want only '
          #9#9'numbers to be returned'
          '=====================================================*/'
          '{'
          #9'if( hasGrid(id) )'
          #9'{'
          #9#9'return getColValues(id,colindex,num);'
          #9'}//if TF_HasGrid'
          #9'else alert('#39'TF_GetColValues() fn: table id not found'#39');'
          '}'
          ''
          'function TF_Filter(id)'
          '/*===================================================='
          #9'- filters a table'
          '=====================================================*/'
          '{'
          #9'var t = grabEBI(id);'
          #9'if( TF_HasGrid(id) ) Filter(id);'
          #9'else alert('#39'TF_Filter() fn: table id not found'#39');'
          '}'
          ''
          'function TF_RemoveFilterGrid(id)'
          '/*===================================================='
          #9'- removes a filter grid'
          '=====================================================*/'
          '{'
          #9'if( TF_HasGrid(id) )'
          #9'{'
          #9#9'var t = grabEBI(id);'
          #9#9'clearFilters(id);'
          #9#9#9#9
          #9#9'if(grabEBI("inf_"+id)!=null)'
          #9#9'{'
          #9#9#9't.parentNode.removeChild(t.previousSibling);'
          #9#9'}'
          #9#9'// remove paging here'
          #9#9'var row = grabTag(t,"tr");'
          #9#9
          #9#9'for(var j=0; j<row.length; j++)'
          #9#9'//this loop shows all rows and removes validRow attribute'
          #9#9'{'#9#9#9
          #9#9#9'row[j].style.display = "";'
          #9#9#9'try'
          #9#9#9'{ '
          #9#9#9#9'if( row[j].hasAttribute("validRow") ) '
          #9#9#9#9#9'row[j].removeAttribute("validRow");'
          #9#9#9'} //ie<=6 doesn'#39't support hasAttribute method'
          #9#9#9'catch(e){'
          #9#9#9#9'for( var x = 0; x < row[j].attributes.length; x++ ) '
          #9#9#9#9'{'
          
            #9#9#9#9#9'if( row[j].attributes[x].nodeName.toLowerCase()=="validrow"' +
            ' ) '
          #9#9#9#9#9#9'row[j].removeAttribute("validRow");'
          #9#9#9#9'}//for x'
          #9#9#9'}//catch(e)'
          #9#9'}//for j'#9#9
          #9#9
          #9#9'if( t.tf_alternateBgs )//removes alterning row colors'
          #9#9'{'
          #9#9#9'for(var k=0; k<row.length; k++)'
          #9#9#9'//this loop removes bg className'
          #9#9#9'{'
          #9#9#9#9'row[k].className = "";'
          #9#9#9'}'
          #9#9'}'
          #9#9
          #9#9'if(t.tf_fltGrid) t.deleteRow(0);'
          #9#9'for(i in TblId)//removes grid id value from array'
          #9#9#9'if(id == TblId[i]) TblId.splice(i,1);'
          #9#9
          #9'}//if TF_HasGrid'
          #9'else alert('#39'TF_RemoveFilterGrid() fn: table id not found'#39');'
          '}'
          ''
          'function TF_ClearFilters(id)'
          '/*===================================================='
          #9'- clears grid filters only, table is not filtered'
          '=====================================================*/'
          '{'
          #9'if( TF_HasGrid(id) ) clearFilters(id);'
          #9'else alert('#39'TF_ClearFilters() fn: table id not found'#39');'
          '}'
          ''
          'function TF_SetFilterValue(id,index,searcharg)'
          '/*===================================================='
          #9'- Inserts value in a specified filter'
          #9'- Params:'
          #9#9'- id: table id (string)'
          #9#9'- index: filter column index (numeric value)'
          #9#9'- searcharg: search string'
          '=====================================================*/'
          '{'
          #9'if( TF_HasGrid(id) )'
          #9'{'
          #9#9'var flts = getFilters(id);'
          #9#9'for(i in flts)'
          #9#9'{'
          #9#9#9'if( i==index ) grabEBI(flts[i]).value = searcharg;'
          #9#9'}'
          #9'} else {'
          #9#9'alert('#39'TF_SetFilterValue() fn: table id not found'#39');'
          #9'}'
          '}'
          ''
          ''
          ''
          ''
          '/*===================================================='
          #9'- bind an external script fns'
          #9'- fns below do not belong to filter grid script '
          #9'and are used to interface with external '
          #9'autocomplete script found at the following URL:'
          #9'http://www.codeproject.com/jscript/jsactb.asp'
          #9'(credit to zichun) '
          #9'- fns used to merge filter grid with external'
          #9'scripts'
          '=====================================================*/'
          'var colValues = new Array();'
          ''
          'function setAutoComplete(id)'
          '{'
          #9'var t = grabEBI(id);'
          #9'var bindScript = t.tf_bindScript;'
          #9'var scriptName = bindScript["name"];'
          #9'var scriptPath = bindScript["path"];'
          #9'initAutoComplete();'
          #9
          #9'function initAutoComplete()'
          #9'{'
          #9#9'var filters = TF_GetFilters(id);'
          #9#9'for(var i=0; i<filters.length; i++)'
          #9#9'{'
          #9#9#9'if( grabEBI(filters[i]).nodeName.toLowerCase()=="input")'
          #9#9#9'{'
          #9#9#9#9'colValues.push( getColValues(id,i) );'#9
          #9#9#9'} else colValues.push( '#39#39' );'
          #9#9'}//for i'
          ''
          #9#9'try{ actb( grabEBI(filters[0]), colValues[0] ); }'
          #9#9'catch(e){ alert(scriptPath + " script may not be loaded"); }'
          ''
          #9'}//fn'
          '}')
        TabOrder = 2
        Visible = False
        WordWrap = False
      end
      object filtergridcss: TMemo
        Left = 567
        Top = 96
        Width = 89
        Height = 73
        Lines.Strings = (
          '/*===================================================='
          #9'- HTML Table Filter Generator v1.6 '
          #9'elements and classes'
          #9'- edit classes below to change filter grid style'
          '=====================================================*/'
          ''
          '.fltrow{ /* filter grid row appearance */'
          #9'height:20px;'
          #9'background-color:#f4f4f4;'
          '}'
          '.btnflt{ /* button appearance */'
          #9'font-size:11px;'
          #9'margin:0 2px 0 2px; padding:0 1px 0 1px;'
          #9'text-decoration:none; color: #fff;'
          #9'background-color:#666;'
          '}'
          '.flt{ /* filter (input) appearance */'
          #9'background-color:#f4f4f4; border:1px inset #ccc; '
          #9'margin:0; width:100%;'
          '}'
          '.flt_s{ /* small filter (input) appearance */'
          #9'background-color:#f4f4f4; border:1px inset #ccc; '
          #9'margin:0; width:80%;'
          '}'
          '.inf{ /* div containing left, middle and right divs */'
          #9'clear:both; width:auto; height:20px; '
          #9'background:#f4f4f4; font-size:11px; '
          #9'margin:0; padding:1px 3px 1px 3px; '
          #9'border:1px solid #ccc;'
          '}'
          '.ldiv{ /* left div */'
          #9'float:left; width:30%; position:inherit; '
          '}'
          '.mdiv{ /* middle div */'
          #9'float:left; width:30%; position:inherit; text-align:center; '
          '}'
          '.rdiv{ /* right div */'
          #9'float:right; width:30%; position:inherit; text-align:right; '
          '}'
          '.loader{ /* loader appearance */'
          #9'position:absolute; padding: 15px 0 15px 0;'
          #9'margin-top:7%; width:200px; left:40%; '
          #9'z-index:1000; font-size:14px; font-weight:bold;'
          #9'border:1px solid #666; background:#f4f4f4; '
          #9'text-align:center; vertical-align:middle;'
          '}'
          'div.mdiv select{ height:20px; }/*paging drop-down list*/'
          'div.inf a{ color:#CC0000; }/*link appearence in .inf div*/'
          
            'div.inf a:hover{ text-decoration:none; }/*link appearence in .in' +
            'f div*/'
          '.tot{ font-weight:bold; }/*rows counter*/'
          '.even{ background-color:#fff; }/*row bg alternating color*/'
          '.odd{ background-color:#f4f4f4; }/*row bg alternating color*/'
          ''
          '')
        TabOrder = 3
        Visible = False
        WordWrap = False
      end
      object actbjs: TMemo
        Left = 567
        Top = 16
        Width = 89
        Height = 73
        Lines.Strings = (
          'function addEvent(obj,event_name,func_name){'
          #9'if (obj.attachEvent){'
          #9#9'obj.attachEvent("on"+event_name, func_name);'
          #9'}else if(obj.addEventListener){'
          #9#9'obj.addEventListener(event_name,func_name,true);'
          #9'}else{'
          #9#9'obj["on"+event_name] = func_name;'
          #9'}'
          '}'
          'function removeEvent(obj,event_name,func_name){'
          #9'if (obj.detachEvent){'
          #9#9'obj.detachEvent("on"+event_name,func_name);'
          #9'}else if(obj.removeEventListener){'
          #9#9'obj.removeEventListener(event_name,func_name,true);'
          #9'}else{'
          #9#9'obj["on"+event_name] = null;'
          #9'}'
          '}'
          'function stopEvent(evt){'
          #9'evt || window.event;'
          #9'if (evt.stopPropagation){'
          #9#9'evt.stopPropagation();'
          #9#9'evt.preventDefault();'
          #9'}else if(typeof evt.cancelBubble != "undefined"){'
          #9#9'evt.cancelBubble = true;'
          #9#9'evt.returnValue = false;'
          #9'}'
          #9'return false;'
          '}'
          'function getElement(evt){'
          #9'if (window.event){'
          #9#9'return window.event.srcElement;'
          #9'}else{'
          #9#9'return evt.currentTarget;'
          #9'}'
          '}'
          'function getTargetElement(evt){'
          #9'if (window.event){'
          #9#9'return window.event.srcElement;'
          #9'}else{'
          #9#9'return evt.target;'
          #9'}'
          '}'
          'function stopSelect(obj){'
          #9'if (typeof obj.onselectstart != '#39'undefined'#39'){'
          #9#9'addEvent(obj,"selectstart",function(){ return false;});'
          #9'}'
          '}'
          'function getCaretEnd(obj){'
          #9'if(typeof obj.selectionEnd != "undefined"){'
          #9#9'return obj.selectionEnd;'
          #9'}else if(document.selection&&document.selection.createRange){'
          #9#9'var M=document.selection.createRange();'
          #9#9'try{'
          #9#9#9'var Lp = M.duplicate();'
          #9#9#9'Lp.moveToElementText(obj);'
          #9#9'}catch(e){'
          #9#9#9'var Lp=obj.createTextRange();'
          #9#9'}'
          #9#9'Lp.setEndPoint("EndToEnd",M);'
          #9#9'var rb=Lp.text.length;'
          #9#9'if(rb>obj.value.length){'
          #9#9#9'return -1;'
          #9#9'}'
          #9#9'return rb;'
          #9'}'
          '}'
          'function getCaretStart(obj){'
          #9'if(typeof obj.selectionStart != "undefined"){'
          #9#9'return obj.selectionStart;'
          #9'}else if(document.selection&&document.selection.createRange){'
          #9#9'var M=document.selection.createRange();'
          #9#9'try{'
          #9#9#9'var Lp = M.duplicate();'
          #9#9#9'Lp.moveToElementText(obj);'
          #9#9'}catch(e){'
          #9#9#9'var Lp=obj.createTextRange();'
          #9#9'}'
          #9#9'Lp.setEndPoint("EndToStart",M);'
          #9#9'var rb=Lp.text.length;'
          #9#9'if(rb>obj.value.length){'
          #9#9#9'return -1;'
          #9#9'}'
          #9#9'return rb;'
          #9'}'
          '}'
          'function setCaret(obj,l){'
          #9'obj.focus();'
          #9'if (obj.setSelectionRange){'
          #9#9'obj.setSelectionRange(l,l);'
          #9'}else if(obj.createTextRange){'
          #9#9'm = obj.createTextRange();'#9#9
          #9#9'm.moveStart('#39'character'#39',l);'
          #9#9'm.collapse();'
          #9#9'm.select();'
          #9'}'
          '}'
          'function setSelection(obj,s,e){'
          #9'obj.focus();'
          #9'if (obj.setSelectionRange){'
          #9#9'obj.setSelectionRange(s,e);'
          #9'}else if(obj.createTextRange){'
          #9#9'm = obj.createTextRange();'#9#9
          #9#9'm.moveStart('#39'character'#39',s);'
          #9#9'm.moveEnd('#39'character'#39',e);'
          #9#9'm.select();'
          #9'}'
          '}'
          'String.prototype.addslashes = function(){'
          #9'return this.replace(/(["\\\.\|\[\]\^\*\+\?\$\(\)])/g, '#39'\\$1'#39');'
          '}'
          'String.prototype.trim = function () {'
          '    return this.replace(/^\s*(\S*(\s+\S+)*)\s*$/, "$1");'
          '};'
          'function curTop(obj){'
          #9'toreturn = 0;'
          #9'while(obj){'
          #9#9'toreturn += obj.offsetTop;'
          #9#9'obj = obj.offsetParent;'
          #9'}'
          #9'return toreturn;'
          '}'
          'function curLeft(obj){'
          #9'toreturn = 0;'
          #9'while(obj){'
          #9#9'toreturn += obj.offsetLeft;'
          #9#9'obj = obj.offsetParent;'
          #9'}'
          #9'return toreturn;'
          '}'
          'function isNumber(a) {'
          '    return typeof a == '#39'number'#39' && isFinite(a);'
          '}'
          'function replaceHTML(obj,text){'
          #9'while(el = obj.childNodes[0]){'
          #9#9'obj.removeChild(el);'
          #9'};'
          #9'obj.appendChild(document.createTextNode(text));'
          '}'
          ''
          'function actb(obj,ca){'
          #9'/* ---- Public Variables ---- */'
          
            #9'this.actb_timeOut = -1; // Autocomplete Timeout in ms (-1: auto' +
            'complete never time out)'
          
            #9'this.actb_lim = 4;    // Number of elements autocomplete can sh' +
            'ow (-1: no limit)'
          
            #9'this.actb_firstText = false; // should the auto complete be lim' +
            'ited to the beginning of keyword?'
          #9'this.actb_mouse = true; // Enable Mouse Support'
          
            #9'this.actb_delimiter = new Array('#39';'#39','#39','#39');  // Delimiter for mul' +
            'tiple autocomplete. Set it to empty array for single autocomplet' +
            'e'
          
            #9'this.actb_startcheck = 1; // Show widget only after this number' +
            ' of characters is typed in.'
          #9'/* ---- Public Variables ---- */'
          ''
          #9'/* --- Styles --- */'
          #9'this.actb_bgColor = '#39'#888888'#39';'
          #9'this.actb_textColor = '#39'#FFFFFF'#39';'
          #9'this.actb_hColor = '#39'#000000'#39';'
          #9'this.actb_fFamily = '#39'Verdana'#39';'
          #9'this.actb_fSize = '#39'11px'#39';'
          
            #9'this.actb_hStyle = '#39'text-decoration:underline;font-weight="bold' +
            '"'#39';'
          #9'/* --- Styles --- */'
          ''
          #9'/* ---- Private Variables ---- */'
          #9'var actb_delimwords = new Array();'
          #9'var actb_cdelimword = 0;'
          #9'var actb_delimchar = new Array();'
          #9'var actb_display = false;'
          #9'var actb_pos = 0;'
          #9'var actb_total = 0;'
          #9'var actb_curr = null;'
          #9'var actb_rangeu = 0;'
          #9'var actb_ranged = 0;'
          #9'var actb_bool = new Array();'
          #9'var actb_pre = 0;'
          #9'var actb_toid;'
          #9'var actb_tomake = false;'
          #9'var actb_getpre = "";'
          #9'var actb_mouse_on_list = 1;'
          #9'var actb_kwcount = 0;'
          #9'var actb_caretmove = false;'
          #9'this.actb_keywords = new Array();'
          #9'/* ---- Private Variables---- */'
          #9
          #9'this.actb_keywords = ca;'
          #9'var actb_self = this;'
          ''
          #9'actb_curr = obj;'
          #9
          #9'addEvent(actb_curr,"focus",actb_setup);'
          #9'function actb_setup(){'
          #9#9'addEvent(document,"keydown",actb_checkkey);'
          #9#9'addEvent(actb_curr,"blur",actb_clear);'
          #9#9'addEvent(document,"keypress",actb_keypress);'
          #9'}'
          ''
          #9'function actb_clear(evt){'
          #9#9'if (!evt) evt = event;'
          #9#9'removeEvent(document,"keydown",actb_checkkey);'
          #9#9'removeEvent(actb_curr,"blur",actb_clear);'
          #9#9'removeEvent(document,"keypress",actb_keypress);'
          #9#9'actb_removedisp();'
          #9'}'
          #9'function actb_parse(n){'
          #9#9'if (actb_self.actb_delimiter.length > 0){'
          #9#9#9'var t = actb_delimwords[actb_cdelimword].trim().addslashes();'
          #9#9#9'var plen = actb_delimwords[actb_cdelimword].trim().length;'
          #9#9'}else{'
          #9#9#9'var t = actb_curr.value.addslashes();'
          #9#9#9'var plen = actb_curr.value.length;'
          #9#9'}'
          #9#9'var tobuild = '#39#39';'
          #9#9'var i;'
          ''
          #9#9'if (actb_self.actb_firstText){'
          #9#9#9'var re = new RegExp("^" + t, "i");'
          #9#9'}else{'
          #9#9#9'var re = new RegExp(t, "i");'
          #9#9'}'
          #9#9'var p = n.search(re);'
          #9#9#9#9
          #9#9'for (i=0;i<p;i++){'
          #9#9#9'tobuild += n.substr(i,1);'
          #9#9'}'
          #9#9'tobuild += "<font style='#39'"+(actb_self.actb_hStyle)+"'#39'>"'
          #9#9'for (i=p;i<plen+p;i++){'
          #9#9#9'tobuild += n.substr(i,1);'
          #9#9'}'
          #9#9'tobuild += "</font>";'
          #9#9#9'for (i=plen+p;i<n.length;i++){'
          #9#9#9'tobuild += n.substr(i,1);'
          #9#9'}'
          #9#9'return tobuild;'
          #9'}'
          #9'function actb_generate(){'
          
            #9#9'if (document.getElementById('#39'tat_table'#39')){ actb_display = fals' +
            'e;document.body.removeChild(document.getElementById('#39'tat_table'#39')' +
            '); } '
          #9#9'if (actb_kwcount == 0){'
          #9#9#9'actb_display = false;'
          #9#9#9'return;'
          #9#9'}'
          #9#9'a = document.createElement('#39'table'#39');'
          #9#9'a.cellSpacing='#39'1px'#39';'
          #9#9'a.cellPadding='#39'2px'#39';'
          #9#9'a.style.position='#39'absolute'#39';'
          
            #9#9'a.style.top = eval(curTop(actb_curr) + actb_curr.offsetHeight)' +
            ' + "px";'
          #9#9'a.style.left = curLeft(actb_curr) + "px";'
          #9#9'a.style.backgroundColor=actb_self.actb_bgColor;'
          #9#9'a.id = '#39'tat_table'#39';'
          #9#9'document.body.appendChild(a);'
          #9#9'var i;'
          #9#9'var first = true;'
          #9#9'var j = 1;'
          #9#9'if (actb_self.actb_mouse){'
          #9#9#9'a.onmouseout = actb_table_unfocus;'
          #9#9#9'a.onmouseover = actb_table_focus;'
          #9#9'}'
          #9#9'var counter = 0;'
          #9#9'for (i=0;i<actb_self.actb_keywords.length;i++){'
          #9#9#9'if (actb_bool[i]){'
          #9#9#9#9'counter++;'
          #9#9#9#9'r = a.insertRow(-1);'
          #9#9#9#9'if (first && !actb_tomake){'
          #9#9#9#9#9'r.style.backgroundColor = actb_self.actb_hColor;'
          #9#9#9#9#9'first = false;'
          #9#9#9#9#9'actb_pos = counter;'
          #9#9#9#9'}else if(actb_pre == i){'
          #9#9#9#9#9'r.style.backgroundColor = actb_self.actb_hColor;'
          #9#9#9#9#9'first = false;'
          #9#9#9#9#9'actb_pos = counter;'
          #9#9#9#9'}else{'
          #9#9#9#9#9'r.style.backgroundColor = actb_self.actb_bgColor;'
          #9#9#9#9'}'
          #9#9#9#9'r.id = '#39'tat_tr'#39'+(j);'
          #9#9#9#9'c = r.insertCell(-1);'
          #9#9#9#9'c.style.color = actb_self.actb_textColor;'
          #9#9#9#9'c.style.fontFamily = actb_self.actb_fFamily;'
          #9#9#9#9'c.style.fontSize = actb_self.actb_fSize;'
          #9#9#9#9'c.innerHTML = actb_parse(actb_self.actb_keywords[i]);'
          #9#9#9#9'c.id = '#39'tat_td'#39'+(j);'
          #9#9#9#9'c.setAttribute('#39'pos'#39',j);'
          #9#9#9#9'if (actb_self.actb_mouse){'
          #9#9#9#9#9'c.style.cursor = '#39'pointer'#39';'
          #9#9#9#9#9'c.onclick=actb_mouseclick;'
          #9#9#9#9#9'c.onmouseover = actb_table_highlight;'
          #9#9#9#9'}'
          #9#9#9#9'j++;'
          #9#9#9'}'
          #9#9#9'if (j - 1 == actb_self.actb_lim && j < actb_total){'
          #9#9#9#9'r = a.insertRow(-1);'
          #9#9#9#9'r.style.backgroundColor = actb_self.actb_bgColor;'
          #9#9#9#9'c = r.insertCell(-1);'
          #9#9#9#9'c.style.color = actb_self.actb_textColor;'
          #9#9#9#9'c.style.fontFamily = '#39'arial narrow'#39';'
          #9#9#9#9'c.style.fontSize = actb_self.actb_fSize;'
          #9#9#9#9'c.align='#39'center'#39';'
          #9#9#9#9'replaceHTML(c,'#39'\\/'#39');'
          #9#9#9#9'if (actb_self.actb_mouse){'
          #9#9#9#9#9'c.style.cursor = '#39'pointer'#39';'
          #9#9#9#9#9'c.onclick = actb_mouse_down;'
          #9#9#9#9'}'
          #9#9#9#9'break;'
          #9#9#9'}'
          #9#9'}'
          #9#9'actb_rangeu = 1;'
          #9#9'actb_ranged = j-1;'
          #9#9'actb_display = true;'
          #9#9'if (actb_pos <= 0) actb_pos = 1;'
          #9'}'
          #9'function actb_remake(){'
          
            #9#9'document.body.removeChild(document.getElementById('#39'tat_table'#39')' +
            ');'
          #9#9'a = document.createElement('#39'table'#39');'
          #9#9'a.cellSpacing='#39'1px'#39';'
          #9#9'a.cellPadding='#39'2px'#39';'
          #9#9'a.style.position='#39'absolute'#39';'
          
            #9#9'a.style.top = eval(curTop(actb_curr) + actb_curr.offsetHeight)' +
            ' + "px";'
          #9#9'a.style.left = curLeft(actb_curr) + "px";'
          #9#9'a.style.backgroundColor=actb_self.actb_bgColor;'
          #9#9'a.id = '#39'tat_table'#39';'
          #9#9'if (actb_self.actb_mouse){'
          #9#9#9'a.onmouseout= actb_table_unfocus;'
          #9#9#9'a.onmouseover=actb_table_focus;'
          #9#9'}'
          #9#9'document.body.appendChild(a);'
          #9#9'var i;'
          #9#9'var first = true;'
          #9#9'var j = 1;'
          #9#9'if (actb_rangeu > 1){'
          #9#9#9'r = a.insertRow(-1);'
          #9#9#9'r.style.backgroundColor = actb_self.actb_bgColor;'
          #9#9#9'c = r.insertCell(-1);'
          #9#9#9'c.style.color = actb_self.actb_textColor;'
          #9#9#9'c.style.fontFamily = '#39'arial narrow'#39';'
          #9#9#9'c.style.fontSize = actb_self.actb_fSize;'
          #9#9#9'c.align='#39'center'#39';'
          #9#9#9'replaceHTML(c,'#39'/\\'#39');'
          #9#9#9'if (actb_self.actb_mouse){'
          #9#9#9#9'c.style.cursor = '#39'pointer'#39';'
          #9#9#9#9'c.onclick = actb_mouse_up;'
          #9#9#9'}'
          #9#9'}'
          #9#9'for (i=0;i<actb_self.actb_keywords.length;i++){'
          #9#9#9'if (actb_bool[i]){'
          #9#9#9#9'if (j >= actb_rangeu && j <= actb_ranged){'
          #9#9#9#9#9'r = a.insertRow(-1);'
          #9#9#9#9#9'r.style.backgroundColor = actb_self.actb_bgColor;'
          #9#9#9#9#9'r.id = '#39'tat_tr'#39'+(j);'
          #9#9#9#9#9'c = r.insertCell(-1);'
          #9#9#9#9#9'c.style.color = actb_self.actb_textColor;'
          #9#9#9#9#9'c.style.fontFamily = actb_self.actb_fFamily;'
          #9#9#9#9#9'c.style.fontSize = actb_self.actb_fSize;'
          #9#9#9#9#9'c.innerHTML = actb_parse(actb_self.actb_keywords[i]);'
          #9#9#9#9#9'c.id = '#39'tat_td'#39'+(j);'
          #9#9#9#9#9'c.setAttribute('#39'pos'#39',j);'
          #9#9#9#9#9'if (actb_self.actb_mouse){'
          #9#9#9#9#9#9'c.style.cursor = '#39'pointer'#39';'
          #9#9#9#9#9#9'c.onclick=actb_mouseclick;'
          #9#9#9#9#9#9'c.onmouseover = actb_table_highlight;'
          #9#9#9#9#9'}'
          #9#9#9#9#9'j++;'
          #9#9#9#9'}else{'
          #9#9#9#9#9'j++;'
          #9#9#9#9'}'
          #9#9#9'}'
          #9#9#9'if (j > actb_ranged) break;'
          #9#9'}'
          #9#9'if (j-1 < actb_total){'
          #9#9#9'r = a.insertRow(-1);'
          #9#9#9'r.style.backgroundColor = actb_self.actb_bgColor;'
          #9#9#9'c = r.insertCell(-1);'
          #9#9#9'c.style.color = actb_self.actb_textColor;'
          #9#9#9'c.style.fontFamily = '#39'arial narrow'#39';'
          #9#9#9'c.style.fontSize = actb_self.actb_fSize;'
          #9#9#9'c.align='#39'center'#39';'
          #9#9#9'replaceHTML(c,'#39'\\/'#39');'
          #9#9#9'if (actb_self.actb_mouse){'
          #9#9#9#9'c.style.cursor = '#39'pointer'#39';'
          #9#9#9#9'c.onclick = actb_mouse_down;'
          #9#9#9'}'
          #9#9'}'
          #9'}'
          #9'function actb_goup(){'
          #9#9'if (!actb_display) return;'
          #9#9'if (actb_pos == 1) return;'
          
            #9#9'document.getElementById('#39'tat_tr'#39'+actb_pos).style.backgroundCol' +
            'or = actb_self.actb_bgColor;'
          #9#9'actb_pos--;'
          #9#9'if (actb_pos < actb_rangeu) actb_moveup();'
          
            #9#9'document.getElementById('#39'tat_tr'#39'+actb_pos).style.backgroundCol' +
            'or = actb_self.actb_hColor;'
          #9#9'if (actb_toid) clearTimeout(actb_toid);'
          
            #9#9'if (actb_self.actb_timeOut > 0) actb_toid = setTimeout(functio' +
            'n(){actb_mouse_on_list=0;actb_removedisp();},actb_self.actb_time' +
            'Out);'
          #9'}'
          #9'function actb_godown(){'
          #9#9'if (!actb_display) return;'
          #9#9'if (actb_pos == actb_total) return;'
          
            #9#9'document.getElementById('#39'tat_tr'#39'+actb_pos).style.backgroundCol' +
            'or = actb_self.actb_bgColor;'
          #9#9'actb_pos++;'
          #9#9'if (actb_pos > actb_ranged) actb_movedown();'
          
            #9#9'document.getElementById('#39'tat_tr'#39'+actb_pos).style.backgroundCol' +
            'or = actb_self.actb_hColor;'
          #9#9'if (actb_toid) clearTimeout(actb_toid);'
          
            #9#9'if (actb_self.actb_timeOut > 0) actb_toid = setTimeout(functio' +
            'n(){actb_mouse_on_list=0;actb_removedisp();},actb_self.actb_time' +
            'Out);'
          #9'}'
          #9'function actb_movedown(){'
          #9#9'actb_rangeu++;'
          #9#9'actb_ranged++;'
          #9#9'actb_remake();'
          #9'}'
          #9'function actb_moveup(){'
          #9#9'actb_rangeu--;'
          #9#9'actb_ranged--;'
          #9#9'actb_remake();'
          #9'}'
          ''
          #9'/* Mouse */'
          #9'function actb_mouse_down(){'
          
            #9#9'document.getElementById('#39'tat_tr'#39'+actb_pos).style.backgroundCol' +
            'or = actb_self.actb_bgColor;'
          #9#9'actb_pos++;'
          #9#9'actb_movedown();'
          
            #9#9'document.getElementById('#39'tat_tr'#39'+actb_pos).style.backgroundCol' +
            'or = actb_self.actb_hColor;'
          #9#9'actb_curr.focus();'
          #9#9'actb_mouse_on_list = 0;'
          #9#9'if (actb_toid) clearTimeout(actb_toid);'
          
            #9#9'if (actb_self.actb_timeOut > 0) actb_toid = setTimeout(functio' +
            'n(){actb_mouse_on_list=0;actb_removedisp();},actb_self.actb_time' +
            'Out);'
          #9'}'
          #9'function actb_mouse_up(evt){'
          #9#9'if (!evt) evt = event;'
          #9#9'if (evt.stopPropagation){'
          #9#9#9'evt.stopPropagation();'
          #9#9'}else{'
          #9#9#9'evt.cancelBubble = true;'
          #9#9'}'
          
            #9#9'document.getElementById('#39'tat_tr'#39'+actb_pos).style.backgroundCol' +
            'or = actb_self.actb_bgColor;'
          #9#9'actb_pos--;'
          #9#9'actb_moveup();'
          
            #9#9'document.getElementById('#39'tat_tr'#39'+actb_pos).style.backgroundCol' +
            'or = actb_self.actb_hColor;'
          #9#9'actb_curr.focus();'
          #9#9'actb_mouse_on_list = 0;'
          #9#9'if (actb_toid) clearTimeout(actb_toid);'
          
            #9#9'if (actb_self.actb_timeOut > 0) actb_toid = setTimeout(functio' +
            'n(){actb_mouse_on_list=0;actb_removedisp();},actb_self.actb_time' +
            'Out);'
          #9'}'
          #9'function actb_mouseclick(evt){'
          #9#9'if (!evt) evt = event;'
          #9#9'if (!actb_display) return;'
          #9#9'actb_mouse_on_list = 0;'
          #9#9'actb_pos = this.getAttribute('#39'pos'#39');'
          #9#9'actb_penter();'
          #9'}'
          #9'function actb_table_focus(){'
          #9#9'actb_mouse_on_list = 1;'
          #9'}'
          #9'function actb_table_unfocus(){'
          #9#9'actb_mouse_on_list = 0;'
          #9#9'if (actb_toid) clearTimeout(actb_toid);'
          
            #9#9'if (actb_self.actb_timeOut > 0) actb_toid = setTimeout(functio' +
            'n(){actb_mouse_on_list = 0;actb_removedisp();},actb_self.actb_ti' +
            'meOut);'
          #9'}'
          #9'function actb_table_highlight(){'
          #9#9'actb_mouse_on_list = 1;'
          
            #9#9'document.getElementById('#39'tat_tr'#39'+actb_pos).style.backgroundCol' +
            'or = actb_self.actb_bgColor;'
          #9#9'actb_pos = this.getAttribute('#39'pos'#39');'
          #9#9'while (actb_pos < actb_rangeu) actb_moveup();'
          #9#9'while (actb_pos > actb_ranged) actb_movedown();'
          
            #9#9'document.getElementById('#39'tat_tr'#39'+actb_pos).style.backgroundCol' +
            'or = actb_self.actb_hColor;'
          #9#9'if (actb_toid) clearTimeout(actb_toid);'
          
            #9#9'if (actb_self.actb_timeOut > 0) actb_toid = setTimeout(functio' +
            'n(){actb_mouse_on_list = 0;actb_removedisp();},actb_self.actb_ti' +
            'meOut);'
          #9'}'
          #9'/* ---- */'
          ''
          #9'function actb_insertword(a){'
          #9#9'if (actb_self.actb_delimiter.length > 0){'
          #9#9#9'str = '#39#39';'
          #9#9#9'l=0;'
          #9#9#9'for (i=0;i<actb_delimwords.length;i++){'
          #9#9#9#9'if (actb_cdelimword == i){'
          #9#9#9#9#9'prespace = postspace = '#39#39';'
          #9#9#9#9#9'gotbreak = false;'
          #9#9#9#9#9'for (j=0;j<actb_delimwords[i].length;++j){'
          #9#9#9#9#9#9'if (actb_delimwords[i].charAt(j) != '#39' '#39'){'
          #9#9#9#9#9#9#9'gotbreak = true;'
          #9#9#9#9#9#9#9'break;'
          #9#9#9#9#9#9'}'
          #9#9#9#9#9#9'prespace += '#39' '#39';'
          #9#9#9#9#9'}'
          #9#9#9#9#9'for (j=actb_delimwords[i].length-1;j>=0;--j){'
          #9#9#9#9#9#9'if (actb_delimwords[i].charAt(j) != '#39' '#39') break;'
          #9#9#9#9#9#9'postspace += '#39' '#39';'
          #9#9#9#9#9'}'
          #9#9#9#9#9'str += prespace;'
          #9#9#9#9#9'str += a;'
          #9#9#9#9#9'l = str.length;'
          #9#9#9#9#9'if (gotbreak) str += postspace;'
          #9#9#9#9'}else{'
          #9#9#9#9#9'str += actb_delimwords[i];'
          #9#9#9#9'}'
          #9#9#9#9'if (i != actb_delimwords.length - 1){'
          #9#9#9#9#9'str += actb_delimchar[i];'
          #9#9#9#9'}'
          #9#9#9'}'
          #9#9#9'actb_curr.value = str;'
          #9#9#9'setCaret(actb_curr,l);'
          #9#9'}else{'
          #9#9#9'actb_curr.value = a;'
          #9#9'}'
          #9#9'actb_mouse_on_list = 0;'
          #9#9'actb_removedisp();'
          #9'}'
          #9'function actb_penter(){'
          #9#9'if (!actb_display) return;'
          #9#9'actb_display = false;'
          #9#9'var word = '#39#39';'
          #9#9'var c = 0;'
          #9#9'for (var i=0;i<=actb_self.actb_keywords.length;i++){'
          #9#9#9'if (actb_bool[i]) c++;'
          #9#9#9'if (c == actb_pos){'
          #9#9#9#9'word = actb_self.actb_keywords[i];'
          #9#9#9#9'break;'
          #9#9#9'}'
          #9#9'}'
          #9#9'actb_insertword(word);'
          #9#9'l = getCaretStart(actb_curr);'
          #9'}'
          #9'function actb_removedisp(){'
          #9#9'if (actb_mouse_on_list==0){'
          #9#9#9'actb_display = 0;'
          
            #9#9#9'if (document.getElementById('#39'tat_table'#39')){ document.body.remo' +
            'veChild(document.getElementById('#39'tat_table'#39')); }'
          #9#9#9'if (actb_toid) clearTimeout(actb_toid);'
          #9#9'}'
          #9'}'
          #9'function actb_keypress(e){'
          #9#9'if (actb_caretmove) stopEvent(e);'
          #9#9'return !actb_caretmove;'
          #9'}'
          #9'function actb_checkkey(evt){'
          #9#9'if (!evt) evt = event;'
          #9#9'a = evt.keyCode;'
          #9#9'caret_pos_start = getCaretStart(actb_curr);'
          #9#9'actb_caretmove = 0;'
          #9#9'switch (a){'
          #9#9#9'case 38:'
          #9#9#9#9'actb_goup();'
          #9#9#9#9'actb_caretmove = 1;'
          #9#9#9#9'return false;'
          #9#9#9#9'break;'
          #9#9#9'case 40:'
          #9#9#9#9'actb_godown();'
          #9#9#9#9'actb_caretmove = 1;'
          #9#9#9#9'return false;'
          #9#9#9#9'break;'
          #9#9#9'case 13: case 9:'
          #9#9#9#9'if (actb_display){'
          #9#9#9#9#9'actb_caretmove = 1;'
          #9#9#9#9#9'actb_penter();'
          #9#9#9#9#9'return false;'
          #9#9#9#9'}else{'
          #9#9#9#9#9'return true;'
          #9#9#9#9'}'
          #9#9#9#9'break;'
          #9#9#9'default:'
          #9#9#9#9'setTimeout(function(){actb_tocomplete(a)},50);'
          #9#9#9#9'break;'
          #9#9'}'
          #9'}'
          ''
          #9'function actb_tocomplete(kc){'
          #9#9'if (kc == 38 || kc == 40 || kc == 13) return;'
          #9#9'var i;'
          #9#9'if (actb_display){ '
          #9#9#9'var word = 0;'
          #9#9#9'var c = 0;'
          #9#9#9'for (var i=0;i<=actb_self.actb_keywords.length;i++){'
          #9#9#9#9'if (actb_bool[i]) c++;'
          #9#9#9#9'if (c == actb_pos){'
          #9#9#9#9#9'word = i;'
          #9#9#9#9#9'break;'
          #9#9#9#9'}'
          #9#9#9'}'
          #9#9#9'actb_pre = word;'
          #9#9'}else{ actb_pre = -1};'
          #9#9
          #9#9'if (actb_curr.value == '#39#39'){'
          #9#9#9'actb_mouse_on_list = 0;'
          #9#9#9'actb_removedisp();'
          #9#9#9'return;'
          #9#9'}'
          #9#9'if (actb_self.actb_delimiter.length > 0){'
          #9#9#9'caret_pos_start = getCaretStart(actb_curr);'
          #9#9#9'caret_pos_end = getCaretEnd(actb_curr);'
          #9#9#9
          #9#9#9'delim_split = '#39#39';'
          #9#9#9'for (i=0;i<actb_self.actb_delimiter.length;i++){'
          #9#9#9#9'delim_split += actb_self.actb_delimiter[i];'
          #9#9#9'}'
          #9#9#9'delim_split = delim_split.addslashes();'
          #9#9#9'delim_split_rx = new RegExp("(["+delim_split+"])");'
          #9#9#9'c = 0;'
          #9#9#9'actb_delimwords = new Array();'
          #9#9#9'actb_delimwords[0] = '#39#39';'
          
            #9#9#9'for (i=0,j=actb_curr.value.length;i<actb_curr.value.length;i+' +
            '+,j--){'
          
            #9#9#9#9'if (actb_curr.value.substr(i,j).search(delim_split_rx) == 0)' +
            '{'
          #9#9#9#9#9'ma = actb_curr.value.substr(i,j).match(delim_split_rx);'
          #9#9#9#9#9'actb_delimchar[c] = ma[1];'
          #9#9#9#9#9'c++;'
          #9#9#9#9#9'actb_delimwords[c] = '#39#39';'
          #9#9#9#9'}else{'
          #9#9#9#9#9'actb_delimwords[c] += actb_curr.value.charAt(i);'
          #9#9#9#9'}'
          #9#9#9'}'
          ''
          #9#9#9'var l = 0;'
          #9#9#9'actb_cdelimword = -1;'
          #9#9#9'for (i=0;i<actb_delimwords.length;i++){'
          
            #9#9#9#9'if (caret_pos_end >= l && caret_pos_end <= l + actb_delimwor' +
            'ds[i].length){'
          #9#9#9#9#9'actb_cdelimword = i;'
          #9#9#9#9'}'
          #9#9#9#9'l+=actb_delimwords[i].length + 1;'
          #9#9#9'}'
          #9#9#9'var ot = actb_delimwords[actb_cdelimword].trim(); '
          #9#9#9'var t = actb_delimwords[actb_cdelimword].addslashes().trim();'
          #9#9'}else{'
          #9#9#9'var ot = actb_curr.value;'
          #9#9#9'var t = actb_curr.value.addslashes();'
          #9#9'}'
          #9#9'if (ot.length == 0){'
          #9#9#9'actb_mouse_on_list = 0;'
          #9#9#9'actb_removedisp();'
          #9#9'}'
          #9#9'if (ot.length < actb_self.actb_startcheck) return this;'
          #9#9'if (actb_self.actb_firstText){'
          #9#9#9'var re = new RegExp("^" + t, "i");'
          #9#9'}else{'
          #9#9#9'var re = new RegExp(t, "i");'
          #9#9'}'
          ''
          #9#9'actb_total = 0;'
          #9#9'actb_tomake = false;'
          #9#9'actb_kwcount = 0;'
          #9#9'for (i=0;i<actb_self.actb_keywords.length;i++){'
          #9#9#9'actb_bool[i] = false;'
          #9#9#9'if (re.test(actb_self.actb_keywords[i])){'
          #9#9#9#9'actb_total++;'
          #9#9#9#9'actb_bool[i] = true;'
          #9#9#9#9'actb_kwcount++;'
          #9#9#9#9'if (actb_pre == i) actb_tomake = true;'
          #9#9#9'}'
          #9#9'}'
          ''
          #9#9'if (actb_toid) clearTimeout(actb_toid);'
          
            #9#9'if (actb_self.actb_timeOut > 0) actb_toid = setTimeout(functio' +
            'n(){actb_mouse_on_list = 0;actb_removedisp();},actb_self.actb_ti' +
            'meOut);'
          #9#9'actb_generate();'
          #9'}'
          #9'return this;'
          '}')
        TabOrder = 4
        Visible = False
        WordWrap = False
      end
      object KillSessions: TCheckBox
        Left = 7
        Top = 273
        Width = 491
        Height = 15
        Caption = 'Kasuj poprzednie sesje'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
    end
  end
end
