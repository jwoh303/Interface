package com.koreab2b.common;

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
    
    //빈 값 체크
    public static boolean chkNull(String[] chkLst, List<Map<String,Object>> itemLst) throws Exception {
    	boolean isChk = true;
        try {
        	for(String chk : chkLst) {
        		for(Map<String,Object> item : itemLst){
    				if(item.get(chk) == null || "".equals(item.get(chk))){
    					isChk = false;					
    				}	
        		}
			}	
        } catch (Exception e) {
        	throw new Exception(e);
        }
        return isChk;
    }
}
