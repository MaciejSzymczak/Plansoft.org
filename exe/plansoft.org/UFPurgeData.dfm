inherited FPurgeData: TFPurgeData
  Left = 502
  Top = 201
  Width = 484
  Height = 325
  Caption = 'Usuwanie danych archiwalnych'
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 120
  TextHeight = 16
  inherited Status: TPanel
    Top = 266
    Width = 476
  end
  object Pages: TPageControl
    Left = 0
    Top = 0
    Width = 476
    Height = 266
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
        Width = 446
        Height = 258
        Align = alClient
        TabOrder = 0
        object Label3: TLabel
          Left = 9
          Top = 183
          Width = 489
          Height = 64
          Caption = 
            'Zachowaj ostro'#380'no'#347#263' !'#13#10'Zostan'#261' usuni'#281'te wszystkie dane spe'#322'niaj'#261 +
            'ce podane kryteria, wszystkich planist'#243'w.'#13#10'Podczas usuwania nie ' +
            'b'#281'dzie brane pod uwag'#281' to, kto utworzy'#322' zaj'#281'cia, ani to, czy '#13#10'z' +
            'alogowany u'#380'ytkownik ma dost'#281'p do wyk'#322'adowc'#243'w, grup czy zasob'#243'w.'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object GroupBox1: TGroupBox
          Left = 9
          Top = 55
          Width = 495
          Height = 120
          Caption = 'Usu'#324' r'#243'wnie'#380' '
          TabOrder = 1
          object Label2: TLabel
            Left = 134
            Top = 17
            Width = 363
            Height = 48
            Caption = 
              'Zostan'#261' usuni'#281'ci tylko wyk'#322'adowcy, grupy, zasoby '#13#10'lub przedmiot' +
              'y, kt'#243're by'#322'y u'#380'yte w usuwanym okresie i nie '#13#10'zosta'#322'y u'#380'yte w i' +
              'nnych okresach.'
          end
          object del_lec_flag: TCheckBox
            Left = 9
            Top = 18
            Width = 120
            Height = 20
            Caption = 'Wyk'#322'adowc'#243'w'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object del_gro_flag: TCheckBox
            Left = 9
            Top = 37
            Width = 120
            Height = 19
            Caption = 'Grupy'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object del_res_flag: TCheckBox
            Left = 9
            Top = 55
            Width = 120
            Height = 19
            Caption = 'Zasoby'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object del_sub_flag: TCheckBox
            Left = 9
            Top = 73
            Width = 120
            Height = 20
            Caption = 'Przedmioty'
            Checked = True
            State = cbChecked
            TabOrder = 3
          end
          object del_per_flag: TCheckBox
            Left = 9
            Top = 91
            Width = 120
            Height = 20
            Caption = 'Semestry'
            Checked = True
            State = cbChecked
            TabOrder = 4
          end
        end
        object GroupBox2: TGroupBox
          Left = 9
          Top = 0
          Width = 495
          Height = 56
          TabOrder = 0
          object Label1: TLabel
            Left = 9
            Top = 27
            Width = 345
            Height = 16
            Caption = 
              'Usu'#324' zaj'#281'cia od dnia                                          do' +
              ' dnia'
          end
          object date_from: TDateTimePicker
            Left = 128
            Top = 18
            Width = 129
            Height = 22
            Date = 40194.741385451390000000
            Time = 40194.741385451390000000
            ShowCheckbox = True
            TabOrder = 0
          end
          object Date_to: TDateTimePicker
            Left = 320
            Top = 18
            Width = 129
            Height = 22
            Date = 40194.741385451390000000
            Time = 40194.741385451390000000
            ShowCheckbox = True
            TabOrder = 1
          end
        end
        object Panel1: TPanel
          Left = 1
          Top = 210
          Width = 444
          Height = 47
          Align = alBottom
          TabOrder = 2
          object BCancel: TBitBtn
            Left = 411
            Top = 9
            Width = 86
            Height = 29
            Caption = 'Anuluj'
            TabOrder = 1
            OnClick = BCancelClick
            Kind = bkCancel
          end
          object BExecute: TBitBtn
            Left = 320
            Top = 9
            Width = 86
            Height = 29
            Caption = 'Usu'#324
            Enabled = False
            TabOrder = 2
            OnClick = BExecuteClick
            Kind = bkOK
          end
          object BPreview: TBitBtn
            Left = 9
            Top = 9
            Width = 212
            Height = 29
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
        Width = 446
        Height = 258
        Align = alClient
        TabOrder = 0
        object Panel4: TPanel
          Left = 1
          Top = 210
          Width = 444
          Height = 47
          Align = alBottom
          TabOrder = 0
          object BitBtn2: TBitBtn
            Left = 9
            Top = 9
            Width = 212
            Height = 29
            Caption = '<< Okno parametr'#243'w'
            TabOrder = 0
            OnClick = BitBtn2Click
          end
          object BExecute2: TBitBtn
            Left = 320
            Top = 9
            Width = 86
            Height = 29
            Caption = 'Usu'#324
            Enabled = False
            TabOrder = 1
            OnClick = BExecuteClick
            Kind = bkOK
          end
          object BitBtn3: TBitBtn
            Left = 411
            Top = 9
            Width = 86
            Height = 29
            Caption = 'Anuluj'
            TabOrder = 2
            OnClick = BCancelClick
            Kind = bkCancel
          end
        end
        object Grupy: TPageControl
          Left = 1
          Top = 1
          Width = 444
          Height = 209
          ActivePage = TabSheet6
          Align = alClient
          TabOrder = 1
          object TabSheet1: TTabSheet
            Caption = 'Wyk'#322'adowcy'
            object DBGrid1: TDBGrid
              Left = 0
              Top = 0
              Width = 502
              Height = 219
              Align = alClient
              DataSource = dsl
              Options = [dgEditing, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = EASTEUROPE_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -14
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
              Width = 502
              Height = 219
              Align = alClient
              DataSource = dsg
              Options = [dgEditing, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = EASTEUROPE_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -14
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
              Width = 502
              Height = 219
              Align = alClient
              DataSource = dsr
              Options = [dgEditing, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = EASTEUROPE_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -14
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
              Width = 502
              Height = 219
              Align = alClient
              DataSource = dss
              Options = [dgEditing, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = EASTEUROPE_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -14
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
              Width = 502
              Height = 219
              Align = alClient
              DataSource = dsp
              Options = [dgEditing, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = EASTEUROPE_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -14
              TitleFont.Name = 'Arial'
              TitleFont.Style = []
            end
          end
          object TabSheet6: TTabSheet
            Caption = 'Podsumowanie'
            ImageIndex = 5
            object Label4: TLabel
              Left = 9
              Top = 46
              Width = 85
              Height = 16
              Caption = 'Wyk'#322'adowcy: '
            end
            object Label5: TLabel
              Left = 9
              Top = 64
              Width = 43
              Height = 16
              Caption = 'Grupy:'
            end
            object Label6: TLabel
              Left = 9
              Top = 82
              Width = 54
              Height = 16
              Caption = 'Zasoby: '
            end
            object Label7: TLabel
              Left = 9
              Top = 101
              Width = 77
              Height = 16
              Caption = 'Przedmioty: '
            end
            object Label8: TLabel
              Left = 9
              Top = 119
              Width = 63
              Height = 16
              Caption = 'Semestry:'
            end
            object L: TLabel
              Left = 91
              Top = 46
              Width = 8
              Height = 16
              Caption = '..'
            end
            object G: TLabel
              Left = 91
              Top = 64
              Width = 8
              Height = 16
              Caption = '..'
            end
            object R: TLabel
              Left = 91
              Top = 82
              Width = 12
              Height = 16
              Caption = '...'
            end
            object S: TLabel
              Left = 91
              Top = 101
              Width = 8
              Height = 16
              Caption = '..'
            end
            object P: TLabel
              Left = 91
              Top = 119
              Width = 8
              Height = 16
              Caption = '..'
            end
            object Label9: TLabel
              Left = 9
              Top = 27
              Width = 49
              Height = 16
              Caption = 'Zaj'#281'cia:'
            end
            object C: TLabel
              Left = 91
              Top = 27
              Width = 119
              Height = 16
              Caption = '<trwaj'#261' obliczenia>'
            end
            object Label10: TLabel
              Left = 9
              Top = 9
              Width = 332
              Height = 16
              Caption = 'Po naci'#347'ni'#281'ciu przycisku Usu'#324' zostan'#261' usuni'#281'te obiekty:'
              Font.Charset = EASTEUROPE_CHARSET
              Font.Color = clRed
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object BSave: TBitBtn
              Left = 9
              Top = 146
              Width = 157
              Height = 29
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
    Left = 297
    Top = 46
  end
  object dsg: TDataSource
    DataSet = qg
    Left = 297
    Top = 78
  end
  object dss: TDataSource
    DataSet = qs
    Left = 297
    Top = 150
  end
  object dsr: TDataSource
    DataSet = qr
    Left = 297
    Top = 114
  end
  object dsp: TDataSource
    DataSet = qp
    Left = 297
    Top = 182
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
    Left = 388
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
