        ��  ��                  �  0   H T M L   X L E F T 1       0           <html>
<head>
	<title>Untitled</title>
<link rel="StyleSheet" type="text/css" href="style.css">

<style>
   :link :visited {color: 3737a5;}
   .pindent  {margin-left: 5px;}
</style>

</head>

<body>

<br><table border=0 width=130 cellpadding="0" cellspacing="0">
<tr><td valign="bottom" height="13"><img src="TabTop.gif"></td>
<tr class="backcolor"><td>
<p style="text-align: center; font-size: 14pt; color: white; margin-top: 30px;">

<b>Contents</b>

<hr style="height: 6; width: 60%; color: 373773;">

<b>
<p class="pindent">
<a target="RightWin" href="page1.htm">Overview</a>
<p class="pindent">
<a target="RightWin" href="page3.htm">Compiling the Demo</a>
<p class="pindent">
<a target="RightWin" href="page4.htm">Using The TFrameBrowser Component</a>
<p class="pindent">
<a target="RightWin" href="page5.htm">Customizing</a>
<p class="pindent">
<a target="RightWin" href="page7.htm">Acknowledge-ments</a>
<p>
</b>
<tr><td valign="top" height="13"><img src="TabBot.gif"></td>

<tr><td Height="50" valign="bottom"><p align="center"><a href="http://www.indyproject.org/" target="_top"><img src="BuiltWIndy.gif"></a>
</td>

</table>

</body>

</html>
 |  0   H T M L   P A G E 1         0           <html>
<head>
<title>Untitled</title>
<link rel="StyleSheet" type="text/css" href="style.css">
<style>
  body.indent {margin-left: 20px;}
</style>
</head>

<body text="black" bgcolor="white" link="blue">   <!-- #3737a5-->

<p class="mainhead"><a name="Top">TFrameBrowser Demo</a><br>
    <small><small>Indy Version 10</small></small></p>
<tr>
  <td width="2%"></td>
  <td valign="top">
  
  <FONT FACE="Arial" >
  
  <p class="heading"><nobr>Demo Quick Facts -- Please Read</nobr></p>
    <ul>
      <li>For online browsing, enter the URL.  For example:
        <p style="margin-left:10pt">
        <a href="http://www.pbear.com/" target="_blank"><code>www.pbear.com/</code></a>
        or 
        <a href="http://code.google.com/p/thtmlviewer/source/checkout" target="_blank"><code>http://code.google.com/p/thtmlviewer/</code></a>
        or
        <a href="https://github.com/BerndGabriel/HtmlViewer/" target="_blank"><code>github.com/BerndGabriel/HtmlViewer</code></a>
        <p>
      <li>To view a local html or image file, use the <B>File</B> menu or enter 
          <code>file:///</code> followed by the filename.
           <p>
      <li>This document is a resource contained within this program.
          To view this document again in the future, select <b>Help|Demo Information</b> from the 
          menu
            or enter <a href="res:///page0.htm" target="_top"><code>res:///page0.htm</code></a>.
         <p>
      <li>To compile this demo program for your own needs, see <a href="Page3.htm"
          target="RightWin">Compiling the Demo</a>. 
          <p>
      <li>The latest HtmlViewer 10.2 and 11 are available at: <a href="http://code.google.com/p/thtmlviewer/"> 
        http://code.google.com/p/thtmlviewer/</a><br>
        <p>
      <li>To enable Secure Socket Layer (SSL) operation (<B>https</B> protocol), the Indy OpenSSL DLLs need to be be downloaded from
         <a href="http://indy.fulgan.com/SSL/" target="_blank">http://indy.fulgan.com/SSL/</a>.
         This program was tested with the 1.0.1c version. 
         The DLLs, named <B>libeay32.dll</B> and <B>ssleay32.dll</B>, should be
         placed in the System directory.
          <p>
    </ul><p>


  <p class="heading"><nobr><a name="Overview">Overview</a></nobr></p>


  <p>The HTML Component set consists of the <b>THtmlViewer</b>, <b>TFrameViewer</b>, and <b>TFrameBrowser</b>
  components.   All three are HTML document display components:</p>
  
  <table width="100%" cellspacing="2" cellpadding="2" border="0">
  <tr>
      <th width="2%"></th>
      <th class="dorange" valign="top" align="left">THtmlViewer</th>
      <td valign="top">The basic component.  <b>THtmlViewer</b> displays single (non-frame)
                     documents.  It forms the basis for the other two components.<br><br></td>
  </tr>
  <tr>
      <td></td>
      <th class="dorange" valign="top" align="left">TFrameViewer</th>
      <td valign="top">Displays both Frame and single HTML documents.  <b>TFrameViewer</b> is
                     oriented more for local disk file use.<br><br></td>
  </tr>
  <tr>
      <th></th>
      <th class="dorange" valign="top" align="left">TFrameBrowser&nbsp;&nbsp;&nbsp;</th>
      <td valign="top">Also displays Frame and single HTML documents.  However, <b>TFrameBrower</b> is
                     oriented toward Internet style protocols and URL usage.  Additional
                     code and/or components are generally required to use <b>TFrameBrowser</b>.<br><br></td>
  </tr>
  </table>

  <p class="heading"><nobr><a name="Demos">Demo Program</a></nobr></p>

  <p>The <B>FrameBrowserId</B> demo program illustrates how the <b>TFrameBrowser</b> 
  component might be used in a complete application. For Internet access, the demo program
  uses the <B>Internet Direct (Indy)</B> components which  come with Delphi 7.  <B>Indy</B>
  versions 
  for Delphi 4, 5  and 5 are also available at no charge at 
  <a href="http://www.indyproject.org/" target="_top">http://www.indyproject.org/</a>.
 
  <p>The demo program supports the following protocols:</p>

  <table width="100%" cellspacing="2" cellpadding="2" border="0">
  <tr>  <tr>
      <th width="2%"></th>
      <th valign="top" align="left">http&nbsp;&nbsp;&nbsp;</th>
      <td valign="top">Internet online protocol<br></td>
  </tr>

      <th width="2%"></th>
      <th valign="top" align="left">https&nbsp;&nbsp;&nbsp;</th>
      <td valign="top">Internet online SSL protocol (optional)<br></td>
  </tr>
  <tr>
      <th width="2%"></th>
      <th valign="top" align="left">file&nbsp;&nbsp;&nbsp;</th>
      <td valign="top">Internet local file protocol<br></td>
  </tr>
  <tr>
      <th width="2%"></th>
      <th valign="top" align="left">res&nbsp;&nbsp;&nbsp;</th>
      <td valign="top">Special protocol to read HTML documents from an application's resources<br></td>
  </tr>
  </table> 
  
    
  <p class="heading"><nobr><a name="Protocols">Protocol Details</a></nobr></p>
  
  <p>When initially loading an HTML document, the full URL including the protocol should be used.
  From that point on, TFrameBrowser is capable of adding the protocol and path to partial URLs found in 
  the document.</p>
  
  <p>The <b>http</b>, <b>https</b>, and <b>file</b> protocols supported by the demo program are standard.  
  &nbsp;URLs using these protocols are in the form:</p>
  
  <pre style="margin-left:10pt">
  http://www.pbear.com/index.html
  file:///c|/thtml4/framedem.htm</pre>

  <p>The <b>res</b> protocol may be used to access HTML documents and their images stored in a program's 
  resources.  URLs with the <b>res</b> protocol have the form:</p>

  <pre style="margin-left:10pt">
  res:///helpinfo.html</pre>

  <p>The <b>res</b> protocol supports document extensions of <code>HTM, HTML, GIF, JPG, JPEG, 
  PNG, BMP, CSS,</code> and <code>TXT</code>. See <a href="page5.htm#Resources" target="RightWin">Adding HTML Documents
  to an Application's Resources</a> for 
  information on how to add HTML resources to an application.</p>

  <p>Additional special protocols may be easily added by the programmer.  Protocols might be defined for reading 
  encrypted files or reading HTML from a database, for instance.  See <a href="page5.htm#AddingProtocols">Adding Your Own Protocols</a>.
  </p>
  </font>

  </td>
  <td width="2%"></td>
</tr>
</table>
<p>&nbsp;</p> 
</body>
</html>
8  0   H T M L   P A G E 3         0           <html>
<head>
	<title>Untitled</title>
<link rel="StyleSheet" type="text/css" href="style.css">
</head>

<body>
<p class="mainhead"><a name="Top">Compiling the Demo Program</a></p>
  
<p class="heading"><a name="Compiling"><nobr>Compiling The Demo Program</nobr></a></p> 
 
  <p>To compile your own version of the FrameBrowzerId program for study or modification, 
     the following is required:
  
  <ol>
   <li>The source code for the demo program which is included in this package.<p>
   
   <li>If you have not already done so, download and install the <b>THtmlViewer</b>, <b>TFrameViewer</b>, 
    and <b>TFrameBrowser</b> HTML Components.  This package may be obtained from 
    <a href="http://www.pbear.com/" target="_blank"><code>http://www.pbear.com/</code></a>.
    <p>
 
   <li>This demo uses the Internet Direct Components
   (Indy) <B>Version 10</b>. Versions 8 or 9 of Indy are not suitable for
   this demo.
   
   <p>Indy Version 10 comes with both Delphi 2007, 2009, XE, and XE2.  For other
   Delphi versions, Indy Version 10
   may be downloaded (no charge) from
    <a href="http://www.indyproject.org/" target="_blank">http://www.indyproject.org/</a>.
   
    
    <p>
   <li>For the optional Secure Socket Layer (SSL) support, the OpenSourceSSL DLLs should be downloaded from
      <a href="http://indy.fulgan.com/SSL/" target="_blank">http://indy.fulgan.com/SSL/</a>.
      Be sure and download the latest version as testing is usually done with that one and older versions often have security flaws. These DLLs
      should be placed in the same directory as your executable or the System32 directory for your program's architecture.
</ol>

<p class="heading"><a name="Compiling"><nobr>Compile Time Options</nobr></a></p> 

  <p>Depending on which options are selected, the following <B>Defines</B> should be entered
     in the Project|Options dialog, Directories/Conditionals tab, Conditional Defines 
     section:
  </p>
  
  <table width="80%" cellspacing="2" cellpadding="2" border="0">
  <tr> 
      <th width="2%"></th>
      <th class="dorange" valign="top" align="left" width="100">UseSSL</th>
      <td valign="top" align="left">Enables the OpenSourceSSL support (<B>https</B>).</td>
  </tr>
  </table>

<p class="heading"><a name="Compiling"><nobr>Debugging</nobr></a></p> 

<p>Both Indy and TFrameBrowser use exception handling as part of normal coding practice
   so exceptions don't necessarily indicate a problem.  However, exceptions can be 
   quite disconcerting when running the application from the IDE.  This is especially true when 
   Socket timeout exceptions start cascading after the IDE stops for another exception.  For this 
   reason, it's a good idea to turn off Delphi's "Break on Exception" option or at 
   least specify that the following exceptions be ignored:
<blockquote>EConvertError<br>
   EIdConnClosedGracefully<br>EIdSocketError<br>EIdHTTPProtocolException
</blockquote>
<p>See <B>Tools|Debugger Options|Language Exceptions</B> for making these changes.

  <p>&nbsp;</p> 
</body>
</html>
#  0   H T M L   P A G E 0         0           <title>Demo Program Information</title>
<frameset  cols="150,*" border="0">
    <frame name="LeftWin" src="XLeft1.htm" marginwidth="10" marginheight="10" scrolling="no"  noresize>
    <frame name="RightWin" src="Page1.htm" marginwidth="5" marginheight="0" scrolling="auto">
</frameset>
 �  0   H T M L   P A G E 4         0           <html>
<head>
	<title>Untitled</title>
<link rel="StyleSheet" type="text/css" href="style.css">
</head>

<body>
<p class="mainhead"><a name="Top">Using the TFrameBrowser Component</a></p>
  
<p class="heading"><a name="Using"><nobr>Overall Approach</nobr></a>

  <p>To use the TFrameBrowser component, you must have event handlers that respond to the <b>OnGetPostRequest</b> 
  and the <b>OnGetImageRequest</b> events.  These events occur whenever a document or an image for a document
  is requested.  These events require that the document or image be returned in stream form.  In some 
  cases, the return of the stream may be delayed to allow for downloading the information.
  </p>
  
  <p>The general sequence of loading a document is as follows:
  </p>
 
  <ol>
    <li>Call the LoadURL method.  The URL parameter supplied should be a full URL and include the 
        protocol.
    <li>An immediate <b>OnGetPostRequest</b> event will occur.  &nbsp;Respond with the stream requested.
    <li>Assuming the document contains images, a number of <b>OnGetImageRequest</b> events will occur.
        Again respond with a stream for each.
    <li>Once the document is loaded, additional events will occur when links are selected, etc.	  
  </ol>
  
  <p>Further information on the <b>OnGetPostRequest</b> and <b>OnGetImageRequest</b> events is available in the
  <code>THtmlViewer.chm</code> file.</p>
  
<p class="heading">Connections</p>
   
  <p>To obtain the document and image streams, the demo programs establish a <i><b>connection</b></i>. 
  A connection is obtained by calling 
  <code>TURLConnection.GetConnection</code> and the proper type of connection is determined by the protocol on the 
  URL used in the call.  It is through the connection concept that the various protocols are 
  supported.  The Connection concept makes it easy to 
  <a href="page5.htm#AddingProtocols" target="RightWin">add new protocols</a> for specialized situations.</p> 
  
  <p>Once the Connection is established, the stream may be obtained, usually with the 
  <code><b>Connection.Get</b></code> method.</P>

 
  <p>&nbsp;</p> 
</body>
</html>
 {  0   H T M L   P A G E 5         0           <html>
<head>
	<title>Untitled</title>
<link rel="StyleSheet" type="text/css" href="style.css">
</head>

<body>

<p class="mainhead"><a name="Top">Customizing</a></p>
  
<p class="heading"><a name="AddingProtocols"><nobr>Adding Your Own Protocols</nobr></a></p> 

  <p>The Connection concept makes it easy to add or modify protocols.  A few possible
  reasons that you might want to do this are:</p>
  
  <ul>
     <li>To read HTML from encrypted files
     <li>To read HTML from a database.
     <li>To use a different <b>http</b> component.</li>     
  </ul>
  
  <p>The various connection types are defined in <code>URLConId.pas</code>.  To add a new protocol,
  it's necessary to define a descendent to <code>TURLConnection</code>, the base class.
  In most cases, this is a two step process:</p>
  <ol>
     <li>Add your new protocol string to <code>TURLConnection.GetConnection</code>.  This makes
        your new connection available for use.
  
     <li>Override the <code>TURLConnection.Get</code> method. 
                The code you add here should use the URL to determine what 
                stream to return. It's also necessary to specify the content 
                type (HTMLtype, TEXTtype, or ImgType) of the return.</li>           
                     
                 
  </ol>
  <br>
  
  <p style="color: #9d3700;"><b>URL Format Considerations</b></font></p> 
  
  <p><b>TFrameBrowser</b> has the capability of assembling full URLs from partial URLs.  The
  syntax for doing this is detemined by the standard <b>http</b> and <b>file</b> protocols.  This
  means that any special protocols that are added should use URLs that resemble those
  used by the <b>http</b> and <b>file</b> protocols.</p><B></B>
  
  <p>The general form of a special URL should be:</p>
  
<pre>     proto://dir1/dir2/file.ext
  or
     proto:///file.ext</pre>  
     
  <p>The important points are:</p>
  <ul>
     <li>The protocol string should be followed by a colon and two (possibly three)
     forward slashes.
  
     <li>dir1/dir2/ represent a directory or other hierarchy.  The user can determine
     how this should be interpreted in his <code>Get</code> method code.
  
     <li>Whatever follows the last forward slash is taken as a document or image name
  
     <li>The URL should contain at least three 
                forward slashes. If there are only two, one will be added on the 
                end.</li>              
           
  </ul>
  <br>


<p class="heading"><a name="Resources"><nobr>Adding HTML documents to an Application's Resources</nobr></a></p>  

  <p>To construct a resource file containing HTML documents and images suitable for the <b>res</b> protocol, proceed as 
  follows:</p>
  <ul>
  	<li>Write a resource compiler file (<b>.rc</b>) listing the files to be included.
  	<li>Use the Borland Resource Compiler to compile the <b>.rc</b> file into a <b>.res</b> file.  The 
       Borland Resource Compiler is
  	    named BRCC32 (32 bit) or BRCC (16 bit).
  	<li>Reference the <b>.res</b> file in your program 
                code using the {$R } compiler directive.</li>             
  </ul>
  
  <p>A typical resource compiler file might look like:</p>
  
  <pre>  //   usage:  BRCC32.EXE -foHelp32.res proghelp.rc
  
  		agif2       GIF   &quot;agif2.gif&quot;
  		readme3     HTML  &quot;readme3.htm&quot;
  		readme1     HTML  &quot;readme1.htm&quot;
  		readme2     HTML  &quot;readme2.htm&quot;
  		leftwin     HTML  &quot;leftwin.htm&quot;
  		index       HTML  &quot;help.htm&quot;
  		style       HTML  &quot;style.css&quot;
  		borders	    TEXT  &quot;borders.txt&quot;
  </pre>
  
  <p>The first column is the name by which the resource is referenced.  Column two is the resource type.  The <b>res</b> 
  protocol as defined recognizes HTML, HTM, GIF, JPG, JPEG, BMP, PNG, and TEXT types.  The third column is the file
  which defined the HTML document.</p>
  
  <p>In the above, the URL, <b><code>res:///index.htm</code></b>, would load the resource defined by the file, 
  <b><code>help.htm</code></b>.
  </p></FONT>

  
<p>&nbsp;</p> 
</body>
</html>
 �  0   H T M L   P A G E 7         0           <html>
<head>
	<title>Untitled</title>
<link rel="StyleSheet" type="text/css" href="style.css">
</head>

<body>

<p class="mainhead"><a name="Top">Acknowledgements</a></p>
  <p>&nbsp;</p>

  <p>The following are some of the organizations and individuals who have contributed to the
  HTML components:<br>&nbsp;</p>
  
  <table align="center" cellspacing="2" cellpadding="2" border="0" width="75%">
<tr>
    <td height="30"><b>SkyLine Tools, Inc.</b></td>
    <td>ImageLib Graphics Library</td>
</tr>
<tr>
    <td height="30"><b>Radek Przybyl</b></td>
    <td>Ideas and code for establishing Print margins</td>
</tr>
<tr>
    <td height="30"><b>Theodor Kleynhans</b></td>
    <td>Animated GIF code</td>
</tr>
<tr>
    <td height="30"><b>Chris Wallace</b></td>
    <td>Print preview ideas and code</td>
</tr>
<tr>
    <td height="30"><b>Yves Urbain</b></td>
    <td>The Connection concept for protocol support</td>
</tr>
<tr>
    <td height="30"><b>Anders Melander</b></td>
    <td>Color dithering code in DitherUnit.Pas</td>
</tr>
<tr>
    <td height="30"><b>Gustavo Daud</b></td>
    <td>PngImage.pas and PngZLIB.pas</td>
</tr>
<tr>
    <td><b>Ron Collins</b></td>
    <td>GIF image code</td>
</tr>
<tr>
    <td><b>Mike Lischke</b></td>
    <td>Unicode routines and assistance</td>
</tr>
<tr>
    <td><b>jrsoftware.org</b></td>
    <td>Inno Installer</td>
</tr>
</table>

<p>&nbsp;</p> 
</body>
</html>
 Q  0   H T M L   S T Y L E         0             body    {color: black; background:  white; font: 10pt Arial;}
  td, th  {font: 10pt Arial;}
  .backcolor  {background-color: #99ccff;}
  :link   {color: blue;} /*{color: #3737eb;}*/
  :hover  {color: blue;}
  :visited {color: blue;}
  code    {font-size: 1em;}
  .heading  {font: bold 12pt "Arial" ;  color: #ff6600;
             border-bottom: solid 1px #0000c0; width: 10; }
  .Mainhead {background-color: #ffd780;/*rgb(240, 192, 48);*/ color: blue;
             font: bold 20pt "Arial"; text-align: center; padding: 10px; Margin: 20;}
  .dorange  {color: #9d3700;}           
   �  8   G I F   B U I L T W I N D Y         0           GIF89ay  �  ��DLB4���TR\�\�b4T"����J�:ԞL�b<T"4�޴|R<��\�����l�b<tjlܖ<Ķ��R4dB4L2,$�Ƭ<24����zT$"$��ܼr<�Ɣ��T
�����d�rD�Z<\RD���D24D*$�rL�r$�b<�R,�֬��t|B,���|RL��\Tj�̮��r<Ԇ<dbdd:,��̌Z<��t�֜���dJ<$$�Ƽ�zT4*,�Ɯ̮lD:D�Z4DBD�j4���|bL4�R<��\̖LĦ�,",���zD̎LԞlL:4�J,̎D
���̶tܮ\$*4|RD|zttB4$�ά<:4����zd�Ό
\RLD*,�r4�jL�R4�J,|z|̆Ddbld:4���Ħ���̾�D:<�2���������dZT̞\|jD��l��|���̦|��d��|�ּ��|rd�zD$
�j<|Z4�zL�μ�Μܦl��T4D"D̖DԶ�,2<�z\�rD��|�z\��������l�bD��d<BLԖT�J4���LB<�b44"$�Z<T*$t:,̶��Z4�δ�Δ�朌��dfd�J�R<lB4T2,$
$lJ<,$�j4����bL4",�zDԎLT:4Զt,*4dRL�r4�R4�z|ԆD$�� n� r � �����pH��ǿ��e � t� ���� �bQ�  � nr �  � � �� � &���D/��B�  \�&�P�   =  n |� ���Y nl|������ �      ,    y   � �H����*\Ȱ�Ç�I"f�DA+j�QǍ=R���c�$!+
Jy��H�Y��y�$ʒ47���C�N�Ip���3$G�A��T9��Ӛ�F��s�O�+5�<I��Ү3�j|��ןe�f4� �nH��T� ����S�Ѭ&o����ԤTU*j��U�~�V�ԭ(��]<3(��Y��9�f�$+JyKR*י������G�9eNV��ِ/wR�\����9�  /sA�Ÿ%`��ָسkߞ7jw����O���]!�������O����p�J������(������t^a���i*Q��w�Dq�}�!}q��G�u�$
����w Vy�\�㽧Yw�8\�q�D܅/���F;6[���G�&�叀��ǂL.JWc�68c�0Vi%��e��M�Qb��c��x�q�"�6���YV��2�8a��嘡{ù'�rڝQ��I�&�'�C̚���x9>��b�H��~aw�r�zF~9��^��� �`d�>��C���L)p�UN+5�N�~��Z�f�i�!�h���S)s"DK�� �S����`~��]��n1E��T#fw���3��:�]��F�b�15XYO�&�R��v�W�%5"F�î
�k- ���~%�YP�}��J����+vM�*�p�� ��c��Dަ��X���d��W�I��U�]�;��c��n���̱0�m��T!��u��Y��;�g	�� ��A�ر<��f�"D����o��ڹ�]�j�(��۹b��x�B �A�������y�+�� �m��na�"v�Л�I��Jj{�J!�7���6��q��l�>z�}w:K�{����9km D���q��v|x�T��v���t������U�����}�:w|6'Q�S�/
��p��ݢ�>��*�_z�Ы�ߚݞ=��k�T��c���ÝrG*���D�7��->{���7:���L��=vp{"�V���qAh1:�x��r�̅'���3������ӯ����l�	�̈́�C">�Y0���rC3�8�P��i���F�Q�RB��-z��`���H�1�����H����6��p���H�6��px̣���>��� �h�B�L�"yȀ  ; �   0   G I F   T A B B O T         0           GIF89a�  �  ������������������������                        ,    �   S��I��8�ͻ�`(�di�h��l�h�t[u����� ���!�����As�@�u{2�`@���9�7�n���|N��# ;  �   0   G I F   T A B T O P         0           GIF89a�  �  ������������������������                        ,    �   T�I��8�ͻ�`@Gi�h��l�p�D����|��e�+�HՠBH:��a"�Z�X���&U�x�����n���|N��K ; <  4   A V I   S T A R C R O S S       0           RIFF4  AVI LIST�  hdrlavih8   @  X                 x        �?^ �?  �l  ��lLISTt  strlstrh8   vidsDIB             @ @B        h  ����            strf(  (               h                     3   f   �   �   �    3  33  f3  �3  �3  �3   f  3f  ff  �f  �f  �f   �  3�  f�  ��  ̙  ��   �  3�  f�  ��  ��  ��   �  3�  f�  ��  ��  ��    3 3 3 f 3 � 3 � 3 � 3  33 333 f33 �33 �33 �33  f3 3f3 ff3 �f3 �f3 �f3  �3 3�3 f�3 ��3 ̙3 ��3  �3 3�3 f�3 ��3 ��3 ��3  �3 3�3 f�3 ��3 ��3 ��3   f 3 f f f � f � f � f  3f 33f f3f �3f �3f �3f  ff 3ff fff �ff �ff �ff  �f 3�f f�f ��f ̙f ��f  �f 3�f f�f ��f ��f ��f  �f 3�f f�f ��f ��f ��f   � 3 � f � � � � � � �  3� 33� f3� �3� �3� �3�  f� 3f� ff� �f� �f� �f�  �� 3�� f�� ��� ̙� ���  ̙ 3̙ f̙ �̙ �̙ �̙  �� 3�� f�� ��� ��� ���   � 3 � f � � � � � � �  3� 33� f3� �3� �3� �3�  f� 3f� ff� �f� �f� �f�  �� 3�� f�� ��� ̙� ���  �� 3�� f�� ��� ��� ���  �� 3�� f�� ��� ��� ���   � 3 � f � � � � � � �  3� 33� f3� �3� �3� �3�  f� 3f� ff� �f� �f� �f�  �� 3�� f�� ��� ̙� ���  �� 3�� f�� ��� ��� ���  �� 3�� f�� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� vedt         JUNK�                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              LIST  moviLIST�  rec 00dbh  ��������������  ����������  ��������  ��������  ������  ����������  ��  ��  ������������������  ������������������  ��  ��  ����������  ������  ��������  ��������  ����������  ��������������  JUNK|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              LIST�  rec 00dbh  �������������  ��������  �����������  ������������  �������  �������  ��������  ����������  �������  ��������  ��������  �����  �������  ���������  �������������  �����������  ���������  ��������������  JUNK|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              idx1@   rec       �  00db      h  rec      �  00db     h  