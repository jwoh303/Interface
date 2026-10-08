package com.kep.common;

public class CommonProperty {

	private static String DB_CONN	= "0";		// 0:개발, 2:운영
	private static String DB_TYPE	= "KEPMP";	// KEPMP, KEPCON

	public static String getDB_CONN() {
		return DB_CONN;
	}
	public static void setDB_CONN(String dB_CONN) {
		DB_CONN = dB_CONN;
	}
	public static String getDB_TYPE() {
		return DB_TYPE;
	}
	public static void setDB_TYPE(String dB_TYPE) {
		DB_TYPE = dB_TYPE;
	}
}