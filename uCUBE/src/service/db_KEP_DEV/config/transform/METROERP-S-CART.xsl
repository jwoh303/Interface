<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"	version="2.0">
<xsl:output method="xml" indent="yes" encoding="UTF-8" cdata-section-elements="SUPPLIER_NAME SUPPLIER_PART_DESC"/>
<xsl:template match="/" name="main">
<NTBCAT>
			<HEADER>
				<CUST_CD>METROERP</CUST_CD>
				<DOC_ID><xsl:value-of select="/XMLDATA/ROW[1]/DOC_ID" /></DOC_ID>
			</HEADER>
			<BODY>
				<xsl:for-each select="/XMLDATA/ROW">
					<ITEM_INFO>
						<USER_ID><xsl:value-of select="USER_ID" /></USER_ID>
						<SEND_NO>	<xsl:value-of	select="SEND_NO" />	</SEND_NO>
						<SEND_LINE_NO><xsl:value-of	select="SEND_LINE_NO" /></SEND_LINE_NO>
						<CUSTOMER_NAME><xsl:value-of	select="CUSTOMER_NAME" /></CUSTOMER_NAME>
						<CUSTOMER_PART_NO><xsl:value-of	select="CUSTOMER_PART_NO" /></CUSTOMER_PART_NO>
						<CUSTOMER_PART_DESC><xsl:value-of	select="CUSTOMER_PART_DESC" /></CUSTOMER_PART_DESC>
						<SUPPLIER_NAME><xsl:value-of	select="SUPPLIER_NAME" /></SUPPLIER_NAME>
						<SUPPLIER_PART_NO><xsl:value-of	select="SUPPLIER_PART_NO" /></SUPPLIER_PART_NO>
						<SUPPLIER_PART_DESC><xsl:value-of select="SUPPLIER_PART_DESC" /></SUPPLIER_PART_DESC>
						<PRICE><xsl:value-of select="format-number(PRICE,'###########.##')" /></PRICE>
						<LIST_PRICE><xsl:value-of	select="LIST_PRICE" /></LIST_PRICE>
						<LEAD_TIME><xsl:value-of select="format-number(LEAD_TIME,'###')" /></LEAD_TIME>
						<MOQ><xsl:value-of select="format-number(MOQ,'#############.###')" /></MOQ>
						<QUANTITY><xsl:value-of	select="format-number(QUANTITY,'#############.###')" /></QUANTITY>
						<PER><xsl:value-of select="PER" /></PER>
						<UOM><xsl:value-of select="UOM" />	</UOM>
						<CURRENCY><xsl:value-of	select="CURRENCY" /></CURRENCY>
						<ENTOB_PART_NUMBER><xsl:value-of	select="ENTOB_PART_NUMBER" /></ENTOB_PART_NUMBER>
						<ENTOB_MAPPING_CODE><xsl:value-of	select="ENTOB_MAPPING_CODE" /></ENTOB_MAPPING_CODE>
						<TAX_TYPE><xsl:value-of	select="TAX_TYPE" /></TAX_TYPE>
						<ENTOB_SEND_DATE><xsl:value-of select="ENTOB_SEND_DATE" /></ENTOB_SEND_DATE>
						<TOTAL_AMOUNT><xsl:value-of select="format-number(TOTAL_AMOUNT,'###############.###')" /></TOTAL_AMOUNT>
						<CATE_NM><xsl:value-of select="CATE_NM" /></CATE_NM>
						<COMPANY_MID><xsl:value-of select="COMPANY_MID" /></COMPANY_MID>
						<COMPANY_WOMEN><xsl:value-of select="COMPANY_WOMEN" /></COMPANY_WOMEN>
						<COMPANY_DISABLED><xsl:value-of select="COMPANY_DISABLED" /></COMPANY_DISABLED>
						<ITEM_NEW_TECHNIQUE><xsl:value-of select="ITEM_NEW_TECHNIQUE" /></ITEM_NEW_TECHNIQUE>
						<ITEM_ENVIRONMENT><xsl:value-of select="ITEM_ENVIRONMENT" /></ITEM_ENVIRONMENT>
						<VENDOR_PROPERTY><xsl:value-of select="VENDOR_PROPERTY" /></VENDOR_PROPERTY>
					</ITEM_INFO>
				</xsl:for-each>
			</BODY>
		</NTBCAT>
</xsl:template>
</xsl:stylesheet>