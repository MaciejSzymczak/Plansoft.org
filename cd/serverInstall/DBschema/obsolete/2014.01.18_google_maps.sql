CREATE OR REPLACE package google_map is  
    function getMap(
              ppla_id    varchar2  
            , pentire_db varchar2  
            , pscale     varchar2 --scale is a dummy parameter. scale is adjusted automatically
            , pmapTypeId varchar2
    ) return clob;  
end;
/

CREATE OR REPLACE package body google_map is  
     res clob;  
       
    --------------------------------------------------------------  
    function getMap(
              ppla_id varchar2  
            , pentire_db varchar2  
            , pscale     varchar2
            , pmapTypeId varchar2
    ) return clob is  
     counter number := 0;  
     avg_longitude varchar2(200);
     avg_latitude varchar2(200);
  
            --------------------------------------------------------------  
            procedure NewClob  (clobloc       in out nocopy clob,  
                                msg_string    in varchar2) is  
             pos integer;  
             amt number;  
            begin  
               dbms_lob.createtemporary(clobloc, TRUE, DBMS_LOB.session);  
               if msg_string is not null then  
                  pos := 1;  
                  amt := length(msg_string);  
                  dbms_lob.write(clobloc,amt,pos,msg_string);  
               end if;  
            end NewClob;  
  
            --------------------------------------------------------------  
            procedure WriteToClob  ( clob_loc      in out nocopy clob,msg_string    in  varchar2) is  
             pos integer;  
             amt number;  
            begin  
               pos :=   dbms_lob.getlength(clob_loc) +1;  
               amt := length(msg_string);  
               dbms_lob.write(clob_loc,amt,pos,msg_string);  
            end WriteToClob;  
  
 
    --------------------------------------------------------------   
    begin --getMap 
    
        select replace(to_char(avg(XXMSZ_TOOLS.strToNumber(longitude))),',','.')
             , replace(to_char(avg(XXMSZ_TOOLS.strToNumber(latitude))),',','.') 
          into avg_longitude, avg_latitude 
          from (
              select name 
                   , xxmsz_tools.extractWord(1,xxmsz_tools.extractWord(1,GOOGLE_LOCATION,'('),',') longitude 
                   , xxmsz_tools.extractWord(2,xxmsz_tools.extractWord(1,GOOGLE_LOCATION,'('),',') latitude
                from rooms
               where (pentire_db='Y' and 0=0)
                     or
                     (pentire_db='N' and ID IN (SELECT ROM_ID FROM ROM_PLA WHERE PLA_ID = ppla_id))                        
          )
          where xxmsz_tools.isnumber(longitude)='Y' 
            and xxmsz_tools.isnumber(latitude)='Y'
            and latitude is not null
            and latitude is not null;        
    --raise_application_error(-20000, ppla_id ||' ' ||pentire_db||' '|| avg_longitude ||'     '|| avg_latitude );
    
    
        NewClob(res, '');   
        WriteToClob(res,'
<!DOCTYPE html "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 <meta http-equiv="content-type" content="text/html; charset=windows-1250" />
 <title>Plansoft.org- zasoby na mapie</title>
 <style type="text/css">
   .labels {
     color: red;
     background-color: transparent;
     font-family: "Lucida Grande", "Arial", sans-serif;
     font-size: 10px;
     font-weight: bold;
     text-align: left;
     width: 140px;     
     border: 0px solid black;
     white-space: nowrap;
   }
 </style>
 <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
 <script type="text/javascript" src="markerwithlabel.js"></script>
 <script type="text/javascript">
   function initMap() {
     var latLng = new google.maps.LatLng('||avg_longitude||', '||avg_latitude||');

     var map = new google.maps.Map(document.getElementById(''map_canvas''), {
       zoom: '||pscale||',
       center: latLng,
			navigationControl: true,
			panControl: true,
			zoomControl: true,
			streetViewControl: true,
			scaleControl: true,
			rotateControl: true,
			overviewMapControl: true,
			overviewMapControlOptions: {
				opened: true
			},
			navigationControlOptions: {
				style: google.maps.NavigationControlStyle.DEFAULT
			},
			mapTypeControl: true,
			mapTypeControlOptions: {
				style: google.maps.MapTypeControlStyle.DEFAULT
			},
       mapTypeId: '||pmapTypeId||'
     });
     var area = new google.maps.LatLngBounds();
');
        
        -------------------------------------------------------------- 
        declare
          point_num integer := 1;
          n         varchar2(50);
        begin
        for rec in (
              select name,attribs_01,desc1,desc2
                   , longitude
                   , latitude 
                from (
                    select name,attribs_01,desc1,desc2
                         , xxmsz_tools.extractWord(1,xxmsz_tools.extractWord(1,GOOGLE_LOCATION,'('),',') longitude 
                         , xxmsz_tools.extractWord(2,xxmsz_tools.extractWord(1,GOOGLE_LOCATION,'('),',') latitude
                      from rooms
                     where (pentire_db='Y' and 0=0)
                           or
                           (pentire_db='N' and ID IN (SELECT ROM_ID FROM ROM_PLA WHERE PLA_ID = ppla_id))                        
                )
                where xxmsz_tools.isnumber(longitude)='Y' 
                  and xxmsz_tools.isnumber(latitude)='Y'
                  and latitude is not null
                  and latitude is not null
              order by name        
        ) loop

               n := to_char(point_num);
               WriteToClob(res,'
     var marker'||n||' = new MarkerWithLabel({
       position: new google.maps.LatLng('||rec.longitude||', '||rec.latitude||'),
       draggable: true,
       map: map,
       labelContent: "'||rec.attribs_01  || ' ' || rec.name||'",
       labelAnchor: new google.maps.Point(22, 0),
       labelClass: "labels", // the CSS class for the label
       labelStyle: {opacity: 0.9},
	   icon : ''http://maps.google.com/mapfiles/kml/pal4/icon49.png''
     });
     var iw'||n||' = new google.maps.InfoWindow({
       content: "'||rec.attribs_01||' '||rec.name||'<BR/>'||rec.desc1||'<BR/>'||rec.desc2||'<BR/><BR/>'||'"
     });
     google.maps.event.addListener(marker'||n||', "click", function (e) { iw'||n||'.open(map, marker'||n||'); });
     area.extend(new google.maps.LatLng('||rec.longitude||', '||rec.latitude||'));
');  
        point_num := point_num + 1;

        end loop;
        end;
        -------------------------------------------------------------- 

            
                
    WriteToClob(res,'
 
	//var myrectangle = new google.maps.Rectangle({
	//	strokeColor: ''#ff0000'',
	//	strokeWeight: 3,
	//	strokeOpacity: 0.4,
	//	bounds: area,
	//	map: map,
	//	fillColor: ''#ff0000'',
	//	fillOpacity: 0.1
	//});    
    
   map.fitBounds(area); 
   };
 </script>
</head>
<body onload="initMap()">
 <div id="map_canvas" style="height: 100%; width: 100%"></div>
 <p>Plansoft.org - lokalizacja zasobów na mapie</p>
</body>
</html>');

        return res;  
    end getMap;  
end;
/
