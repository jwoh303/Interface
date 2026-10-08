package com.koreab2b.util;

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

	public static String null2sp(String str) {
		
		String rtn = "";
		
		try {
			if( !"".equals(str) && str != null) {
				rtn = str;
			}
		} catch (Exception e) {
		}
		
		return rtn;
	}
	
	public static String makeElement(String name, String value) {
		String rtn = "";
		
		if ( value == null || "".equals(value) ) {
			rtn = "	<"+name+"/>\n";
		} else {
			rtn = "	<"+name+">"+value+"</"+name+">\n";
		}
		
		return rtn;
	}
}