package com.koreab2b.mro.buyer.mpds.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("buyerMpDsOrderManageDao")
@Transactional
public class BuyerMpDsOrderManageDaoImpl implements BuyerMpDsOrderManageDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMpDsOrderManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpds.selectBuyerMpDsOrderManageList", formData);
	}
	
	
	//부분입고	
	@SuppressWarnings("unchecked")
	public String updateSelectedDataGrNextMonth(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "정상처리 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				String st_ds_qty =  CommonUtil.nvl(formData.get("st_ds_qty") ,"0");
				String st_gr_qty =  CommonUtil.nvl(formData.get("st_gr_qty") ,"0");
				
				int st_next_po_qty =  Integer.valueOf(st_ds_qty).intValue() - Integer.valueOf(st_gr_qty).intValue();
				String st_user_id =  formData.get("st_user_id");
				String reason_remark = "이월 : "+st_next_po_qty+" ("+st_user_id+")";
				
				formData.put("st_next_po_qty", String.valueOf(st_next_po_qty));
				formData.put("st_reason_remark", reason_remark);
				sqlSessionTemplate.insert("buyer.mpds.updateSelectedDataGrNextMonth_1", formData);
				sqlSessionTemplate.insert("buyer.mpds.updateSelectedDataGrNextMonth_2", formData);
				sqlSessionTemplate.insert("buyer.mpds.updateSelectedDataGrNextMonth_3", formData);
					
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("부분입고에 실패하였습니다.");
		}
	return _rtnMsg;
		
	}	
	// 입고취소
	@SuppressWarnings("unchecked")
	public String updateSelectedDataGrCancelReg(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "입고취소 완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
	
					sqlSessionTemplate.insert("buyer.mpds.updateSelectedDataGrCancelReg_1", formData);
					sqlSessionTemplate.insert("buyer.mpds.updateSelectedDataGrCancelReg_2", formData);
					
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("입고취소에 실패하였습니다.");
		}
		
	return _rtnMsg;
		
	}	
	// 입고실적등록
	@SuppressWarnings("unchecked")
	public String updateSelectedDataGrRegBuyer(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "입고실적등록 완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
	
				sqlSessionTemplate.insert("buyer.mpds.updateSelectedDataGrRegBuyer_1", formData);
				sqlSessionTemplate.insert("buyer.mpds.updateSelectedDataGrRegBuyer_2", formData);
					
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("입고실적등록에 실패하였습니다.");
		}
	return _rtnMsg;
		
	}	
	
}
