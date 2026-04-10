<?xml version="1.0" encoding="windows-1250" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  
  <xsl:template match="xml">
      <html>
       <HEAD>
        <xsl:for-each select = "title">
          <title>
            <xsl:value-of select="@name"/> 
          </title>
        </xsl:for-each>
       </HEAD>
       <body style="font-variant: small-caps; text-align: center;  background-color: #eeeeee; ">
             <xsl:apply-templates/>
       </body>
      </html>
  </xsl:template>

  <xsl:template match="title">
  <h1 style="font-variant: small-caps; text-align: center; color: white; background-color: black; "> <xsl:value-of select="@name"/></h1> 
   </xsl:template>

  <xsl:template match="data">
   <center>  
    <TABLE BORDER="1" WIDTH="30%" style="font-variant: small-caps; border: 0px dashed black">
    <TR style="background-color: silver">
        <TD><center>Folder</center></TD>
        <TD><center>Processed</center></TD>
        <TD><center>Not Processed</center></TD>
        <TD><center>Status</center></TD>
    </TR>
	<xsl:for-each select = "folder">
    <TR VALIGN="TOP" style="border: 1px dashed silver">
		<TD><center><xsl:value-of select="@name"/></center></TD>
		<TD><center><xsl:value-of select="@ProcessedCnt"/></center></TD>
		<TD><center><xsl:value-of select="@NotProcessedCnt"/></center></TD>
		<td><center><img src="{@icon}"/></center></td>
    </TR>
	</xsl:for-each>
    </TABLE>
    </center>
  </xsl:template>

  <xsl:template match="who">
    <BR/><small><xsl:value-of select="@lastupdatetext"/></small>
  </xsl:template>


</xsl:stylesheet>



