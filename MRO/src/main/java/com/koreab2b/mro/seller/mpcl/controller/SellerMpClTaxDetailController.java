package com.koreab2b.mro.seller.mpcl.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.seller.mpcl.service.SellerMpClTaxDetailService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetResponseUtil;

/**
 * 전자세금계산서 상세내역 Controller
 * Java 1.6 호환성 유지
 */
@Controller("sellerMpClTaxDetailController")
public class SellerMpClTaxDetailController {

    @Autowired
    private SellerMpClTaxDetailService sellerMpClTaxDetailService;

    /**
     * 전자세금계산서 상세내역 Ajax 조회 (DetailViewPopup용)
     * @param pMap 요청 파라미터 (taxBillNo 필수)
     * @return IBSheet 표준 응답 형식
     */
    @RequestMapping(value = "/mpcl/getSellerMpClTaxDetailList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getSellerMpClTaxDetailList(@RequestParam Map<String, String> pMap) {

        Map<String, Object> response = new HashMap<String, Object>();

        try {
            // 필수 파라미터 검증
            String taxBillNo = pMap.get("taxBillNo");
            if (taxBillNo == null || taxBillNo.trim().length() == 0) {
                return IBSheetResponseUtil.createErrorResponse("세금계산서 번호가 필요합니다.");
            }

            // 검색 조건 설정
            Map<String, String> searchParams = new HashMap<String, String>();
            searchParams.put("taxBillNo", taxBillNo.trim());

            // 상세내역 조회
            List<Map<String, String>> dataList = sellerMpClTaxDetailService.getTaxDetailList(searchParams);

            // NULL 값 처리
            List<Map<String, String>> processedData = CommonUtil.getListNvl(dataList);

            // IBSheet 표준 응답 생성
            Map<String, Object> result = IBSheetResponseUtil.createSuccessResponse(processedData);

            return result;

        } catch (Exception e) {
            // 오류 로그 출력
            System.err.println("[SellerMpClTaxDetailController] 오류 발생: " + e.getMessage());
            e.printStackTrace();

            // 오류 발생 시 표준 에러 응답 반환
            return IBSheetResponseUtil.createErrorResponse("상세내역 조회 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
}