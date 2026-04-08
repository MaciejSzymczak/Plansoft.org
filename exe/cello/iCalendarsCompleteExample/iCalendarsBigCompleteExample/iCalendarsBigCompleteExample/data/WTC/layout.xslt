<?xml version="1.0" encoding="windows-1250" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  
  <xsl:template match="xml">
      <html>
       <HEAD>
        <link rel="stylesheet" href="menu.css" type="text/css" />
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


  <xsl:template match="period">
  <h1 style="font-variant: small-caps; text-align: center; color: white; background-color: black; "> <xsl:value-of select="@name"/></h1> 
   </xsl:template>

  <xsl:template match="description">
    <center><xsl:value-of select="@text"/></center><BR/><BR/>
  </xsl:template>

  <xsl:template match="data">
   <center>  
    <TABLE BORDER="1" WIDTH="80%" style="font-variant: small-caps; border: 0px dashed black">
    <TR style="background-color: silver">
        <xsl:if test="//data/gro">
        <TD><center>Grupy</center></TD>
        </xsl:if>
        <xsl:if test="//data/lec">
        <TD><center>Wykładowcy</center></TD>
        </xsl:if>
        <xsl:if test="//data/res">
        <TD><center>Zasoby</center></TD>
        </xsl:if>
    </TR>
    <TR>
    <xsl:if test="//data/gro">
    <TD VALIGN="TOP" style="border: 1px dashed silver">
     <div id="container">
       <ul class="menu">
         <xsl:for-each select = "gro">
          <a>
            <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
           <xsl:value-of select="@text"/>
          </a>
         </xsl:for-each>
       </ul>
     </div>
    </TD>
    </xsl:if>
    <xsl:if test="//data/lec">
    <TD VALIGN="TOP"  style="border: 1px dashed silver">
     <div id="container">
       <ul class="menu">
         <xsl:for-each select = "lec">
          <a>
            <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
           <xsl:value-of select="@text"/>
          </a>
         </xsl:for-each>
       </ul>
     </div>
    </TD>
    </xsl:if>
    <xsl:if test="//data/res">
    <TD VALIGN="TOP"  style="border: 1px dashed silver">
     <div id="container">
       <ul class="menu">
         <xsl:for-each select = "res">
          <a>
            <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
           <xsl:value-of select="@text"/>
          </a>
         </xsl:for-each>
       </ul>
     </div>
    </TD>
    </xsl:if>
    </TR>
    </TABLE>
    </center>
  </xsl:template>

  <xsl:template match="who">
    <BR/><small><xsl:value-of select="@lastupdatetext"/></small>
  </xsl:template>

  <xsl:template match="extraText">
    <BR/><BR/><BR/><small><xsl:value-of select="@text"/></small>
  </xsl:template>

  <xsl:template match="href1">
  <br/><a href="{@href}" target="_blank"><xsl:value-of select="@text"/></a>
  </xsl:template>

  <xsl:template match="href2">
  <br/><a href="{@href}" target="_blank"><xsl:value-of select="@text"/></a>
  </xsl:template>

  <xsl:template match="href3">
  <br/><a href="{@href}" target="_blank"><xsl:value-of select="@text"/></a>
  </xsl:template>

</xsl:stylesheet>



