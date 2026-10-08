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



@Repository("CommonMdCmStndApprovalDao")
@Transactional
public class CommonMdCmStndApprovalDaoImpl implements CommonMdCmStndApprovalDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonMdCmStndApprovalDao.class);
		@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	//상신취소
	public String MdCmStndCancle(Map<String,String> formData){
		
        sqlSessionTemplate.update("commonMdCmStndApproval.updateMdCmStndKEPMGPHD", formData);
        sqlSessionTemplate.update("commonMdCmStndApproval.updateMdCmStndKEPMGPDT", formData);
        sqlSessionTemplate.update("commonMdCmStndApproval.updateMdcmCmsCatlgApprAdd", formData);

		return "OK";
	}
	//결재
	public String MdCmStndApprovalA(Map<String,String> formData){
        sqlSessionTemplate.update("commonMdCmStndApproval.updateMdCmStndKEPMGPHD", formData);
        sqlSessionTemplate.update("commonMdCmStndApproval.updateMdCmStndKEPMGPDT", formData);
        sqlSessionTemplate.update("commonMdCmStndApproval.updateMdcmCmsCatlgApprAdd", formData);
        List<Map<String,String>> list = null;
        list = sqlSessionTemplate.selectList("commonMdCmStndApproval.selectMdCmStndKEPMGPHDREGINFO", formData);
	    if(list.size() > 0){
			for(int z=0; z<list.size(); z++){
				Map<String,String> mp = (Map<String,String>)list.get(z);
				formData.put("REG_USER_ID", mp.get("REG_USER_ID"));
			}
	    }
        //카탈로그 생성.
        sqlSessionTemplate.update("commonMdCmStndApproval.insertMdcmCmsCatlgApprAdd", formData);
        //CMSCATLG_ADD CMSCATLG_ID 업데이트.
        sqlSessionTemplate.update("commonMdCmStndApproval.updateMdcmCmsCatlgIdAdd", formData);
        
        
		return "OK";
	}
	//반려
	public String MdCmStndApprovalB(Map<String,String> formData){
        sqlSessionTemplate.update("commonMdCmStndApproval.updateMdCmStndKEPMGPHD", formData);
        sqlSessionTemplate.update("commonMdCmStndApproval.updateMdCmStndKEPMGPDT", formData);
        sqlSessionTemplate.update("commonMdCmStndApproval.updateMdcmCmsCatlgApprAdd", formData);
		return "OK";
	}


}
