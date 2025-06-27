inherited FDataEnrichment: TFDataEnrichment
  Left = 567
  Top = 351
  Width = 685
  Height = 179
  Caption = 'Wzbogacanie danych'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 128
    Width = 677
  end
  object Panel1: TPanel
    Left = 0
    Top = 87
    Width = 677
    Height = 41
    Align = alBottom
    TabOrder = 1
    object BClose: TBitBtn
      Left = 592
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Zamknij'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object LecSub: TBitBtn
    Left = 16
    Top = 8
    Width = 209
    Height = 73
    Caption = 'Przedmioty wyk'#322'adowc'#243'w'
    TabOrder = 2
    OnClick = LecSubClick
  end
  object LecSubDesc: TMemo
    Left = 232
    Top = 8
    Width = 433
    Height = 73
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clMenu
    Lines.Strings = (
      
        'Funkcja wzbogacanie danych uzupe'#322'nia przedmioty, kt'#243're prowadz'#261' ' +
        'wyk'#322'adowcy.'
      
        'Pobiera przedmioty z istniej'#261'cych rozk'#322'ad'#243'w, analizowane s'#261' rozk' +
        #322'ady zaj'#281#263' z ostatnich '
      
        'trzech lat (ostatnich 3*365 dni). Przeliczenie jest wykonywane d' +
        'la wyk'#322'adowc'#243'w '
      'widocznych dla u'#380'ytkownika / wybranej roli.'
      '')
    ReadOnly = True
    TabOrder = 3
  end
  object SQLLecSub: TMemo
    Left = 0
    Top = 0
    Width = 185
    Height = 41
    Lines.Strings = (
      'begin'
      'update LECTURERS set desc1=null where %MY_LEC_ONLY1;'
      'MERGE INTO LECTURERS'
      'USING ('
      '    select lec_id'
      
        '    , LISTAGG(name, '#39', '#39') WITHIN GROUP (ORDER BY name) AS subjec' +
        'ts_list'
      '    from'
      '    ('
      '    select unique subjects.name , lec_id'
      '      from classes cla'
      '         , lec_cla'
      '         , subjects'
      '     where lec_cla.cla_id = cla.id'
      '       and subjects.id = sub_id'
      '       and lec_id>0'
      '       and cla.day > sysdate-365*3'
      '       and %MY_LEC_ONLY2'
      '    )'
      '    group by lec_id'
      ') s'
      'ON (LECTURERS.id = s.lec_id)'
      'WHEN MATCHED THEN'
      '    UPDATE SET LECTURERS.DESC1 = s.subjects_list;'
      'COMMIT;'
      'end;')
    TabOrder = 4
    Visible = False
    WordWrap = False
  end
end
