<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
<xsl:output method="xml" indent="yes" encoding="EUC-KR" />

<xsl:template match="/" name="main">
	<XMLDATA>
		<xsl:for-each select="/NTBPR/BODY/ITEM_INFO">
        	<ROW>
			<PR_NUMBER><xsl:value-of select="PR_NUMBER" /></PR_NUMBER>
			<PR_LINE_NUMBER><xsl:value-of select="number(PR_LINE_NUMBER)" /></PR_LINE_NUMBER>
			<PO_NUMBER><xsl:value-of select="PO_NUMBER" /></PO_NUMBER>
			<PO_LINE_NUMBER><xsl:value-of select="number(PO_LINE_NUMBER)" /></PO_LINE_NUMBER>
			<CUSTOMER_PART_NO><xsl:value-of select="CUSTOMER_PART_NO" /></CUSTOMER_PART_NO>
			<CUSTOMER_PART_DESC><xsl:value-of select="CUSTOMER_PART_DESC" /></CUSTOMER_PART_DESC>
			<SUPPLIER_NAME><xsl:value-of select="SUPPLIER_NAME" /></SUPPLIER_NAME>
			<QUANTITY><xsl:value-of select="number(QUANTITY)" /></QUANTITY>
			<UNIT_PRICE><xsl:value-of select="number(UNIT_PRICE)" /></UNIT_PRICE>
			<UOM><xsl:value-of select="UOM" /></UOM>
			<EMPLOYEE_NUMBER><xsl:value-of select="EMPLOYEE_NUMBER" /></EMPLOYEE_NUMBER>
			<AMOUNT><xsl:value-of select="number(AMOUNT)" /></AMOUNT>
			<PO_CREATION_DATE><xsl:value-of select="PO_CREATION_DATE" /></PO_CREATION_DATE>
			<REQUESTED_DATE><xsl:value-of select="REQUESTED_DATE" /></REQUESTED_DATE>
			<SHIPTO_ZIP><xsl:value-of select="SHIPTO_ZIP" /></SHIPTO_ZIP>
			<SHIPTO_ADDR1><xsl:value-of select="SHIPTO_ADDR1" /></SHIPTO_ADDR1>
			<SHIPTO_ADDR2><xsl:value-of select="SHIPTO_ADDR2" /></SHIPTO_ADDR2>
			<SHIPTO_RECEIVER><xsl:value-of select="SHIPTO_RECEIVER" /></SHIPTO_RECEIVER>
			<SHIPTO_TELEPHONE><xsl:value-of select="SHIPTO_TELEPHONE" /></SHIPTO_TELEPHONE>
			<FIELD_NAME><xsl:value-of select="FIELD_NAME" /></FIELD_NAME>
			<CUSTOMER_MESSAGE><xsl:value-of select="CUSTOMER_MESSAGE" /></CUSTOMER_MESSAGE>
			<CANCEL_FLAG><xsl:value-of select="CANCEL_FLAG" /></CANCEL_FLAG>
			<ENTOB_ITEM_NAME><xsl:value-of select="ENTOB_ITEM_NAME" /></ENTOB_ITEM_NAME>
			<TAX_FREE_YN><xsl:value-of select="TAX_FREE_YN" /></TAX_FREE_YN>
			<UDF_ATTR><xsl:value-of select="UDF_ATTR" /></UDF_ATTR>
		    </ROW>
	        </xsl:for-each>
        </XMLDATA>
</xsl:template>
</xsl:stylesheet>
