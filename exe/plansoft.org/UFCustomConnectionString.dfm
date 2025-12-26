inherited FCustomConnectionString: TFCustomConnectionString
  Left = 490
  Top = 312
  BorderStyle = bsDialog
  Caption = 'Logowanie '
  ClientHeight = 147
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 127
  end
  object BLogin: TBitBtn
    Left = 120
    Top = 16
    Width = 281
    Height = 41
    Caption = 'Zaloguj za pomoc'#261' u'#380'ytkownika Windows'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 86
    Width = 532
    Height = 41
    Align = alBottom
    TabOrder = 2
    object BitBtn2: TBitBtn
      Left = 8
      Top = 8
      Width = 169
      Height = 25
      Caption = 'Edytuj po'#322#261'czenie'
      TabOrder = 0
      OnClick = BitBtn2Click
    end
    object BitBtn3: TBitBtn
      Left = 360
      Top = 8
      Width = 163
      Height = 25
      Cancel = True
      Caption = 'Zaloguj za pomoc'#261' has'#322'a'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object connectionString: TEdit
    Left = 24
    Top = 64
    Width = 497
    Height = 22
    TabOrder = 3
    Text = 
      'Provider=OraOLEDB.Oracle.1;User ID=/;Data Source=PLANSOFT_ORG;OS' +
      'Authent=1;'
    Visible = False
  end
end
