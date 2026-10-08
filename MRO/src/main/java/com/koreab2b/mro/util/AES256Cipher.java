package com.koreab2b.mro.util;

import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.koreab2b.mro.manager.login.controller.LoginConrtroller; 

public class AES256Cipher {
	//public static byte[] ivBytes = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
	private static final Logger LOGGER = LoggerFactory.getLogger(LoginConrtroller.class);

	public static String AES_Base64_Encode(String str, String key)	throws java.io.UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,	IllegalBlockSizeException, BadPaddingException {

		byte[] textBytes = str.getBytes("UTF-8");
		String iv ="MOIN000000002005";
		byte[] ivBytes = iv.getBytes("US-ASCII");
		
		AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
		byte[] key_bytes = key.getBytes("US-ASCII");
		
		SecretKeySpec newKey = new SecretKeySpec(key_bytes, "AES");
		Cipher cipher = null;
		     
		cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		cipher.init(Cipher.ENCRYPT_MODE, newKey, ivSpec);
		byte[] result = cipher.doFinal(textBytes);
		String strResult =Base64.encodeBase64String(result);
		return strResult;
	}

	public static String AES_EncodeUrl(String str, String key)	throws java.io.UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,	IllegalBlockSizeException, BadPaddingException {

		byte[] textBytes = str.getBytes("UTF-8");
		String iv ="MOIN000000002005";
		byte[] ivBytes = iv.getBytes("US-ASCII");
		
		AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
		byte[] key_bytes = key.getBytes("US-ASCII");
		
		SecretKeySpec newKey = new SecretKeySpec(key_bytes, "AES");
		Cipher cipher = null;
		     
		cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		cipher.init(Cipher.ENCRYPT_MODE, newKey, ivSpec);
		byte[] result = cipher.doFinal(textBytes);
		String strResult =Base64.encodeBase64String(result);
		return strResult.replaceAll("[+]", "-").replaceAll("/", "_");
	}

	public static String AES_DecodeUrl(String str, String key)	throws java.io.UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		String iv ="MOIN000000002005";
		byte[] ivBytes = iv.getBytes("US-ASCII");
		
		str =str.replaceAll("-", "[+]");
		str =str.replaceAll("_", "/");
		str =str.replaceAll(" ", "[+]");
		
		byte[] textBytes = Base64.decodeBase64(str);
		//byte[] textBytes = str.getBytes("UTF-8");
		AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
		SecretKeySpec newKey = new SecretKeySpec(key.getBytes("US-ASCII"), "AES");
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		cipher.init(Cipher.DECRYPT_MODE, newKey, ivSpec);
		return new String(cipher.doFinal(textBytes), "UTF-8");
	}
	
	public static String AES_Base64_Decode(String str, String key)	throws java.io.UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		String iv ="MOIN000000002005";
		byte[] ivBytes = iv.getBytes("US-ASCII");

		str =str.replaceAll(" ", "[+]"); //일반적으로 공백은 +로 바꾸자
		
		byte[] textBytes = Base64.decodeBase64(str);
		//byte[] textBytes = str.getBytes("UTF-8");
		AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
		SecretKeySpec newKey = new SecretKeySpec(key.getBytes("US-ASCII"), "AES");
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		cipher.init(Cipher.DECRYPT_MODE, newKey, ivSpec);
		return new String(cipher.doFinal(textBytes), "UTF-8");
	}
	
	//KCTech AES로 암호화하여 넘어올 경우
	public static SecretKeySpec getKeySpec() throws IOException, NoSuchAlgorithmException

	{

		String key = "1la093jamv1az05302zdlae98adfq321";
		return new SecretKeySpec(key.getBytes("UTF-8"), "AES");

	}
	
	public static String Base64Encode(String targetstr) throws Exception

	{		
		byte[] textBytes = targetstr.getBytes("UTF-8");
		byte[] encodeBytes = Base64.encodeBase64(textBytes);
		return new String(encodeBytes, "UTF-8");
		
	}
	
	public static String Base64Decrypt(String targetstr) throws Exception

	{
		targetstr =targetstr.replaceAll(" ", "[+]"); //일반적으로 공백은 +로 바꾸자
		byte[] textBytes = Base64.decodeBase64(targetstr);
		return new String(textBytes, "UTF-8");
		
	}
}
