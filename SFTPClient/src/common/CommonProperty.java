package common;

public class CommonProperty {

	private static String DB_CONN	= "0";

	public static String getDB_CONN() {
		return DB_CONN;
	}

	public static void setDB_CONN(String dB_CONN) {
		DB_CONN = dB_CONN; 
	}
}