package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCmCmsItemAltCodeSelPopDao")
@Transactional
public class MasterMdCmCmsItemAltCodeSelPopDaoImpl implements MasterMdCmCmsItemAltCodeSelPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 팝업 상단 [기존 상품 정보] 1행
	public Map<String,String> selectBase(Map<String,Object> param) {
		return sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCmsItemAltCodeBase", param);
	}

	// 대체코드 후보 목록 (IBSheet 페이징)
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		// 대량입력·복수선택 팝업이 넘긴 '@' 구분 문자열을 IN 절용 List 로 변환한다(목록 화면과 같은 처리).
		param.put("st_cmscatlg_multi", CommonUtil.getStringArrary((String) param.get("st_cmscatlg_multi"), "@"));
		param.put("st_sg_id_multi",    CommonUtil.getStringArrary((String) param.get("st_sg_id_multi"),    "@"));
		param.put("st_categ_id_multi", CommonUtil.getStringArrary((String) param.get("st_categ_id_multi"), "@"));
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemAltCodeSelPopList", param);
	}

}
