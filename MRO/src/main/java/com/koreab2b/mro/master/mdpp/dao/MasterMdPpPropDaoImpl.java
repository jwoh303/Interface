package com.koreab2b.mro.master.mdpp.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;

@Repository("masterMdPpPropDao")
@Transactional
public class MasterMdPpPropDaoImpl implements MasterMdPpPropDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdPpPropDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	
	private String _rtnMsg = "";

	// 저장
	public String updateSelectedData(Map<String,String>  formData) {
		
		_rtnMsg = "OK";
		String pp_no = "";
		
		try{
			if(formData.get("PP_NO") ==null || "".equals(formData.get("PP_NO"))){
				pp_no = buyerMpSoOrderInfoDao.getOrderNo(formData.get("st_com_code"), "PP");
				formData.put("PP_NO", pp_no);
			}

			sqlSessionTemplate.update("master.mdpp.insertMasterMdPpPropHdReg", formData);
			sqlSessionTemplate.update("master.mdpp.insertMasterMdPpPropDtReg", formData);
			
			//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
			formData.put("DOC_NO", formData.get("st_image_key"));
			sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			
		} catch (Exception e){
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("제안요청이 실패 하였습니다.");
		}
		return _rtnMsg;
	}
}
