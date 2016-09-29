object MainFormCont: TMainFormCont
  Left = 383
  Top = 80
  Width = 497
  Height = 582
  Caption = 'Google contacts demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 12
    Width = 28
    Height = 13
    Caption = 'Email:'
  end
  object Label2: TLabel
    Left = 191
    Top = 12
    Width = 50
    Height = 13
    Caption = 'Password:'
  end
  object Label5: TLabel
    Left = 252
    Top = 60
    Width = 24
    Height = 13
    Caption = 'Port:'
  end
  object EmailEd: TEdit
    Left = 47
    Top = 8
    Width = 129
    Height = 21
    TabOrder = 0
  end
  object PasswordEd: TEdit
    Left = 247
    Top = 8
    Width = 210
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object ConnectBtn: TButton
    Left = 384
    Top = 56
    Width = 75
    Height = 21
    Caption = 'Connect'
    Default = True
    TabOrder = 5
    OnClick = ConnectBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 258
    Width = 465
    Height = 239
    Caption = 'Contacts'
    TabOrder = 7
    object Label4: TLabel
      Left = 7
      Top = 214
      Width = 210
      Height = 13
      Caption = 'Select contact to highlight groups contact in'
    end
    object ContactsLB: TListBox
      Left = 8
      Top = 16
      Width = 361
      Height = 193
      ItemHeight = 13
      TabOrder = 0
      OnClick = ContactsLBClick
      OnDblClick = ContactsLBDblClick
    end
    object ConAddBtn: TButton
      Left = 376
      Top = 16
      Width = 75
      Height = 21
      Caption = 'Add...'
      Enabled = False
      TabOrder = 1
      OnClick = ConAddBtnClick
    end
    object ConEditBtn: TButton
      Left = 376
      Top = 48
      Width = 75
      Height = 21
      Caption = 'Edit...'
      Enabled = False
      TabOrder = 2
      OnClick = ConEditBtnClick
    end
    object ConDeleteBtn: TButton
      Left = 376
      Top = 80
      Width = 75
      Height = 21
      Caption = 'Delete'
      Enabled = False
      TabOrder = 3
      OnClick = ConDeleteBtnClick
    end
    object ConAddGrBtn: TButton
      Left = 376
      Top = 139
      Width = 75
      Height = 33
      Caption = 'Add to group...'
      Enabled = False
      TabOrder = 5
      WordWrap = True
      OnClick = ConAddGrBtnClick
    end
    object ConRemGrBtn: TButton
      Left = 376
      Top = 179
      Width = 75
      Height = 33
      Caption = 'Remove from group...'
      Enabled = False
      TabOrder = 6
      WordWrap = True
      OnClick = ConRemGrBtnClick
    end
    object ConBDelBtn: TButton
      Left = 376
      Top = 108
      Width = 75
      Height = 21
      Caption = 'Batch Delete'
      Enabled = False
      TabOrder = 4
      OnClick = ConBDelBtnClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 7
    Top = 83
    Width = 465
    Height = 169
    Caption = 'Groups'
    TabOrder = 6
    object Label3: TLabel
      Left = 7
      Top = 148
      Width = 188
      Height = 13
      Caption = 'Select group to filter contacts by group'
    end
    object GroupsLB: TListBox
      Left = 8
      Top = 16
      Width = 361
      Height = 127
      ItemHeight = 13
      TabOrder = 0
      OnClick = GroupsLBClick
      OnDblClick = GroupsLBDblClick
    end
    object GrAddBtn: TButton
      Left = 376
      Top = 16
      Width = 75
      Height = 21
      Caption = 'Add...'
      Enabled = False
      TabOrder = 1
      OnClick = GrAddBtnClick
    end
    object GrEditBtn: TButton
      Left = 376
      Top = 48
      Width = 75
      Height = 21
      Caption = 'Edit...'
      Enabled = False
      TabOrder = 2
      OnClick = GrEditBtnClick
    end
    object GrDeleteBtn: TButton
      Left = 376
      Top = 80
      Width = 75
      Height = 21
      Caption = 'Delete'
      Enabled = False
      TabOrder = 3
      OnClick = GrDeleteBtnClick
    end
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 34
    Width = 97
    Height = 17
    Caption = 'Use proxy'
    TabOrder = 2
    OnClick = CheckBox1Click
  end
  object ProxyEd: TEdit
    Left = 15
    Top = 56
    Width = 218
    Height = 21
    Enabled = False
    TabOrder = 3
  end
  object PortEd: TSpinEdit
    Left = 288
    Top = 56
    Width = 73
    Height = 22
    Enabled = False
    MaxValue = 65535
    MinValue = 0
    TabOrder = 4
    Value = 0
  end
  object Button1: TButton
    Left = 384
    Top = 501
    Width = 75
    Height = 33
    Caption = 'Store batch changes'
    TabOrder = 8
    WordWrap = True
    OnClick = Button1Click
  end
end
