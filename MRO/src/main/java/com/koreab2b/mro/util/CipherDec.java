package com.koreab2b.mro.util;

import java.security.Key;
import java.security.MessageDigest;

import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;


public class CipherDec {
	//이노엔 sso 로그인
	
	//복호화
	public static String decrypt(String encStr, String keyValue) throws Exception {
		if (encStr == null || encStr.length() == 0) {
			return "";
		}

		final Cipher cipher = Cipher.getInstance("DESede/ECB/PKCS5Padding");
		cipher.init(Cipher.DECRYPT_MODE, getKey(keyValue));

		sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();

		final byte[] inputBytes = decoder.decodeBuffer(encStr);
		final byte[] outputBytes = cipher.doFinal(inputBytes);

		String decStr = new String(outputBytes, "UTF8");
		return decStr;
	}

	private static Key getKey(String keyValue) throws Exception {

		final MessageDigest md = MessageDigest.getInstance("md5");
		final byte[] digestOfPassword = md.digest(keyValue.getBytes("utf-8"));

		byte[] keyBytes = new byte[24];
		System.arraycopy(digestOfPassword, 0, keyBytes, 0, digestOfPassword.length);
		for (int j = 0, k = 16; j < 8; k++, j++) {
			keyBytes[k] = keyBytes[j];
		}

		DESedeKeySpec desKeySpec = new DESedeKeySpec(keyBytes);
		SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DESede");

		Key key = keyFactory.generateSecret(desKeySpec);
		return key;
	}

}
