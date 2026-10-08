package com.koreab2b.mro.master.mdcm.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCmCmsBuyInfoMapMoveDao")
@Transactional
public class MasterMdCmCmsBuyInfoMapMoveDaoImpl implements MasterMdCmCmsBuyInfoMapMoveDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCmsBuyInfoMapMoveDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public Map<String,String> selectStdInfo(Map<String,Object> param) {
		return sqlSessionTemplate.selectOne("master.mdcm.mapmove.selectMasterMdCmCmsBuyInfoMapStdInfo", param);
	}

	public List<Map<String,String>> selectCustList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.mapmove.selectMasterMdCmCmsBuyInfoMapCustList", param);
	}

	public List<Map<String,String>> selectStdSelList(Map<String,Object> param) {
		// 카테고리(SG)·상세분류 복수선택 팝업이 넘긴 '@' 구분 문자열을 IN 절용 List 로 변환한다.
		param.put("st_sg_id_multi",    CommonUtil.getStringArrary((String) param.get("st_sg_id_multi"),    "@"));
		param.put("st_categ_id_multi", CommonUtil.getStringArrary((String) param.get("st_categ_id_multi"), "@"));
		return sqlSessionTemplate.selectList("master.mdcm.mapmove.selectMasterMdCmCmsBuyInfoMapStdSelList", param);
	}

	/**
	 * 매핑 이관. 체크한 고객사 계약행마다 매핑 축을 변경 표준DB코드로 옮긴다.
	 *
	 * ★ 고객사지정여부 Y 인데 협력사가 다르면 이관할 수 없다 — 화면이 이미 막지만
	 *   다른 창에서 값이 바뀐 사이를 대비해 행마다 다시 센다. 한 건이라도 걸리면 전부 되돌린다.
	 */
	@SuppressWarnings("unchecked")
	public int moveMapping(Map<String,String> param, List<Object> gridData) {

		if (gridData == null || gridData.isEmpty()) { return 0; }

		int moved = 0;
		try {
			for (int i = 0; i < gridData.size(); i++) {
				Map<String,String> _row = (Map<String,String>) gridData.get(i);
				if (CommonUtil.nvl(_row.get("CONTRACT_NO")).trim().length() == 0) { continue; }

				Map<String,String> _p = new HashMap<String,String>(param);
				_p.putAll(_row);

				Integer _blocked = (Integer) sqlSessionTemplate.selectOne(
					"master.mdcm.mapmove.selectMasterMdCmCmsBuyInfoMapMoveBlockCnt", _p);

				if (_blocked != null && _blocked.intValue() > 0) {
					LOGGER.debug("매핑 이관 불가 - 고객사지정여부 Y, 협력사 불일치 : {} {}",
						_row.get("BUYER_CODE"), _row.get("CONTRACT_NO"));
					throw new RuntimeException("고객사 지정여부가 Y인 항목은 동일한 협력사인 경우만 변경 가능합니다.");
				}

				moved += sqlSessionTemplate.update("master.mdcm.mapmove.updateMasterMdCmCmsBuyInfoMapMove", _p);
			}
		} catch (RuntimeException re) {
			throw re;
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("고객사 매핑 이관에 실패하였습니다.");
		}

		LOGGER.debug("매핑 이관 {} 건 : {} -> {}", new Object[]{
			Integer.valueOf(moved), param.get("st_from_buy_info"), param.get("st_to_buy_info")});
		return moved;
	}

	public List<Map<String,String>> selectMapFormList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.mapmove.selectMasterMdCmCmsBuyInfoMapFormList", param);
	}

	public List<Map<String,String>> selectMapTargetList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.mapmove.selectMasterMdCmCmsBuyInfoMapTargetList", param);
	}
}
