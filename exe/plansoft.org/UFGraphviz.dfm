inherited FGraphviz: TFGraphviz
  Left = 747
  Top = 445
  Width = 385
  Height = 173
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
  inherited Status: TPanel
    Top = 122
    Width = 377
  end
  object topPanel: TPanel
    Left = 0
    Top = 80
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
  object Interactive: TCheckBox
    Left = 8
    Top = 56
    Width = 97
    Height = 17
    Caption = 'Interaktywny'
    TabOrder = 8
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
