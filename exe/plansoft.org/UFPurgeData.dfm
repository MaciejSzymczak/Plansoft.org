inherited FPurgeData: TFPurgeData
  Left = 390
  Top = 225
  Width = 573
  Height = 359
  Caption = 'Usuwanie danych archiwalnych'
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 308
    Width = 565
  end
  object Pages: TPageControl
    Left = 0
    Top = 0
    Width = 565
    Height = 308
    ActivePage = Main
    Align = alClient
    MultiLine = True
    TabOrder = 1
    TabPosition = tpRight
    OnChange = PagesChange
    object Main: TTabSheet
      Caption = 'G'#322#243'wna'
      object MainPanel: TPanel
        Left = 0
        Top = 0
        Width = 538
        Height = 300
        Align = alClient
        TabOrder = 0
        object Label3: TLabel
          Left = 8
          Top = 192
          Width = 445
          Height = 60
          Caption = 
            'Zachowaj ostro'#380'no'#347#263' !'#13#10'Zostan'#261' usuni'#281'te wszystkie zaj'#281'cia w poda' +
            'nych datach, wszystkich planist'#243'w.'#13#10'Podczas usuwania nie b'#281'dzie ' +
            'brane pod uwag'#281' to, kto utworzy'#322' zaj'#281'cia, ani to, czy '#13#10'zalogowa' +
            'ny u'#380'ytkownik ma dost'#281'p do wyk'#322'adowc'#243'w, grup czy zasob'#243'w.'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clRed
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object GroupBox1: TGroupBox
          Left = 8
          Top = 48
          Width = 441
          Height = 145
          Caption = 'Usu'#324' r'#243'wnie'#380' '
          TabOrder = 1
          object Label2: TLabel
            Left = 117
            Top = 15
            Width = 285
            Height = 42
            Caption = 
              'Zostan'#261' usuni'#281'ci tylko wyk'#322'adowcy, grupy, zasoby '#13#10'lub przedmiot' +
              'y, kt'#243're by'#322'y u'#380'yte w usuwanym okresie i nie '#13#10'zosta'#322'y u'#380'yte w i' +
              'nnych okresach.'
          end
          object del_lec_flag: TCheckBox
            Left = 8
            Top = 16
            Width = 105
            Height = 17
            Caption = 'Wyk'#322'adowc'#243'w'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object del_gro_flag: TCheckBox
            Left = 8
            Top = 32
            Width = 105
            Height = 17
            Caption = 'Grupy'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object del_res_flag: TCheckBox
            Left = 8
            Top = 48
            Width = 105
            Height = 17
            Caption = 'Zasoby'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object del_sub_flag: TCheckBox
            Left = 8
            Top = 64
            Width = 105
            Height = 17
            Caption = 'Przedmioty'
            Checked = True
            State = cbChecked
            TabOrder = 3
          end
          object del_per_flag: TCheckBox
            Left = 8
            Top = 80
            Width = 105
            Height = 17
            Caption = 'Semestry'
            Checked = True
            State = cbChecked
            TabOrder = 4
          end
          object CheckBox1: TCheckBox
            Left = 8
            Top = 104
            Width = 233
            Height = 17
            Caption = 'Preferowane terminy'
            Enabled = False
            TabOrder = 5
          end
          object CheckBox2: TCheckBox
            Left = 8
            Top = 120
            Width = 105
            Height = 17
            Caption = 'Semestry'
            Enabled = False
            TabOrder = 6
          end
        end
        object GroupBox2: TGroupBox
          Left = 8
          Top = 0
          Width = 441
          Height = 49
          TabOrder = 0
          object Label1: TLabel
            Left = 8
            Top = 24
            Width = 261
            Height = 14
            Caption = 
              'Usu'#324' zaj'#281'cia od dnia                                          do' +
              ' dnia'
          end
          object date_from: TDateTimePicker
            Left = 112
            Top = 16
            Width = 113
            Height = 22
            Date = 40194.741385451390000000
            Time = 40194.741385451390000000
            ShowCheckbox = True
            TabOrder = 0
          end
          object Date_to: TDateTimePicker
            Left = 280
            Top = 16
            Width = 113
            Height = 22
            Date = 40194.741385451390000000
            Time = 40194.741385451390000000
            ShowCheckbox = True
            TabOrder = 1
          end
        end
        object Panel1: TPanel
          Left = 1
          Top = 258
          Width = 536
          Height = 41
          Align = alBottom
          TabOrder = 2
          object BCancel: TBitBtn
            Left = 381
            Top = 8
            Width = 75
            Height = 25
            Caption = 'Anuluj'
            TabOrder = 1
            OnClick = BCancelClick
            Kind = bkCancel
          end
          object BExecute: TBitBtn
            Left = 301
            Top = 8
            Width = 75
            Height = 25
            Caption = 'Usu'#324
            Enabled = False
            TabOrder = 2
            OnClick = BExecuteClick
            Kind = bkOK
          end
          object BPreview: TBitBtn
            Left = 8
            Top = 8
            Width = 224
            Height = 25
            Caption = 'Poka'#380', jakie dane zostan'#261' usuni'#281'te'
            TabOrder = 0
            OnClick = BPreviewClick
          end
        end
      end
    end
    object Preview: TTabSheet
      Caption = 'Podgl'#261'd'
      ImageIndex = 1
      object PreviewPanel: TPanel
        Left = 0
        Top = 0
        Width = 538
        Height = 300
        Align = alClient
        TabOrder = 0
        object Panel4: TPanel
          Left = 1
          Top = 258
          Width = 536
          Height = 41
          Align = alBottom
          TabOrder = 0
          object BitBtn2: TBitBtn
            Left = 8
            Top = 8
            Width = 185
            Height = 25
            Caption = '<< Okno parametr'#243'w'
            TabOrder = 0
            OnClick = BitBtn2Click
          end
          object BExecute2: TBitBtn
            Left = 280
            Top = 8
            Width = 75
            Height = 25
            Caption = 'Usu'#324
            Enabled = False
            TabOrder = 1
            OnClick = BExecuteClick
            Kind = bkOK
          end
          object BitBtn3: TBitBtn
            Left = 360
            Top = 8
            Width = 75
            Height = 25
            Caption = 'Anuluj'
            TabOrder = 2
            OnClick = BCancelClick
            Kind = bkCancel
          end
        end
        object Grupy: TPageControl
          Left = 1
          Top = 1
          Width = 536
          Height = 257
          ActivePage = TabSheet6
          Align = alClient
          TabOrder = 1
          object TabSheet1: TTabSheet
            Caption = 'Wyk'#322'adowcy'
            object DBGrid1: TDBGrid
              Left = 0
              Top = 0
              Width = 439
              Height = 192
              Align = alClient
              DataSource = dsl
              Options = [dgEditing, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = EASTEUROPE_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Arial'
              TitleFont.Style = []
            end
          end
          object TabSheet2: TTabSheet
            Caption = 'Grupy'
            ImageIndex = 1
            object DBGrid2: TDBGrid
              Left = 0
              Top = 0
              Width = 439
              Height = 192
              Align = alClient
              DataSource = dsg
              Options = [dgEditing, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = EASTEUROPE_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Arial'
              TitleFont.Style = []
            end
          end
          object TabSheet3: TTabSheet
            Caption = 'Zasoby'
            ImageIndex = 2
            object DBGrid3: TDBGrid
              Left = 0
              Top = 0
              Width = 439
              Height = 192
              Align = alClient
              DataSource = dsr
              Options = [dgEditing, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = EASTEUROPE_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Arial'
              TitleFont.Style = []
            end
          end
          object TabSheet4: TTabSheet
            Caption = 'Przemioty'
            ImageIndex = 3
            object DBGrid4: TDBGrid
              Left = 0
              Top = 0
              Width = 439
              Height = 192
              Align = alClient
              DataSource = dss
              Options = [dgEditing, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = EASTEUROPE_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Arial'
              TitleFont.Style = []
            end
          end
          object TabSheet5: TTabSheet
            Caption = 'Semestry'
            ImageIndex = 4
            object DBGrid5: TDBGrid
              Left = 0
              Top = 0
              Width = 439
              Height = 192
              Align = alClient
              DataSource = dsp
              Options = [dgEditing, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = EASTEUROPE_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Arial'
              TitleFont.Style = []
            end
          end
          object TabSheet6: TTabSheet
            Caption = 'Podsumowanie'
            ImageIndex = 5
            object Label4: TLabel
              Left = 8
              Top = 40
              Width = 69
              Height = 14
              Caption = 'Wyk'#322'adowcy: '
            end
            object Label5: TLabel
              Left = 8
              Top = 56
              Width = 33
              Height = 14
              Caption = 'Grupy:'
            end
            object Label6: TLabel
              Left = 8
              Top = 72
              Width = 43
              Height = 14
              Caption = 'Zasoby: '
            end
            object Label7: TLabel
              Left = 8
              Top = 88
              Width = 59
              Height = 14
              Caption = 'Przedmioty: '
            end
            object Label8: TLabel
              Left = 8
              Top = 104
              Width = 49
              Height = 14
              Caption = 'Semestry:'
            end
            object L: TLabel
              Left = 80
              Top = 40
              Width = 6
              Height = 14
              Caption = '..'
            end
            object G: TLabel
              Left = 80
              Top = 56
              Width = 6
              Height = 14
              Caption = '..'
            end
            object R: TLabel
              Left = 80
              Top = 72
              Width = 9
              Height = 14
              Caption = '...'
            end
            object S: TLabel
              Left = 80
              Top = 88
              Width = 6
              Height = 14
              Caption = '..'
            end
            object P: TLabel
              Left = 80
              Top = 104
              Width = 6
              Height = 14
              Caption = '..'
            end
            object Label9: TLabel
              Left = 8
              Top = 24
              Width = 38
              Height = 14
              Caption = 'Zaj'#281'cia:'
            end
            object C: TLabel
              Left = 80
              Top = 24
              Width = 94
              Height = 14
              Caption = '<trwaj'#261' obliczenia>'
            end
            object Label10: TLabel
              Left = 8
              Top = 8
              Width = 308
              Height = 15
              Caption = 'Po naci'#347'ni'#281'ciu przycisku Usu'#324' zostan'#261' usuni'#281'te obiekty:'
              Font.Charset = EASTEUROPE_CHARSET
              Font.Color = clRed
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object BSave: TBitBtn
              Left = 8
              Top = 128
              Width = 137
              Height = 25
              Caption = 'Zachowaj w pliku'
              TabOrder = 0
              OnClick = BSaveClick
            end
          end
        end
      end
    end
  end
  object dsl: TDataSource
    DataSet = ql
    Left = 473
    Top = 30
  end
  object dsg: TDataSource
    DataSet = qg
    Left = 473
    Top = 70
  end
  object dss: TDataSource
    DataSet = qs
    Left = 473
    Top = 134
  end
  object dsr: TDataSource
    DataSet = qr
    Left = 473
    Top = 106
  end
  object dsp: TDataSource
    DataSet = qp
    Left = 473
    Top = 166
  end
  object ql: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    Parameters = <>
    Left = 388
    Top = 56
  end
  object qg: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    Parameters = <>
    Left = 412
    Top = 84
  end
  object qr: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    Parameters = <>
    Left = 388
    Top = 116
  end
  object qs: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    Parameters = <>
    Left = 388
    Top = 148
  end
  object qp: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    Parameters = <>
    Left = 388
    Top = 188
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'txt'
    FileName = 'Report'
    Filter = 'txt|*.txt'
    Left = 17
    Top = 190
  end
end
