inherited FMassUpdateSUB: TFMassUpdateSUB
  Left = 535
  Top = 426
  Width = 615
  Height = 122
  Caption = 'Aktualizacja zestawu przedmiot'#243'w'
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel [0]
    Left = 16
    Top = 16
    Width = 186
    Height = 14
    Caption = 'Wybrano przedmiot'#243'w do aktualizacji: '
  end
  object LCnt: TLabel [1]
    Left = 208
    Top = 16
    Width = 22
    Height = 14
    Caption = 'LCnt'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  inherited Status: TPanel
    Top = 71
    Width = 607
  end
  object mrYes: TButton
    Left = 8
    Top = 40
    Width = 249
    Height = 25
    Caption = 'Email o zmianach: Wysy'#322'aj'
    ModalResult = 6
    TabOrder = 1
    OnClick = mrYesClick
  end
  object mrNo: TButton
    Left = 272
    Top = 40
    Width = 249
    Height = 25
    Caption = 'Email o zmianach: NIE wysy'#322'aj'
    ModalResult = 7
    TabOrder = 2
    OnClick = mrNoClick
  end
  object BUpdCancel: TBitBtn
    Left = 536
    Top = 40
    Width = 65
    Height = 25
    Caption = '&Anuluj'
    ModalResult = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = BUpdCancelClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
end
