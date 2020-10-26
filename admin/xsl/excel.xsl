<xsl:stylesheet xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:user="urn:my-scripts" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">
<ss:Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel">
<xsl:apply-templates />
</ss:Workbook>
</xsl:template>
<xsl:template match="/*">
<ss:Worksheet>
<xsl:attribute name="ss:Name">
<xsl:value-of select="local-name(/*/*)" />
</xsl:attribute>
<ss:Table x:FullColumns="1" x:FullRows="1">
<ss:Row>
<xsl:for-each select="*[position() = 1]/*">
<ss:Cell>
<ss:Data ss:Type="String">
<xsl:value-of select="local-name()" />
</ss:Data>
</ss:Cell>
</xsl:for-each>
</ss:Row>
<xsl:apply-templates />
</ss:Table>
</ss:Worksheet>
</xsl:template>
<xsl:template match="/*/*">
<ss:Row>
<xsl:apply-templates />
</ss:Row>
</xsl:template>
<xsl:template match="/*/*/*">
<ss:Cell>
<ss:Data ss:Type="String">
<xsl:value-of select="." />
</ss:Data>
</ss:Cell>
</xsl:template>
</xsl:stylesheet>