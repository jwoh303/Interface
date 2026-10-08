package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqCmpySelQuotationSendDaoImpl;

@Repository("masterMpSoStockApplyPopDao")
@Transactional
public class MasterMpSoStockApplyPopDaoImpl implements MasterMpSoStockApplyPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpRqCmpySelQuotationSendDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectMasterMpSoStockApplyPopList", formData);
	}
	// 조회(상세)
	public List<Map<String,String>> selectListDetail(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectMasterMpSoStockApplyPopListDetail", formData);
	}
	
	
	// 저장
	@SuppressWarnings("unchecked")
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData){
		_rtnMsg = "정상적으로 반영 되었습니다.";
		String prmNo = "";
		Integer PrmSeq = 1;
		
		try{
			prmNo = masterMpRqBuyerReqDao.nextVal("KRKORE0001", "PRM"); // 지급이슈 채번 PRM
			formData.put("PAY_REG_NO", prmNo);
			formData.put("PAY_REG_SEQ", PrmSeq.toString());
			
			sqlSessionTemplate.update("common.mpso.insertMasterMpSoStockApplyToPayRegMngList", formData);
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("common.mpso.insertMasterMpSoStockApplyPop", formData);
				
				String option_type = formData.get("st_option_type");
				if("TYPE_A".equals(option_type)){
					sqlSessionTemplate.update("common.mpso.updateMasterMpSoStockApplyPop", formData);
				}
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("실패하였습니다. 기술연구소로 연락 바랍니다.");
		}
		return _rtnMsg;
		
	}	
}
