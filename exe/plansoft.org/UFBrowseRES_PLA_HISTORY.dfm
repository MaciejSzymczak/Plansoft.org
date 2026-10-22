inherited FBrowseRES_PLA_HISTORY: TFBrowseRES_PLA_HISTORY
  Caption = 'Historia zmian uprawnie'#324
  PixelsPerInch = 96
  TextHeight = 14
  inherited MainPage: TPageControl
    inherited Browse: TTabSheet
      inherited Grid: TRxDBGrid
        Columns = <
          item
            Expanded = False
            FieldName = 'LAST_UPDATE_DATE'
            Title.Caption = 'Data zmiany'
            Width = 120
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OPERATION_DSP'
            Title.Caption = 'Operacja'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RES_TYPE'
            Title.Caption = 'Typ zasobu'
            Width = 90
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RES_NAME'
            Title.Caption = 'Zas'#243'b'
            Width = 260
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PLA_NAME'
            Title.Caption = 'Komu'
            Width = 160
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LAST_UPDATED_BY'
            Title.Caption = 'Zmieni'#322
            Width = 110
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OS_USER'
            Title.Caption = 'U'#380'ytkownik systemu'
            Width = 130
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MODULE'
            Title.Caption = 'Program'
            Width = 110
            Visible = True
          end>
      end
      inherited CustomPanel: TPanel
        Height = 33
        object LPlaSearch: TLabel
          Left = 8
          Top = 9
          Width = 84
          Height = 14
          Caption = 'Komu zmieniono:'
        end
        object EPlaSearch: TEdit
          Left = 96
          Top = 5
          Width = 180
          Height = 22
          TabOrder = 0
          OnChange = ExtraSearchChange
        end
        object LChangedBySearch: TLabel
          Left = 292
          Top = 9
          Width = 60
          Height = 14
          Caption = 'Kto zmieni'#322':'
        end
        object EChangedBySearch: TEdit
          Left = 356
          Top = 5
          Width = 150
          Height = 22
          TabOrder = 1
          OnChange = ExtraSearchChange
        end
        object LHint: TLabel
          Left = 520
          Top = 9
          Width = 262
          Height = 14
          Caption = 'Kilka fraz oddziel przecinkiem, np. Kowalski, Nowak'
        end
      end
    end
  end
  inherited HolderSortOrder: TStrHolder
    Capacity = 8
    StrData = (
      ''
      
        '494420444553437c44617461207a6d69616e79202d206f64206e616a6e6f7773' +
        '7a7963687c43415445474f52593a44454641554c54'
      
        '49447c44617461207a6d69616e79202d206f64206e616a73746172737a796368' +
        '7c43415445474f52593a44454641554c54'
      
        '5245535f4e414d452c20494420444553437c5a6173f3627c43415445474f5259' +
        '3a44454641554c54'
      
        '504c415f4e414d452c20494420444553437c4b6f6d757c43415445474f52593a' +
        '44454641554c54'
      
        '4c4153545f555044415445445f42592c20494420444553437c5a6d69656e69b3' +
        '7c43415445474f52593a44454641554c54'
      '')
  end
  inherited Query: TADOQuery
    CursorType = ctStatic
    SQL.Strings = (
      'select *'
      '  from (select h.id'
      '             , h.last_update_date'
      '             , %RES_TYPE_DSP res_type'
      '             , nvl(case h.table_name'
      '                     when '#39'LEC_PLA'#39' then (select trim(title||'#39' '#39'||last_name||'#39' '#39'||first_name) from lecturers where id = h.res_id)'
      '                     when '#39'GRO_PLA'#39' then (select nvl(abbreviation, name) from groups where id = h.res_id)'
      '                     when '#39'ROM_PLA'#39' then (select name from rooms where id = h.res_id)'
      '                     when '#39'SUB_PLA'#39' then (select name from subjects where id = h.res_id)'
      '                     when '#39'FOR_PLA'#39' then (select name from forms where id = h.res_id)'
      '                     when '#39'PER_PLA'#39' then (select name from periods where id = h.res_id)'
      '                     when '#39'ROL_PLA'#39' then (select name from planners where id = h.res_id)'
      '                   end, '#39'(usuni'#281'ty, id='#39'||h.res_id||'#39')'#39') res_name'
      '             , decode(h.operation, '#39'I'#39', '#39'Nadanie'#39', '#39'D'#39', '#39'Odebranie'#39', '#39'U-'#39', '#39'Zmiana - przed'#39', '#39'U+'#39', '#39'Zmiana - po'#39', h.operation)'
      '               || decode(h.access_type, null, null, '#39' ('#39'||h.access_type||'#39')'#39') operation_dsp'
      '             , nvl((select name from planners where id = h.pla_id), '#39'(usuni'#281'ty, id='#39'||h.pla_id||'#39')'#39') pla_name'
      '             , h.last_updated_by'
      '             , h.os_user'
      '             , h.module'
      '             , h.table_name'
      '             , h.operation'
      '             , h.access_type'
      '             , h.res_id'
      '             , h.pla_id'
      '          from res_pla_history h'
      '         where %SEARCH'
      '           and %PLA_FILTER'
      '           and %LUB_FILTER'
      '        %SORTORDER)'
      ' where %CONDITIONALS')
  end
end
