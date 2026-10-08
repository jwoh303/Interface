/**
 * 
 */
package com.koreab2b.mro.util;

/**
 * @author jiwon
 *
 */
public class CommonProperty {
	
	private static String HANJIN_DEV_URL = "https://api-stg.hanjin.com";	
	private static String HANJIN_PRD_URL = "https://api.hanjin.com";
	private static String HANJIN_PARCEL_DEV_URL = "https://ebbapd.hjt.co.kr/v1/wbl/KORB2B/print-wbl-sc";	
	private static String HANJIN_PARCEL_PRD_URL = "https://ebbapp.hjt.co.kr/v1/wbl/KORB2B/print-wbl-sc";
	private static String HANJIN_CLIENT_ID = "KORB2B";
	private static String HANJIN_API_KEY = "u5YwoIhGbN5D51cVt1AyyyZmXjrX13PmU3gCX51NRu48zru8"; // DEV : 5FIfXguzytQe3J19wPeQe1HC3m1wDv0UVsvbZvsDtDnpr6Oy
	private static String HANJIN_SECRET_KEY = "R6IW9KDB4FDjVs6XW7SVuANw1PuPcjJVMXYW098jkj2Y67nt9IAHTBApY1jxDxKz"; // DEV : sobG2Wyp9lZsV47cOsvGsYsKCR27eUCqQCH5aiNibfeGYKnGBD6yYH0dgOgUOQK3
	private static String BIZWIRE_WEBLINK_DEV_KEY = "f8d8ee21e2b51a0ba2d908f7cef2ae80f409c9019a22b01c67d8da55aaff6c06";
	private static String BIZWIRE_WEBLINK_PRD_KEY = "a12139b8a45a2a828c7da4c54f7c47591d8a7aa906cbd8e47339f81d47b3aee5";	
	private static String BIZWIRE_WEBLINK_DEV_URL = "https://test.bizwire.co.kr:38443/wp/bizwire/member/login/loginForWeblinkWithToken.do";
	private static String BIZWIRE_WEBLINK_PRD_URL = "https://www.bizwire.co.kr/wp/bizwire/member/login/loginForWeblinkWithToken.do";
	
	public static String getHanjinDevUrl() {
		return HANJIN_DEV_URL;
	}
	
	public static String getHanjinPrdUrl() {
		return HANJIN_PRD_URL;
	}
	
	public static String getHanjinApiKey() {
		return HANJIN_API_KEY;
	}
	
	public static String getHanjinSecretKey() {
		return HANJIN_SECRET_KEY;
	}
	
	public static String getHanjinClientId() {
		return HANJIN_CLIENT_ID;
	}

	public static String getHanjinParcelDevUrl() {
		return HANJIN_PARCEL_DEV_URL;
	}
	
	public static String getHanjinParcelPrdUrl() {
		return HANJIN_PARCEL_PRD_URL;
	}
	
	public static String getBizWebDevKey() {
		return BIZWIRE_WEBLINK_DEV_KEY;
	}
	
	public static String getBizWebPrdKey() {
		return BIZWIRE_WEBLINK_PRD_KEY;
	}	
	
	public static String getBizWebDevUrl() {
		return BIZWIRE_WEBLINK_DEV_URL;
	}
	
	public static String getBizWebPrdUrl() {
		return BIZWIRE_WEBLINK_PRD_URL;
	}
	
	
}
