/**
 * 
 */
package com.koreab2b.mro.webservice.hanssem.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author jiwon
 *
 */
@Repository("hanssemDao")
@Transactional
public class HanssemDaoImpl implements HanssemDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(HanssemDaoImpl.class);//
	
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;	
	private String _rtnMsg = "";	

	@Override
	public List<Map<String, String>> selectUserId(String userId) {
		return sqlSessionTemplate.selectList("webservice.hanssem.selectUserId", userId);
	}
	
	@Override
	public String mergeHanssemBdgtTrxl(Map<String, Object> param) throws Exception {		
		 
		String _rtnMsg = null;
		
		try{
			sqlSessionTemplate.update("webservice.hanssem.mergeHanssemBdgtTrxl", param);
			LOGGER.info("####### HanssemDaoImpl 예산 이벤트 데이터 저장완료 : ");
			
		}catch(Exception e){
			_rtnMsg = "예산 이벤트 추가에 실패하였습니다.";
			throw new Exception(e);
		}finally {
			return _rtnMsg;
		}		
	}	

}
