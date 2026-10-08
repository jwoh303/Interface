package com.koreab2b.common;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;


public class Cryptograph {

	// MD2, MD5, SHA-1, SHA-256, SHA-384, SHA-512
	private String algorithm;
	private MessageDigest md;
	
	
	
	public Cryptograph(String _algorithm) {
		this.algorithm = _algorithm;
		try {
			this.md = MessageDigest.getInstance(this.algorithm);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}

	}
	
	private void init(){
		md.reset();
		
		try {
			this.md = MessageDigest.getInstance(this.algorithm);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
	}

	public String getAlgorithm() {
		return algorithm;
	}

	public void setAlgorithm(String algorithm) {
		this.algorithm = algorithm;
	}
	
	/*
	 * @_algorithm 암호화 알고리즘 
	 */
	public String encrypt(String str){
		
		String ret = null;
		byte digest[] = null;
		StringBuffer buf = null;
		
		init();
		
		md.update(str.getBytes());
		digest = md.digest();
		buf = new StringBuffer();
		
		//결과 헥사값으로 저장
		for(int i=0; i<digest.length; i++){
			buf.append(Integer.toHexString(0xFF & digest[i]));
		}
		
		ret = buf.toString();
		
		return ret;
	}
	
}
