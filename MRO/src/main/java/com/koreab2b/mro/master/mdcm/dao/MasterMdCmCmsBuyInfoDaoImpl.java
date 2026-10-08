package com.koreab2b.mro.master.mdcm.dao;

import java.util.ArrayList;
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


@Repository("masterMdCmCmsBuyInfoDao")
@Transactional
public class MasterMdCmCmsBuyInfoDaoImpl implements MasterMdCmCmsBuyInfoDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCmsBuyInfoDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Autowired
	private com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;

	// 목록 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		// 대량입력 팝업이 넘긴 '@' 구분 문자열을 IN 절용 List 로 변환한다.
		param.put("st_catlg_id_multi", CommonUtil.getStringArrary((String) param.get("st_catlg_id_multi"), "@"));
		// 카테고리(SG)·상세분류 복수선택 팝업이 넘긴 '@' 구분 문자열을 IN 절용 List 로 변환한다.
		param.put("st_sg_id_multi",    CommonUtil.getStringArrary((String) param.get("st_sg_id_multi"),    "@"));
		param.put("st_categ_id_multi", CommonUtil.getStringArrary((String) param.get("st_categ_id_multi"), "@"));
		// 협력사도 복수선택 팝업이 같은 '@' 규약으로 넘긴다.
		param.put("st_agent_code",    CommonUtil.getStringArrary((String) param.get("st_agent_code"),    "@"));
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsBuyInfoList", param);
	}

	// 상세 단건 조회 (TCODE 키)
	public Map<String,String> selectDetail(Map<String,Object> param) {
		return sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCmsBuyInfoDetail", param);
	}

	// 구매정보 변경이력 목록 조회
	public List<Map<String,String>> selectHistoryList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsBuyInfoHistoryList", param);
	}

	// 상세 팝업 고객사 매핑정보 목록
	public List<Map<String,String>> selectDetailMapList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsBuyInfoDetailMapList", param);
	}

	// 상세 팝업 규격 상세 속성 목록 (상품정보 상세팝업과 같은 statement 를 쓴다)
	public List<Map<String,String>> selectDetailAttrList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemDetailAttrList", param);
	}

	/**
	 * 구매정보 상세 [변경] 반영.
	 *   매입단가 인상  -> CMSPRICE 에 쓰지 않고 KEPMGPHD/KEPMGPDT 신청(SP)만 만든다. 반영은 결재 승인 시.
	 *   그 밖의 항목   -> 즉시 반영. 이력은 UPDATE 의 SET 절에 끼운 F_HST_CMSPRICE 가 남긴다.
	 * ★ 매입단가는 인상이 결재다. 기준가(BP)와 반대 방향이다. 인상 여부는 DB 현재값으로 가른다.
	 */
	@SuppressWarnings("unchecked")
	public String saveBuyInfoChange(Map<String,String> param, List<Object> gridData) {

		Map<String,String> _upRow = null;

		try {
			for (int i = 0; gridData != null && i < gridData.size(); i++) {
				Map<String,String> _row = (Map<String,String>) gridData.get(i);
				String _key = CommonUtil.nvl(_row.get("CHG_KEY")).trim();

				if (_key.length() == 0) { continue; }

				Map<String,String> _p = new HashMap<String,String>(param);
				_p.putAll(_row);
				int _cnt = sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsBuyInfoChangeItem", _p);
				if (_cnt == 0 && "BUY_PRICE".equals(_key)) { _upRow = _row; }
			}
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("구매정보 변경 반영에 실패하였습니다.");
		}

		if (_upRow == null) { return ""; }

		List<Object> _one = new ArrayList<Object>();
		Map<String,String> _row = new HashMap<String,String>();
		_row.put("BUY_INFO_ID",  CommonUtil.nvl(param.get("st_buy_info")));
		_row.put("AGENT",        CommonUtil.nvl(param.get("st_agent")));
		_row.put("PRICE_AFTER",  CommonUtil.nvl(_upRow.get("CHG_VALUE")));
		_row.put("PRICE_REASON", CommonUtil.nvl(_upRow.get("CHG_REASON")));
		_one.add(_row);

		Map<String,String> _hd = new HashMap<String,String>(param);
		_hd.put("st_gubun",   "SP");
		_hd.put("st_subject", "매입단가 인상 품의 - " + CommonUtil.nvl(param.get("st_buy_info")));

		return requestBuyPriceUpBulk(_hd, _one);
	}

	/**
	 * 매입단가 인상 품의 신청 생성. 단건(SP)·일괄(SPM) 공용이며 디테일 행 수만 다르다.
	 * 채번이 실패하면 신청을 만들지 않고 앞 단계까지 되돌린다.
	 */
	@SuppressWarnings("unchecked")
	public String requestBuyPriceUpBulk(Map<String,String> param, List<Object> gridData) {

		if (gridData == null || gridData.isEmpty()) { return ""; }

		String pm_no = "";
		try {
			pm_no = buyerMpSoOrderInfoDao.getOrderNo(param.get("st_com_code"), "PM");
		} catch (Exception e) {
			LOGGER.error("매입단가 인상 상신 - PM 채번 실패", e);
			throw new RuntimeException("품의번호 채번에 실패하였습니다.");
		}

		Map<String,String> _hd = new HashMap<String,String>(param);
		_hd.put("st_pm_no", pm_no);
		if (CommonUtil.nvl(_hd.get("st_gubun")).length() == 0) { _hd.put("st_gubun", "SPM"); }
		if (CommonUtil.nvl(_hd.get("st_subject")).length() == 0) {
			_hd.put("st_subject", "매입단가 인상 품의 - " + gridData.size() + "건");
		}
		_hd.put("st_remark", CommonUtil.nvl(_hd.get("st_remark")));
		sqlSessionTemplate.update("master.mdcm.insertMasterMdCmCmsBuyInfoPriceReqHd", _hd);

		for (int i = 0; i < gridData.size(); i++) {
			Map<String,String> _dt = new HashMap<String,String>(param);
			_dt.putAll((Map<String,String>) gridData.get(i));
			_dt.put("st_pm_no",  pm_no);
			_dt.put("st_pm_seq", String.format("%06d", i + 1));
			sqlSessionTemplate.update("master.mdcm.insertMasterMdCmCmsBuyInfoPriceReqDt", _dt);
		}

		LOGGER.debug("매입단가 인상 상신 PM_NO : {} / {} 건", pm_no, gridData.size());
		return pm_no;
	}

}
