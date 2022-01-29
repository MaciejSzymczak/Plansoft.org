inherited FUSOS: TFUSOS
  Left = 521
  Top = 223
  Width = 1003
  Height = 737
  Caption = 'USOS: Integracja'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 686
    Width = 995
  end
  object Panel1: TPanel
    Left = 0
    Top = 645
    Width = 995
    Height = 41
    Align = alBottom
    TabOrder = 1
    object BZamknij: TBitBtn
      Left = 911
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
      OnClick = BZamknijClick
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 995
    Height = 169
    Align = alTop
    TabOrder = 2
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 993
      Height = 167
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Podstawowe'
        object Label1: TLabel
          Left = 24
          Top = 16
          Width = 47
          Height = 14
          Caption = 'Kod cyklu'
        end
        object USOS_CYKL: TEdit
          Left = 24
          Top = 32
          Width = 121
          Height = 22
          TabOrder = 0
          Text = 'USOS_CYKL'
        end
        object BitBtn2: TBitBtn
          Left = 152
          Top = 16
          Width = 257
          Height = 41
          Caption = 'Uruchom synchronizacj'#281' USOS --> Plansoft'
          TabOrder = 1
          OnClick = BitBtn2Click
        end
        object BitBtn1: TBitBtn
          Left = 152
          Top = 64
          Width = 257
          Height = 41
          Caption = 'Uruchom synchronizacj'#281' Plansoft --> USOS'
          TabOrder = 2
          OnClick = BitBtn1Click
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Konfiguracja'
        ImageIndex = 1
        object Label2: TLabel
          Left = 24
          Top = 16
          Width = 103
          Height = 14
          Caption = 'Liczba godzin w dniu'
        end
        object LRESCAT_COMB_ID: TLabel
          Left = 48
          Top = 44
          Width = 82
          Height = 14
          Caption = 'Typ ograniczenia'
        end
        object Label3: TLabel
          Left = 16
          Top = 68
          Width = 118
          Height = 14
          Caption = 'U'#380'ytkownik integracyjny'
        end
        object Label4: TLabel
          Left = 16
          Top = 100
          Width = 60
          Height = 14
          Caption = 'Sala ONLINE'
        end
        object USOS_HOURS_PER_DAY: TEdit
          Left = 136
          Top = 8
          Width = 121
          Height = 22
          TabOrder = 0
          Text = 'USOS_HOURS_PER_DAY'
        end
        object RESCAT_COMB_ID_VALUE: TEdit
          Left = 136
          Top = 35
          Width = 301
          Height = 22
          ReadOnly = True
          TabOrder = 1
        end
        object RESCAT_COMB_IDSel: TBitBtn
          Left = 440
          Top = 35
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = RESCAT_COMB_IDSelClick
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
        object RESCAT_COMB_ID: TEdit
          Left = 472
          Top = 32
          Width = 121
          Height = 22
          TabOrder = 3
          Text = 'RESCAT_COMB_ID'
          Visible = False
          OnChange = RESCAT_COMB_IDChange
        end
        object USOS_INTEGRATION_USER: TEdit
          Left = 136
          Top = 64
          Width = 121
          Height = 22
          TabOrder = 4
          Text = 'USOS_USER'
        end
        object USOS_ONLINE: TEdit
          Left = 136
          Top = 96
          Width = 121
          Height = 22
          TabOrder = 5
          Text = 'USOS_ONLINE'
        end
      end
    end
  end
  object Grid: TRxDBGrid
    Left = 0
    Top = 169
    Width = 995
    Height = 476
    Align = alClient
    DataSource = Source
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgTitles, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    TitleButtons = True
    Columns = <
      item
        Expanded = False
        FieldName = 'CREATED'
        Title.Caption = 'Uruchomiono'
        Width = 171
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MESSAGE'
        Title.Caption = 'Komunikat'
        Width = 1000
        Visible = True
      end>
  end
  object Source: TDataSource
    DataSet = Query
    Left = 64
    Top = 136
  end
  object Query: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select message, to_char(created,'#39'yyyy-mm-dd hh24:mi:ss'#39') created' +
        ' from xxmsztools_eventlog where module_name in  ('#39'INTEGRATION_US' +
        'OS'#39','#39'INTEGRATION_TO_USOS'#39','#39'INTEGRATION_FROM_USOS'#39') order by id d' +
        'esc')
    Left = 28
    Top = 132
  end
end
