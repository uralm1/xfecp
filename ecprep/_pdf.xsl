<?xml version="1.0"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version="1.0">

  <xsl:import href="/usr/share/xml/docbook/xsl-stylesheets-1.75.2/fo/docbook.xsl"/>

  <xsl:param name="paper.type" select="'A4'"/>
  <xsl:param name="page.orientation" select="'landscape'"/>
  <xsl:param name="fop1.extensions" select="1"/>

  <xsl:param name="draft.mode">no</xsl:param>

  <xsl:param name="draft.watermark.image">/usr/share/xml/docbook/xsl-stylesheets-1.75.2/images/draft.png</xsl:param>
  <xsl:param name="generate.toc">article nop</xsl:param>
  <xsl:param name="title.font.family">Times New Roman</xsl:param>
  <xsl:param name="body.font.family">Times New Roman</xsl:param>
  <xsl:param name="monospace.font.family">Courier New</xsl:param>
  <xsl:param name="body.font.master">12</xsl:param>
  <xsl:param name="body.font.size">12</xsl:param>
  <xsl:param name="footnote.font.size">12</xsl:param>
  <xsl:param name="header.rule">0</xsl:param>
  <xsl:param name="footer.rule">0</xsl:param>
  <xsl:param name="hyphenate">false</xsl:param>
  <xsl:param name="line-height">1.3</xsl:param>
  <xsl:param name="page.margin.top">1.5cm</xsl:param>
  <xsl:param name="page.margin.bottom">2cm</xsl:param>
  <xsl:param name="page.margin.outer">2cm</xsl:param>
  <xsl:param name="page.margin.inner">3cm</xsl:param>
  <xsl:param name="body.start.indent">0cm</xsl:param>
  <xsl:param name="body.end.indent">0cm</xsl:param>
  <!--xsl:param name="body.margin.top">0cm</xsl:param-->
  <!--xsl:param name="body.margin.bottom">0cm</xsl:param-->
  <xsl:param name="section.autolabel">1</xsl:param>
  <xsl:param name="section.autolabel.max.depth">2</xsl:param>
  <xsl:param name="section.label.includes.component.label">1</xsl:param>
  <xsl:param name="appendix.autolabel">1</xsl:param>
  <xsl:param name="orderedlist.label.width">3.2em</xsl:param>

  <xsl:attribute-set name="component.title.properties">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <!--xsl:attribute name="start-indent">1.5cm</xsl:attribute-->
    <xsl:attribute name="text-indent">1.5cm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.properties">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.8em</xsl:attribute>
    <!--xsl:attribute name="start-indent">1.5cm</xsl:attribute-->
    <xsl:attribute name="text-indent">1.5cm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">12pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="font-size">12pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="font-size">12pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:param name="formal.title.placement">
    figure after
    example before
    equation after
    table before
    procedure before
  </xsl:param>

  <xsl:attribute-set name="formal.title.properties">
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">1.0em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">1.2em</xsl:attribute>
    <xsl:attribute name="text-indent">1.5cm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="normal.para.spacing">
    <xsl:attribute name="space-before.optimum">0.2em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.3em</xsl:attribute>
    <xsl:attribute name="text-indent">1.5cm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="table.footnote.properties">
    <xsl:attribute name="font-weight">normal</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="list.item.spacing">
    <xsl:attribute name="space-before.optimum">0.2em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.3em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="list.block.spacing">
    <xsl:attribute name="space-before.optimum">0.2em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.1em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.3em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template name="next.numeration">
    <xsl:param name="numeration" select="'default'"/>
    <xsl:choose>
      <xsl:when test="$numeration = 'arabic'">arabic</xsl:when>
      <xsl:when test="$numeration = 'loweralpha'">loweralpha</xsl:when>
      <xsl:when test="$numeration = 'lowerroman'">lowerroman</xsl:when>
      <xsl:when test="$numeration = 'upperalpha'">upperalpha</xsl:when>
      <xsl:when test="$numeration = 'upperroman'">upperroman</xsl:when>
      <xsl:otherwise>arabic</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="figure[processing-instruction('landscapeFigure')]">
    <fo:block-container reference-orientation="90">
      <xsl:apply-imports/>
    </fo:block-container>
  </xsl:template>

  <xsl:template match="processing-instruction('linebreak')">
    <fo:block/>
  </xsl:template>

  <!--xsl:param name="local.l10n.xml" select="document('')"/>
    <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
     <l:l10n language="ru">
      <l:context name="xref-number-and-title">
       <l:template name="chapter" text="Chapter %n: &#8220;%t&#8221;"/>
      </l:context>
     </l:l10n>
    </l:i18n-->

</xsl:stylesheet>
