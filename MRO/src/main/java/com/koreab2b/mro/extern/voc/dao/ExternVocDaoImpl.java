package com.koreab2b.mro.extern.voc.dao;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("externVocDao")
@Transactional
public class ExternVocDaoImpl implements ExternVocDao {
	private static final Logger logger = LoggerFactory.getLogger(ExternVocDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<Map<String, String>> selectDomainKeywordList() {
		return sqlSessionTemplate.selectList("extern.voc.selectDomainKeywordList");
	}

	@Override
	public String insertExternVoc(Map<String, String> pMap) {
		String _rtnMsg = "OK";
		try {
			String vc_no = getOrderNo("KRKORE0001","VC");
			pMap.put("vc_no", vc_no);
			pMap.put("st_buyer", "KRSAMS0123");
			sqlSessionTemplate.update("extern.voc.insertExternVoc", pMap);
		} catch (Exception e) {
			_rtnMsg = "Err";
		}
		
		return _rtnMsg;
	}

	@Override
	public List<Map<String, String>> selectExternVocList(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("extern.voc.selectExternVocList", pMap);
	}
	
	//채번
	private String getOrderNo(String cmpyId, String docType) throws Exception{
		String returnValue = null;
		Map<String, String>  pMap = new HashMap<String, String>();
		
		pMap.put("COM_CODE", cmpyId);
		pMap.put("DOC_TYPE", docType);
		try {
			returnValue = sqlSessionTemplate.selectOne("common.getDocuNo", pMap);
			logger.debug("채번 - returnValue : ", returnValue);
			
			if (returnValue == null || "".equals(returnValue) ||  returnValue.isEmpty()){
				sqlSessionTemplate.insert("common.insertDocuNo", pMap);
				
				String year = "0" + Calendar.getInstance().get(Calendar.YEAR );
				returnValue = docType +year.substring(3,5) + "000001";
				
			} else {
				sqlSessionTemplate.update("common.updateDocuNo", pMap);
			}
			logger.debug("채번 - returnValue : ", returnValue);
			
		} catch (Exception e){
			logger.debug("채번 Exception : ", e);
			throw new RuntimeException( "채번 취득에 실패하였습니다.");
		} finally {
			
		}
		return returnValue;
	}

	@Override
	public int selectExternVocCount(Map<String, String> pMap) {
		return (Integer)sqlSessionTemplate.selectOne("extern.voc.selectExternVocCount", pMap);
	}
}
