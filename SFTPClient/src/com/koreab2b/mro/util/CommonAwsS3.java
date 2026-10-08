package com.koreab2b.mro.util;

import java.io.BufferedInputStream;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.S3Object;

public class CommonAwsS3 {

    // 접근 bucket 설정
	static String bucketName = "kepb2b";
	
	
	// bucket 접근권한 인증
	public static AmazonS3 certify(){
		/*
        * AWS S3 credentials 환경세팅 필요
        * C:\Users\USER_NAME\.aws\ 내 config, credentails 확인
        */

		final AmazonS3 s3 = AmazonS3ClientBuilder.standard().withRegion(Regions.AP_NORTHEAST_2).build();
	       
        return s3;


	}
	
	// 파일 존재여부 체크
	public static boolean doesFileExists(String fileDirName) {
		AmazonS3 s3 = certify();
       String key = fileDirName;
		
		return s3.doesObjectExist(bucketName, key);
	}


	// 파일 업로드
   public static void upload(MultipartFile file, String dir, String fileKey) throws IOException {

       AmazonS3 s3 = certify();
       /*
        * File key 설정
        * /디렉토리/등록파일명 으로 사용
        * 디렉토리 없을 시 자동 생성
        */
       String key = dir + fileKey;

       try {

       	ObjectMetadata omd = new ObjectMetadata();
           omd.setContentType(file.getContentType());
           omd.setContentLength(file.getSize());
           omd.setHeader("filename", fileKey);
       	
       	// 파일 업로드
           s3.putObject(new PutObjectRequest(bucketName, key, file.getInputStream(), omd));

       } catch (AmazonServiceException ase) {
           System.out.println("Caught an AmazonServiceException, which means your request made it "
                   + "to Amazon S3, but was rejected with an error response for some reason.");
           System.out.println("Error Message:    " + ase.getMessage());
           System.out.println("HTTP Status Code: " + ase.getStatusCode());
           System.out.println("AWS Error Code:   " + ase.getErrorCode());
           System.out.println("Error Type:       " + ase.getErrorType());
           System.out.println("Request ID:       " + ase.getRequestId());
       } catch (AmazonClientException ace) {
           System.out.println("Caught an AmazonClientException, which means the client encountered "
                   + "a serious internal problem while trying to communicate with S3, "
                   + "such as not being able to access the network.");
           System.out.println("Error Message: " + ace.getMessage());
       }
       
   }
   
   // 파일 다운로드
	public static File download(String fileName, String realName) throws Exception {
       
       AmazonS3 s3 = certify();
       String key = fileName;

       InputStream in = null;
       S3Object fileObject = null;
     
       try {
       	
           if(doesFileExists(key)){
           	fileObject = s3.getObject(new GetObjectRequest(bucketName, key));
           }else{
           	throw new Exception("file is not exist");
           }
           
       } catch (AmazonServiceException ase) {
           System.out.println("Caught an AmazonServiceException, which means your request made it "
                   + "to Amazon S3, but was rejected with an error response for some reason.");
           System.out.println("Error Message:    " + ase.getMessage());
           System.out.println("HTTP Status Code: " + ase.getStatusCode());
           System.out.println("AWS Error Code:   " + ase.getErrorCode());
           System.out.println("Error Type:       " + ase.getErrorType());
           System.out.println("Request ID:       " + ase.getRequestId());
       } catch (AmazonClientException ace) {
           System.out.println("Caught an AmazonClientException, which means the client encountered "
                   + "a serious internal problem while trying to communicate with S3, "
                   + "such as not being able to access the network.");
           System.out.println("Error Message: " + ace.getMessage());
       } catch (Exception e){
       	System.out.println("Error Message: " + e.getMessage());
       }
       
       File file = new File("D:/SFTPClient/SYGP/TMP/"+realName);
       
       try{
       	in = new BufferedInputStream(fileObject.getObjectContent());
       	FileOutputStream outputStream = new FileOutputStream(file);
       	int read;
       	byte[] bytes = new byte[1024];
       	
       	while((read=in.read(bytes))!= -1) {
       		outputStream.write(bytes, 0 ,read);
       	}
       }catch (Exception e) {
       	System.out.println("Error Message: " + e.getMessage());
       }
       
       
       
       return file;
       
   }    
   
   

}

    
