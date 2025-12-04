inherited FVersion: TFVersion
  Left = 723
  Top = 317
  Width = 596
  Height = 462
  Caption = 'Utw'#243'rz / Przywr'#243#263' wersj'#281' rozk'#322'adu zaj'#281#263
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 411
    Width = 588
  end
  object Main: TPageControl
    Left = 0
    Top = 0
    Width = 588
    Height = 411
    ActivePage = tab2
    Align = alClient
    MultiLine = True
    TabHeight = 1
    TabOrder = 1
    TabPosition = tpBottom
    TabWidth = 1
    object Tab1: TTabSheet
      Caption = 'Co chcesz zrobi'#263'?'
      object BitBtn1: TBitBtn
        Left = 8
        Top = 8
        Width = 569
        Height = 105
        Caption = 'Utw'#243'rz wersj'#281
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = BitBtn1Click
      end
      object BitBtn2: TBitBtn
        Left = 8
        Top = 120
        Width = 569
        Height = 105
        Caption = 'Przywr'#243#263' lub skasuj wersj'#281
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = BitBtn2Click
      end
    end
    object tab2: TTabSheet
      Caption = 'Utw'#243'rz wersj'#281
      ImageIndex = 2
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 38
        Height = 14
        Caption = 'Nazwa:'
      end
      object Label2: TLabel
        Left = 8
        Top = 32
        Width = 43
        Height = 14
        Caption = 'Semestr:'
      end
      object Label3: TLabel
        Left = 8
        Top = 56
        Width = 40
        Height = 14
        Caption = 'Planista:'
      end
      object Confirm: TCheckBox
        Left = 8
        Top = 264
        Width = 185
        Height = 17
        Caption = 'Potwierdzam'
        TabOrder = 0
        OnClick = ConfirmClick
      end
      object Memo1: TMemo
        Left = 8
        Top = 104
        Width = 433
        Height = 153
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWhite
        Enabled = False
        Lines.Strings = (
          
            'Nie dodawaj ani nie usuwaj wyk'#322'adowc'#243'w, grup i sal z autoryzacji' +
            ' w oknie czasowym '
          'pomi'#281'dzy utworzeniem wersji a jej przywr'#243'ceniem.'
          ''
          
            'Wersja obejmuje zaj'#281'cia i rezerwacje wyk'#322'adowc'#243'w, grup i sal zgo' +
            'dnie z wybran'#261' '
          
            'aktualnie autoryzacj'#261' (np. tylko zaj'#281'cia stacjonarne lub tylko n' +
            'iestacjonarne), wg stanu '
          'na teraz.'
          ''
          
            'W razie wyst'#261'pienia konflikt'#243'w z zaj'#281'ciami innych planist'#243'w przy' +
            'wr'#243'cenie wersji nie '
          
            'b'#281'dzie mo'#380'liwe do czasu skasowania konflikt'#243'w. W przypadku wyst'#261 +
            'pienia konflikt'#243'w '
          'jest tworzony raport wskazuj'#261'cy konflikty.')
        ReadOnly = True
        TabOrder = 1
      end
      object Run: TBitBtn
        Left = 208
        Top = 272
        Width = 137
        Height = 49
        Caption = 'Utw'#243'rz wersj'#281
        Enabled = False
        TabOrder = 2
        OnClick = RunClick
      end
      object ver_name: TEdit
        Left = 80
        Top = 8
        Width = 353
        Height = 22
        TabOrder = 3
        Text = 'ver_name'
      end
      object PeriodName: TEdit
        Left = 80
        Top = 32
        Width = 121
        Height = 22
        Color = clMenu
        ReadOnly = True
        TabOrder = 4
        Text = 'PeriodName'
      end
      object OwnerName: TEdit
        Left = 80
        Top = 56
        Width = 121
        Height = 22
        Color = clMenu
        ReadOnly = True
        TabOrder = 5
        Text = 'OwnerName'
      end
    end
    object Tab3: TTabSheet
      Caption = 'Przywr'#243#263' lub skasuj'
      ImageIndex = 2
      object BitBtn3: TBitBtn
        Left = 192
        Top = 16
        Width = 161
        Height = 33
        Caption = 'Wybierz wersj'#281
        TabOrder = 0
        OnClick = BitBtn3Click
      end
      object details: TPanel
        Left = 64
        Top = 56
        Width = 449
        Height = 217
        TabOrder = 1
        object Label4: TLabel
          Left = 8
          Top = 8
          Width = 38
          Height = 14
          Caption = 'Nazwa:'
        end
        object Label5: TLabel
          Left = 8
          Top = 32
          Width = 43
          Height = 14
          Caption = 'Semestr:'
        end
        object Label6: TLabel
          Left = 8
          Top = 56
          Width = 40
          Height = 14
          Caption = 'Data od:'
        end
        object Label7: TLabel
          Left = 8
          Top = 80
          Width = 40
          Height = 14
          Caption = 'Data do:'
        end
        object Label8: TLabel
          Left = 8
          Top = 104
          Width = 40
          Height = 14
          Caption = 'Planista:'
        end
        object Label9: TLabel
          Left = 8
          Top = 128
          Width = 62
          Height = 14
          Caption = 'Autoryzacja:'
        end
        object name: TEdit
          Left = 80
          Top = 8
          Width = 353
          Height = 22
          Color = clMenu
          ReadOnly = True
          TabOrder = 0
        end
        object per: TEdit
          Left = 80
          Top = 32
          Width = 353
          Height = 22
          Color = clMenu
          ReadOnly = True
          TabOrder = 1
        end
        object date_from: TEdit
          Left = 80
          Top = 56
          Width = 121
          Height = 22
          Color = clMenu
          ReadOnly = True
          TabOrder = 2
        end
        object date_to: TEdit
          Left = 80
          Top = 80
          Width = 121
          Height = 22
          Color = clMenu
          ReadOnly = True
          TabOrder = 3
        end
        object planners: TEdit
          Left = 80
          Top = 104
          Width = 353
          Height = 22
          Color = clMenu
          ReadOnly = True
          TabOrder = 4
        end
        object Role: TEdit
          Left = 80
          Top = 128
          Width = 353
          Height = 22
          Color = clMenu
          ReadOnly = True
          TabOrder = 5
        end
        object ver_id: TEdit
          Left = 80
          Top = 152
          Width = 353
          Height = 22
          Color = clMenu
          ReadOnly = True
          TabOrder = 6
          Text = 'OwnerName'
        end
        object BitBtn4: TBitBtn
          Left = 8
          Top = 184
          Width = 185
          Height = 25
          Caption = 'Przywr'#243#263' wersj'#281
          TabOrder = 7
          OnClick = BitBtn4Click
        end
        object BitBtn5: TBitBtn
          Left = 256
          Top = 184
          Width = 187
          Height = 25
          Caption = 'Skasuj wersj'#281
          TabOrder = 8
          OnClick = BitBtn5Click
        end
      end
    end
  end
end
