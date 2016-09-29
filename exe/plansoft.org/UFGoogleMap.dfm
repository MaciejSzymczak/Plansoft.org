inherited FGoogleMap: TFGoogleMap
  Left = 444
  Top = 243
  Height = 183
  Caption = 'Mapa Google z zasobami'
  PixelsPerInch = 96
  TextHeight = 14
  object Label3: TLabel [0]
    Left = 8
    Top = 40
    Width = 62
    Height = 14
    Caption = 'Rodzaj mapy'
  end
  inherited Status: TPanel
    Top = 130
  end
  object topPanel: TPanel
    Left = 0
    Top = 89
    Width = 532
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      532
      41)
    object BCreate: TSpeedButton
      Left = 330
      Top = 11
      Width = 111
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Tw'#243'rz map'#281
      Flat = True
      OnClick = BCreateClick
    end
    object BClose: TSpeedButton
      Left = 449
      Top = 11
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Zamknij'
      Flat = True
      OnClick = BCloseClick
    end
    object markerwithlabeljs: TMemo
      Left = 40
      Top = 8
      Width = 33
      Height = 25
      Lines.Strings = (
        '/**'
        ' * @name MarkerWithLabel for V3'
        ' * @version 1.0.1 [September 17, 2010]'
        
          ' * @author Gary Little (inspired by code from Marc Ridey of Goog' +
          'le).'
        
          ' * @copyright Copyright 2010 Gary Little [gary at luxcentral.com' +
          ']'
        
          ' * @fileoverview MarkerWithLabel extends the Google Maps JavaScr' +
          'ipt API V3'
        ' *  <code>google.maps.Marker</code> class.'
        ' *  <p>'
        
          ' *  MarkerWithLabel allows you to define markers with associated' +
          ' labels. As you would expect,'
        
          ' *  if the marker is draggable, so too will be the label. In add' +
          'ition, a marker with a label'
        
          ' *  responds to all mouse events in the same manner as a regular' +
          ' marker. It also fires mouse'
        
          ' *  events and "property changed" events just as a regular marke' +
          'r would.'
        ' */'
        ''
        '/*!'
        ' *'
        
          ' * Licensed under the Apache License, Version 2.0 (the "License"' +
          ');'
        
          ' * you may not use this file except in compliance with the Licen' +
          'se.'
        ' * You may obtain a copy of the License at'
        ' *'
        ' *       http://www.apache.org/licenses/LICENSE-2.0'
        ' *'
        
          ' * Unless required by applicable law or agreed to in writing, so' +
          'ftware'
        
          ' * distributed under the License is distributed on an "AS IS" BA' +
          'SIS,'
        
          ' * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express ' +
          'or implied.'
        
          ' * See the License for the specific language governing permissio' +
          'ns and'
        ' * limitations under the License.'
        ' */'
        ''
        '/*jslint browser:true */'
        '/*global document,google */'
        ''
        '/**'
        
          ' * This constructor creates a label and associates it with a mar' +
          'ker.'
        ' * It is for the private use of the MarkerWithLabel class.'
        ' * @constructor'
        
          ' * @param {Marker} marker The marker with which the label is to ' +
          'be associated.'
        ' * @private'
        ' */'
        'function MarkerLabel_(marker) {'
        '  this.marker_ = marker;'
        ''
        '  this.labelDiv_ = document.createElement("div");'
        
          '  this.labelDiv_.style.cssText = "position: absolute; overflow: ' +
          'hidden;";'
        ''
        
          '  // Set up the DIV for handling mouse events in the label. This' +
          ' DIV forms a transparent veil'
        
          '  // in the "overlayMouseTarget" pane, a veil that covers just t' +
          'he label. This is done so that'
        
          '  // events can be captured even if the label is in the shadow o' +
          'f a google.maps.InfoWindow.'
        
          '  // Code is included here to ensure the veil is always exactly ' +
          'the same size as the label.'
        '  this.eventDiv_ = document.createElement("div");'
        '  this.eventDiv_.style.cssText = this.labelDiv_.style.cssText;'
        '}'
        ''
        '// MarkerLabel_ inherits from OverlayView:'
        'MarkerLabel_.prototype = new google.maps.OverlayView();'
        ''
        '/**'
        
          ' * Adds the DIV representing the label to the DOM. This method i' +
          's called'
        
          ' * automatically when the marker'#39's <code>setMap</code> method is' +
          ' called.'
        ' * @private'
        ' */'
        'MarkerLabel_.prototype.onAdd = function () {'
        '  var me = this;'
        '  var cMouseIsDown = false;'
        '  var cDraggingInProgress = false;'
        '  var cSavedPosition;'
        '  var cSavedZIndex;'
        '  var cLatOffset, cLngOffset;'
        '  var cIgnoreClick;'
        ''
        '  // Stops all processing of an event.'
        '  //'
        '  var cAbortEvent = function (e) {'
        '    if (e.preventDefault) {'
        '      e.preventDefault();'
        '    }'
        '    e.cancelBubble = true;'
        '    if (e.stopPropagation) {'
        '      e.stopPropagation();'
        '    }'
        '  };'
        ''
        '  this.getPanes().overlayImage.appendChild(this.labelDiv_);'
        
          '  this.getPanes().overlayMouseTarget.appendChild(this.eventDiv_)' +
          ';'
        ''
        '  this.listeners_ = ['
        
          '    google.maps.event.addDomListener(document, "mouseup", functi' +
          'on (mEvent) {'
        '      if (cDraggingInProgress) {'
        '        mEvent.latLng = cSavedPosition;'
        
          '        cIgnoreClick = true; // Set flag to ignore the click eve' +
          'nt reported after a label drag'
        
          '        google.maps.event.trigger(me.marker_, "dragend", mEvent)' +
          ';'
        '      }'
        '      cMouseIsDown = false;'
        '      google.maps.event.trigger(me.marker_, "mouseup", mEvent);'
        '    }),'
        
          '    google.maps.event.addListener(me.marker_.getMap(), "mousemov' +
          'e", function (mEvent) {'
        '      if (cMouseIsDown && me.marker_.getDraggable()) {'
        
          '        // Change the reported location from the mouse position ' +
          'to the marker position:'
        
          '        mEvent.latLng = new google.maps.LatLng(mEvent.latLng.lat' +
          '() - cLatOffset, mEvent.latLng.lng() - cLngOffset);'
        '        cSavedPosition = mEvent.latLng;'
        '        if (cDraggingInProgress) {'
        '          google.maps.event.trigger(me.marker_, "drag", mEvent);'
        '        } else {'
        
          '          // Calculate offsets from the click point to the marke' +
          'r position:'
        
          '          cLatOffset = mEvent.latLng.lat() - me.marker_.getPosit' +
          'ion().lat();'
        
          '          cLngOffset = mEvent.latLng.lng() - me.marker_.getPosit' +
          'ion().lng();'
        
          '          google.maps.event.trigger(me.marker_, "dragstart", mEv' +
          'ent);'
        '        }'
        '      }'
        '    }),'
        
          '    google.maps.event.addDomListener(this.eventDiv_, "mouseover"' +
          ', function (e) {'
        '      me.eventDiv_.style.cursor = "pointer";'
        '      google.maps.event.trigger(me.marker_, "mouseover", e);'
        '    }),'
        
          '    google.maps.event.addDomListener(this.eventDiv_, "mouseout",' +
          ' function (e) {'
        '      me.eventDiv_.style.cursor = me.marker_.getCursor();'
        '      google.maps.event.trigger(me.marker_, "mouseout", e);'
        '    }),'
        
          '    google.maps.event.addDomListener(this.eventDiv_, "click", fu' +
          'nction (e) {'
        
          '      if (cIgnoreClick) { // Ignore the click reported when a la' +
          'bel drag ends'
        '        cIgnoreClick = false;'
        '      } else {'
        
          '        cAbortEvent(e); // Prevent click from being passed on to' +
          ' map'
        '        google.maps.event.trigger(me.marker_, "click", e);'
        '      }'
        '    }),'
        
          '    google.maps.event.addDomListener(this.eventDiv_, "dblclick",' +
          ' function (e) {'
        
          '      cAbortEvent(e); // Prevent map zoom when double-clicking o' +
          'n a label'
        '      google.maps.event.trigger(me.marker_, "dblclick", e);'
        '    }),'
        
          '    google.maps.event.addDomListener(this.eventDiv_, "mousedown"' +
          ', function (e) {'
        '      cMouseIsDown = true;'
        '      cDraggingInProgress = false;'
        '      cLatOffset = 0;'
        '      cLngOffset = 0;'
        
          '      cAbortEvent(e); // Prevent map pan when starting a drag on' +
          ' a label'
        '      google.maps.event.trigger(me.marker_, "mousedown", e);'
        '    }),'
        
          '    google.maps.event.addListener(this.marker_, "dragstart", fun' +
          'ction (mEvent) {'
        '      cDraggingInProgress = true;'
        '      cSavedZIndex = me.marker_.getZIndex();'
        '    }),'
        
          '    google.maps.event.addListener(this.marker_, "drag", function' +
          ' (mEvent) {'
        '      me.marker_.setPosition(mEvent.latLng);'
        
          '      me.marker_.setZIndex(1000000); // Moves the marker to the ' +
          'foreground during a drag'
        '    }),'
        
          '    google.maps.event.addListener(this.marker_, "dragend", funct' +
          'ion (mEvent) {'
        '      cDraggingInProgress = false;'
        '      me.marker_.setZIndex(cSavedZIndex);'
        '    }),'
        
          '    google.maps.event.addListener(this.marker_, "position_change' +
          'd", function () {'
        '      me.setPosition();'
        '    }),'
        
          '    google.maps.event.addListener(this.marker_, "zindex_changed"' +
          ', function () {'
        '      me.setZIndex();'
        '    }),'
        
          '    google.maps.event.addListener(this.marker_, "visible_changed' +
          '", function () {'
        '      me.setVisible();'
        '    }),'
        
          '    google.maps.event.addListener(this.marker_, "labelvisible_ch' +
          'anged", function () {'
        '      me.setVisible();'
        '    }),'
        
          '    google.maps.event.addListener(this.marker_, "title_changed",' +
          ' function () {'
        '      me.setTitle();'
        '    }),'
        
          '    google.maps.event.addListener(this.marker_, "labelcontent_ch' +
          'anged", function () {'
        '      me.setContent();'
        '    }),'
        
          '    google.maps.event.addListener(this.marker_, "labelanchor_cha' +
          'nged", function () {'
        '      me.setAnchor();'
        '    }),'
        
          '    google.maps.event.addListener(this.marker_, "labelclass_chan' +
          'ged", function () {'
        '      me.setStyles();'
        '    }),'
        
          '    google.maps.event.addListener(this.marker_, "labelstyle_chan' +
          'ged", function () {'
        '      me.setStyles();'
        '    })'
        '  ];'
        '};'
        ''
        '/**'
        
          ' * Removes the DIV for the label from the DOM. It also removes a' +
          'll event handlers.'
        
          ' * This method is called automatically when the marker'#39's <code>s' +
          'etMap(null)</code>'
        ' * method is called.'
        ' * @private'
        ' */'
        'MarkerLabel_.prototype.onRemove = function () {'
        '  var i;'
        '  this.labelDiv_.parentNode.removeChild(this.labelDiv_);'
        '  this.eventDiv_.parentNode.removeChild(this.eventDiv_);'
        ''
        '  // Remove event listeners:'
        '  for (i = 0; i < this.listeners_.length; i++) {'
        '    google.maps.event.removeListener(this.listeners_[i]);'
        '  }'
        '};'
        ''
        '/**'
        ' * Draws the label on the map.'
        ' * @private'
        ' */'
        'MarkerLabel_.prototype.draw = function () {'
        '  this.setContent();'
        '  this.setTitle();'
        '  this.setStyles();'
        '};'
        ''
        '/**'
        ' * Sets the content of the label.'
        ' * The content can be plain text or an HTML DOM node.'
        ' * @private'
        ' */'
        'MarkerLabel_.prototype.setContent = function () {'
        '  var content = this.marker_.get("labelContent");'
        '  if (typeof content.nodeType === "undefined") {'
        '    this.labelDiv_.innerHTML = content;'
        '    this.eventDiv_.innerHTML = this.labelDiv_.innerHTML;'
        '  } else {'
        '    this.labelDiv_.appendChild(content);'
        '    content = content.cloneNode(true);'
        '    this.eventDiv_.appendChild(content);'
        '  }'
        '};'
        ''
        '/**'
        ' * Sets the content of the tool tip for the label. It is'
        ' * always set to be the same as for the marker itself.'
        ' * @private'
        ' */'
        'MarkerLabel_.prototype.setTitle = function () {'
        '  this.eventDiv_.title = this.marker_.getTitle() || "";'
        '};'
        ''
        '/**'
        
          ' * Sets the style of the label by setting the style sheet and ap' +
          'plying'
        ' * other specific styles requested.'
        ' * @private'
        ' */'
        'MarkerLabel_.prototype.setStyles = function () {'
        '  var i, labelStyle;'
        ''
        
          '  // Apply style values from the style sheet defined in the labe' +
          'lClass parameter:'
        '  this.labelDiv_.className = this.marker_.get("labelClass");'
        '  this.eventDiv_.className = this.labelDiv_.className;'
        ''
        '  // Clear existing inline style values:'
        '  this.labelDiv_.style.cssText = "";'
        '  this.eventDiv_.style.cssText = "";'
        '  // Apply style values defined in the labelStyle parameter:'
        '  labelStyle = this.marker_.get("labelStyle");'
        '  for (i in labelStyle) {'
        '    if (labelStyle.hasOwnProperty(i)) {'
        '      this.labelDiv_.style[i] = labelStyle[i];'
        '      this.eventDiv_.style[i] = labelStyle[i];'
        '    }'
        '  }'
        '  this.setMandatoryStyles();'
        '};'
        ''
        '/**'
        
          ' * Sets the mandatory styles to the DIV representing the label a' +
          's well as to the'
        
          ' * associated event DIV. This includes setting the DIV position,' +
          ' zIndex, and visibility.'
        ' * @private'
        ' */'
        'MarkerLabel_.prototype.setMandatoryStyles = function () {'
        '  this.labelDiv_.style.position = "absolute";'
        '  this.labelDiv_.style.overflow = "hidden";'
        
          '  // Make sure the opacity setting causes the desired effect on ' +
          'MSIE:'
        '  if (typeof this.labelDiv_.style.opacity !== "undefined") {'
        
          '    this.labelDiv_.style.filter = "alpha(opacity=" + (this.label' +
          'Div_.style.opacity * 100) + ")";'
        '  }'
        ''
        '  this.eventDiv_.style.position = this.labelDiv_.style.position;'
        '  this.eventDiv_.style.overflow = this.labelDiv_.style.overflow;'
        
          '  this.eventDiv_.style.opacity = 0.01; // Don'#39't use 0; DIV won'#39't' +
          ' be clickable on MSIE'
        '  this.eventDiv_.style.filter = "alpha(opacity=1)"; // For MSIE'
        '  '
        '  this.setAnchor();'
        '  this.setPosition(); // This also updates zIndex, if necessary.'
        '  this.setVisible();'
        '};'
        ''
        '/**'
        ' * Sets the anchor point of the label.'
        ' * @private'
        ' */'
        'MarkerLabel_.prototype.setAnchor = function () {'
        '  var anchor = this.marker_.get("labelAnchor");'
        '  this.labelDiv_.style.marginLeft = -anchor.x + "px";'
        '  this.labelDiv_.style.marginTop = -anchor.y + "px";'
        '  this.eventDiv_.style.marginLeft = -anchor.x + "px";'
        '  this.eventDiv_.style.marginTop = -anchor.y + "px";'
        '};'
        ''
        '/**'
        
          ' * Sets the position of the label. The zIndex is also updated, i' +
          'f necessary.'
        ' * @private'
        ' */'
        'MarkerLabel_.prototype.setPosition = function () {'
        
          '  var position = this.getProjection().fromLatLngToDivPixel(this.' +
          'marker_.getPosition());'
        '  '
        '  this.labelDiv_.style.left = position.x + "px";'
        '  this.labelDiv_.style.top = position.y + "px";'
        '  this.eventDiv_.style.left = this.labelDiv_.style.left;'
        '  this.eventDiv_.style.top = this.labelDiv_.style.top;'
        ''
        '  this.setZIndex();'
        '};'
        ''
        '/**'
        
          ' * Sets the zIndex of the label. If the marker'#39's zIndex property' +
          ' has not been defined, the zIndex'
        
          ' * of the label is set to the vertical coordinate of the label. ' +
          'This is in keeping with the default'
        
          ' * stacking order for Google Maps: markers to the south are in f' +
          'ront of markers to the north.'
        ' * @private'
        ' */'
        'MarkerLabel_.prototype.setZIndex = function () {'
        
          '  var zAdjust = (this.marker_.get("labelInBackground") ? -1 : +1' +
          ');'
        '  if (typeof this.marker_.getZIndex() === "undefined") {'
        
          '    this.labelDiv_.style.zIndex = parseInt(this.labelDiv_.style.' +
          'top, 10) + zAdjust;'
        '    this.eventDiv_.style.zIndex = this.labelDiv_.style.zIndex;'
        '  } else {'
        
          '    this.labelDiv_.style.zIndex = this.marker_.getZIndex() + zAd' +
          'just;'
        '    this.eventDiv_.style.zIndex = this.labelDiv_.style.zIndex;'
        '  }'
        '};'
        ''
        '/**'
        
          ' * Sets the visibility of the label. The label is visible only i' +
          'f the marker itself is'
        
          ' * visible (i.e., its visible property is true) and the labelVis' +
          'ible property is true.'
        ' * @private'
        ' */'
        'MarkerLabel_.prototype.setVisible = function () {'
        '  if (this.marker_.get("labelVisible")) {'
        
          '    this.labelDiv_.style.display = this.marker_.getVisible() ? "' +
          'block" : "none";'
        '  } else {'
        '    this.labelDiv_.style.display = "none";'
        '  }'
        '  this.eventDiv_.style.display = this.labelDiv_.style.display;'
        '};'
        ''
        '/**'
        ' * @name MarkerWithLabelOptions'
        
          ' * @class This class represents the optional parameter passed to' +
          ' the {@link MarkerWithLabel} constructor.'
        
          ' *  The properties available are the same as for <code>google.ma' +
          'ps.Marker</code> with the addition'
        
          ' *  of the properties listed below. To change any of these addit' +
          'ional properties after the labeled'
        
          ' *  marker has been created, call <code>google.maps.Marker.set(p' +
          'ropertyName, propertyValue)</code>.'
        ' *  <p>'
        
          ' *  When any of these properties changes, a property changed eve' +
          'nt is fired. The names of these'
        
          ' *  events are derived from the name of the property and are of ' +
          'the form <code>propertyname_changed</code>.'
        
          ' *  For example, if the content of the label changes, a <code>la' +
          'belcontent_changed</code> event'
        ' *  is fired.'
        ' *  <p>'
        
          ' * @property {string|Node} [labelContent] The content of the lab' +
          'el (plain text or an HTML DOM node).'
        
          ' * @property {Point} [labelAnchor] By default, a label is drawn ' +
          'with its anchor point at (0,0) so'
        
          ' *  that its top left corner is positioned at the anchor point o' +
          'f the associated marker. Use this'
        
          ' *  property to change the anchor point of the label. For exampl' +
          'e, to center a 50px-wide label'
        
          ' *  beneath a marker, specify a <code>labelAnchor</code> of <cod' +
          'e>google.maps.Point(25, 0)</code>.'
        
          ' *  (Note: x-values increase to the right and y-values increase ' +
          'to the bottom.)'
        
          ' * @property {string} [labelClass] The name of the CSS class def' +
          'ining the styles for the label.'
        
          ' *  Note that style values for <code>position</code>, <code>over' +
          'flow</code>, <code>top</code>,'
        
          ' *  <code>left</code>, <code>zIndex</code>, <code>display</code>' +
          ', <code>marginLeft</code>, and'
        
          ' *  <code>marginTop</code> are ignored; these styles are for int' +
          'ernal use only.'
        
          ' * @property {Object} [labelStyle] An object literal whose prope' +
          'rties define specific CSS'
        
          ' *  style values to be applied to the label. Style values define' +
          'd here override those that may'
        
          ' *  be defined in the <code>labelClass</code> style sheet. If th' +
          'is property is changed after the'
        
          ' *  label has been created, all previously set styles (except th' +
          'ose defined in the style sheet)'
        
          ' *  are removed from the label before the new style values are a' +
          'pplied.'
        
          ' *  Note that style values for <code>position</code>, <code>over' +
          'flow</code>, <code>top</code>,'
        
          ' *  <code>left</code>, <code>zIndex</code>, <code>display</code>' +
          ', <code>marginLeft</code>, and'
        
          ' *  <code>marginTop</code> are ignored; these styles are for int' +
          'ernal use only.'
        
          ' * @property {boolean} [labelInBackground] A flag indicating whe' +
          'ther a label that overlaps its'
        
          ' *  associated marker should appear in the background (i.e., in ' +
          'a plane below the marker).'
        
          ' *  The default is <code>false</code>, which causes the label to' +
          ' appear in the foreground.'
        
          ' * @property {boolean} [labelVisible] A flag indicating whether ' +
          'the label is to be visible.'
        
          ' *  The default is <code>true</code>. Note that even if <code>la' +
          'belVisible</code> is'
        
          ' *  <code>true</code>, the label will <i>not</i> be visible unle' +
          'ss the associated marker is also'
        
          ' *  visible (i.e., unless the marker'#39's <code>visible</code> prop' +
          'erty is <code>true</code>).'
        ' */'
        '/**'
        
          ' * Creates a MarkerWithLabel with the options specified in {@lin' +
          'k MarkerWithLabelOptions}.'
        ' * @constructor'
        
          ' * @param {MarkerWithLabelOptions} [opt_options] The optional pa' +
          'rameters.'
        ' */'
        'function MarkerWithLabel(opt_options) {'
        '  opt_options = opt_options || {};'
        '  opt_options.labelContent = opt_options.labelContent || "";'
        
          '  opt_options.labelAnchor = opt_options.labelAnchor || new googl' +
          'e.maps.Point(0, 0);'
        
          '  opt_options.labelClass = opt_options.labelClass || "markerLabe' +
          'ls";'
        '  opt_options.labelStyle = opt_options.labelStyle || {};'
        
          '  opt_options.labelInBackground = opt_options.labelInBackground ' +
          '|| false;'
        '  if (typeof opt_options.labelVisible === "undefined") {'
        '    opt_options.labelVisible = true;'
        '  }'
        ''
        
          '  this.label = new MarkerLabel_(this); // Bind the label to the ' +
          'marker'
        ''
        
          '  // Call the parent constructor. It calls Marker.setValues to i' +
          'nitialize, so all'
        
          '  // the new parameters are conveniently saved and can be access' +
          'ed with get/set.'
        
          '  // Marker.set triggers a property changed event (called "prope' +
          'rtyname_changed")'
        
          '  // that the marker label listens for in order to react to stat' +
          'e changes.'
        '  google.maps.Marker.apply(this, arguments);'
        '}'
        ''
        '// MarkerWithLabel inherits from <code>Marker</code>:'
        'MarkerWithLabel.prototype = new google.maps.Marker();'
        ''
        'MarkerWithLabel.prototype.setMap = function (theMap) {'
        '  // Call the inherited function...'
        '  google.maps.Marker.prototype.setMap.apply(this, arguments);'
        ''
        '  // ... then deal with the label:'
        '  this.label.setMap(theMap);'
        '};')
      TabOrder = 0
      Visible = False
      WordWrap = False
    end
  end
  object showAll: TCheckBox
    Left = 8
    Top = 7
    Width = 321
    Height = 17
    Caption = 'Uwzgl'#281'dniaj wszystkie zasoby (ignoruj uprawnienia dost'#281'pu)'
    TabOrder = 2
  end
  object map: TMemo
    Left = 443
    Top = 8
    Width = 81
    Height = 65
    Lines.Strings = (
      'Drogowa=google.maps.MapTypeId.ROADMAP'
      'Satelita=google.maps.MapTypeId.SATELLITE'
      'Hybrydowa=google.maps.MapTypeId.HYBRID'
      'Terenowa=google.maps.MapTypeId.TERRAIN'
      '---------------'
      ''
      '')
    TabOrder = 3
    Visible = False
    WordWrap = False
  end
  object pmapTypeId: TComboBox
    Left = 77
    Top = 32
    Width = 132
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 4
    Text = 'Drogowa'
    Items.Strings = (
      'Drogowa'
      'Satelita'
      'Hybrydowa'
      'Terenowa')
  end
  object googleMap: TADOQuery
    AutoCalcFields = False
    Connection = DModule.ADOConnection
    CommandTimeout = 1000
    Parameters = <>
    Left = 8
    Top = 88
  end
end
