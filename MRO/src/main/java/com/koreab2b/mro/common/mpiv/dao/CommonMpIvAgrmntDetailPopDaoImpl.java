package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("commonMpIvAgrmntDetailPopDao")
@Transactional
public class CommonMpIvAgrmntDetailPopDaoImpl implements CommonMpIvAgrmntDetailPopDao {
	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvAgrmntDetailPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.selectCommonMpIvAgrmntDetailPopList", formData);
	}
	
	public String selectMailYn(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mpiv.selectCommonMpIvAgrmntDetailPopMailYn", formData);
	}	
	
	public String insertCommonCoCoScmActionDetailPop(Map<String,String> formData) {
		String _rtnMsg = "";
		String _mailSend = "";
		try{
			formData.put("st_reason_remark", CommonUtil.nvl(formData.get("st_reason_remark")));
			
			_mailSend = CommonUtil.nvl(formData.get("st_mail_chk"));
			
			sqlSessionTemplate.update("common.mpiv.insertCommonMpIvAgrmntDetailPop", formData);
			
			sqlSessionTemplate.update("common.mpiv.updateCommonMpIvAgrmntPors", formData);
			
			if(_mailSend.equals("Y")){
				sqlSessionTemplate.update("common.mpiv.insertCommonMpIvAgrmntMailSend", formData);
			}
			
			
		}catch(Exception e){
			logger.debug("Exception : ", e);
			throw new RuntimeException("합의내역 저장이 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
		}
		
		return _rtnMsg;
	}	
	
}
