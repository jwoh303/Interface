<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
<xsl:output method="xml" indent="yes" encoding="EUC-KR" />

<xsl:template match="/" name="main">
	<XMLDATA>
		<xsl:for-each select="/NTBREC/BODY/ITEM_INFO">
		<ROW>
			<PO_NUMBER><xsl:value-of select="PO_NUMBER" /></PO_NUMBER>
			<PO_LINE_ITEM_ID><xsl:value-of select="number(PO_LINE_ITEM_ID)" /></PO_LINE_ITEM_ID>
			<CUSTOMER_PART_NO><xsl:value-of select="CUSTOMER_PART_NO" /></CUSTOMER_PART_NO>
			<ACTUAL_DELIVERY_DATE><xsl:value-of select="ACTUAL_DELIVERY_DATE" /></ACTUAL_DELIVERY_DATE>
			<ACTUAL_QUANTITY_DELIVERED><xsl:value-of select="ACTUAL_QUANTITY_DELIVERED" /></ACTUAL_QUANTITY_DELIVERED>
			<ACTUAL_AMOUNT><xsl:value-of select="ACTUAL_AMOUNT" /></ACTUAL_AMOUNT>
			<RECEIPT_NUMBER><xsl:value-of select="RECEIPT_NUMBER" /></RECEIPT_NUMBER>
			<RECEIPT_LINE_NUMBER><xsl:value-of select="number(RECEIPT_LINE_NUMBER)" /></RECEIPT_LINE_NUMBER>
	        <ASD_IN><xsl:value-of select="RECEIPT_NUMBER" /></ASD_IN>
	        <ASN_LINE_ITEM_ID><xsl:value-of select="ASN_LINE_ITEM_ID"/></ASN_LINE_ITEM_ID>
	        <GR_TYPE><xsl:value-of select="GR_TYPE"/></GR_TYPE>
	        <GE_MESSAGE><xsl:value-of select="GE_MESSAGE"/></GE_MESSAGE>
	        </ROW>
	        </xsl:for-each>
        </XMLDATA>
</xsl:template>
</xsl:stylesheet>