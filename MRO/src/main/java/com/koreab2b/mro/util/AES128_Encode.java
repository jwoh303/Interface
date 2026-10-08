package com.koreab2b.mro.util;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

public class AES128_Encode {

	/**
	 * 
	 * @param str	평문
	 * @param Key	인코딩 키값
	 * @param type	인코딩타입 (UTF-8, EUC-KR 등)
	 * @return
	 */
	public static String encode(String str, String Key, String type) throws Exception {
		byte[] keyData = Key.getBytes();
		SecretKey secureKey = new SecretKeySpec(keyData, "AES");
		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.ENCRYPT_MODE, secureKey, new IvParameterSpec(Key.getBytes()));
		byte[] encrypted = c.doFinal(str.getBytes(type));
		String enStr = new String(Base64.encodeBase64(encrypted));
		return enStr;
	}
}