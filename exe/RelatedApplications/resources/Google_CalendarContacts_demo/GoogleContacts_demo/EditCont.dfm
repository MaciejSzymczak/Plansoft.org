object EditContForm: TEditContForm
  Left = 471
  Top = 78
  Width = 398
  Height = 484
  ActiveControl = FNameEd
  Caption = 'Name'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    382
    446)
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 80
    Top = 415
    Width = 75
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 240
    Top = 415
    Width = 75
    Height = 21
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 382
    Height = 404
    ActivePage = TabSheet1
    Align = alTop
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Personal'
      object Label4: TLabel
        Left = 6
        Top = 30
        Width = 53
        Height = 13
        Caption = 'Last name:'
      end
      object Label2: TLabel
        Left = 6
        Top = 10
        Width = 54
        Height = 13
        Caption = 'First name:'
      end
      object Label1: TLabel
        Left = 6
        Top = 71
        Width = 34
        Height = 13
        Caption = 'Mobile:'
      end
      object Label3: TLabel
        Left = 6
        Top = 91
        Width = 34
        Height = 13
        Caption = 'Phone:'
      end
      object Label5: TLabel
        Left = 6
        Top = 111
        Width = 32
        Height = 13
        Caption = 'E-mail:'
      end
      object Label6: TLabel
        Left = 6
        Top = 131
        Width = 43
        Height = 13
        Caption = 'Address:'
      end
      object Label7: TLabel
        Left = 6
        Top = 151
        Width = 23
        Height = 13
        Caption = 'City:'
      end
      object Label8: TLabel
        Left = 6
        Top = 171
        Width = 30
        Height = 13
        Caption = 'State:'
      end
      object Label9: TLabel
        Left = 6
        Top = 191
        Width = 33
        Height = 13
        Caption = 'Postal:'
      end
      object Label10: TLabel
        Left = 6
        Top = 211
        Width = 43
        Height = 13
        Caption = 'Country:'
      end
      object Label11: TLabel
        Left = 6
        Top = 50
        Width = 49
        Height = 13
        Caption = 'Full name:'
      end
      object Label12: TLabel
        Left = 6
        Top = 231
        Width = 67
        Height = 26
        AutoSize = False
        Caption = 'Formatted address:'
        WordWrap = True
      end
      object Label13: TLabel
        Left = 6
        Top = 291
        Width = 23
        Height = 13
        Caption = 'ICQ:'
      end
      object Label14: TLabel
        Left = 6
        Top = 311
        Width = 25
        Height = 13
        Caption = 'MSN:'
      end
      object Label15: TLabel
        Left = 6
        Top = 331
        Width = 50
        Height = 13
        Caption = 'WebPage:'
      end
      object Label16: TLabel
        Left = 6
        Top = 351
        Width = 44
        Height = 13
        Caption = 'Bitrhday:'
      end
      object FNameEd: TEdit
        Left = 80
        Top = 7
        Width = 289
        Height = 21
        TabOrder = 0
      end
      object LNameEd: TEdit
        Left = 80
        Top = 27
        Width = 289
        Height = 21
        TabOrder = 1
      end
      object FullNameEd: TEdit
        Left = 80
        Top = 47
        Width = 289
        Height = 21
        TabOrder = 2
      end
      object MobileEd: TEdit
        Left = 80
        Top = 67
        Width = 289
        Height = 21
        TabOrder = 3
      end
      object PhoneEd: TEdit
        Left = 80
        Top = 87
        Width = 289
        Height = 21
        TabOrder = 4
      end
      object EMailEd: TEdit
        Left = 80
        Top = 107
        Width = 289
        Height = 21
        TabOrder = 5
      end
      object AddressEd: TEdit
        Left = 80
        Top = 127
        Width = 289
        Height = 21
        TabOrder = 6
      end
      object CityEd: TEdit
        Left = 80
        Top = 147
        Width = 289
        Height = 21
        TabOrder = 7
      end
      object StateEd: TEdit
        Left = 80
        Top = 167
        Width = 289
        Height = 21
        TabOrder = 8
      end
      object PostalEd: TEdit
        Left = 80
        Top = 187
        Width = 289
        Height = 21
        TabOrder = 9
      end
      object CountryEd: TEdit
        Left = 80
        Top = 207
        Width = 289
        Height = 21
        TabOrder = 10
      end
      object FAddressMM: TMemo
        Left = 80
        Top = 227
        Width = 289
        Height = 61
        TabOrder = 11
      end
      object ICQEd: TEdit
        Left = 80
        Top = 287
        Width = 289
        Height = 21
        TabOrder = 12
      end
      object MSNEd: TEdit
        Left = 80
        Top = 307
        Width = 289
        Height = 21
        TabOrder = 13
      end
      object WebPageEd: TEdit
        Left = 80
        Top = 327
        Width = 289
        Height = 21
        TabOrder = 14
      end
      object BirthdayTP: TDateTimePicker
        Left = 80
        Top = 347
        Width = 129
        Height = 21
        Date = 40070.726992291670000000
        Time = 40070.726992291670000000
        ShowCheckbox = True
        TabOrder = 15
        OnClick = BirthdayTPClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Business'
      ImageIndex = 1
      object Label17: TLabel
        Left = 6
        Top = 10
        Width = 49
        Height = 13
        Caption = 'Company:'
      end
      object Label18: TLabel
        Left = 6
        Top = 30
        Width = 42
        Height = 13
        Caption = 'Job title:'
      end
      object Label19: TLabel
        Left = 6
        Top = 50
        Width = 64
        Height = 13
        Caption = 'Business fax:'
      end
      object Label20: TLabel
        Left = 6
        Top = 70
        Width = 78
        Height = 13
        Caption = 'Business phone:'
      end
      object Label21: TLabel
        Left = 6
        Top = 90
        Width = 72
        Height = 13
        Caption = 'Business email:'
      end
      object Label22: TLabel
        Left = 6
        Top = 110
        Width = 92
        Height = 13
        Caption = 'Business webpage:'
      end
      object Label23: TLabel
        Left = 6
        Top = 131
        Width = 86
        Height = 13
        Caption = 'Business address:'
      end
      object Label24: TLabel
        Left = 6
        Top = 151
        Width = 65
        Height = 13
        Caption = 'Business city:'
      end
      object Label25: TLabel
        Left = 6
        Top = 171
        Width = 73
        Height = 13
        Caption = 'Business state:'
      end
      object Label26: TLabel
        Left = 6
        Top = 191
        Width = 77
        Height = 13
        Caption = 'Business postal:'
      end
      object Label27: TLabel
        Left = 6
        Top = 211
        Width = 85
        Height = 13
        Caption = 'Business country:'
      end
      object Label28: TLabel
        Left = 6
        Top = 231
        Width = 93
        Height = 26
        AutoSize = False
        Caption = 'Business formatted address:'
        WordWrap = True
      end
      object Label29: TLabel
        Left = 7
        Top = 290
        Width = 78
        Height = 13
        Caption = 'Business mobile:'
      end
      object CompanyEd: TEdit
        Left = 102
        Top = 7
        Width = 268
        Height = 21
        TabOrder = 0
      end
      object JobTitleEd: TEdit
        Left = 102
        Top = 27
        Width = 268
        Height = 21
        TabOrder = 1
      end
      object BusFaxEd: TEdit
        Left = 102
        Top = 47
        Width = 268
        Height = 21
        TabOrder = 2
      end
      object BusPhoneEd: TEdit
        Left = 102
        Top = 67
        Width = 268
        Height = 21
        TabOrder = 3
      end
      object BusEMailEd: TEdit
        Left = 102
        Top = 87
        Width = 268
        Height = 21
        TabOrder = 4
      end
      object BusWebPageEd: TEdit
        Left = 102
        Top = 107
        Width = 268
        Height = 21
        TabOrder = 5
      end
      object BusAddressEd: TEdit
        Left = 102
        Top = 127
        Width = 268
        Height = 21
        TabOrder = 6
      end
      object BusCityEd: TEdit
        Left = 102
        Top = 147
        Width = 268
        Height = 21
        TabOrder = 7
      end
      object BusStateEd: TEdit
        Left = 102
        Top = 167
        Width = 268
        Height = 21
        TabOrder = 8
      end
      object BusPostalEd: TEdit
        Left = 102
        Top = 187
        Width = 268
        Height = 21
        TabOrder = 9
      end
      object BusCountryEd: TEdit
        Left = 102
        Top = 207
        Width = 268
        Height = 21
        TabOrder = 10
      end
      object BusFAddressMM: TMemo
        Left = 102
        Top = 227
        Width = 268
        Height = 61
        TabOrder = 11
      end
      object BusMobileEd: TEdit
        Left = 102
        Top = 287
        Width = 268
        Height = 21
        TabOrder = 12
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'User fields'
      ImageIndex = 2
      object UserFieldsGR: TStringGrid
        Left = 0
        Top = 0
        Width = 374
        Height = 321
        Align = alTop
        ColCount = 2
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
        TabOrder = 0
        OnDblClick = UserFieldsGRDblClick
        ColWidths = (
          146
          225)
      end
      object Button1: TButton
        Left = 8
        Top = 336
        Width = 75
        Height = 25
        Caption = 'Add...'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 151
        Top = 336
        Width = 75
        Height = 25
        Caption = 'Edit...'
        TabOrder = 2
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 293
        Top = 336
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 3
        OnClick = Button3Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Events'
      ImageIndex = 3
      object EventsGR: TStringGrid
        Left = 0
        Top = 0
        Width = 374
        Height = 329
        Align = alTop
        ColCount = 2
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
        TabOrder = 0
        OnDblClick = EventsGRDblClick
        ColWidths = (
          146
          225)
      end
      object Button4: TButton
        Left = 8
        Top = 336
        Width = 75
        Height = 25
        Caption = 'Add...'
        TabOrder = 1
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 151
        Top = 336
        Width = 75
        Height = 25
        Caption = 'Edit...'
        TabOrder = 2
        OnClick = Button5Click
      end
      object Button6: TButton
        Left = 293
        Top = 336
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 3
        OnClick = Button6Click
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Notes'
      ImageIndex = 4
      object NotesMM: TMemo
        Left = 0
        Top = 0
        Width = 374
        Height = 376
        Align = alClient
        TabOrder = 0
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Photo'
      ImageIndex = 5
      object PhotoIM: TImage
        Left = 0
        Top = 0
        Width = 374
        Height = 329
        Align = alTop
      end
      object Button7: TButton
        Left = 8
        Top = 336
        Width = 75
        Height = 25
        Caption = 'Add/Replace'
        TabOrder = 0
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 293
        Top = 336
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 1
        OnClick = Button8Click
      end
    end
  end
  object Button9: TButton
    Left = 160
    Top = 415
    Width = 75
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'Batch'
    ModalResult = 1
    TabOrder = 3
    OnClick = OKBtnClick
  end
  object PhotoOD: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Choose photo file'
    Left = 184
    Top = 264
  end
end
