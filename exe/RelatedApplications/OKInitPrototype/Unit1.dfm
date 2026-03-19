object Form1: TForm1
  Left = 698
  Top = 227
  Width = 973
  Height = 641
  Caption = 'Calling okinit.exe'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 96
    Width = 85
    Height = 13
    Caption = 'okinit.exe location'
  end
  object Label2: TLabel
    Left = 16
    Top = 8
    Width = 48
    Height = 13
    Caption = 'Username'
  end
  object Label3: TLabel
    Left = 16
    Top = 32
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object Label4: TLabel
    Left = 16
    Top = 64
    Width = 71
    Height = 13
    Caption = 'Token location'
  end
  object Label5: TLabel
    Left = 16
    Top = 200
    Width = 18
    Height = 13
    Caption = 'Log'
  end
  object Label6: TLabel
    Left = 456
    Top = 8
    Width = 106
    Height = 13
    Caption = 'You can leave it blank'
  end
  object okinitPath: TEdit
    Left = 16
    Top = 112
    Width = 433
    Height = 21
    TabOrder = 3
    Text = 'C:\app\Maciek\product\21c\dbhomeXE\bin\okinit.exe'
  end
  object BitBtn1: TBitBtn
    Left = 16
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Run'
    TabOrder = 4
    OnClick = BitBtn1Click
  end
  object Username: TEdit
    Left = 104
    Top = 8
    Width = 345
    Height = 21
    TabOrder = 0
    Text = '-p tgasior'
  end
  object Password: TEdit
    Left = 104
    Top = 32
    Width = 345
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    Text = 'Password'
  end
  object Tokenlocation: TEdit
    Left = 104
    Top = 56
    Width = 345
    Height = 21
    TabOrder = 2
    Text = 'Tokenlocation'
  end
  object log: TMemo
    Left = 16
    Top = 224
    Width = 937
    Height = 377
    Lines.Strings = (
      'log')
    ReadOnly = True
    TabOrder = 5
  end
end
