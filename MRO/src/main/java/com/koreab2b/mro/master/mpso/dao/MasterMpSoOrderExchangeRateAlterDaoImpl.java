package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpSoOrderExchangeRateAlterDao")
@Transactional
public class MasterMpSoOrderExchangeRateAlterDaoImpl implements MasterMpSoOrderExchangeRateAlterDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoOrderExchangeRateAlterDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트조회 ( 일괄)
	public List<Map<String,String>> getMasterMpSoOrderExchangeRateList(Map<String,Object>  param) {
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoOrderExchangeRateList", param);
	}

	// 저장  ( 일괄)
	public String saveMasterMpSoOrderExchangeRateList(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		String USER_ID = CommonUtil.nvl(formData.get("USER_ID"),"");
		String PO_NO = "";
		String PO_SEQ = "";
		String UNIT_PRICE = "";
		String EXP_CUR = "";
		String EXP_CUR_PRICE = ""; 
		String EXP_GR_NO = "";		
		String EXP_DATE_OF_SHIPMENT = "";
		int userEquals = 0;

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				// STEP1
				formData.put("USER_ID", USER_ID); 			
				PO_NO = CommonUtil.nvl(formData.get("PO_NO"),"");
				PO_SEQ = CommonUtil.nvl(formData.get("PO_SEQ"),"");
				UNIT_PRICE = CommonUtil.nvl(formData.get("UNIT_PRICE"),"");
				EXP_CUR = CommonUtil.nvl(formData.get("EXP_CUR"),"");
				EXP_CUR_PRICE = CommonUtil.nvl(formData.get("EXP_CUR_PRICE"),"");
				EXP_GR_NO = CommonUtil.nvl(formData.get("EXP_GR_NO"),"");
				EXP_DATE_OF_SHIPMENT = CommonUtil.nvl(formData.get("EXP_DATE_OF_SHIPMENT"),"");
				if ("".equals(PO_NO)
						|| "".equals(PO_SEQ)
						|| "".equals(UNIT_PRICE)
						|| "".equals(EXP_CUR)
						|| "".equals(EXP_CUR_PRICE)
						|| "".equals(EXP_GR_NO)
						|| "".equals(EXP_DATE_OF_SHIPMENT) 
						|| "".equals(USER_ID) 
					){
					userEquals = 1;
					throw new RuntimeException();
				} 
				sqlSessionTemplate.update("master.mpso.deleteMasterMpSoOrderExchangeRateTmp", formData);				
				sqlSessionTemplate.update("master.mpso.insertMasterMpSoOrderExchangeRateTmp", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if (userEquals == 1){
				throw new RuntimeException("정확한 정보를 엑셀 업로드하세요.");
			} else{
				throw new RuntimeException("엑셀 저장에 실패하였습니다.");
			}
		}
		return _rtnMsg;
	}
	
	// 삭제 ( 일괄)
	public String delMasterMpSoOrderExchangeRateList(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "삭제완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				// STEP1
				sqlSessionTemplate.update("master.mpso.deleteMasterMpSoOrderExchangeRateTmp", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("삭제에 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
