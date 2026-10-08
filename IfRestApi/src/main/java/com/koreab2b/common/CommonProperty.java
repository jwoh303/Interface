package com.koreab2b.common;

public class CommonProperty {

	private static String DB_CONN	= "2";	// 0:개발, 2:운영

	public static String getDB_CONN() {
		return DB_CONN;
	}

	public static void setDB_CONN(String dB_CONN) {
		DB_CONN = dB_CONN;
	}
}