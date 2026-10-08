package com.koreab2b.mro.util;
/**
세금계산서 전송 암호화로직
*/
import java.io.UnsupportedEncodingException;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class AesCryptoAlgorithmUtil {
	// AES Code
	public static String Decrypt(String text, String key) throws Exception
	{
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		byte[] keyBytes= new byte[16];
		byte[] b= key.getBytes("UTF-8");
		int len= b.length;
		if (len > keyBytes.length) len = keyBytes.length;
		System.arraycopy(b, 0, keyBytes, 0, len);
		SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
		IvParameterSpec ivSpec = new IvParameterSpec(keyBytes);
		cipher.init(Cipher.DECRYPT_MODE,keySpec,ivSpec);
		byte [] results = cipher.doFinal(base64Decode(text));
        return new String(results,"UTF-8");
    }

    public static String Encrypt(String text, String key) throws Exception
    {    
    	Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
    	byte[] keyBytes= new byte[16];
    	byte[] b= key.getBytes("UTF-8");
    	int len= b.length;
    	if (len > keyBytes.length) len = keyBytes.length;
    	System.arraycopy(b, 0, keyBytes, 0, len);
    	SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
    	IvParameterSpec ivSpec = new IvParameterSpec(keyBytes);
    	cipher.init(Cipher.ENCRYPT_MODE,keySpec,ivSpec);
    	byte[] results = cipher.doFinal(text.getBytes("UTF-8"));
    	return base64Encode(results);
    }
    
    
    // Base64 Code
    private static byte[] mBase64EncMap, mBase64DecMap; 
    static
    {
    	byte[] base64Map = 
    	{
    		(byte)'A', (byte)'B', (byte)'C', (byte)'D', (byte)'E', (byte)'F',
  	        (byte)'G', (byte)'H', (byte)'I', (byte)'J', (byte)'K', (byte)'L', 
  	        (byte)'M', (byte)'N', (byte)'O', (byte)'P', (byte)'Q', (byte)'R', 
  	        (byte)'S', (byte)'T', (byte)'U', (byte)'V', (byte)'W', (byte)'X', 
  	        (byte)'Y', (byte)'Z', 
  	        (byte)'a', (byte)'b', (byte)'c', (byte)'d', (byte)'e', (byte)'f', 
  	        (byte)'g', (byte)'h', (byte)'i', (byte)'j', (byte)'k', (byte)'l', 
  	        (byte)'m', (byte)'n', (byte)'o', (byte)'p', (byte)'q', (byte)'r', 
  	        (byte)'s', (byte)'t', (byte)'u', (byte)'v', (byte)'w', (byte)'x', 
  	        (byte)'y', (byte)'z', 
  	        (byte)'0', (byte)'1', (byte)'2', (byte)'3', (byte)'4', (byte)'5', 
  	        (byte)'6', (byte)'7', (byte)'8', (byte)'9', (byte)'+', (byte)'/'
    	}; 
    	mBase64EncMap = base64Map;
    	mBase64DecMap = new byte[128];
    	for (int i=0; i<mBase64EncMap.length; i++)
    		mBase64DecMap[mBase64EncMap[i]] = (byte) i;
    	
    } 

    public static String base64Encode(byte[] aData) 
    {
    	if ((aData == null) || (aData.length == 0)) 
  	            throw new IllegalArgumentException("Can not encode NULL or empty byte array."); 

  	        byte encodedBuf[] = new byte[((aData.length+2)/3)*4]; 

  	        int srcIndex, destIndex; 
  	        for (srcIndex=0, destIndex=0; srcIndex < aData.length-2; srcIndex += 3) { 
  	            encodedBuf[destIndex++] = mBase64EncMap[(aData[srcIndex] >>> 2) & 077]; 
  	            encodedBuf[destIndex++] = mBase64EncMap[(aData[srcIndex+1] >>> 4) & 017 | 
  	                        (aData[srcIndex] << 4) & 077]; 
  	            encodedBuf[destIndex++] = mBase64EncMap[(aData[srcIndex+2] >>> 6) & 003 | 
  	                        (aData[srcIndex+1] << 2) & 077]; 
  	            encodedBuf[destIndex++] = mBase64EncMap[aData[srcIndex+2] & 077]; 
  	        } 

  	        if (srcIndex < aData.length) { 
  	            encodedBuf[destIndex++] = mBase64EncMap[(aData[srcIndex] >>> 2) & 077]; 
  	            if (srcIndex < aData.length-1) { 
  	                encodedBuf[destIndex++] = mBase64EncMap[(aData[srcIndex+1] >>> 4) & 017 | 
  	                    (aData[srcIndex] << 4) & 077]; 
  	                encodedBuf[destIndex++] = mBase64EncMap[(aData[srcIndex+1] << 2) & 077]; 
  	            } 
  	            else { 
  	                encodedBuf[destIndex++] = mBase64EncMap[(aData[srcIndex] << 4) & 077]; 
  	            } 
  	        } 

  	        while (destIndex < encodedBuf.length) { 
  	            encodedBuf[destIndex] = (byte) '='; 
  	            destIndex++; 
  	        } 

  	        String result = new String(encodedBuf); 
  	        return result; 
  	    } 

  	    public static byte[] base64Decode(String aData) { 
  	        if ((aData == null) || (aData.length() == 0)) 
  	            throw new IllegalArgumentException("Can not decode NULL or empty string."); 

  	        byte[] data = aData.getBytes(); 

  	        int tail = data.length; 
  	        while (data[tail-1] == '=') 
  	            tail--; 

  	        byte decodedBuf[] = new byte[tail - data.length/4]; 

  	        for (int i = 0; i < data.length; i++) 
  	            data[i] = mBase64DecMap[data[i]]; 

  	        int srcIndex, destIndex; 
  	        for (srcIndex = 0, destIndex=0; destIndex < decodedBuf.length-2; 
  	                srcIndex += 4, destIndex += 3) { 
  	            decodedBuf[destIndex] = (byte) ( ((data[srcIndex] << 2) & 255) | 
  	                ((data[srcIndex+1] >>> 4) & 003) ); 
  	            decodedBuf[destIndex+1] = (byte) ( ((data[srcIndex+1] << 4) & 255) | 
  	                ((data[srcIndex+2] >>> 2) & 017) ); 
  	            decodedBuf[destIndex+2] = (byte) ( ((data[srcIndex+2] << 6) & 255) | 
  	                (data[srcIndex+3] & 077) ); 
  	        } 

  	        if (destIndex < decodedBuf.length) 
  	            decodedBuf[destIndex] = (byte) ( ((data[srcIndex] << 2) & 255) | 
  	                ((data[srcIndex+1] >>> 4) & 003) ); 
  	        if (++destIndex < decodedBuf.length) 
  	            decodedBuf[destIndex] = (byte) ( ((data[srcIndex+1] << 4) & 255) | 
  	                ((data[srcIndex+2] >>> 2) & 017) ); 

  	        return decodedBuf; 
  	    }
  	  public static String URLUTF8Encoder_encodeOld(String s){
  		   String[] hex = {
  				"%00", "%01", "%02", "%03", "%04", "%05", "%06", "%07",
  				"%08", "%09", "%0a", "%0b", "%0c", "%0d", "%0e", "%0f",
  				"%10", "%11", "%12", "%13", "%14", "%15", "%16", "%17",
  				"%18", "%19", "%1a", "%1b", "%1c", "%1d", "%1e", "%1f",
  				"%20", "%21", "%22", "%23", "%24", "%25", "%26", "%27",
  				"%28", "%29", "%2a", "%2b", "%2c", "%2d", "%2e", "%2f",
  				"%30", "%31", "%32", "%33", "%34", "%35", "%36", "%37",
  				"%38", "%39", "%3a", "%3b", "%3c", "%3d", "%3e", "%3f",
  				"%40", "%41", "%42", "%43", "%44", "%45", "%46", "%47",
  				"%48", "%49", "%4a", "%4b", "%4c", "%4d", "%4e", "%4f",
  				"%50", "%51", "%52", "%53", "%54", "%55", "%56", "%57",
  				"%58", "%59", "%5a", "%5b", "%5c", "%5d", "%5e", "%5f",
  				"%60", "%61", "%62", "%63", "%64", "%65", "%66", "%67",
  				"%68", "%69", "%6a", "%6b", "%6c", "%6d", "%6e", "%6f",
  				"%70", "%71", "%72", "%73", "%74", "%75", "%76", "%77",
  				"%78", "%79", "%7a", "%7b", "%7c", "%7d", "%7e", "%7f",
  				"%80", "%81", "%82", "%83", "%84", "%85", "%86", "%87",
  				"%88", "%89", "%8a", "%8b", "%8c", "%8d", "%8e", "%8f",
  				"%90", "%91", "%92", "%93", "%94", "%95", "%96", "%97",
  				"%98", "%99", "%9a", "%9b", "%9c", "%9d", "%9e", "%9f",
  				"%a0", "%a1", "%a2", "%a3", "%a4", "%a5", "%a6", "%a7",
  				"%a8", "%a9", "%aa", "%ab", "%ac", "%ad", "%ae", "%af",
  				"%b0", "%b1", "%b2", "%b3", "%b4", "%b5", "%b6", "%b7",
  				"%b8", "%b9", "%ba", "%bb", "%bc", "%bd", "%be", "%bf",
  				"%c0", "%c1", "%c2", "%c3", "%c4", "%c5", "%c6", "%c7",
  				"%c8", "%c9", "%ca", "%cb", "%cc", "%cd", "%ce", "%cf",
  				"%d0", "%d1", "%d2", "%d3", "%d4", "%d5", "%d6", "%d7",
  				"%d8", "%d9", "%da", "%db", "%dc", "%dd", "%de", "%df",
  				"%e0", "%e1", "%e2", "%e3", "%e4", "%e5", "%e6", "%e7",
  				"%e8", "%e9", "%ea", "%eb", "%ec", "%ed", "%ee", "%ef",
  				"%f0", "%f1", "%f2", "%f3", "%f4", "%f5", "%f6", "%f7",
  				"%f8", "%f9", "%fa", "%fb", "%fc", "%fd", "%fe", "%ff"
  			};

  			StringBuffer sbuf = new StringBuffer();
  			int len = s.length();

  			for (int i = 0; i < len; i++) {
  				int ch = s.charAt(i);

  				if ('A' <= ch && ch <= 'Z') {		// 'A'..'Z'
  					sbuf.append((char)ch);
  				}else if ('a' <= ch && ch <= 'z') {	// 'a'..'z'
  					sbuf.append((char)ch);
  				}else if ('0' <= ch && ch <= '9') {	// '0'..'9'
  					sbuf.append((char)ch);
  				}else if (ch == ' ') {			// space
  					sbuf.append('+');
  				}else if (ch == '-' || ch == '_'		// unreserved
  					  || ch == '.' || ch == '!'
  					  || ch == '~' || ch == '*'
  					  || ch == '\'' || ch == '('
  					  || ch == ')') {
  					sbuf.append((char)ch);
  				}else if (ch <= 0x007f){		// other ASCII
  					sbuf.append(hex[ch]);
  				}else if (ch <= 0x07FF){		// non-ASCII <= 0x7FF
  					sbuf.append(hex[0xc0 | (ch >> 6)]);
  					sbuf.append(hex[0x80 | (ch & 0x3F)]);
  				}else{					// 0x7FF < ch <= 0xFFFF
  					sbuf.append(hex[0xe0 | (ch >> 12)]);
  					sbuf.append(hex[0x80 | ((ch >> 6) & 0x3F)]);
  					sbuf.append(hex[0x80 | (ch & 0x3F)]);
  				}
  			}
  			return sbuf.toString();
  		}
  	  
  	  public static String URLUTF8Encoder_encode(String s) throws UnsupportedEncodingException{

  		// String 을 utf-8 로 인코딩.
  		byte[] utf8StringBuffer = s.getBytes("UTF-8");
  		//String decodedFromUtf8 = new String(utf8StringBuffer, "UTF-8");
  		String decodedFromUtf8 = utf8StringBuffer.toString();
  		return decodedFromUtf8;
  	  }
  	  public static String[] URLUTF8Encoder_encodeA(String s) throws UnsupportedEncodingException{

  		// String 을 utf-8 로 인코딩.
  		byte[] utf8StringBuffer = s.getBytes("UTF-8");
  		String[] encodeData = new String[1];
  		encodeData[0] =utf8StringBuffer.toString();
  		return encodeData;
  	  }
  	  public static String URLUTF8Encoder_encode1(String s){
		   String[] hex = {
				"%00", "%01", "%02", "%03", "%04", "%05", "%06", "%07",
				"%08", "%09", "%0a", "%0b", "%0c", "%0d", "%0e", "%0f",
				"%10", "%11", "%12", "%13", "%14", "%15", "%16", "%17",
				"%18", "%19", "%1a", "%1b", "%1c", "%1d", "%1e", "%1f",
				"%20", "%21", "%22", "%23", "%24", "%25", "%26", "%27",
				"%28", "%29", "%2a", "%2b", "%2c", "%2d", "%2e", "%2f",
				"%30", "%31", "%32", "%33", "%34", "%35", "%36", "%37",
				"%38", "%39", "%3a", "%3b", "%3c", "%3d", "%3e", "%3f",
				"%40", "%41", "%42", "%43", "%44", "%45", "%46", "%47",
				"%48", "%49", "%4a", "%4b", "%4c", "%4d", "%4e", "%4f",
				"%50", "%51", "%52", "%53", "%54", "%55", "%56", "%57",
				"%58", "%59", "%5a", "%5b", "%5c", "%5d", "%5e", "%5f",
				"%60", "%61", "%62", "%63", "%64", "%65", "%66", "%67",
				"%68", "%69", "%6a", "%6b", "%6c", "%6d", "%6e", "%6f",
				"%70", "%71", "%72", "%73", "%74", "%75", "%76", "%77",
				"%78", "%79", "%7a", "%7b", "%7c", "%7d", "%7e", "%7f",
				"%80", "%81", "%82", "%83", "%84", "%85", "%86", "%87",
				"%88", "%89", "%8a", "%8b", "%8c", "%8d", "%8e", "%8f",
				"%90", "%91", "%92", "%93", "%94", "%95", "%96", "%97",
				"%98", "%99", "%9a", "%9b", "%9c", "%9d", "%9e", "%9f",
				"%a0", "%a1", "%a2", "%a3", "%a4", "%a5", "%a6", "%a7",
				"%a8", "%a9", "%aa", "%ab", "%ac", "%ad", "%ae", "%af",
				"%b0", "%b1", "%b2", "%b3", "%b4", "%b5", "%b6", "%b7",
				"%b8", "%b9", "%ba", "%bb", "%bc", "%bd", "%be", "%bf",
				"%c0", "%c1", "%c2", "%c3", "%c4", "%c5", "%c6", "%c7",
				"%c8", "%c9", "%ca", "%cb", "%cc", "%cd", "%ce", "%cf",
				"%d0", "%d1", "%d2", "%d3", "%d4", "%d5", "%d6", "%d7",
				"%d8", "%d9", "%da", "%db", "%dc", "%dd", "%de", "%df",
				"%e0", "%e1", "%e2", "%e3", "%e4", "%e5", "%e6", "%e7",
				"%e8", "%e9", "%ea", "%eb", "%ec", "%ed", "%ee", "%ef",
				"%f0", "%f1", "%f2", "%f3", "%f4", "%f5", "%f6", "%f7",
				"%f8", "%f9", "%fa", "%fb", "%fc", "%fd", "%fe", "%ff"
			};

			StringBuffer sbuf = new StringBuffer();
			int len = s.length();
			for (int i = 0; i < len; i++) {
				int ch = s.charAt(i);

				if ('A' <= ch && ch <= 'Z') {		// 'A'..'Z'
					sbuf.append((char)ch);
				}else if ('a' <= ch && ch <= 'z') {	// 'a'..'z'
					sbuf.append((char)ch);
				}else if ('0' <= ch && ch <= '9') {	// '0'..'9'
					sbuf.append((char)ch);
				}else if (ch == ' ') {			// space
					sbuf.append('+');
				}else if (ch == '-' || ch == '_'		// unreserved
					  || ch == '.' || ch == '!'
					  || ch == '~' || ch == '*'
					  || ch == '\'' || ch == '('
					  || ch == ')'|| ch == '<'|| ch == '>'|| ch == '>'|| ch == '/'|| ch == '='||ch == ' '|| ch == '?') {
					sbuf.append((char)ch);
				}else if (ch <= 0x007f){		// other ASCII
					sbuf.append(hex[ch]);
				}else if (ch <= 0x07FF){		// non-ASCII <= 0x7FF
					sbuf.append(hex[0xc0 | (ch >> 6)]);
					sbuf.append(hex[0x80 | (ch & 0x3F)]);
				}else{					// 0x7FF < ch <= 0xFFFF
					sbuf.append(hex[0xe0 | (ch >> 12)]);
					sbuf.append(hex[0x80 | ((ch >> 6) & 0x3F)]);
					sbuf.append(hex[0x80 | (ch & 0x3F)]);
				}
			}
			return sbuf.toString();
		}
  	  public static String[] URLUTF8Encoder_encodeArray(String[] s){
 		   String[] hex = {
 				"%00", "%01", "%02", "%03", "%04", "%05", "%06", "%07",
 				"%08", "%09", "%0a", "%0b", "%0c", "%0d", "%0e", "%0f",
 				"%10", "%11", "%12", "%13", "%14", "%15", "%16", "%17",
 				"%18", "%19", "%1a", "%1b", "%1c", "%1d", "%1e", "%1f",
 				"%20", "%21", "%22", "%23", "%24", "%25", "%26", "%27",
 				"%28", "%29", "%2a", "%2b", "%2c", "%2d", "%2e", "%2f",
 				"%30", "%31", "%32", "%33", "%34", "%35", "%36", "%37",
 				"%38", "%39", "%3a", "%3b", "%3c", "%3d", "%3e", "%3f",
 				"%40", "%41", "%42", "%43", "%44", "%45", "%46", "%47",
 				"%48", "%49", "%4a", "%4b", "%4c", "%4d", "%4e", "%4f",
 				"%50", "%51", "%52", "%53", "%54", "%55", "%56", "%57",
 				"%58", "%59", "%5a", "%5b", "%5c", "%5d", "%5e", "%5f",
 				"%60", "%61", "%62", "%63", "%64", "%65", "%66", "%67",
 				"%68", "%69", "%6a", "%6b", "%6c", "%6d", "%6e", "%6f",
 				"%70", "%71", "%72", "%73", "%74", "%75", "%76", "%77",
 				"%78", "%79", "%7a", "%7b", "%7c", "%7d", "%7e", "%7f",
 				"%80", "%81", "%82", "%83", "%84", "%85", "%86", "%87",
 				"%88", "%89", "%8a", "%8b", "%8c", "%8d", "%8e", "%8f",
 				"%90", "%91", "%92", "%93", "%94", "%95", "%96", "%97",
 				"%98", "%99", "%9a", "%9b", "%9c", "%9d", "%9e", "%9f",
 				"%a0", "%a1", "%a2", "%a3", "%a4", "%a5", "%a6", "%a7",
 				"%a8", "%a9", "%aa", "%ab", "%ac", "%ad", "%ae", "%af",
 				"%b0", "%b1", "%b2", "%b3", "%b4", "%b5", "%b6", "%b7",
 				"%b8", "%b9", "%ba", "%bb", "%bc", "%bd", "%be", "%bf",
 				"%c0", "%c1", "%c2", "%c3", "%c4", "%c5", "%c6", "%c7",
 				"%c8", "%c9", "%ca", "%cb", "%cc", "%cd", "%ce", "%cf",
 				"%d0", "%d1", "%d2", "%d3", "%d4", "%d5", "%d6", "%d7",
 				"%d8", "%d9", "%da", "%db", "%dc", "%dd", "%de", "%df",
 				"%e0", "%e1", "%e2", "%e3", "%e4", "%e5", "%e6", "%e7",
 				"%e8", "%e9", "%ea", "%eb", "%ec", "%ed", "%ee", "%ef",
 				"%f0", "%f1", "%f2", "%f3", "%f4", "%f5", "%f6", "%f7",
 				"%f8", "%f9", "%fa", "%fb", "%fc", "%fd", "%fe", "%ff"
 			};

 			StringBuffer sbuf = new StringBuffer();
 			int len = s[0].length();
 			for (int i = 0; i < len; i++) {
 				int ch = s[0].charAt(i);

 				if ('A' <= ch && ch <= 'Z') {		// 'A'..'Z'
 					sbuf.append((char)ch);
 				}else if ('a' <= ch && ch <= 'z') {	// 'a'..'z'
 					sbuf.append((char)ch);
 				}else if ('0' <= ch && ch <= '9') {	// '0'..'9'
 					sbuf.append((char)ch);
 				}else if (ch == ' ') {			// space
 					sbuf.append('+');
 				}else if (ch == '-' || ch == '_'		// unreserved
 					  || ch == '.' || ch == '!'
 					  || ch == '~' || ch == '*'
 					  || ch == '\'' || ch == '('
 					 || ch == ')'|| ch == '<'|| ch == '>'|| ch == '>'|| ch == '/'|| ch == '='||ch == ' '|| ch == '?') {
 					sbuf.append((char)ch);
 				}else if (ch <= 0x007f){		// other ASCII
 					sbuf.append(hex[ch]);
 				}else if (ch <= 0x07FF){		// non-ASCII <= 0x7FF
 					sbuf.append(hex[0xc0 | (ch >> 6)]);
 					sbuf.append(hex[0x80 | (ch & 0x3F)]);
 				}else{					// 0x7FF < ch <= 0xFFFF
 					sbuf.append(hex[0xe0 | (ch >> 12)]);
 					sbuf.append(hex[0x80 | ((ch >> 6) & 0x3F)]);
 					sbuf.append(hex[0x80 | (ch & 0x3F)]);
 				}
 			}
 			String[] encodeData = {sbuf.toString()};
 			return encodeData;
 		}
}











