package com.koreab2b.mro.master.mdcm.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;


@Repository("masterMdCmCmsItemDao")
@Transactional
public class MasterMdCmCmsItemDaoImpl implements MasterMdCmCmsItemDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCmsItemDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// PM 번호 채번(SQMT)만 빌려 쓴다
	@Autowired
	private com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;

	// 목록 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		// 대량입력 팝업이 넘긴 '@' 구분 문자열을 IN 절용 List 로 변환한다.
		param.put("st_cmscatlg_multi", CommonUtil.getStringArrary((String) param.get("st_cmscatlg_multi"), "@"));
		param.put("st_chem_no_multi",  CommonUtil.getStringArrary((String) param.get("st_chem_no_multi"),  "@"));
		// 카테고리(SG)·상세분류 복수선택 팝업이 넘긴 '@' 구분 문자열도 같은 방식으로 변환한다.
		param.put("st_sg_id_multi",    CommonUtil.getStringArrary((String) param.get("st_sg_id_multi"),    "@"));
		param.put("st_categ_id_multi", CommonUtil.getStringArrary((String) param.get("st_categ_id_multi"), "@"));
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemList", param);
	}

	// 상세 단건 조회
	public Map<String,String> selectDetail(Map<String,Object> param) {
		return sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCmsItemDetail", param);
	}

	// 상세 - 규격 상세 속성 목록 조회
	public List<Map<String,String>> selectDetailAttrList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemDetailAttrList", param);
	}

	// 상세 - 구매정보 리스트 조회
	public List<Map<String,String>> selectDetailBuyInfoList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemDetailBuyInfoList", param);
	}

	// 변경이력 목록 조회
	public List<Map<String,String>> selectHistoryList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemHistoryList", param);
	}

	// 기준가 변경이력 목록 조회
	public List<Map<String,String>> selectBasePriceHistoryList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemBasePriceHistoryList", param);
	}

	// 기준가 변경 팝업 [기존] 기준가/유형 + 결재화면에 찍을 상품기본정보
	public Map<String,String> selectBasePriceInfo(Map<String,Object> param) {
		return sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCmsItemBasePriceInfo", param);
	}

	/**
	 * 기준가 즉시 반영. 인하면 반영하지 않고 0 을 돌려준다(WHERE 가 거른다).
	 * 이력은 UPDATE 의 SET 절에 끼운 F_HST_CMSCATLG 가 남긴다.
	 */
	public int applyBasePrice(Map<String,String> param) {
		return sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsItemBasePriceApply", param);
	}

	/**
	 * 기준가 인하 = 결재 대상이므로 CMSCATLG 에 쓰지 않고 신청(KEPMGPHD/KEPMGPDT)만 만든다.
	 * 실제 반영은 결재 승인 시 CommonMdCmBasePriceApprovalDao 가 한다.
	 */
	public String requestBasePriceDown(Map<String,String> param) {

		// PM 번호 채번 (SQMT 공통 채번. 다른 화면도 같은 방식으로 'PM' 을 쓴다)
		// getOrderNo 가 throws Exception 이라 여기서 감싼다. 채번 실패 시 신청을 만들지 않는다.
		String pm_no = "";
		try {
			pm_no = buyerMpSoOrderInfoDao.getOrderNo(param.get("st_com_code"), "PM");
		} catch (Exception e) {
			LOGGER.error("기준가 인하 상신 - PM 채번 실패", e);
			throw new RuntimeException("품의번호 채번에 실패하였습니다.");
		}

		param.put("st_pm_no",  pm_no);
		param.put("st_pm_seq", "000001");   // 단건. 일괄(BPM)은 호출부가 행마다 증가시킨다

		sqlSessionTemplate.update("master.mdcm.insertMasterMdCmCmsItemBasePriceReqHd", param);
		sqlSessionTemplate.update("master.mdcm.insertMasterMdCmCmsItemBasePriceReqDt", param);

		LOGGER.debug("기준가 인하 상신 신청 생성 PM_NO : {}", pm_no);
		return pm_no;
	}

	/**
	 * 기준가 일괄 반영. 화면이 정상 건만 걸러 보내고, 여기서 인상/인하로 다시 가른다.
	 *   인상·기준가유형 단독 변경 -> CMSCATLG 즉시 UPDATE
	 *   인하                      -> KEPMGPHD 1건 + KEPMGPDT N건(PM_SEQ 증가), 반영은 결재 승인 시
	 * 채번이 실패하면 앞서 반영한 인상 건까지 되돌린다(한 번의 [확인]이 반쯤 반영되면 안 된다).
	 */
	@SuppressWarnings("unchecked")
	public String saveBasePriceBulk(Map<String,String> param, List<Object> gridData) {

		List<Map<String,String>> _downList = new ArrayList<Map<String,String>>();

		try {
			for (int i = 0; i < gridData.size(); i++) {
				Map<String,String> _row = (Map<String,String>) gridData.get(i);

				Map<String,String> _p = new HashMap<String,String>(param);
				_p.putAll(_row);
				if (sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsItemBasePriceApplyBulk", _p) == 0) {
					_downList.add(_row);
				}
			}
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("기준가 반영에 실패하였습니다.");
		}

		if (_downList.isEmpty()) {
			return "";
		}

		String pm_no = "";
		try {
			pm_no = buyerMpSoOrderInfoDao.getOrderNo(param.get("st_com_code"), "PM");
		} catch (Exception e) {
			LOGGER.error("기준가 인하 일괄 상신 - PM 채번 실패", e);
			throw new RuntimeException("품의번호 채번에 실패하였습니다.");
		}

		Map<String,String> _hd = new HashMap<String,String>(param);
		_hd.put("st_pm_no",   pm_no);
		_hd.put("st_gubun",   "BPM");
		_hd.put("st_subject", "기준가 인하 품의 - " + _downList.size() + "건");
		_hd.put("st_remark",  "");
		sqlSessionTemplate.update("master.mdcm.insertMasterMdCmCmsItemBasePriceReqHd", _hd);

		for (int i = 0; i < _downList.size(); i++) {
			Map<String,String> _dt = new HashMap<String,String>(param);
			_dt.putAll(_downList.get(i));
			_dt.put("st_pm_no",  pm_no);
			_dt.put("st_pm_seq", String.format("%06d", i + 1));
			sqlSessionTemplate.update("master.mdcm.insertMasterMdCmCmsItemBasePriceReqDtBulk", _dt);
		}

		LOGGER.debug("기준가 인하 일괄 상신 PM_NO : {} / {} 건", pm_no, _downList.size());
		return pm_no;
	}

	// MSDS 매핑(등록·변경) - 그리드에서 체크된 행 단위로 CMSCATLG.MSDS_NO 를 갱신한다
	public String saveSelectedMsdsMapping(Map<String,String> param, List<Object> gridData) {
		String _rtnMsg = "매핑 완료 되었습니다.";

		try {
			for (int i = 0; i < gridData.size(); i++) {
				param.putAll((Map<String,String>) gridData.get(i));

				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsItemMsdsMapping", param);
			}
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("MSDS 매핑에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	// MSDS 매핑해제
	public String saveSelectedMsdsClean(Map<String,String> param, List<Object> gridData) {
		String _rtnMsg = "매핑 해제 완료 되었습니다.";

		try {
			for (int i = 0; i < gridData.size(); i++) {
				param.putAll((Map<String,String>) gridData.get(i));

				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsItemMsdsClean", param);
			}
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("매핑 해제에 실패하였습니다.");
		}
		return _rtnMsg;
	}

}
