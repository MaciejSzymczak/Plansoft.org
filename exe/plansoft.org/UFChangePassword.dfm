inherited FChangePassword: TFChangePassword
  Left = 444
  Top = 248
  Height = 236
  ActiveControl = ENewPassword
  Caption = 'Zmiana has'#322'a zalogowanego u'#380'ytkownika'
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel [0]
    Left = 40
    Top = 48
    Width = 169
    Height = 14
    Alignment = taRightJustify
    Caption = 'Wprowad'#378' nowe has'#322'o'
  end
  object Label2: TLabel [1]
    Left = 24
    Top = 72
    Width = 185
    Height = 14
    Alignment = taRightJustify
    Caption = 'Wprowad'#378' ponownie nowe has'#322'o'
  end
  object Label3: TLabel [2]
    Left = 8
    Top = 104
    Width = 452
    Height = 14
    Caption = 
      'Gdy has'#322'o zostanie zmienione, nie b'#281'dzie mo'#380'liwe zalogowanie si'#281 +
      ' za pomoc'#261' starego has'#322'a.'
  end
  object Label4: TLabel [3]
    Left = 8
    Top = 120
    Width = 419
    Height = 14
    Caption = 
      ' Podczas wpisywania has'#322'a zwr'#243#263' uwag'#281', czy nie jest naci'#347'ni'#281'ty k' +
      'lawisz CapsLock. '
  end
  object Label5: TLabel [4]
    Left = 8
    Top = 16
    Width = 428
    Height = 14
    Caption = 
      'Aby zmieni'#263' has'#322'o wprowad'#378' dwukrotnie nowe has'#322'o, a nast'#281'pnie na' +
      'ci'#347'nij przycisk OK.'
  end
  inherited Status: TPanel
    Top = 183
  end
  object ENewPassword: TEdit
    Left = 216
    Top = 40
    Width = 185
    Height = 22
    PasswordChar = '*'
    TabOrder = 1
  end
  object EConfirmPassword: TEdit
    Left = 216
    Top = 64
    Width = 185
    Height = 22
    PasswordChar = '*'
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 142
    Width = 536
    Height = 41
    Align = alBottom
    TabOrder = 3
    object BCancel: TBitBtn
      Left = 456
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 0
      OnClick = BCancelClick
      Kind = bkCancel
    end
    object BChangePassword: TBitBtn
      Left = 376
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 1
      OnClick = BChangePasswordClick
      Kind = bkOK
    end
  end
end
