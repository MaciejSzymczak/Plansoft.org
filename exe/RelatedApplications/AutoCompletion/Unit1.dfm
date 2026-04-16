object Form1: TForm1
  Left = 266
  Top = 89
  Width = 1231
  Height = 675
  Caption = 'Form1'
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
  object acl1_Edit: TEdit
    Left = 224
    Top = 264
    Width = 377
    Height = 21
    TabOrder = 1
    Text = 'kot'
    OnChange = acl1_EditChange
    OnEnter = acl1_EditEnter
    OnExit = acl1_EditExit
    OnKeyDown = acl1_EditKeyDown
  end
  object ac1_ListBox: TListBox
    Left = 736
    Top = 72
    Width = 377
    Height = 97
    Style = lbOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 0
    Visible = False
    OnClick = ac1_ListBoxClick
    OnDblClick = ac1_ListBoxDblClick
    OnDrawItem = ac1_ListBoxDrawItem
    OnExit = ac1_ListBoxExit
  end
  object Edit2: TEdit
    Left = 224
    Top = 288
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Edit2'
  end
  object Edit1: TEdit
    Left = 224
    Top = 240
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit2'
  end
  object ac1_Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = ac1_TimerTimer
    Left = 736
    Top = 40
  end
end
