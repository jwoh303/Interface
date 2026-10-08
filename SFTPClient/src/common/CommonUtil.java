package common;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CommonUtil {

    public static String printStackTraceToString(Throwable e) {
        StringBuffer sb = new StringBuffer();
        try {
            sb.append(e.toString());
            sb.append("\n");
            StackTraceElement element[] = e.getStackTrace();
            for (int idx = 0; idx < element.length; idx++) {
                sb.append("\tat ");
                sb.append(element[idx].toString());
                sb.append("\n");
            }
        } catch (Exception ex) {
            return e.toString();
        }
        return sb.toString();
    }
    
    public static List<Map<String,Object>> convertResultSetToMaps(ResultSet rs) throws SQLException {
    	List<Map<String, Object>> maps = new ArrayList<Map<String, Object>>();
    	
    	ResultSetMetaData mData = rs.getMetaData();
    	int col = mData.getColumnCount();
    	
    	while (rs.next()) {
    		Map<String, Object> map = new HashMap<String, Object>();
    		
    		for (int i = 1 ; i < (col + 1) ; i++ ) {
    			String colName = mData.getColumnName(i);
    			map.put(colName, rs.getString(colName));
    		}
    		maps.add(map);
    	}
    	
    	return maps;
    }
    
    public static List<Map<String,String>> convertResultSetToMapsString(ResultSet rs) throws SQLException {
    	List<Map<String, String>> maps = new ArrayList<Map<String, String>>();
    	
    	ResultSetMetaData mData = rs.getMetaData();
    	int col = mData.getColumnCount();
    	
    	while (rs.next()) {
    		Map<String, String> map = new HashMap<String, String>();
    		
    		for (int i = 1 ; i < (col + 1) ; i++ ) {
    			String colName = mData.getColumnName(i);
    			map.put(colName, rs.getString(colName));
    		}
    		maps.add(map);
    	}
    	
    	return maps;
    }
}