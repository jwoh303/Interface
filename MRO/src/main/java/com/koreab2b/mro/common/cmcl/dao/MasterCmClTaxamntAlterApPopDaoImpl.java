package com.koreab2b.mro.common.cmcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClSalesTaxsheetIssueRegDaoImpl;

@Repository("masterCmClTaxamntAlterApPopDao")
@Transactional
public class MasterCmClTaxamntAlterApPopDaoImpl implements MasterCmClTaxamntAlterApPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesTaxsheetIssueRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.cmcl.selectMasterCmClTaxamntAlterApPopList", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "세액 변경이 정상적으로 이루어 졌습니다.";
		
		try {
			List<Map<String,String>> list = null;
			
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// 외상매입_세금계산서 update
				sqlSessionTemplate.update("common.cmcl.updateMasterCmClTaxamntAlterApPopList_KEPTARDT", formData);
			}
			// TOT_SUPP_PRICE,TOT_TAX_PRICE,TOT_AMT 계산
			list = sqlSessionTemplate.selectList("common.cmcl.selectMasterCmClTaxamntAlterApPopChkList", formData);

			for ( int i=0; i < list.size(); i++ ) {
				formData.putAll((Map<String, String>)list.get(i));
			}
									
			formData.put("tot_amt", String.valueOf(formData.get("TOT_AMT")));
			formData.put("tot_tax_price", String.valueOf(formData.get("TOT_TAX_PRICE")));
			formData.put("tot_supp_price", String.valueOf(formData.get("TOT_SUPP_PRICE")));
			
			// 외상매입_세금계산서 update
			sqlSessionTemplate.update("common.cmcl.updateMasterCmClTaxamntAlterApPopList_KEPTARDT2", formData);
			
			sqlSessionTemplate.update("common.cmcl.updateMasterCmClTaxamntAlterApPopList_KEPTITEM", formData);
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 세액 변경 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
}
