package com.koreab2b.mro.util;

import java.io.UnsupportedEncodingException;

import com.amazonaws.encryptionsdk.AwsCrypto;
import com.amazonaws.encryptionsdk.CryptoAlgorithm;
import com.amazonaws.encryptionsdk.kms.KmsMasterKeyProvider;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.kms.AWSKMS;
import com.amazonaws.services.kms.AWSKMSClientBuilder;
import com.amazonaws.services.kms.model.EncryptRequest;

/**
@file AWSKMSAlgorithmUtil.java
@brief AWS KMS 알고리즘
*/

public class AWSKMSAlgorithmUtil {
//	private final AWSKMS kmsClient = AWSKMSClientBuilder.standard().withRegion(Regions.AP_NORTHEAST_2).build();
	private final static String keyId = "arn:aws:kms:ap-northeast-2:150890254166:key/cd14c906-0b0b-4aa3-a474-47493d2e2d05";
	
	private static AwsCrypto crypto = new AwsCrypto();
	
	private static KmsMasterKeyProvider prov = null;
	
	public static String encrypt(String plainText) throws UnsupportedEncodingException {
		prov = new KmsMasterKeyProvider(keyId);
		crypto.setEncryptionAlgorithm(CryptoAlgorithm.ALG_AES_256_GCM_IV12_TAG16_HKDF_SHA256);
		
		String cipherText = crypto.encryptString(prov, new String(plainText.getBytes("UTF-8"))).getResult();
		
		return cipherText;
	}
	
	public static String decrypt(String cipherText) throws UnsupportedEncodingException {
		String plainText = "";
		prov = new KmsMasterKeyProvider(keyId);
		
		crypto.setEncryptionAlgorithm(CryptoAlgorithm.ALG_AES_256_GCM_IV12_TAG16_HKDF_SHA256);
		
		plainText = crypto.decryptString(prov, cipherText).getResult();
		plainText = new String(plainText.getBytes("UTF-8"));
		
		return plainText;
	}
}











