<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<xsl:output method="xml" indent="yes" encoding="UTF-8" cdata-section-elements="ITEM_DESCRIPTION SPEC"/>
<xsl:template match="/" name="main">
  <RFQAPPREQ>
	<HEADER>
		 <CUST_CD>METROERP</CUST_CD>
		 <DOC_ID><xsl:value-of select="/XMLDATA/ROW[1]/DOC_ID" /></DOC_ID>
	</HEADER>
	<BODY>
		<xsl:for-each select="/XMLDATA/ROW">
			<ITEM_INFO>
				<RFQ_NO><xsl:value-of select="RFQ_NO" /></RFQ_NO>
				<RFQ_LINE_NO><xsl:value-of select="format-number(RFQ_LINE_NO,'######')" /></RFQ_LINE_NO>
				<ITEM_DESCRIPTION><xsl:value-of select="substring(ITEM_DESCRIPTION,1,255)" /></ITEM_DESCRIPTION>
				<ITEM_CODE><xsl:value-of select="substring(ITEM_CODE,1,18)" /></ITEM_CODE>
				<UOM><xsl:value-of select="substring(UOM,1,3)" /></UOM>
				<QUANTITY><xsl:value-of select="format-number(QUANTITY,'#############.###')" /></QUANTITY>
				<LEAD_TIME_DAYS><xsl:value-of select="format-number(LEAD_TIME_DAYS,'###')" /></LEAD_TIME_DAYS>
				<UNIT_PRICE><xsl:value-of select="format-number(UNIT_PRICE,'###########.##')" /></UNIT_PRICE>
				<ENTOB_PART_NUMBER><xsl:value-of select="substring(ENTOB_PART_NUMBER,1,35)" /></ENTOB_PART_NUMBER>
				<CATE_NM><xsl:value-of select="substring(CATE_NM,1,100)" /></CATE_NM>
				<SPEC><xsl:value-of select="SPEC" /></SPEC>
				<MKR><xsl:value-of select="MKR" /></MKR>
				<MDN_NM><xsl:value-of select="MDN_NM" /></MDN_NM>
				<FORC_UPRC><xsl:value-of select="FORC_UPRC" /></FORC_UPRC>
				<GDS_DESC><xsl:value-of select="GDS_DESC" /></GDS_DESC>
				<ITEM_TYPE><xsl:value-of select="substring(ITEM_TYPE,1,4)" /></ITEM_TYPE>
				<EMPLOYEE><xsl:value-of select="substring(EMPLOYEE,1,8)" /></EMPLOYEE>
				<RFQ_DATE><xsl:value-of select="substring(RFQ_DATE,1,8)" /></RFQ_DATE>
			</ITEM_INFO>
		</xsl:for-each> 
	</BODY>
</RFQAPPREQ>
</xsl:template>
</xsl:stylesheet>