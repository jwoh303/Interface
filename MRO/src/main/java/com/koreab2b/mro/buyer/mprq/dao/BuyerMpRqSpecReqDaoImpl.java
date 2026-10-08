package com.koreab2b.mro.buyer.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.DateTimeUtil;


@Repository("BuyerMpRqSpecReqDao")
@Transactional
public class BuyerMpRqSpecReqDaoImpl implements BuyerMpRqSpecReqDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
 
	/*규격의뢰*/
	@SuppressWarnings("unchecked")
	public String updateData(List<Object> gridData, Map<String, String> formData) {
		
		String _rtnMsg = "규격의뢰가 성공적으로 이루어 졌습니다.";
		try{
			String today = DateTimeUtil.getShortDateString();
			formData.put("today", today);
			Integer rav_no = sqlSessionTemplate.selectOne("buyer.mp.rq.selectRaNo", formData);
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				rav_no = (rav_no==null)?0 : ++rav_no;
				formData.put("rav_no", CommonUtil.addZero(rav_no.toString()));
				sqlSessionTemplate.update("buyer.mp.rq.insertBuyerMpRqSpecReq", formData);
				

				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			}
		}catch(Exception e){
				throw new RuntimeException("규격의뢰에 실패하였습니다.");
		}
		return _rtnMsg;
	} 

	
}
