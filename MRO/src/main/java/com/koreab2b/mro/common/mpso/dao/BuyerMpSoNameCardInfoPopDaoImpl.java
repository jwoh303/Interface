package com.koreab2b.mro.common.mpso.dao;

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

@Repository("buyerMpSoNameCardInfoPopDao")
@Transactional
public class BuyerMpSoNameCardInfoPopDaoImpl implements BuyerMpSoNameCardInfoPopDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMpSoNameCardInfoPopDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectBuyerMpSoNameCardInfoPopList", formData);
	}
	
	// 회원 정보조회
	public Map<String,String> selectUserInfoList(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selectBuyerMpSoNameCardUserInfoList", formData);
	}
	
	// 명함 컬럼명 조회
	public Map<String, Object> selectColumnInfoList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selectBuyerMpSoNameCardColumnInfoList", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String saveBuyerMpSoCartRemarkNameCard(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			
			String st_type = CommonUtil.nvl(formData.get("st_type"), "");
			String center_addr = "";
			
			if("HAAC".equals(st_type)) {
				// 센터코드 이용하여 센터주소 갖고 오기
				center_addr = sqlSessionTemplate.selectOne("common.mpso.selectBuyerMpSoNameCardCenterAddr", formData);
				formData.put("st_center_addr", center_addr);
				logger.debug("요청 파라미터 : {}", formData);
				// 센터주소 추가하여 REMARK 업데이트
				sqlSessionTemplate.update("common.mpso.updateBuyerMpSoCartRemarkNameCardHaac", formData);
				// 센터주소 포함된 REMARK 리턴
				_rtnMsg = sqlSessionTemplate.selectOne("common.mpso.selectBuyerMpSoNameCardRemark", formData);
			}else if("LSAT".equals(st_type)) {
				// 근무지코드 이용하여 근무지 주소(국/영문) 갖고 오기.
				// 한샘 직위/직급 자동판별에 쓰는 selectColumnInfoList()를 그대로 재사용(TEXT2/TEXT3까지
				// 반환하도록 쿼리만 확장함, WKPL 전용 메서드/쿼리 새로 안 만듦) - CODE1='WKPL' 고정 + CODE2로 조회.
				// REMARK에 그대로 노출되는 값이라(엑셀 등으로 협력사가 봄), 층수를 숫자만
				// 남기지 않고 명함에 인쇄될 형식 그대로(주소 뒤에 "20층"/"20F") 붙여서 저장한다.
				// 예: "14067 경기도 안양시 시민대로 260 안양금융센터 (AFC) 20층"
				Map<String, Object> _wkplParam = new HashMap<String, Object>();
				_wkplParam.put("stBuyer", formData.get("st_buyer"));
				_wkplParam.put("type", "NCIF");
				_wkplParam.put("code1List", new String[]{"WKPL"});
				_wkplParam.put("stCode2", formData.get("st_workplace_code"));
				Map<String, Object> _addr = selectColumnInfoList(_wkplParam);
				// 층수는 국/영문 공용 필드라 숫자만 받아서 언어별로 "층"/"F"를 서버가 붙인다
				// (화면 placeholder로 숫자만 입력하도록 안내하지만, 혹시 "층"/"F"를 포함해서
				//  입력해도 중복 접미사가 안 붙도록 방어적으로 제거 후 사용)
				String _floor = CommonUtil.nvl(formData.get("st_floor")).replaceAll("(?i)(층|F)+$", "").trim();
				String _addrKo = "";
				String _addrEn = "";
				if (_addr != null) {
					String _rawAddrKo = CommonUtil.nvl((String) _addr.get("TEXT2"));
					String _rawAddrEn = CommonUtil.nvl((String) _addr.get("TEXT3"));
					_addrKo = _rawAddrKo + (_floor.isEmpty() ? "" : " " + _floor + "층");
					_addrEn = _rawAddrEn + (_floor.isEmpty() ? "" : " " + _floor + "F");
				}
				// REMARK 문자열 조립(';' 이어붙이기)
				String _fullRemark = CommonUtil.nvl(formData.get("st_remark")) + ";" + _addrKo + ";" + _addrEn;
				formData.put("st_remark", _fullRemark);
				logger.debug("요청 파라미터 : {}", formData);
				sqlSessionTemplate.update("common.mpso.updateBuyerMpSoCartRemarkNameCard", formData);
				// 근무지 주소 포함된 REMARK 리턴
				_rtnMsg = sqlSessionTemplate.selectOne("common.mpso.selectBuyerMpSoNameCardRemark", formData);
			}else {
				sqlSessionTemplate.update("common.mpso.updateBuyerMpSoCartRemarkNameCard", formData);
			}
		} catch (Exception e) {
			_rtnMsg = "Err";
			throw new RuntimeException("저장 중 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
		}
		return _rtnMsg;
	}
}

