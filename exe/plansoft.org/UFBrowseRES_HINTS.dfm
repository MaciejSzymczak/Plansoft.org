inherited FBrowseRES_HINTS: TFBrowseRES_HINTS
  Caption = 'Preferowane Terminy'
  PixelsPerInch = 96
  TextHeight = 14
  inherited MainPage: TPageControl
    inherited Browse: TTabSheet
      inherited Grid: TRxDBGrid
        Columns = <
          item
            Expanded = False
            FieldName = 'DAY'
            Title.Caption = 'Dzie'#324
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CAPTION'
            Title.Caption = 'Godzina'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RATIO'
            Title.Caption = 'Preferencja'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Title.Caption = 'Wyk'#322'adowca lub nazwa zasobu'
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CREATED_BY'
            Title.Caption = 'Utworzy'#322
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CREATION_DATE'
            Title.Caption = 'Data utworzenia'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LAST_UPDATED_BY'
            Title.Caption = 'Zmieni'#322
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LAST_UPDATE_DATE'
            Title.Caption = 'Data zmiany'
            Width = 100
            Visible = True
          end>
      end
    end
  end
  inherited Query: TADOQuery
    CursorType = ctStatic
    SQL.Strings = (
      'select res_hints.id '
      '     , res_hints.day'
      '     , grids.caption'
      
        '     , case when res_hints.ratio>0 then '#39'TAK '#39'||res_hints.ratio ' +
        'else '#39'NIE '#39'||res_hints.ratio  end ratio'
      '     , resources.name '
      '     , res_hints.created_by'
      '     , res_hints.creation_date'
      '     , res_hints.last_update_date'
      '     , res_hints.last_updated_by'
      '  from res_hints'
      '     , resources'
      '     , grids'
      '  where res_hints.res_id = resources.id'
      '    and grids.no = res_hints.hour'
      '    and %CONDITIONALS AND %SEARCH'
      '%SORTORDER')
  end
end
