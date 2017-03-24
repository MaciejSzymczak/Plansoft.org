inherited FChangePassword: TFChangePassword
  Left = 444
  Top = 248
  Width = 623
  Height = 273
  ActiveControl = ENewPassword
  Caption = 'Zmiana has'#322'a zalogowanego u'#380'ytkownika'
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel [0]
    Left = 99
    Top = 55
    Width = 140
    Height = 16
    Alignment = taRightJustify
    Caption = 'Wprowad'#378' nowe has'#322'o'
  end
  object Label2: TLabel [1]
    Left = 35
    Top = 82
    Width = 204
    Height = 16
    Alignment = taRightJustify
    Caption = 'Wprowad'#378' ponownie nowe has'#322'o'
  end
  object Label3: TLabel [2]
    Left = 9
    Top = 119
    Width = 580
    Height = 16
    Caption = 
      'Gdy has'#322'o zostanie zmienione, nie b'#281'dzie mo'#380'liwe zalogowanie si'#281 +
      ' za pomoc'#261' starego has'#322'a.'
  end
  object Label4: TLabel [3]
    Left = 9
    Top = 137
    Width = 519
    Height = 16
    Caption = 
      ' Podczas wpisywania has'#322'a zwr'#243#263' uwag'#281', czy nie jest naci'#347'ni'#281'ty k' +
      'lawisz CapsLock. '
  end
  object Label5: TLabel [4]
    Left = 9
    Top = 18
    Width = 539
    Height = 16
    Caption = 
      'Aby zmieni'#263' has'#322'o wprowad'#378' dwukrotnie nowe has'#322'o, a nast'#281'pnie na' +
      'ci'#347'nij przycisk OK.'
  end
  inherited Status: TPanel
    Top = 214
    Width = 615
  end
  object ENewPassword: TEdit
    Left = 247
    Top = 46
    Width = 211
    Height = 24
    PasswordChar = '*'
    TabOrder = 1
  end
  object EConfirmPassword: TEdit
    Left = 247
    Top = 73
    Width = 211
    Height = 24
    PasswordChar = '*'
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 167
    Width = 615
    Height = 47
    Align = alBottom
    TabOrder = 3
    object BCancel: TBitBtn
      Left = 521
      Top = 9
      Width = 86
      Height = 29
      TabOrder = 0
      OnClick = BCancelClick
      Kind = bkCancel
    end
    object BChangePassword: TBitBtn
      Left = 430
      Top = 9
      Width = 85
      Height = 29
      TabOrder = 1
      OnClick = BChangePasswordClick
      Kind = bkOK
    end
  end
end
