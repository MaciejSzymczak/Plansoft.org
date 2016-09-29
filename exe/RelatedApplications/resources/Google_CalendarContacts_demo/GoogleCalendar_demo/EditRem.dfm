object ReminderForm: TReminderForm
  Left = 431
  Top = 106
  BorderStyle = bsDialog
  Caption = 'Edit reminder'
  ClientHeight = 82
  ClientWidth = 233
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object MethodCB: TComboBox
    Left = 16
    Top = 16
    Width = 97
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 0
    Text = 'Pop-up'
    Items.Strings = (
      'None'
      'Pop-up'
      'Email'
      'SMS')
  end
  object PeriodCB: TComboBox
    Left = 120
    Top = 16
    Width = 97
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 1
    Text = '10 minutes'
    Items.Strings = (
      '5 minutes'
      '10 minutes'
      '15 minutes'
      '20 minutes'
      '25 minutes'
      '30 minutes'
      '45 minutes'
      '1 hour'
      '2 hours'
      '3 hours'
      '12 hours'
      '1 day'
      '2 days'
      '1 week')
  end
  object OKBtn: TButton
    Left = 24
    Top = 54
    Width = 75
    Height = 21
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 136
    Top = 54
    Width = 75
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
