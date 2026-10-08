package com.koreab2b.mro.util;
import java.io.UnsupportedEncodingException;
import java.util.MissingResourceException;
import java.util.ResourceBundle;


import com.koreab2b.mro.manager.login.domain.SessionInfo;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

public class CommonLang {
    private static final String PROP_KR_BASE = "resources_ko";
    private static final String PROP_KR_MSG_BASE = "msg_ko";
    private static final String PROP_EN_BASE = "resources_en";
    private static final String PROP_EN_MSG_BASE = "msg_en";
    public static String get(String name) throws UnsupportedEncodingException
    {
        String property;
        try
        {
            ServletRequestAttributes attr = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();
        	SessionInfo _sessionLangInfo = (SessionInfo) attr.getRequest().getSession().getAttribute("sessionInfo");
        	String userLang = "";
        	if(_sessionLangInfo == null){
        		userLang = "KR";
        	}else{
        		userLang = _sessionLangInfo.getLang();	
        		if(userLang == null){
        			userLang = "KR";
        		}
        	}
    		if(userLang.equals("EN")){
            	ResourceBundle rb = ResourceBundle.getBundle(PROP_EN_BASE);
            	property = new String(rb.getString(name).getBytes("ISO-8859-1"), "utf-8");    			
    		}else{
            	ResourceBundle rb = ResourceBundle.getBundle(PROP_KR_BASE);
            	property = new String(rb.getString(name).getBytes("ISO-8859-1"), "utf-8");    			
    		}
    		

            //property = rb.getString(name);
        }
        catch (MissingResourceException e)
        {
            property = "";
        }
        
        return property;
    }
    public static String msg(String name) throws UnsupportedEncodingException
    {
        String property;
        try
        {
            ServletRequestAttributes attr = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();
        	SessionInfo _sessionLangInfo = (SessionInfo) attr.getRequest().getSession().getAttribute("sessionInfo");
        	String userLang = "";
        	if(_sessionLangInfo == null){
        		userLang = "KR";
        	}else{
        		userLang = _sessionLangInfo.getLang();	
        		if(userLang == null){
        			userLang = "KR";
        		}
        	}
        	if(userLang.equals("EN")){
            	ResourceBundle rb = ResourceBundle.getBundle(PROP_EN_MSG_BASE);
            	property = new String(rb.getString(name).getBytes("ISO-8859-1"), "utf-8");
        	}else{
            	ResourceBundle rb = ResourceBundle.getBundle(PROP_KR_MSG_BASE);
            	property = new String(rb.getString(name).getBytes("ISO-8859-1"), "utf-8");        		
        	}
            //property = rb.getString(name);
        }
        catch (MissingResourceException e)
        {
            property = "";
        }
        
        return property;
    }

} 
    
