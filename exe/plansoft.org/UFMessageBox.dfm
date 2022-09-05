inherited FMessageBox: TFMessageBox
  Left = 366
  Top = 253
  Width = 988
  Caption = 'Informacja'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Width = 980
  end
  object Panel1: TPanel
    Left = 0
    Top = 205
    Width = 980
    Height = 41
    Align = alBottom
    TabOrder = 1
    object BClose: TBitBtn
      Left = 897
      Top = 8
      Width = 75
      Height = 28
      Hint = 'Zamknij bie'#380#261'ce okno'
      Cancel = True
      Caption = 'Zamknij'
      ModalResult = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = BCloseClick
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
    object BitBtn1: TBitBtn
      Left = 9
      Top = 5
      Width = 75
      Height = 28
      Hint = 'Zamknij bie'#380#261'ce okno'
      Caption = 'Kopiuj'
      ModalResult = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = BitBtn1Click
      NumGlyphs = 2
    end
  end
  object Message: TMemo
    Left = 0
    Top = 0
    Width = 980
    Height = 205
    Align = alClient
    Color = clInactiveBorder
    Lines.Strings = (
      'Message')
    ReadOnly = True
    TabOrder = 2
    WordWrap = False
  end
end
