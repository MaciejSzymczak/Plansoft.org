inherited FGraphviz: TFGraphviz
  Left = 747
  Top = 445
  Width = 385
  Height = 234
  Caption = 'Diagram: Nadrz'#281'dny - podrz'#281'dny'
  PixelsPerInch = 96
  TextHeight = 14
  object Label3: TLabel [0]
    Left = 8
    Top = 16
    Width = 57
    Height = 14
    Caption = 'Co pokaza'#263
  end
  object Label1: TLabel [1]
    Left = 8
    Top = 40
    Width = 49
    Height = 14
    Caption = 'Orientacja'
  end
  object Label2: TLabel [2]
    Left = 8
    Top = 64
    Width = 33
    Height = 14
    Caption = 'Rodzaj'
  end
  inherited Status: TPanel
    Top = 183
    Width = 377
  end
  object topPanel: TPanel
    Left = 0
    Top = 141
    Width = 377
    Height = 42
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      377
      42)
    object BCreate: TSpeedButton
      Left = 175
      Top = 11
      Width = 111
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Tw'#243'rz diagram'
      Flat = True
      OnClick = BCreateClick
    end
    object BClose: TSpeedButton
      Left = 294
      Top = 11
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Zamknij'
      Flat = True
      OnClick = BCloseClick
    end
  end
  object chartHeader: TMemo
    Left = 24
    Top = 280
    Width = 185
    Height = 89
    Lines.Strings = (
      '<html>'
      
        '<script type="text/javascript" src="http://viz-js.com/bower_comp' +
        'onents/viz.js/viz.js"></script>'
      '<body>'
      '<script>'
      'var gt = '#39'digraph G { %orientation'#39';')
    TabOrder = 2
    Visible = False
    WordWrap = False
  end
  object chartFooter: TMemo
    Left = 216
    Top = 280
    Width = 185
    Height = 89
    Lines.Strings = (
      '    gt += '#39'}'#39';'
      'document.body.innerHTML = Viz(gt, "svg");'
      '</script>'
      '</body>'
      '</html>')
    TabOrder = 3
    Visible = False
    WordWrap = False
  end
  object pmapTypeId: TComboBox
    Left = 77
    Top = 8
    Width = 292
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 4
    Text = 'Wszystkie grupy'
    Items.Strings = (
      'Wszystkie grupy'
      'Grupy z bie'#380#261'cego semestru'
      'Grupy powi'#261'zane z wybran'#261' grup'#261)
  end
  object orientation: TComboBox
    Left = 77
    Top = 32
    Width = 292
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 1
    TabOrder = 5
    Text = 'Pionowo'
    Items.Strings = (
      'Poziomo'
      'Pionowo')
  end
  object chartHeaderIneractive: TMemo
    Left = 24
    Top = 384
    Width = 185
    Height = 89
    Lines.Strings = (
      '<!doctype html>'
      '<html>'
      '<head>'
      '  <style type="text/css">'
      '    #mynetwork {'
      '      width: 1200px;'
      '      height: 1200px'
      '    }'
      '  </style>'
      ''
      
        '  <script type="text/javascript" src="https://cdnjs.cloudflare.c' +
        'om/ajax/libs/vis/4.21.0/vis.min.js"></script>'
      
        '  <link href="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/' +
        'vis.min.css" rel="stylesheet" type="text/css" />'
      ''
      '  <script type="text/javascript">'
      '    var nodes = null;'
      '    var edges = null;'
      '    var network = null;'
      ''
      '    // Called when the Visualization API is loaded.'
      '    function draw() {'
      '      // Create a data table with nodes.'
      '      nodes = [];'
      ''
      '      // Create a data table with links.'
      '      edges = [];'
      ''
      '      //nodes.push({id: 100, label: '#39'Parent'#39'});'
      '      //nodes.push({id: 200, label: '#39'Child'#39'});'
      '      //edges.push({from: 100, to: 200, length: 1});')
    TabOrder = 6
    Visible = False
    WordWrap = False
  end
  object chartFooterInteractive: TMemo
    Left = 216
    Top = 384
    Width = 185
    Height = 89
    Lines.Strings = (
      '      // create a network'
      '      var container = document.getElementById('#39'mynetwork'#39');'
      '      var data = {'
      '        nodes: nodes,'
      '        edges: edges'
      '      };'
      '      var options = {};'
      '      network = new vis.Network(container, data, options);'
      '    }'
      '  </script>'
      '  '
      ''
      '<body onload="draw()">'
      '<div id="mynetwork"></div>'
      ''
      '</body>'
      '</html>')
    TabOrder = 7
    Visible = False
    WordWrap = False
  end
  object chartHeaderVer2: TMemo
    Left = 424
    Top = 280
    Width = 185
    Height = 89
    Lines.Strings = (
      '<html>'
      
        '<script type="text/javascript" src="http://viz-js.com/bower_comp' +
        'onents/viz.js/viz.js"></script>'
      '<body>'
      ''
      '<p>Prawie gotowe.</p>'
      
        '<p>Kliknij <a href=" https://viz-js.com/" target="_blank" >TUTAJ' +
        '</a> aby uruchomi'#263' program Viz-js.com i skopiuj tam poni'#380'sz'#261' zaw' +
        'arto'#347#263'. Viz-js.com jest programem graficznym.</p>'
      ''
      '<br/>'
      'digraph G { %orientation'
      '<br/>')
    TabOrder = 8
    Visible = False
    WordWrap = False
  end
  object chartFooterVer2: TMemo
    Left = 616
    Top = 280
    Width = 185
    Height = 89
    Lines.Strings = (
      '}'
      '</body>'
      '</html>')
    TabOrder = 9
    Visible = False
    WordWrap = False
  end
  object chartHeaderVer3: TMemo
    Left = 832
    Top = 280
    Width = 185
    Height = 89
    Lines.Strings = (
      '<!DOCTYPE html>'
      '<html>'
      '<head>'
      '<title>Plansoft.org - diagram</title>'
      '</head>'
      '<body>'
      '')
    TabOrder = 10
    Visible = False
    WordWrap = False
  end
  object chartFooterVer3: TMemo
    Left = 1024
    Top = 280
    Width = 185
    Height = 89
    Lines.Strings = (
      '</body>'
      '</html>')
    TabOrder = 11
    Visible = False
    WordWrap = False
  end
  object ChartMode: TComboBox
    Left = 77
    Top = 56
    Width = 292
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 12
    Text = 'Obraz'
    Items.Strings = (
      'Obraz'
      'Edytowalny'
      'Interaktywny')
  end
  object SQLcurrentGroup: TMemo
    Left = 16
    Top = 88
    Width = 57
    Height = 41
    Lines.Strings = (
      'select * from'
      '('
      
        'select child_dsp, parent_dsp, exclusive_parent, (select colour f' +
        'rom groups where id = child_id) as color, child_id, parent_id '
      'from str_elems_v '
      'where child_id in (select id from helper1) '
      'or parent_id in (select id from helper1) '
      'union all'
      
        'select res_excluded_dsp, res_dsp, '#39'X'#39' exclusive_parent, (select ' +
        'colour from groups where id = res_id_excluded) as color, res_id_' +
        'excluded, res_id '
      'from exclusions_v '
      'where type!='#39'Nad'#39' and'
      '('
      'res_id_excluded in (select id from helper1)'
      'or'
      'res_id in (select id from helper1)'
      ')'
      ')'
      'order by parent_dsp, child_dsp')
    TabOrder = 13
    Visible = False
    WordWrap = False
  end
  object SQLMain: TMemo
    Left = 80
    Top = 88
    Width = 57
    Height = 41
    Lines.Strings = (
      'select * from '
      '('
      
        'select child_dsp, parent_dsp, exclusive_parent, (select colour f' +
        'rom groups where id = child_id) as color, child_id, parent_id fr' +
        'om str_elems_v'
      'union all'
      
        'select res_excluded_dsp, res_dsp, '#39'X'#39' exclusive_parent, (select ' +
        'colour from groups where id = res_id_excluded) as color, res_id_' +
        'excluded, res_id from exclusions_v'
      'where type!='#39'Nad'#39
      ')')
    TabOrder = 14
    Visible = False
    WordWrap = False
  end
  object generateChart: TADOQuery
    AutoCalcFields = False
    Connection = DModule.ADOConnection
    CommandTimeout = 1000
    Parameters = <>
    SQL.Strings = (
      
        'select  '#39'gt += '#39#39'"'#39' || child_dsp || '#39'"->"'#39' || parent_dsp || '#39'";'#39 +
        #39#39' relation from str_elems_v'
      '')
    Left = 216
    Top = 8
  end
end
