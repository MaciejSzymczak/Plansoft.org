object EditEventForm: TEditEventForm
  Left = 376
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Edit event'
  ClientHeight = 383
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 20
    Width = 30
    Height = 13
    Caption = 'What:'
  end
  object Label2: TLabel
    Left = 16
    Top = 52
    Width = 32
    Height = 13
    Caption = 'When:'
  end
  object Label3: TLabel
    Left = 256
    Top = 52
    Width = 10
    Height = 13
    Caption = 'to'
  end
  object Label4: TLabel
    Left = 16
    Top = 108
    Width = 36
    Height = 13
    Caption = 'Where:'
  end
  object Label5: TLabel
    Left = 16
    Top = 140
    Width = 57
    Height = 13
    Caption = 'Description:'
  end
  object WhatEd: TEdit
    Left = 80
    Top = 16
    Width = 353
    Height = 21
    TabOrder = 0
  end
  object StartDateDTP: TDateTimePicker
    Left = 80
    Top = 48
    Width = 81
    Height = 21
    Date = 39448.000000000000000000
    Time = 39448.000000000000000000
    TabOrder = 1
  end
  object StartTimeDTP: TDateTimePicker
    Left = 162
    Top = 48
    Width = 81
    Height = 21
    Date = 39448.000000000000000000
    Time = 39448.000000000000000000
    Kind = dtkTime
    TabOrder = 2
  end
  object EndDateDTP: TDateTimePicker
    Left = 272
    Top = 48
    Width = 81
    Height = 21
    Date = 39448.000000000000000000
    Time = 39448.000000000000000000
    TabOrder = 3
  end
  object EndTimeDTP: TDateTimePicker
    Left = 354
    Top = 48
    Width = 81
    Height = 21
    Date = 39448.000000000000000000
    Time = 39448.000000000000000000
    Kind = dtkTime
    TabOrder = 4
  end
  object AllDayCB: TCheckBox
    Left = 84
    Top = 72
    Width = 97
    Height = 17
    Caption = 'AllDay'
    TabOrder = 5
    OnClick = AllDayCBClick
  end
  object LocationEd: TEdit
    Left = 80
    Top = 104
    Width = 353
    Height = 21
    TabOrder = 6
  end
  object DescriptMem: TMemo
    Left = 80
    Top = 136
    Width = 353
    Height = 73
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object OKBtn: TButton
    Left = 96
    Top = 352
    Width = 75
    Height = 21
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 8
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 280
    Top = 352
    Width = 75
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 9
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 224
    Width = 417
    Height = 113
    Caption = 'Reminders'
    TabOrder = 10
    object RemindersLB: TListBox
      Left = 8
      Top = 16
      Width = 313
      Height = 89
      ItemHeight = 13
      TabOrder = 0
      OnClick = RemindersLBClick
    end
    object RemAddBtn: TButton
      Left = 328
      Top = 16
      Width = 75
      Height = 21
      Caption = 'Add...'
      TabOrder = 1
      OnClick = RemAddBtnClick
    end
    object RemEditBtn: TButton
      Left = 328
      Top = 48
      Width = 75
      Height = 21
      Caption = 'Edit...'
      Enabled = False
      TabOrder = 2
      OnClick = RemEditBtnClick
    end
    object RemDeleteBtn: TButton
      Left = 328
      Top = 80
      Width = 75
      Height = 21
      Caption = 'Delete'
      Enabled = False
      TabOrder = 3
      OnClick = RemDeleteBtnClick
    end
  end
end
