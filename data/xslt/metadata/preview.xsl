<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:pi="http://papyri.info/ns">
  <xsl:include href="../pn/navigator/pn-xslt/pi-global-varsandparams.xsl"/>
  <xsl:include href="../pn/navigator/pn-xslt/morelikethis-varsandparams.xsl"/>
  <xsl:include href="../pn/navigator/pn-xslt/pi-functions.xsl"/>
  <xsl:include href="../pn/navigator/pn-xslt/metadata.xsl"/>
  <xsl:include href="../pn/navigator/pn-xslt/metadata-dclp.xsl"/>
  <xsl:key name="lang-codes" match="//pi:lang-codes-to-expansions" use="@code"></xsl:key>
  <xsl:variable name="collection" select="'dclp'"/>
  <xsl:variable name="resolve-uris" select="false()"/>
  <xsl:param name="path">/dev/null/idp.data</xsl:param>
  <xsl:variable name="outbase">/dev/null/idp.html</xsl:variable>
  <xsl:variable name="tmbase">/dev/null/files</xsl:variable>
  <xsl:template match="/">
    <div class="metadata">
        <xsl:apply-templates mode="metadata"/>
    </div>
  </xsl:template>
</xsl:stylesheet>
