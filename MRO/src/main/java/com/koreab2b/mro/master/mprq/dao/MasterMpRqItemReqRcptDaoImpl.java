package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpRqItemReqRcptDao")
@Transactional
public class MasterMpRqItemReqRcptDaoImpl implements MasterMpRqItemReqRcptDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqReqNegoReceiptDaoImpl.class);
	private String _rtnMsg = "";

	public List<Map<String,String>> selectList(Map<String,Object> pMasterMpRqItemReqRcpt) {
		return sqlSessionTemplate.selectList("master.mp.rq.selectMasterMpRqItemReqRcptList", pMasterMpRqItemReqRcpt);
	}

	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "삭제하였습니다.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.delete("master.mp.rq.updateMasterMpRqItemReqRcpt", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException( "삭제에 실패하였습니다.");
		}
		return _rtnMsg;
		
//		return sqlSessionTemplate.delete("master.mp.rq.updateMasterMpRqItemReqRcpt", pMasterMpRqItemReqRcpt);
	}
	
	public List<Map<String,String>> selectListBoard(Map<String,Object> pMasterMpRqItemReqRcpt) {
		return sqlSessionTemplate.selectList("master.mp.rq.selectMasterMpRqItemReqRcptBoardList", pMasterMpRqItemReqRcpt);
	}

	@SuppressWarnings("unchecked")
	public String updateSelectedDataBoard(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "삭제하였습니다.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.delete("master.mp.rq.updateMasterMpRqItemReqRcptBoard", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException( "삭제에 실패하였습니다.");
		}
		return _rtnMsg;
		
//		return sqlSessionTemplate.delete("master.mp.rq.updateMasterMpRqItemReqRcpt", pMasterMpRqItemReqRcpt);
	}

}
