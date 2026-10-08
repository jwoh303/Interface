package com.koreab2b.mro.common.coco.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository("boardDao")
@Transactional
public class BoardDaoImpl implements BoardDao {
	private static final Logger logger = LoggerFactory.getLogger(BoardDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate; 
 
	public List<Map<String,String>> boardList(Map<String,String>  pMap) {
		return sqlSessionTemplate.selectList("board.boardList", pMap);
	}
	
	@Transactional
	public void boardWrite(Map<String,String>  pMap) {		
		sqlSessionTemplate.insert("board.boardWrite", pMap);
		
		if(!"".equals(pMap.get("st_open_company_code"))){		
			String[] _companyList = pMap.get("st_open_company_code").split("\\@");
			
			for (int j=0; j < _companyList.length; j++) {
				pMap.put("COM_CODE",  _companyList[j]);
				sqlSessionTemplate.insert("board.insertICOMBDDT", pMap);
			}
		}
		
		/** 파일업로드 테이블 Y 로 변경*/
        //첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경)  
        Map<String,String> _fildData = new HashMap<String,String>() ; 
        _fildData.put("DOC_NO", pMap.get("IMAGE_KEY"));
        sqlSessionTemplate.update("common.fileUploadFlagUpdate", _fildData);
	}
	
	public Map<String, String> boardDetail(Map<String,String>  pMap) {
		return sqlSessionTemplate.selectOne("board.boardDetail",pMap);
	}
	
	public void boardUpdate(Map<String,String>  pMap){		 
		sqlSessionTemplate.update("board.boardUpdate", pMap);
		
		/** 파일업로드 테이블 Y 로 변경*/
        //첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경)  
        Map<String,String> _fildData = new HashMap<String,String>() ; 
        _fildData.put("DOC_NO", pMap.get("IMAGE_KEY"));
        sqlSessionTemplate.update("common.fileUploadFlagUpdate", _fildData);
	}
	
	public void boardDelete(Map<String,String>  pMap) { 
		sqlSessionTemplate.update("board.boardDelete", pMap);
		sqlSessionTemplate.update("board.deleteICOMBDDT", pMap);
	}
	
	public List<Map<String,String>> codeMasterList(Map<String,String>  pMap) {
		return sqlSessionTemplate.selectList("board.codeMasterList",pMap);
	}
	
	@Transactional
	@SuppressWarnings("unchecked")
	public void codeMasterProcess(List<Object>pList,Map<String,String>  pMap) {
		for (int i=0; i<pList.size(); i++){
			Map<String,String>_valueMap = (Map<String, String>) pList.get(i);
			if (i==0){
				// 삭제
				sqlSessionTemplate.update("board.deleteAllIcomcod1", pMap);
			}
			// 등록시작
			sqlSessionTemplate.update("board.insertComcod1", _valueMap);
		}
	}
	
	public List<Map<String,String>> getMasterMdAmSelectCompanyPop(Map<String,String>  pMap) {
		return sqlSessionTemplate.selectList("board.getMasterMdAmSelectCompanyPop", pMap);
	}
	
	public String boardConfirm(Map<String,String> pMap) {

		String _rtnMsg = "";

		try{
			if("NO".equals(pMap.get("st_open_type"))){
				_rtnMsg = "정상적으로 승인취소 되었습니다.";
			}else{
				_rtnMsg = "정상적으로 승인 되었습니다.";
			}
			
			sqlSessionTemplate.update("board.boardConfirm",pMap);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("오류가 발생하였습니다. \n\n담당자에게 연락바랍니다.");
		}
		return _rtnMsg;
		
	}

}
