object Form1: TForm1
  Left = 192
  Top = 117
  Width = 1305
  Height = 675
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 88
    Width = 24
    Height = 13
    Caption = 'Input'
  end
  object Label2: TLabel
    Left = 544
    Top = 88
    Width = 32
    Height = 13
    Caption = 'Output'
  end
  object Button1: TButton
    Left = 16
    Top = 16
    Width = 75
    Height = 25
    Caption = 'POST'
    TabOrder = 0
    OnClick = Button1Click
  end
  object output: TMemo
    Left = 536
    Top = 104
    Width = 729
    Height = 505
    Lines.Strings = (
      'output')
    TabOrder = 1
  end
  object Input: TMemo
    Left = 16
    Top = 104
    Width = 521
    Height = 505
    Lines.Strings = (
      '@startuml'
      ''
      'digraph world {'
      'size="7,7";'
      #9'{rank=same; S8 S24 S1 S35 S30;}'
      #9'{rank=same; T8 T24 T1 T35 T30;}'
      #9'{rank=same; 43 37 36 10 2;}'
      #9'{rank=same; 25 9 38 40 13 17 12 18;}'
      #9'{rank=same; 26 42 11 3 33 19 39 14 16;}'
      #9'{rank=same; 4 31 34 21 41 28 20;}'
      #9'{rank=same; 27 5 22 32 29 15;}'
      #9'{rank=same; 6 23;}'
      #9'{rank=same; 7;}'
      ''
      #9'S8 -> 9;'
      #9'S24 -> 25;'
      #9'S24 -> 27;'
      #9'S1 -> 2;'
      #9'S1 -> 10;'
      #9'S35 -> 43;'
      #9'S35 -> 36;'
      #9'S30 -> 31;'
      #9'S30 -> 33;'
      #9'9 -> 42;'
      #9'9 -> T1;'
      #9'25 -> T1;'
      #9'25 -> 26;'
      #9'27 -> T24;'
      #9'2 -> {3 ; 16 ; 17 ; T1 ; 18}'
      #9'10 -> { 11 ; 14 ; T1 ; 13; 12;}'
      #9'31 -> T1;'
      #9'31 -> 32;'
      #9'33 -> T30;'
      #9'33 -> 34;'
      #9'42 -> 4;'
      #9'26 -> 4;'
      #9'3 -> 4;'
      #9'16 -> 15;'
      #9'17 -> 19;'
      #9'18 -> 29;'
      #9'11 -> 4;'
      #9'14 -> 15;'
      #9'37 -> {39 ; 41 ; 38 ; 40;}'
      #9'13 -> 19;'
      #9'12 -> 29;'
      #9'43 -> 38;'
      #9'43 -> 40;'
      #9'36 -> 19;'
      #9'32 -> 23;'
      #9'34 -> 29;'
      #9'39 -> 15;'
      #9'41 -> 29;'
      #9'38 -> 4;'
      #9'40 -> 19;'
      #9'4 -> 5;'
      #9'19 -> {21 ; 20 ; 28;}'
      #9'5 -> {6 ; T35 ; 23;}'
      #9'21 -> 22;'
      #9'20 -> 15;'
      #9'28 -> 29;'
      #9'6 -> 7;'
      #9'15 -> T1;'
      #9'22 -> T35;'
      #9'22 -> 23;'
      #9'29 -> T30;'
      #9'7 -> T8;'
      #9'23 -> T24;'
      #9'23 -> T1;'
      '}'
      '@enduml')
    TabOrder = 2
  end
  object url: TEdit
    Left = 96
    Top = 16
    Width = 497
    Height = 21
    TabOrder = 3
    Text = 'https://soft.home.pl/tools/plantumlAPI.php'
  end
end
