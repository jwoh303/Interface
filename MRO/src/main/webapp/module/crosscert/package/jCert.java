import java.io.*;
import crosscert.*;

public class jCert 
{
	public static void main(String[] args) 
	{
		int nPrilen=0, nCertlen=0, nRet;
		InputStream inPri=null;
		InputStream inCert=null;
		
		//OutputStream out=null;
		byte[] Prifilebuf;
		byte[] Certfilebuf;
		
		String sInput = "01:506-81-32479+02:(주)스마코+03:제조,도소매+04:경북 포항시 남구 연일읍 오천리 634-4번지+05:506-81-00017+06:포항종합제철(주)+07:제조,서비스,도소매,부동산+08:경북 포항시 남구 괴동동 1번지+10:10,790,420+11:1,079,042+12:2001-07-02+13:Cutting Fluid/Oil K MSDS DONG HO DAICOOL,200 L외+14:+15:+16:2001-07-02+30:";
		
		System.out.println("원문길이 : " + sInput.length() );
		
		try 
		{
			inPri =  new FileInputStream(new File("./Cert/signPri.key"));
			inCert = new FileInputStream(new File("./Cert/signCert.der"));
		}
		catch (FileNotFoundException e) 
		{
			System.out.println(e);
			return;
		}
		catch (IOException e) 
		{
			System.out.println(e);
			return;
		}
		
		try 
		{
			nPrilen=inPri.available();
			Prifilebuf=new byte[nPrilen];
			
			nRet=inPri.read(Prifilebuf);
			
			// 개인키 추출
			PrivateKey privateKey = new PrivateKey();
			nRet=privateKey.DecryptPriKey( "88888888", Prifilebuf, nPrilen);
			
			if ( nRet !=0)
			{
				System.out.println("PrivateKey Class=> " + privateKey.errmessage);
				return;
			}			
			System.out.println("개인키 길이 : " + privateKey.prikeylen);

			nCertlen=inCert.available();
			Certfilebuf = new byte[nCertlen];
		
			nRet=inCert.read(Certfilebuf);
		
			// 전자서명
			Signer signer = new Signer();
			nRet=signer.GetSignedData(privateKey.prikeybuf, privateKey.prikeylen, Certfilebuf, nCertlen, sInput.getBytes("KSC5601"), sInput.getBytes("KSC5601").length);
			
			System.out.println("전자서명 길이 : " + signer.signedlen);

			
			// 서명 검증
			Verifier verifier = new Verifier();
			nRet = verifier.VerSignedData(signer.signedbuf, signer.signedlen);

			System.out.println("서명 검증 결과 : " + Integer.toHexString(nRet));
			String sOrgData = new String( verifier.contentbuf, "KSC5601");
			
			System.out.println("원문 : " + sOrgData);
			System.out.println("원문길이 : String - " + sOrgData.length() + ", byte - " + verifier.contentlen );
			
			// 원문이 없는 전자서명
			nRet=signer.GetSignedDataNoContent(privateKey.prikeybuf, privateKey.prikeylen, Certfilebuf, nCertlen, sInput.getBytes("KSC5601"), sInput.getBytes("KSC5601").length);
			
			System.out.println("원문이 없는 전자서명 길이 : " + signer.signedlen);

			
			// 원문이 없는 서명 검증
			nRet = verifier.VerSignedDataNoContent(signer.signedbuf, signer.signedlen, sInput.getBytes("KSC5601"), sInput.getBytes("KSC5601").length);

			System.out.println("원문이 없는 서명 검증 결과 : " + Integer.toHexString(nRet));
						
		
			// 인증서 정보 추출
			Certificate certificate = new Certificate();
			nRet = certificate.ExtractCertInfo(verifier.certbuf, verifier.certlen);
			
			System.out.println("인증서 정보 추출 결과 : " + Integer.toHexString(nRet));
			System.out.println("############################");	
			System.out.println("version : " + certificate.version);
			System.out.println("serial : " + certificate.serial);
			System.out.println("issuer : " + certificate.issuer);
			System.out.println("subject : " + certificate.subject);
			System.out.println("subjectAlgId : " + certificate.subjectAlgId);
			System.out.println("from : " + certificate.from);
			System.out.println("to : " + certificate.to);
			System.out.println("signatureAlgId : " + certificate.signatureAlgId);
			System.out.println("pubkey : " + certificate.pubkey);
			System.out.println("signature : " + certificate.signature);
			System.out.println("issuerAltName : " + certificate.issuerAltName);
			System.out.println("subjectAltName : " + certificate.subjectAltName);
			System.out.println("keyusage : " + certificate.keyusage);
			System.out.println("policy : " + certificate.policy);
			System.out.println("basicConstraint : " + certificate.basicConstraint);
			System.out.println("policyConstraint : " + certificate.policyConstraint);
			System.out.println("distributionPoint : " + certificate.distributionPoint);
			System.out.println("authorityKeyId : " + certificate.authorityKeyId);
			System.out.println("subjectKeyId : " + certificate.subjectKeyId);
			System.out.println("############################");	
			
			String Policies = "1.2.410.200004.5.4.1.1|1.2.410.200004.5.4.1.2|1.2.410.200004.5.4.1.3|1.2.410.200004.5.4.1.4|1.2.410.200004.5.4.1.5";
			
			nRet = certificate.ValidateCert(verifier.certbuf, verifier.certlen, Policies , 1);
			//
			System.out.println("인증서 검증 결과 : " + Integer.toHexString(nRet));
			System.out.println("errcode : " + Integer.toHexString(certificate.errcode));
			System.out.println("errmessage : " + certificate.errmessage);

			
			// 암호화 (PKCS#7)
			Encrypt encrypt = new Encrypt();
			nRet = encrypt.EncEnvelopedData(Certfilebuf, nCertlen, sInput.getBytes("KSC5601"), sInput.getBytes("KSC5601").length);
			
			System.out.println("암호문(PKCS) 길이 : " + encrypt.envelopedlen);
			
			// 복호화 (PKCS#7)

			Decrypt decrypt = new Decrypt();
			nRet = decrypt.DecEnvelopedData(privateKey.prikeybuf, privateKey.prikeylen, Certfilebuf, nCertlen, encrypt.envelopedbuf, encrypt.envelopedlen);
			//nRet = decrypt.DecEnvelopedData(privateKey.prikeybuf, privateKey.prikeylen, certificate.contentbuf, certificate.contentlen, encrypt.envelopedbuf, encrypt.envelopedlen);

			System.out.println("복호문(PKCS) 결과 : " + Integer.toHexString(nRet));
			String sOrgData2 = new String( decrypt.contentbuf, "KSC5601");
			System.out.println("원문 : " + sOrgData2);
			System.out.println("원문길이 : String - " + sOrgData2.length() + ", byte - " + decrypt.contentlen );

			// 암호화 (SEED)
			nRet = encrypt.EncryptData(sInput.getBytes("KSC5601"), sInput.getBytes("KSC5601").length, "8888888888888888");
			
			System.out.println("암호문(SEED) 길이 : " + encrypt.envelopedlen);
			
			// Base64 Encoding
			Base64 base64 = new Base64();
			base64.Encode(decrypt.contentbuf, decrypt.contentlen);
			String sEncData = new String(base64.contentbuf, "KSC5601");
			System.out.println("암호문(SEED) ( Base64 Encoding) : " + sEncData);
			
			// Base64 Decoding
			base64.Decode(base64.contentbuf, base64.contentlen);
			System.out.println("암호문(SEED) 길이 (Base64 Decoding) : " + base64.contentlen);
		
			
			// 복호화 (SEED)
			nRet = decrypt.DecryptData(encrypt.envelopedbuf, encrypt.envelopedlen, "8888888888888888");

			System.out.println("복호화(SEED) 결과 : " + Integer.toHexString(nRet));
			String sOrgData3 = new String( decrypt.contentbuf, "KSC5601");
			System.out.println("원문 : " + sOrgData3);
			System.out.println("원문길이 : String - " + sOrgData3.length() + ", byte - " + decrypt.contentlen );
									
		}
		catch(IOException e1) 
		{
			System.out.println(e1); 
		}
		

	}
}
