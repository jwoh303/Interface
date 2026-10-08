package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("MasterMpRqBulkQuotationItemListDao")
@Transactional
public class MasterMpRqBulkQuotationItemListDaoImpl implements MasterMpRqBulkQuotationItemListDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationItemListDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		// 벌크견적건 상태 업데이트
		sqlSessionTemplate.update("master.mprq.updateMasterMpRqBulkQuotationRfqStatus", param);
		
		if((param.get("st_project_unit")).equals("B")) {
			return sqlSessionTemplate.selectList("master.mprq.selectItemListBuyer", param);
		}else {
			return sqlSessionTemplate.selectList("master.mprq.selectItemListGroup", param);
		}
	}
	
	// 프로젝트 조회 팝업
	public List<Map<String,String>> selectProject(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mprq.selectprojectList", param);
	}

	// 선택 삭제
	@SuppressWarnings("unchecked")
	public String deleteData(Map<String,Object> param) {
		
		try{
			String[] itemkeyArr = ((String) param.get("st_query")).split("@@");
			for(String itemKey : itemkeyArr) {
				param.put("ITEM_KEY_ID", itemKey);
				
				// step 1 MNG에서 품목 삭제
				int cnt = sqlSessionTemplate.update("master.mprq.delBulkQuotaionItem", param);
				
				if(cnt < 0) {
					_rtnMsg = "품목 삭제에 실패하였습니다. "+param.get("st_burq_no") +"의 "+ itemKey +"를 확인해보세요";
					throw new RuntimeException();
				}
				
				// step 2 rfq에 있는 견적 진행건 삭제
				sqlSessionTemplate.update("master.mprq.delBulkQuotaionItemRFQ", param);
			}
			
		} catch (Exception e){
			if(_rtnMsg == null) {_rtnMsg = "삭제 하던중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.";}
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
}
