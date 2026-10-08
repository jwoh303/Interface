<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
<xsl:output method="xml" indent="yes" encoding="EUC-KR" />

<xsl:template match="/" name="main">
	<XMLDATA>
  	<xsl:for-each select="/RFQAPPRES/BODY/ITEM_INFO">
      <ROW>
			<!--<UPDATEDEPTID><xsl:value-of select="/RFQAPPRES/HEADER[1]/CUST_CD" /></UPDATEDEPTID>
			<UPDATEUSERID>ENTOB</UPDATEUSERID>-->
			<RFQ_NO><xsl:value-of select="RFQ_NO" /></RFQ_NO>
			<RFQ_LINE_NO><xsl:value-of select="number(RFQ_LINE_NO)" /></RFQ_LINE_NO>
			<ENTOB_MAPPING_CODE><xsl:value-of select="ENTOB_MAPPING_CODE" /></ENTOB_MAPPING_CODE>
			<ITEM_CODE><xsl:value-of select="ITEM_CODE" /></ITEM_CODE>
			<ITEM_TYPE><xsl:value-of select="ITEM_TYPE" /></ITEM_TYPE> 
      <FU_ACTION><xsl:value-of select="FU_ACTION" /></FU_ACTION> 
      <REJECT_CD><xsl:value-of select="REJECT_CD" /></REJECT_CD> 
      <REJECT_DESC><xsl:value-of select="REJECT_DESC" /></REJECT_DESC>
     </ROW>
	        </xsl:for-each>
        </XMLDATA>
</xsl:template>
</xsl:stylesheet>