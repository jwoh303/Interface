package com.koreab2b.mro.seller.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqCmpySelQuotationSendDaoImpl;

@Repository("sellerMpRqQuotReqDao")
@Transactional
public class SellerMpRqQuotReqDaoImpl implements SellerMpRqQuotReqDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqCmpySelQuotationSendDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mprq.selectSellerMpRqQuotReqList", param);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "견적을 제출하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				String msds_flag = formData.get("MSDS_YN");
				String giveup_flag = formData.get("st_giveup_yn");
				
				if("Y".equals(msds_flag)){
					sqlSessionTemplate.update("seller.mprq.saveSellerMpRqQuotReqMsds", formData);	
				}
				
				if("Y".equals(giveup_flag)){
					_rtnMsg = "정상적으로 견적포기 되었습니다.";
				}
				
				sqlSessionTemplate.update("seller.mprq.saveSellerMpRqQuotReqList", formData);
				
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("SELLER_IMAGE_KEY"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 저장에 실패하였습니다.");
		}
		
		return _rtnMsg;		
	}
}
