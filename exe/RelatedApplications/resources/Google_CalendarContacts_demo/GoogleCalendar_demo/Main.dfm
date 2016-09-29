object MainForm: TMainForm
  Left = 470
  Top = 108
  Width = 489
  Height = 523
  Caption = 'Google calendar demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 12
    Width = 28
    Height = 13
    Caption = 'Email:'
  end
  object Label2: TLabel
    Left = 192
    Top = 12
    Width = 50
    Height = 13
    Caption = 'Password:'
  end
  object EmailEd: TEdit
    Left = 48
    Top = 8
    Width = 129
    Height = 21
    TabOrder = 0
  end
  object PasswordEd: TEdit
    Left = 248
    Top = 8
    Width = 129
    Height = 21
    TabOrder = 1
  end
  object ConnectBtn: TButton
    Left = 392
    Top = 8
    Width = 75
    Height = 21
    Caption = 'Connect'
    TabOrder = 2
    OnClick = ConnectBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 40
    Width = 465
    Height = 145
    Caption = 'Calendars'
    TabOrder = 3
    object CalendarsLB: TListBox
      Left = 8
      Top = 16
      Width = 361
      Height = 121
      ItemHeight = 13
      TabOrder = 0
      OnClick = CalendarsLBClick
    end
    object CalAddBtn: TButton
      Left = 376
      Top = 16
      Width = 75
      Height = 21
      Caption = 'Add...'
      Enabled = False
      TabOrder = 1
      OnClick = CalAddBtnClick
    end
    object CalEditBtn: TButton
      Left = 376
      Top = 48
      Width = 75
      Height = 21
      Caption = 'Edit...'
      Enabled = False
      TabOrder = 2
      OnClick = CalEditBtnClick
    end
    object CalDeleteBtn: TButton
      Left = 376
      Top = 80
      Width = 75
      Height = 21
      Caption = 'Delete'
      Enabled = False
      TabOrder = 3
      OnClick = CalDeleteBtnClick
    end
    object CalRefreshBtn: TButton
      Left = 376
      Top = 112
      Width = 75
      Height = 21
      Caption = 'Refresh'
      TabOrder = 4
      OnClick = CalRefreshBtnClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 192
    Width = 465
    Height = 289
    Caption = 'Events'
    TabOrder = 4
    object EventsLB: TListBox
      Left = 8
      Top = 16
      Width = 361
      Height = 265
      ItemHeight = 13
      TabOrder = 0
      OnClick = EventsLBClick
    end
    object EventAddBtn: TButton
      Left = 376
      Top = 16
      Width = 75
      Height = 21
      Caption = 'Add...'
      Enabled = False
      TabOrder = 1
      OnClick = EventAddBtnClick
    end
    object EventEditBtn: TButton
      Left = 376
      Top = 48
      Width = 75
      Height = 21
      Caption = 'Edit...'
      Enabled = False
      TabOrder = 2
      OnClick = EventEditBtnClick
    end
    object EventDeleteBtn: TButton
      Left = 376
      Top = 80
      Width = 75
      Height = 21
      Caption = 'Delete'
      Enabled = False
      TabOrder = 3
      OnClick = EventDeleteBtnClick
    end
    object EventRefreshBtn: TButton
      Left = 376
      Top = 112
      Width = 75
      Height = 21
      Caption = 'Refresh'
      TabOrder = 4
      OnClick = EventRefreshBtnClick
    end
  end
end
