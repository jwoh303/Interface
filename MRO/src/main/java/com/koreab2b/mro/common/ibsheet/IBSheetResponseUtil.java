package com.koreab2b.mro.common.ibsheet;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.koreab2b.mro.util.CommonUtil;

/**
 * IBSheet DoSearch 응답 처리 유틸리티
 * 
 * IBSheet의 DoSearch 메소드 호출에 대한 표준 JSON 응답을 생성하는 유틸리티 클래스
 * 
 * @author Claude Code
 * @since 2025.01.31
 */
public class IBSheetResponseUtil {
    
    /**
     * DoSearch 성공 응답 생성 (데이터 있음)
     * 
     * @param data 조회된 데이터 리스트
     * @return IBSheet DoSearch 표준 JSON 응답 Map
     */
    public static Map<String, Object> createSuccessResponse(List<Map<String, String>> data) {
        return createSuccessResponse(data, "조회가 정상 처리되었습니다.");
    }
    
    /**
     * DoSearch 성공 응답 생성 (커스텀 메시지)
     * 
     * @param data 조회된 데이터 리스트
     * @param message 응답 메시지
     * @return IBSheet DoSearch 표준 JSON 응답 Map
     */
    public static Map<String, Object> createSuccessResponse(List<Map<String, String>> data, String message) {
        Map<String, Object> response = new HashMap<String, Object>();
        
        // CommonUtil.getListNvl로 null 안전 처리
        List<Map<String, String>> cleanData = CommonUtil.getListNvl(data);
        
        // Data (필수): 조회 데이터 배열
        response.put("Data", cleanData);
        
        // Message (선택): 서버 처리 메시지 - OnSearchEnd의 message 인자로 전달
        if (cleanData == null || cleanData.isEmpty()) {
            response.put("Message", "조회된 데이터가 없습니다.");
        } else {
            response.put("Message", message);
        }
        
        // Total (선택): 전체 데이터 개수
        response.put("Total", cleanData != null ? cleanData.size() : 0);
        
        // Result (선택): 서버 처리 결과 객체
        Map<String, Object> resultInfo = new HashMap<String, Object>();
        resultInfo.put("Code", 0);  // 0 이상: 정상
        resultInfo.put("Message", "서버 처리 완료");
        response.put("Result", resultInfo);
        
        return response;
    }
    
    /**
     * DoSearch 빈 결과 응답 생성
     * 
     * @return IBSheet DoSearch 표준 JSON 응답 Map (빈 데이터)
     */
    public static Map<String, Object> createEmptyResponse() {
        return createEmptyResponse("조회된 데이터가 없습니다.");
    }
    
    /**
     * DoSearch 빈 결과 응답 생성 (커스텀 메시지)
     * 
     * @param message 응답 메시지
     * @return IBSheet DoSearch 표준 JSON 응답 Map (빈 데이터)
     */
    public static Map<String, Object> createEmptyResponse(String message) {
        Map<String, Object> response = new HashMap<String, Object>();
        
        // Data (필수): 빈 배열
        response.put("Data", CommonUtil.getListNvl(null));
        
        // Message (선택): 서버 처리 메시지
        response.put("Message", message);
        
        // Total (선택): 0
        response.put("Total", 0);
        
        // Result (선택): 서버 처리 결과 객체
        Map<String, Object> resultInfo = new HashMap<String, Object>();
        resultInfo.put("Code", 0);  // 정상이지만 데이터 없음
        resultInfo.put("Message", "서버 처리 완료");
        response.put("Result", resultInfo);
        
        return response;
    }
    
    /**
     * DoSearch 에러 응답 생성
     * 
     * @param errorMessage 에러 메시지
     * @return IBSheet DoSearch 표준 JSON 응답 Map (에러)
     */
    public static Map<String, Object> createErrorResponse(String errorMessage) {
        return createErrorResponse(errorMessage, -1);
    }
    
    /**
     * DoSearch 에러 응답 생성 (에러 코드 포함)
     * 
     * @param errorMessage 에러 메시지
     * @param errorCode 에러 코드 (음수)
     * @return IBSheet DoSearch 표준 JSON 응답 Map (에러)
     */
    public static Map<String, Object> createErrorResponse(String errorMessage, int errorCode) {
        Map<String, Object> response = new HashMap<String, Object>();
        
        // Data (필수): 빈 배열
        response.put("Data", CommonUtil.getListNvl(null));
        
        // Message (선택): 에러 메시지
        response.put("Message", errorMessage);
        
        // Total (선택): 0
        response.put("Total", 0);
        
        // Result (선택): 서버 처리 결과 객체
        Map<String, Object> resultInfo = new HashMap<String, Object>();
        resultInfo.put("Code", errorCode);  // 0 미만: 실패
        resultInfo.put("Message", errorMessage);
        response.put("Result", resultInfo);
        
        return response;
    }
    
    /**
     * DoSearch 페이징 응답 생성
     * 
     * @param data 조회된 데이터 리스트
     * @param totalCount 전체 데이터 개수 (페이징 시 실제 전체 개수)
     * @param currentPage 현재 페이지
     * @param pageSize 페이지 크기
     * @return IBSheet DoSearch 표준 JSON 응답 Map (페이징 정보 포함)
     */
    public static Map<String, Object> createPagingResponse(List<Map<String, String>> data, 
                                                           int totalCount, 
                                                           int currentPage, 
                                                           int pageSize) {
        Map<String, Object> response = new HashMap<String, Object>();
        
        // CommonUtil.getListNvl로 null 안전 처리
        List<Map<String, String>> cleanData = CommonUtil.getListNvl(data);
        
        // Data (필수): 조회 데이터 배열
        response.put("Data", cleanData);
        
        // Message (선택): 서버 처리 메시지
        if (cleanData == null || cleanData.isEmpty()) {
            response.put("Message", "조회된 데이터가 없습니다.");
        } else {
            response.put("Message", "조회가 정상 처리되었습니다. (페이지 " + currentPage + ")");
        }
        
        // Total: 전체 데이터 개수 (페이징 시)
        response.put("Total", totalCount);
        
        // 페이징 정보 추가
        response.put("CurrentPage", currentPage);
        response.put("PageSize", pageSize);
        response.put("TotalPages", (int) Math.ceil((double) totalCount / pageSize));
        
        // Result (선택): 서버 처리 결과 객체
        Map<String, Object> resultInfo = new HashMap<String, Object>();
        resultInfo.put("Code", 0);  // 0 이상: 정상
        resultInfo.put("Message", "서버 처리 완료");
        response.put("Result", resultInfo);
        
        return response;
    }
    
    /**
     * DoSearch 응답에 추가 정보 설정
     *
     * @param response 기존 응답 Map
     * @param key 추가할 키
     * @param value 추가할 값
     * @return 추가 정보가 설정된 응답 Map
     */
    public static Map<String, Object> addAdditionalInfo(Map<String, Object> response, String key, Object value) {
        if (response != null && key != null && value != null) {
            response.put(key, value);
        }
        return response;
    }
}