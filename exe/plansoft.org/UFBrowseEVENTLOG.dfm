inherited FBrowseEVENTLOG: TFBrowseEVENTLOG
  Caption = 'Dziennik zdarze'#324' systemowych'
  PixelsPerInch = 96
  TextHeight = 14
  inherited MainPage: TPageControl
    inherited Browse: TTabSheet
      inherited Grid: TRxDBGrid
        Columns = <
          item
            Expanded = False
            FieldName = 'CREATED_DSP'
            Title.Caption = 'Data i godzina'
            Width = 130
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MESSAGE_TYPE'
            Title.Caption = 'Rodzaj'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MODULE_NAME'
            Title.Caption = 'Modu'#322
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MESSAGE'
            Title.Caption = 'Komunikat'
            Width = 600
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ID'
            Title.Caption = 'Id'
            Width = 60
            Visible = True
          end>
      end
    end
  end
  inherited Query: TADOQuery
    CursorType = ctStatic
    SQL.Strings = (
      'select e.id'
      '     , e.created_dsp'
      '     , e.message_type'
      '     , e.module_name'
      '     , e.message'
      '  from (select id, to_char(created, ''yyyy-mm-dd hh24:mi:ss'') created_dsp, message_type, module_name, message'
      '          from xxmsztools_eventlog'
      '         order by id desc) e'
      ' where %CONDITIONALS AND %SEARCH'
      '%SORTORDER')
  end
end
