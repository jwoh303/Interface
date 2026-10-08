package com.koreab2b.mro.common.coco.dao;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

import com.googlecode.ehcache.annotations.Cacheable;
import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.util.CommonAwsS3;
import com.koreab2b.mro.util.CommonUtil;

@Repository("commonInfoDao")
public class CommonInfoDaoImpl implements CommonInfoDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonInfoDaoImpl.class);

	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate; 

	public List<Map<String,String>> loginProcess(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("login.loginprocess", pMap);
	}
	
	@Cacheable(cacheName = "commonCache")
	public List<Map<String,String>> ajaxCombo(Map<String, String> pMap) {
		String queryId = pMap.get("COMMONTABLEGUBUN").toString();
		return sqlSessionTemplate.selectList("common.getCombo"+queryId, pMap);
	}
	
	@Cacheable(cacheName = "commonCache")
	public List<Map<String,String>> ajaxQueryIdCombo(String queryId) {
		return sqlSessionTemplate.selectList(queryId, null);
	}
 
	@Cacheable(cacheName = "commonCache")
	public List<Map<String,String>> ajaxQueryIdCombo(Map<String, String> pMap) {
		String queryId =  pMap.get("QUERYID").toString();
		if(queryId.equals("getBuyerUnitMeasureInfo")){
			List<Map<String,String>> list = null;
			list = sqlSessionTemplate.selectList(queryId, pMap);
			 if(list.size() > 0){
				 return sqlSessionTemplate.selectList(queryId, pMap);
			 }else{
				 return sqlSessionTemplate.selectList("common.getUnitMeasureInfo", pMap);
			 }
						
		}else{
			return sqlSessionTemplate.selectList(queryId, pMap);			
		}

	}

	public List<Map<String,String>> ajaxQueryIdComboNoCache(Map<String, String> pMap) {
		String queryId =  pMap.get("QUERYID").toString();
		//LOGGER.debug("ajaxQueryIdCombo queryId " +queryId);
		return sqlSessionTemplate.selectList(queryId, pMap);
	}
	
	public String fileUpload(FileUploadForm uploadForm, Map<String,String> pMap) {
		
//			Map<String,String> _map = _pList.get(i);
			//LOGGER.debug("_map_map_map_map " +_map);
		String docNo = "";
		int intfilesize = 0;
		int maxsize = 307200; // 300MB
		boolean maxCheck = false;
		List<String> allowArray = Arrays.asList(new String[] {".csv",".enc",".ncf",".txt",".gif",".png",".jpg",".jpeg",".bmp",".sit",".xls",".doc",".docx",".hwp",".ppt",".pptx",".pdf",".tif",".tiff",".xlsx",".zip",".dwg",".ai",".gul",".mht"});    // 첨부 가능한 확장자
		boolean extCheck = false;	
			try{
				List<MultipartFile> _files = uploadForm.getFiles();
				
				
				LOGGER.debug("typetypetypetypetypetype  {}", pMap.get("TYPE"));
				
				
				pMap.put("TYPE", CommonUtil.onvl(pMap.get("TYPE"), "TEMP"));
				pMap.put("IMG_YN", CommonUtil.onvl(pMap.get("IMG_YN"), "N"));
				pMap.put("DATE_DIR", CommonUtil.onvl(pMap.get("DATE_DIR"), "N"));
				
				String osName = System.getProperty("os.name");
				LOGGER.debug("osName {}",osName);
				String img_yn =  pMap.get("IMG_YN");	
				String type =  pMap.get("TYPE");			
				String date_dir =  pMap.get("DATE_DIR");			
				
				
				LOGGER.debug("img_yn  {}",img_yn);
				LOGGER.debug("type  {}",type);
				LOGGER.debug("date_dir  {}",date_dir);
				String _path = "";
				String _newDir = "";

				// S3 업로드 경로 설정
				if ("Y".equals(date_dir)){ // 하위디렉토리를 만들필요가 있을경우
					_newDir = CommonUtil.formatDate(new Date(),1,"-");
					_path = CommonUtil.getUploadTypePath(type, img_yn)  + "/" +_newDir;
				}else{
					_path = CommonUtil.getUploadTypePath(type, img_yn);
				}

				LOGGER.debug("_path  {}",_path);
				
				File f = new File(_path); 
				if(!f.isDirectory()) {
		            f.mkdirs();
		            LOGGER.debug("폴더생성 {} " ,f);
		        }else{
		        	 LOGGER.debug("폴더이미존재 {} " ,f);
		        }
		
				LOGGER.debug("_path  {}",_path);
				docNo = pMap.get("DOC_NO");
				if(docNo == null || "".equals(docNo)){
					docNo = String.valueOf(System.currentTimeMillis());
					pMap.put("DOC_NO", docNo);
				}
				
				if (null != _files && _files.size() > 0) {
					for (MultipartFile _multipartFile : _files) {
	
						String _fileName = _multipartFile.getOriginalFilename();
						if(_fileName.isEmpty()) continue;
						
						String ext = _fileName.substring(_fileName.lastIndexOf("."), _fileName.length()).toLowerCase(); //확장자 뽑아내기
						
						if(!allowArray.contains(ext)) { //허용 확장자에 포함되어있지 않으면 업로드 불가
							extCheck = true;
							docNo = docNo+ext; //return값에 +확장자
							throw new RuntimeException(ext+"파일은 첨부할 수 없는 파일입니다.");
				        }
						
						String docSeq = sqlSessionTemplate.selectOne("common.getFileUploadSqlNo",pMap);
						
						//리뉴얼때 파일 삭제용으로 쓰기위한 key = docSeq
						if(pMap.get("key")==null){
							pMap.put("key", docSeq);
						}else{
							pMap.put("key", pMap.get("key")+","+docSeq);
						}
						
	//					String _fileName_rnd = UUID.randomUUID().toString() + _fileName;
						String UniqFileName = pMap.get("COM_CODE") +"_"+docNo+docSeq;
						
						String filesize = String.valueOf(_multipartFile.getSize() / 1024);
					    LOGGER.debug("filesize {} " , filesize);
					    intfilesize = Integer.parseInt(filesize);
					    if(type.equals("SR")){
						    if (intfilesize > 512000){
						    	maxCheck = true;
						    	throw new RuntimeException("500MB 파일사이즈 초과하였습니다.");
						    }					    						    	
					    }else{
						    if (intfilesize > maxsize){
						    	maxCheck = true;
						    	throw new RuntimeException("300MB 파일사이즈 초과하였습니다.");
						    }					    	
					    }
						Map<String, String> fileMap = new HashMap<String, String>();
						fileMap.put("DOC_NO", docNo); 
						fileMap.put("DOC_SEQ", docSeq);
						fileMap.put("TYPE", pMap.get("TYPE")); 
						fileMap.put("DES_FILE_NAME",UniqFileName);  
						fileMap.put("SRC_FILE_NAME",_fileName); 
						fileMap.put("FILE_SIZE",filesize); 
						fileMap.put("ADD_USER_ID",pMap.get("USER_ID")); 
						fileMap.put("ADD_USER_NAME",pMap.get("USER_NAME_LOC")); 
						if ("Y".equals(date_dir)){ // 하위디렉토리를 만들필요가 있을경우
							fileMap.put("DES_FILE_DIR",_newDir);  
						}else{
							fileMap.put("DES_FILE_DIR","./");  
						}
						
						LOGGER.debug("fileMap  {}",fileMap);
						if ("".equals(_fileName)) {
							LOGGER.debug("_fileName null ");
						} else {
														
							File _destFile = new File(f+ "/" + UniqFileName);  // 폴더가 이미 존재
							LOGGER.debug("yes folder _destFile {}",_destFile);
							try {
								// AWS S3에 파일 업로드
								CommonAwsS3.upload(_multipartFile, _path+ "/" , UniqFileName);
								LOGGER.debug("yes folder 파일 생성 성공 " );
							} catch (IOException e) {
								// TODO Auto-generated catch block
								LOGGER.debug("yes folder e " +e.toString() );
								throw new RuntimeException();
							}						
							
						} 
						/*
						 * 기존 이미지를 가로,세로길이에 맞게 변경한다.
						 * 예제임니다...추후 사용하세요.
						 * CommonUtil.makeThumbnail
						 */
						//CommonUtil.makeThumbnail(_path + "/" + UniqFileName, _path + "/resize_" + UniqFileName,10,10);
						sqlSessionTemplate.update("common.createIcomatch",fileMap);
	
					}//end of for
				}
			}
			catch(Exception e){
				LOGGER.debug("fileUpload Exception {}",e);
				if(extCheck == true) { //허용되지 않은 확장자
					return docNo;
				}
				if (maxCheck == true){
					throw new RuntimeException("20MB 파일사이즈 초과하였습니다.");
				}else{
					throw new RuntimeException("파일업로드 실패하였습니다.");
				}
			} 
			return docNo;
			
	}
	
	public List<Map<String,String>> getFileUploadList(Map<String,String>  pMap) {
		return sqlSessionTemplate.selectList("common.getIcomatch", pMap);
	}
	
	public void removeFileInfo(Map<String, String> pMap) {
		sqlSessionTemplate.update("common.removeIcomatch",pMap);
	}
	
	public Map<String,String> getFileUploadDetail(Map<String, String> pMap) {
		return sqlSessionTemplate.selectOne("common.getDetailIcomatch", pMap);
	}
	
	public List<Map<String, String>> getFileUploadDetail_v2(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("common.getDetailIcomatch_v2", pMap);
	}
	public List<Map<String, String>> getFileUploadDetailMulti_v2(Map<String, Object> pMap) {
		List<String> list = CommonUtil.getStringArrary((String)pMap.get("DOC_NO"), ",");
		if(list.size() != 0){
			pMap.put("DOC_NO", list);
		}
		return sqlSessionTemplate.selectList("common.getDetailMultiIcomatch_v2", pMap);
	}
	
	@Cacheable(cacheName = "commonCache")
	public List<Map<String,String>> selectFieldNames() {
		return sqlSessionTemplate.selectList("common.selectFieldNames");
	}
	
	//사용자권한조회(도안관리용)
	public Map<String,String> selectUserRole(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.selectUserRole", formData);
	}	
	
	/**
	 * 거래명세서 레포트 ID 조회
	 * @param pMap
	 * @return
	 */
	public String selectRptUrl(Map<String,String> pMap){
		return sqlSessionTemplate.selectOne("common.selectTranStatementRptUrl", pMap);
	}

	public String imageFileUpload(FileUploadForm uploadForm, Map<String,String> pMap) {
		
		String docNo = "";
		int intfilesize = 0;
		int maxsize = 20480; // 20MB
		boolean maxCheck = false;
			try{
				List<MultipartFile> _files = uploadForm.getFiles();
				
				
				LOGGER.debug("typetypetypetypetypetype  {}", pMap.get("TYPE"));
				
				pMap.put("CLS", CommonUtil.onvl(pMap.get("CLS"), "ETC"));
				pMap.put("TYPE", CommonUtil.onvl(pMap.get("TYPE"), "TEMP"));
				pMap.put("IMG_YN", CommonUtil.onvl(pMap.get("IMG_YN"), "N"));
				pMap.put("DATE_DIR", CommonUtil.onvl(pMap.get("DATE_DIR"), "N"));
				pMap.put("INVOICE", CommonUtil.onvl(pMap.get("INVOICE"), "NO_INVOICE"));
				
				String osName = System.getProperty("os.name");
				LOGGER.debug("osName {}",osName);
				String img_yn =  pMap.get("IMG_YN");	
				String type =  pMap.get("TYPE");			
				String date_dir =  pMap.get("DATE_DIR");			
				
				
				LOGGER.debug("img_yn  {}",img_yn);
				LOGGER.debug("type  {}",type);
				LOGGER.debug("date_dir  {}",date_dir);
				String _newDir = CommonUtil.onvl(pMap.get("BUYER"), "NO_BUYER_CODE");
				String _path = CommonUtil.getUploadTypePath(type, img_yn)+"/" +_newDir;
				
				LOGGER.debug("_path  {}",_path);
				LOGGER.debug("_path_real  {}",CommonUtil.getUploadTypePath(type, img_yn)+"/" +_newDir);
				
				File f = new File(_path); 
				if(!f.isDirectory()) {
		            f.mkdirs();
		            LOGGER.debug("폴더생성 {} " ,f);
		        }else{
		        	 LOGGER.debug("폴더이미존재 {} " ,f);
		        }
		
				LOGGER.debug("_path  {}",_path);
				docNo = pMap.get("DOC_NO");
				if(docNo == null || "".equals(docNo)){
					docNo = String.valueOf(System.currentTimeMillis());
					pMap.put("DOC_NO", docNo);
				}
				
				if (null != _files && _files.size() > 0) {
					for (MultipartFile _multipartFile : _files) {
	
						String _fileName = _multipartFile.getOriginalFilename();
						if(_fileName.isEmpty()) continue;
						
						String docSeq = sqlSessionTemplate.selectOne("common.getFileUploadSqlNo",pMap);
						
						String UniqFileName = pMap.get("INVOICE") +"_"+docNo+docSeq;
						
						String filesize = String.valueOf(_multipartFile.getSize() / 1024);
					    LOGGER.debug("filesize {} " , filesize);
					    intfilesize = Integer.parseInt(filesize);
					    if (intfilesize > maxsize){
					    	maxCheck = true;
					    	throw new RuntimeException("20MB 파일사이즈 초과하였습니다.");
					    }
						
						Map<String, String> fileMap = new HashMap<String, String>();
						fileMap.put("DOC_NO", docNo); 
						fileMap.put("DOC_SEQ", docSeq);
						fileMap.put("TYPE", pMap.get("TYPE"));
						if("IV".equals(pMap.get("TYPE"))){
							if("SIGN".equals(pMap.get("CLS"))){
								fileMap.put("DES_FILE_NAME",UniqFileName);	
							}else{
								fileMap.put("DES_FILE_NAME",UniqFileName);		
							}
						}
						fileMap.put("SRC_FILE_NAME",_fileName); 
						fileMap.put("FILE_SIZE",filesize); 
						fileMap.put("ADD_USER_ID",pMap.get("USER_ID")); 
						fileMap.put("ADD_USER_NAME",pMap.get("USER_NAME_LOC")); 
						fileMap.put("DES_FILE_DIR",_newDir);
						LOGGER.debug("_path : "+_path);
						
						LOGGER.debug("fileMap  {}",fileMap);
						/* 리사이징 기능 S3로 인해 주석 처리 2023.01.27 현명환
						MultipartFile multi = null;
						if("IV".equals(pMap.get("TYPE"))){
							if(!"SIGN".equals(pMap.get("CLS"))){//거래명세서 일때
								multi = CommonUtil.makeThumbnail(_multipartFile,750,980); //이미지 리사이징
							}
						}else{
							multi = CommonUtil.makeThumbnail(_multipartFile,750,980); //이미지 리사이징
						}
						*/
						if ("".equals(_fileName)) {
							LOGGER.debug("_fileName null ");
						} else {
														
							File _destFile = new File(f+ "/" + UniqFileName);  // 폴더가 이미 존재						 
							LOGGER.debug("yes folder _destFile {}",_destFile);
							try {
								if("IV".equals(pMap.get("TYPE"))&&"SIGN".equals(pMap.get("CLS"))){//서명일때 리사이징 안함
									CommonAwsS3.upload(_multipartFile, _path+ "/" , UniqFileName);
								}else {//거래명세서 첨부일때 리사이징
									CommonAwsS3.upload(_multipartFile, _path+ "/" , UniqFileName); // multi -> _multipartFile  2023.01.27 현명환
								}
								LOGGER.debug("yes folder 파일 생성 성공 " );
							} catch (IOException e) {
								// TODO Auto-generated catch block
								LOGGER.debug("yes folder e " +e.toString() );
								throw new RuntimeException();
							}						
							
						} 
						/*
						 * 기존 이미지를 가로,세로길이에 맞게 변경한다.
						 * CommonUtil.makeThumbnail
						 */
						sqlSessionTemplate.update("common.createIcomatch",fileMap);
	
					}//end of for
				}
			}
			catch(Exception e){
				LOGGER.debug("fileUpload Exception {}",e);
				if (maxCheck == true){
					throw new RuntimeException("20MB 파일사이즈 초과하였습니다.");
				}else{
					throw new RuntimeException("파일업로드 실패하였습니다.");
				}
			} 
			return docNo;
			
	}
	// VOC 유형별 담당자 ID 조회
	@Override
	public Map<String,String> getVOCUser(Map<String, String> pMap) {
		return sqlSessionTemplate.selectOne("common.getVOCUser", pMap);		
	}


	public Map<String, String> getFileUploadDetailMsds(Map<String, String> pMap) {
		return sqlSessionTemplate.selectOne("common.getDetailIcomatchMsds", pMap);
	}

	/**
	 * ICOMATCH 테이블에서 파일 완전 삭제 (DELETE)
	 * @param pMap - D_DOC_NO, D_DOC_SEQ 포함
	 */
	@Override
	public void removeIcomatch(Map<String, String> pMap) {
		sqlSessionTemplate.delete("common.removeIcomatch", pMap);
	}

	@Override
	public int getFileUploadAtYnCnt(Map<String, String> pMap) {
		int count = 0;
		count = sqlSessionTemplate.selectOne("common.getFileUploadAtYnCnt", pMap);
		return count;
	}

}
