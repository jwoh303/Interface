package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;

@Repository("masterMdCmExpMngDao")
@Transactional
public class MasterMdCmExpMngDaoImpl implements MasterMdCmExpMngDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmExpMngDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	private String _rtnMsg = "";
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		resultList =  sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmExpMngList", param);
		
		return resultList;
	}
	/*저장*/
	@SuppressWarnings("unchecked")
	public String saveMasterMdCmExpMng(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "환율반영이 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//환율반영처리
				sqlSessionTemplate.update("master.mdcm.call_PROC_CURRENCY_UPDATE", formData);
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("환율반영에 실패하였습니다.");
		}
		return _rtnMsg;
	}

}
