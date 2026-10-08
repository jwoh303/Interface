<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
<xsl:output method="xml" indent="yes" encoding="EUC-KR" />

<xsl:template match="/" name="main">
	<XMLDATA>
		<xsl:for-each select="/NTBINV/BODY/ITEM_INFO">
        	<ROW>
			<INVOICE_NUMBER><xsl:value-of select="INVOICE_NUMBER" /></INVOICE_NUMBER>
			<INVOICE_LINE_NUMBER><xsl:value-of select="number(INVOICE_LINE_NUMBER)" /></INVOICE_LINE_NUMBER>
			<PO_NUMBER><xsl:value-of select="PO_NUMBER" /></PO_NUMBER>
			<PO_LINE_ITEM_ID><xsl:value-of select="number(PO_LINE_ITEM_ID)" /></PO_LINE_ITEM_ID>
			<BUYC_RECEIPT_NUMBER><xsl:value-of select="BUYC_RECEIPT_NUMBER" /></BUYC_RECEIPT_NUMBER>
			<BUYC_RECEIPT_LINE_NUMBER><xsl:value-of select="number(BUYC_RECEIPT_LINE_NUMBER)" /></BUYC_RECEIPT_LINE_NUMBER>
			<CUSTOMER_PART_NO><xsl:value-of select="CUSTOMER_PART_NO"/></CUSTOMER_PART_NO>
	        <DELIVERY_QUANTITY><xsl:value-of select="number(DELIVERY_QUANTITY)" /></DELIVERY_QUANTITY>
			<DELIVERY_DATE><xsl:value-of select="DELIVERY_DATE" /></DELIVERY_DATE>
			<UNIT_PRICE><xsl:value-of select="number(UNIT_PRICE)" /></UNIT_PRICE>
			<INVOICE_ITEM_AMOUNT><xsl:value-of select="number(INVOICE_ITEM_AMOUNT)"/></INVOICE_ITEM_AMOUNT>
	        <INVOICE_TOTAL_TAX_AMOUNT><xsl:value-of select="number(INVOICE_TOTAL_TAX_AMOUNT)"/></INVOICE_TOTAL_TAX_AMOUNT>
	        <INVOICE_TOTAL_AMOUNT><xsl:value-of select="number(INVOICE_TOTAL_AMOUNT)"/></INVOICE_TOTAL_AMOUNT>
	        <TAX_TYPE><xsl:value-of select="TAX_TYPE" /></TAX_TYPE>
	        <RETURN_FLAG><xsl:value-of select="RETURN_FLAG" /></RETURN_FLAG>
	        <INVOICE_TOTAL_DELAY_FEE><xsl:value-of select="number(INVOICE_TOTAL_DELAY_FEE)"/></INVOICE_TOTAL_DELAY_FEE>
	        <BUYC_RECEIPT_DELAY_FEE><xsl:value-of select="number(BUYC_RECEIPT_DELAY_FEE)" /></BUYC_RECEIPT_DELAY_FEE>
	        </ROW>
	        </xsl:for-each>
        </XMLDATA>
</xsl:template>
</xsl:stylesheet>
