//WMS TR 출력물 리포트 디자이너 Sheet
function setWmsTrMultiSheet(sgid, carid, user_dept, warehouse_code, buyer, ik_no, user_id, legacy_po, legacy_po_seq, legacy_iv_serial, doc_type) {
	var seller = "KRKORE0001";
	var legacy_flag = "";
	var dhim_legacy_po_no = "";
	var url = "/coco/showReportMultiViewer.do";
	
	// 동일한 RPT_ID 내에 다른 유형의 파라미터 사용시 증가 필요(금호석유화학 등)
	var params = "";
	var params1 = "";
	
	var end_flag = "";
	var ik_no_arr = [];
	var legacy_po_arr = [];
	var legacy_iv_arr = [];
	
	ik_no_arr = ik_no.split("@@");
	legacy_po_arr = legacy_po.split("@@");
	legacy_iv_arr = legacy_iv_serial.split("@@");
	
	// IK번호 갯수만큼 반복
	for(i=0; i<ik_no_arr.length-1; i++){
		if(i == (ik_no_arr.length-2)){
			end_flag = "^^";
		}else{
			end_flag = "@@";
		}
		
		if(legacy_po_arr[i].size > 2){
			legacy_flag = legacy_po_arr[i].substring(0, 2);	
		}
		
		if(legacy_po_arr[i].size > 1){
			dhim_legacy_po_no = legacy_po_arr[i].substring(0, 1);
		}
		
		if (sgid == "P08-0000011-01") { // 두산중공업의 경우.
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-02") { // 대우조선의 경우
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-03") { // 덕흥공업의 경우
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-05") {
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-06") { // 20140611 장민기 두산건설(주)_HRSG() 추가
			params += "[" + buyer + "][" + seller + "][" + ik_no_arr[i] + "]" + end_flag;
		} else if (sgid == "P08-0000011-07") {
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-08") { // 하이트맥주 마산
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-09") { // 구미 물류센터 코오롱 관련
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if ((sgid == "P08-0000011-10" || sgid == "P08-0000011-12" || sgid == "P08-0000011-11")
				&& (dhim_legacy_po_no == "5" || dhim_legacy_po_no == "4" || dhim_legacy_po_no == "A")) {
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-14") {
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-15") {
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-16") {
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-17") {
			if(legacy_iv_serial == ''){
				alert("고객사 시스템에 등록중입니다.\n(납품서 출력은 약 20분 후 가능합니다)");
				return;
			}else{
				params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
			}
		} else if (sgid == "P08-0000011-19") { // 한화 거래명세서
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-20") { // KEP_건설_두산메카텍
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-21") {
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-22" || sgid == "P08-0000011-46") {// 두산인프라코어
			alert("다중 거래명세서 출력이 불가한 고객사입니다.");
			return;
		} else if (sgid == "P08-0000011-23") {// (주)화승네트웍스
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-24") {// 하이트맥주(주) + (주)진로
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-25") {// 한국미쓰비시엘리베이터(주)
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-26") {// 교보리얼코
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-27") {// 현대비앤지스틸 주식회사
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == "P08-0000011-28") {// 한화케미칼(주) 여수
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		} else if (sgid == "P08-0000011-29") {// 두산엔진(주)
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		} else if (sgid == "P08-0000011-30") {// 동일고무벨트
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		} else if (sgid == "P08-0000011-31") {// 한국델파이(주)
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		} else if (sgid == "P08-0000011-32") {// (주)효성
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		} else if (sgid == "P08-0000011-33") {// (주)효성(SAP)
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		} else if (sgid == "P08-0000011-34") {// 성동조선해양(주) 김상근 1021 seller 추가
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		} else if (sgid == "P08-0000011-35") {// 쌍용자동차(주)
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		} else if (sgid == "P08-0000011-36") {// 유한 - 유한킴벌리 김천공장(KRYUHA0013), 김천공장_사무(KRYUHA0016) 제외 2017.05.08 by HSJ
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		} else if (sgid == "P08-0000011-37") {// 쌍용자동차 (주) 창원공장
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		} else if (sgid == "P08-0000011-38") {// 한화케미칼(주) 울산1,울산2,울산3
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		} else if (sgid == "P08-0000011-39") {// STX 조선해양
			alert("다중 거래명세서 출력이 불가한 고객사입니다.");
			return;
		} else if ((sgid == "P08-0000011-40")) {// STX 엔진3사 (KRSTX-0002,KRSTX-0003,KRSTX-0005,KRSTX-0006)
			alert("다중 거래명세서 출력이 불가한 고객사입니다.");
			return;
		} else if (sgid == "P08-0000011-41") { // 화천기공 김상근 1021 seller 추가
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		} else if (sgid == 'P08-0000011-42') {
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		} else if (sgid == 'P08-0000011-43') { // SM00033 유도스타 주식회사 20140820 장민기
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		} else if (sgid == 'P08-0000011-44') { // SM00033 유도썬셋 주식회사 20140820 장민기
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		} else if (sgid == 'P08-0000011-45') { // 20140724 장민기 한국제지 SR14007548 요청자
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "][" + legacy_po_arr[i] + "][" + user_id + "]" + end_flag;
		} else if (sgid == "P08-0000011-47") { // 코오롱 SAP
			if (legacy_iv_serial == '') {
				alert("고객사 시스템에 등록중입니다.\n(납품서 출력은 약 20분 후 가능합니다)");
				return;
			}
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		} else if (sgid == "P08-0000011-48") { // 삼남석유회사
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		} else if (sgid == "P08-0000011-49") { // 삼남석유회사 제외한 삼양계열사(ICOMCOD2, TYPE='PLNT')
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-50") { // 20151126 한승준 - 한화호텔앤드리조트 요청자 : 김연희 사원
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-51") { // 창성KRCHAN0076, KRCHAN0078,KRCHAN0079
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-52") { // 20160128 한승준 - 셀트리온 KRCELL0004 요청자 : 이지윤
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-53") { // 20160128 한승준 - 빙그레 KRBING0002, KRBING0003, KRBING0004, KRBING0005 요청자 : 김상훈, 일동제약 KRILDO0005 요청자 : 강대로, 20180404 유도썬스 KRYOUN0301 요청자 : 김상훈, 20180410 바이오토피아 KRBIOT0004 요청자 : 한영민
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-54") { // 20160429 현명환 광동 제약 KRKWAB0001
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-55") { // 20160518 한승준 효성사무용품(사업장) KRHYOS0051 요청자 : 신숙희
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		}else if (sgid == "P08-0000011-56") { // 품목코드 있는 표준 코아비스(KRCOAV0001) 요청자 안병환/티씨테크, 20171124 한승준 셀트리온제약(KRCELL0008,KRCELL0009,KRCELL0010) - 정윤석CJ
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-58") { // 일진제강 수원, 전주 (KRILJI0055, KRILJI0056) 요청자 한다연
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-59") { // 윈체 (KRWINC0001, KRWINC0002, KRWINC0003) 요청자 박경혁GJ
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-60") { // (신)유도썬스 (KRYUDO0006) 요청자 김상훈CJ
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "][" + legacy_po_arr[i] + "]" + end_flag;
		}else if (sgid == "P08-0000011-61") { // 에스원(KRS-1-0001) 요청자 김초롱SW
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-62") { //  삼성전자(KRSAMS0123), 삼성전자서비스(KRSAMS0192)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-63") { //  대덕전자(KRDAED0079)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-64") { //  미스미(KRMISU0014)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-65") { // 유한킴벌리 김천공장(KRYUHA0013), 김천공장_사무(KRYUHA0016) 요청자 박형근GJ 2017.05.08 by HSJ
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-66") { // 케이오씨전기(KRKOC-0001), 요청자 김민성 과장 2017.05.24 by HSJ
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-67") { //  삼성전기(KRSAMS0140), 요청자 심재운GJ 2017.06.01 by HSJ
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-68") { // 롯데푸드 11개 고객사 2017.07.13 by HSJ
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-69") { // 위닉스(KRWINI0003) 2017.07.21 by HSJ
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-70") { // 미래페이퍼(KRMIRA0089) 2017.09.22 by HSJ
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-71") { // 일진머티리얼즈(KRILJI0006) 2017.10.12 by HSJ
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-72") { // 이케아(KRIKEA0001) 2017.10.24 by HSJ
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-73") { //  BQMS 미사용 오프라인 삼성전자(KRSAMS0149)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-74") { //  일진전기_펀치아웃 대체용(KRILJI0066, KRILJI0067)
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		}else if (sgid == "P08-0000011-75") { // 롯데알미늄 8개 고객사(KRLOTT0030~KRLOTT0037)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-76") { // 전략영업팀 전 고객사 중 삼성전자, 삼성전기, 대덕전자, 에스원 제외한 고객사
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-77") { // 품목별비고 기본 거래명세서 2018.10.05 by HSJ
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-78") { // 크린팩토메이션(KRCLEA0041) 거래명세서 & 현품표, 요청자 정윤석 2019.06.25 by HSJ
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-79") { // 삼성에스디에스(KRSAMS0167)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-80") { // 화천기계(KRHWAC0016) 화천보관용 & 공급사보관용, 요청자 최진수 2019.09.27 by HSJ
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-81" || sgid == "P08-0000011-82" || sgid == "P08-0000011-83") { // 에스원 그룹(KRS-1-G001) 70개 고객사 거래명세서
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-84") { // 휴켐스(주) 여수2공장 (KRHUCH0002)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-85") { // 대원강업
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-86") { // 에스와이에스리테일(IF) (KRSYS-0002)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-87") { // 경농(주) (KRKYUN0184)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-88") { // 동화그룹 (KRDONGG007)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-89") { // SPC
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-90") { // 넥센타이어 IF(KRNEXE0008, KRNEXE0009)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-91") { // non-IF 품목코드, 발주번호, 관리코드 표준 거래명세서
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-92") { // 지에스건설 (KRGS-E0001)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-93") { // 한화기계그룹(KRHANW0096, KRHANW0097, KRHANW0098)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-94") { /* 한화방산글로벌(KRHANW0085, KRHANW0086, KRHANW0087, KRHANW0088, KRHANW0089, KRHANW0090, KRHANW0091, 
															KRHANW0092, KRHANW0093, KRHANW0094, KRHANW0100)*/
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-95") { // 램리서치코리아테크놀로지(KRLAM-0001)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-96") { // 팔도(KRPALD0001, KRPALD0002, KRPALD0003, KRPALD0004, KRPALD0005)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-97") { // 엘에스메탈(주)장항공장(KRLS-M0002)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-98") { // 롯데알미늄(KRLOTT0070,KRLOTT0071,	KRLOTT0072, KRLOTT0073, KRLOTT0074, KRLOTT0075,	KRLOTT0076, KRLOTT0077)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-99") { // 삼기(KRSAMK0030,KRSAMK0031)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-100") { // 삼기이브이(KRSAMK0032,KRSAMK0033)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-101") { // // 금호석유화학(KRKUMH0043~KRKUMH0053) 
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-102") { // 코오롱(NON IF, P08-0000011-47 와 같은 형식이지만 LEGACY_IV_SERIAL을 체크하지 않음)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-103") { // 솔브레인 그룹
			if(dhim_legacy_po_no == "4" && legacy_iv_serial == ""){ // IF발주에 LEGACY_IV_SERIAL 없는 것들
				alert("고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)");
				return;
			}else{
				params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;	
			}
		}else if (sgid == "P08-0000011-104") { // SK마이크로웍스(KRSK--0001, KRSK--0002, KRSK--0003, KRSK--0004)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-105") { // 피유코어 주식회사(KRSKPU0001)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-106") { // 깨끗한나라(KRKLEA0003)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-107") { // // (주)일진베어링, KRILJI0094
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-108") { // 디알비동일(KRDRB-0004, KRDRB-0005, KRDRB-0006)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-109") { // // (주)일진, KRILJI0093
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else if (sgid == "P08-0000011-110") { // (주)종근당(KRCHON0034), 주식회사뉴라테온(KRNURA0001)
			params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}else {
			params += "[" + warehouse_code + "][" + buyer + "][" + ik_no_arr[i] + "][" + seller + "]" + end_flag;
		}

		/* 기본 출력과 함께 필요한 케이스 */
		if (sgid == "P08-0000011-101") { // 금호석유화학(KRKUMH0043~KRKUMH0053) 검수보고서 추가 출력
			params1 += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "]" + end_flag;
		}
	}
	// for - end
	
	// 출력 start
	var rdParams = [];
	
	if (sgid == "P08-0000011-01") { // 두산중공업의 경우.
		// 리포트 디자이너 Sheet Open
		if (legacy_flag == 'PR' || legacy_flag == '') {
			rdParams.push({key:"fileName", value:"RD_08_M_006_55"});
			rdParams.push({key:"param", value:params});
			OpenReportPost(url, "REPORTPOP1", rdParams);
			rdParams = [];
			
			rdParams.push({key:"fileName", value:"RD_08_M_006_54"});
			rdParams.push({key:"param", value:params});
			OpenReportPost(url, "REPORTPOP2", rdParams);
			rdParams = [];
		} else {
			rdParams.push({key:"fileName", value:"RD_08_M_006_32"});
			rdParams.push({key:"param", value:params});
			OpenReportPost(url, "REPORTPOP1", rdParams);
			rdParams = [];
			
			rdParams.push({key:"fileName", value:"RD_08_M_006_56"});
			rdParams.push({key:"param", value:params});
			OpenReportPost(url, "REPORTPOP2", rdParams);
			rdParams = [];
		}
	} else if (sgid == "P08-0000011-02") { // 대우조선의 경우
		// 리포트 디자이너 Sheet Open
		if (legacy_flag == 'PR' || legacy_flag == '') {
			rdParams.push({key:"fileName", value:"RD_08_M_006_55"});
			rdParams.push({key:"param", value:params});
			OpenReportPost(url, "REPORTPOP1", rdParams);
			rdParams = [];
			
			rdParams.push({key:"fileName", value:"RD_08_M_006_54"});
			rdParams.push({key:"param", value:params});
			OpenReportPost(url, "REPORTPOP2", rdParams);
			rdParams = [];
		} else {
			rdParams.push({key:"fileName", value:"RD_08_M_006_48"});
			rdParams.push({key:"param", value:params});
			OpenReportPost(url, "REPORTPOP1", rdParams);
			rdParams = [];
			
			rdParams.push({key:"fileName", value:"RD_08_M_006_47"});
			rdParams.push({key:"param", value:params});
			OpenReportPost(url, "REPORTPOP2", rdParams);
			rdParams = [];
		}
	} else if (sgid == "P08-0000011-03") { // 덕흥공업의 경우
		// 리포트 디자이너 Sheet Open
		rdParams.push({key:"fileName", value:"RD_08_M_006_50"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_49"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	} else if (sgid == 'P08-0000011-04') { // FAG KOREA의 경우
		// 리포트 디자이너 Sheet Open
		rdParams.push({key:"fileName", value:"RD_08_M_006_35"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_34"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];

		if(dhim_legacy_po_no == "8"){ // 셰플러 LEGACY_PO_NO 8로 시작하면 태그 출력 - 20170612 HSJ
			rdParams.push({key:"fileName", value:"RD_06_X_002_15"});
			rdParams.push({key:"param", value:params});
			OpenReportPost(url, "REPORTPOP3", rdParams);
			rdParams = [];
		}
	} else if (sgid == "P08-0000011-05") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_61"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_33"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	} else if (sgid == "P08-0000011-06") { // 20140611 장민기 두산건설(주)_HRSG() 추가
		rdParams.push({key:"fileName", value:"RD_08_M_006_30"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_31"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_29"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP3", rdParams);
		rdParams = [];
	} else if (sgid == "P08-0000011-07") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_42"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	} else if (sgid == "P08-0000011-08") { // 하이트맥주 마산
		rdParams.push({key:"fileName", value:"RD_08_M_006_37"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_36"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	} else if (sgid == "P08-0000011-09") { // 구미 물류센터 코오롱 관련
		rdParams.push({key:"fileName", value:"RD_08_M_006_46"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_45"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	} else if ((sgid == "P08-0000011-10" || sgid == "P08-0000011-12" || sgid == "P08-0000011-11")
			&& (dhim_legacy_po_no == "5" || dhim_legacy_po_no == "4" || dhim_legacy_po_no == "A")) {
		alert("다중 거래명세서 출력이 불가한 고객사입니다.");
		return;
	} else if ((sgid == "P08-0000011-10" || ((sgid == "P08-0000011-11" || sgid == "P08-0000011-13"))) && TrimCommon(legacy_flag) == "20") {
		alert("다중 거래명세서 출력이 불가한 고객사입니다.");
		return;
	} else if (sgid == "P08-0000011-14") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_53"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];

		/* 20140424 장민기 요청번호 : 4 에스엔티중공업 기계공장 거래명세서 내용수정및 바코드 추가 후 분할 작업시작 */
	} else if (sgid == "P08-0000011-15") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_62"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];

		/* 20140424 장민기 작업끝 */
	} else if (sgid == "P08-0000011-16") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_41"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	} else if (sgid == "P08-0000011-17") {
		if(legacy_iv_serial == ''){
			alert("고객사 시스템에 등록중입니다.\n(납품서 출력은 약 20분 후 가능합니다)");
			return;
		}else{
			rdParams.push({key:"fileName", value:"RD_06_S_001_131"});
			rdParams.push({key:"param", value:params});
			OpenReportPost(url, "REPORTPOP1", rdParams);
			rdParams = [];
			
			rdParams.push({key:"fileName", value:"RD_06_S_001_132"});
			rdParams.push({key:"param", value:params});
			OpenReportPost(url, "REPORTPOP2", rdParams);
			rdParams = [];
		}
	} else if (sgid == "P08-0000011-19") { // 한화 거래명세서
		rdParams.push({key:"fileName", value:"RD_08_M_006_11"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_10"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	} else if (sgid == "P08-0000011-20") { // KEP_건설_두산메카텍
		rdParams.push({key:"fileName", value:"RD_08_M_006_19"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	} else if (sgid == "P08-0000011-21") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_28"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_54"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];

	// 두산인프라코어
	} else if (sgid == "P08-0000011-22" || sgid == "P08-0000011-46") {
		alert("다중 거래명세서 출력이 불가한 고객사입니다.");
		return;

	// 하이트맥주(주) + (주)진로
	} else if (sgid == "P08-0000011-24") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_12"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_54"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];

	// 한국미쓰비시엘리베이터(주)
	} else if (sgid == "P08-0000011-25") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_21"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_54"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];

	// 교보리얼코
	} else if (sgid == "P08-0000011-26") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_20"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_54"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];

	// 현대비앤지스틸 주식회사
	} else if (sgid == "P08-0000011-27") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_04"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];

	// 한화케미칼(주) 여수
	} else if (sgid == "P08-0000011-28") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_09"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];

	// 두산엔진(주)
	} else if (sgid == "P08-0000011-29") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_07"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];

	// 동일고무벨트
	} else if (sgid == "P08-0000011-30") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_06"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];

	// 한국델파이(주)
	} else if (sgid == "P08-0000011-31") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_05"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];

	// (주)효성
	} else if (sgid == "P08-0000011-32") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_17"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];

		rdParams.push({key:"fileName", value:"RD_08_M_006_57"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];

		/**
		 * KEPPROJECT
		 * 
		 * @author 최진수
		 * @programid CJS00008 start
		 * @remark 효성 세종 공장(KRHYOS0043) 추가
		 * @date 2014-06-24
		 */
	// (주)효성(SAP)
	} else if (sgid == "P08-0000011-33") {
		// 김민성 대리 요청으로 거래명세서와 태그를 분리함.
		rdParams.push({key:"fileName", value:"RD_08_M_006_18"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_40"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];

	// 성동조선해양(주) 김상근 1021 seller 추가
	} else if (sgid == "P08-0000011-34") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_25"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_59"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	
	// 쌍용자동차(주)
	} else if (sgid == "P08-0000011-35") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_23"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
	// 유한 - 유한킴벌리 김천공장(KRYUHA0013), 김천공장_사무(KRYUHA0016) 제외 2017.05.08 by HSJ
	} else if (sgid == "P08-0000011-36") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_22"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
	// 쌍용자동차 (주) 창원공장
	} else if (sgid == "P08-0000011-37") {
		rdParams.push({key:"fileName", value:"RD_08_M_006_64"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_65"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];

	// 한화케미칼(주) 울산1,울산2,울산3
	} else if (sgid == "P08-0000011-38") {
		rdParams.push({key:"fileName", value:"RD_06_S_001_106"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];

	// STX 조선해양
	} else if (sgid == "P08-0000011-39") {
		alert("다중 거래명세서 출력이 불가한 고객사입니다.");
		return;

		// STX 엔진3사 (KRSTX-0002,KRSTX-0003,KRSTX-0005,KRSTX-0006)
	} else if ((sgid == "P08-0000011-40")) {
		alert("다중 거래명세서 출력이 불가한 고객사입니다.");
		return;

	} else if (sgid == "P08-0000011-41") { // 화천기공 김상근 1021 seller 추가
		rdParams.push({key:"fileName", value:"RD_08_M_006_13"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
	// 김상근 추가부분 1017 -- 시작
	} else if (sgid == 'P08-0000011-42') { // SM00035 20140903 KRFAGB0001분리 장민기
											// SR14008727 - P08-0000011-04에서 변경됨
		// 리포트 디자이너 Sheet Open
		rdParams.push({key:"fileName", value:"RD_08_M_006_74"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_75"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
		
		if(dhim_legacy_po_no == "8"){ // 셰플러 LEGACY_PO_NO 8로 시작하면 태그 출력 - 20170612 HSJ
			rdParams.push({key:"fileName", value:"RD_06_X_002_15"});
			rdParams.push({key:"param", value:params});
			OpenReportPost(url, "REPORTPOP3", rdParams);
			rdParams = [];
		}
	} else if (sgid == 'P08-0000011-43') { // SM00033 유도스타 주식회사 20140820 장민기
		// 리포트 디자이너 Sheet Open
		rdParams.push({key:"fileName", value:"RD_08_M_006_76"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_77"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	} else if (sgid == 'P08-0000011-44') { // SM00033 유도썬셋 주식회사 20140820 장민기
		// 리포트 디자이너 Sheet Open
		rdParams.push({key:"fileName", value:"RD_08_M_006_78"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_79"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	} else if (sgid == 'P08-0000011-45') { // 20140724 장민기 한국제지 SR14007548 요청자
		rdParams.push({key:"fileName", value:"RD_06_S_001_162"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_06_S_001_53"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	} else if (sgid == "P08-0000011-47") { // 코오롱 SAP
		if (legacy_iv_serial == '') {
			alert("고객사 시스템에 등록중입니다.\n(납품서 출력은 약 20분 후 가능합니다)");
			return;
		}
		rdParams.push({key:"fileName", value:"RD_06_T_003_01"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	} else if (sgid == "P08-0000011-48") { // 삼남석유회사
		rdParams.push({key:"fileName", value:"RD_06_S_001_100"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	} else if (sgid == "P08-0000011-49") { // 삼남석유회사 제외한 삼양계열사(ICOMCOD2, TYPE='PLNT')
		rdParams.push({key:"fileName", value:"RD_06_S_001_103"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-50") { // 20151126 한승준 - 한화호텔앤드리조트 요청자 : 김연희 사원
		rdParams.push({key:"fileName", value:"RD_06_S_001_102"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-51") { // 창성KRCHAN0076, KRCHAN0078,KRCHAN0079
		rdParams.push({key:"fileName", value:"RD_06_S_001_108"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-52") { // 20160128 한승준 - 셀트리온 KRCELL0004 요청자 : 이지윤
		rdParams.push({key:"fileName", value:"RD_06_S_001_109"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-53") { // 20160128 한승준 - 빙그레 KRBING0002, KRBING0003, KRBING0004, KRBING0005 요청자 : 김상훈, 일동제약 KRILDO0005 요청자 : 강대로, 20180404 유도썬스 KRYOUN0301 요청자 : 김상훈, 20180410 바이오토피아 KRBIOT0004 요청자 : 한영민
		rdParams.push({key:"fileName", value:"RD_06_S_001_110"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-54") { // 20160429 현명환 광동 제약 KRKWAB0001
		rdParams.push({key:"fileName", value:"RD_06_S_001_111"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-55") { // 20160518 한승준 효성사무용품(사업장) KRHYOS0051 요청자 : 신숙희
		rdParams.push({key:"fileName", value:"RD_08_M_006_80"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];

		rdParams.push({key:"fileName", value:"RD_08_M_006_81"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-56") { // 품목코드 있는 표준 코아비스(KRCOAV0001) 요청자 안병환/티씨테크, 20171124 한승준 셀트리온제약(KRCELL0008,KRCELL0009,KRCELL0010) - 정윤석CJ
		rdParams.push({key:"fileName", value:"RD_06_S_001_110"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-58") { // 일진제강 수원, 전주 (KRILJI0055, KRILJI0056) 요청자 한다연
		rdParams.push({key:"fileName", value:"RD_06_S_001_113"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-59") { // 윈체 (KRWINC0001, KRWINC0002, KRWINC0003) 요청자 박경혁GJ
		rdParams.push({key:"fileName", value:"RD_06_S_001_122"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-60") { // (신)유도썬스 (KRYUDO0006) 요청자 김상훈CJ
		rdParams.push({key:"fileName", value:"RD_06_S_003_44"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_06_S_003_45"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-61") { // 에스원(KRS-1-0001) 요청자 김초롱SW
		rdParams.push({key:"fileName", value:"RD_06_S_001_139"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-62") { //  삼성전자(KRSAMS0123), 삼성전자서비스(KRSAMS0192)
		rdParams.push({key:"fileName", value:"RD_06_S_001_117"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-63") { //  대덕전자(KRDAED0079)
		rdParams.push({key:"fileName", value:"RD_06_S_001_118"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-64") { //  미스미(KRMISU0014)
		rdParams.push({key:"fileName", value:"RD_06_S_001_119"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_06_X_002_79"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-65") { // 유한킴벌리 김천공장(KRYUHA0013), 김천공장_사무(KRYUHA0016) 요청자 박형근GJ 2017.05.08 by HSJ
		rdParams.push({key:"fileName", value:"RD_06_S_001_120"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-66") { // 케이오씨전기(KRKOC-0001), 요청자 김민성 과장 2017.05.24 by HSJ
		rdParams.push({key:"fileName", value:"RD_06_S_001_121"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-67") { //  삼성전기(KRSAMS0140), 요청자 심재운GJ 2017.06.01 by HSJ
		rdParams.push({key:"fileName", value:"RD_06_S_001_123"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_06_X_002_14"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-68") { // 롯데푸드 11개 고객사 2017.07.13 by HSJ
										/* 2024.07.19  롯데웰푸드 19개 고객사(KRLOTT0084,KRLOTT0085,KRLOTT0086,KRLOTT0087,KRLOTT0088,KRLOTT0089,KRLOTT0090,KRLOTT0091,KRLOTT0092,KRLOTT0093,
										KRLOTT0094,KRLOTT0095,KRLOTT0096,KRLOTT0097,KRLOTT0098,KRLOTT0099,KRLOTT0100,KRLOTT0101,KRLOTT0102) */
		rdParams.push({key:"fileName", value:"RD_06_S_001_124"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-69") { // 위닉스(KRWINI0003) 2017.07.21 by HSJ
		rdParams.push({key:"fileName", value:"RD_06_S_001_89"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-70") { // 미래페이퍼(KRMIRA0089) 2017.09.22 by HSJ
		rdParams.push({key:"fileName", value:"RD_06_S_001_126"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-71") { // 일진머티리얼즈(KRILJI0006) 2017.10.12 by HSJ
		rdParams.push({key:"fileName", value:"RD_06_S_001_127"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-72") { // 이케아(KRIKEA0001) 2017.10.24 by HSJ
		rdParams.push({key:"fileName", value:"RD_06_S_001_128"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-73") { //  BQMS 미사용 오프라인 삼성전자(KRSAMS0149)
		rdParams.push({key:"fileName", value:"RD_06_S_001_130"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-74") { //  일진전기_펀치아웃 대체용(KRILJI0066, KRILJI0067)
		rdParams.push({key:"fileName", value:"RD_08_M_006_82"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-75") { // 롯데알미늄 8개 고객사(KRLOTT0030~KRLOTT0037)
		rdParams.push({key:"fileName", value:"RD_06_S_001_133"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-76") { // 전략영업팀 전 고객사 중 삼성전자, 삼성전기, 대덕전자, 에스원 제외한 고객사
		rdParams.push({key:"fileName", value:"RD_06_S_001_138"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-77") { // 품목별비고 기본 거래명세서 2018.10.05 by HSJ
		rdParams.push({key:"fileName", value:"RD_06_S_001_200"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-78") { // 크린팩토메이션(KRCLEA0041) 거래명세서 & 현품표, 요청자 정윤석 2019.06.25 by HSJ
		rdParams.push({key:"fileName", value:"RD_06_S_001_140"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_06_S_001_141"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-79") { // 삼성에스디에스(KRSAMS0167)
		rdParams.push({key:"fileName", value:"RD_06_S_001_143"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-80") { // 화천기계(KRHWAC0016) 화천보관용 & 공급사보관용, 요청자 최진수 2019.09.27 by HSJ
		rdParams.push({key:"fileName", value:"RD_06_S_001_144"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_06_S_001_145"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-81" || sgid == "P08-0000011-82" || sgid == "P08-0000011-83") { // 에스원 그룹(KRS-1-G001) 70개 고객사 거래명세서
		rdParams.push({key:"fileName", value:"RD_06_S_001_146"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-84") { // 휴켐스(주) 여수2공장 (KRHUCH0002)
		rdParams.push({key:"fileName", value:"RD_06_S_001_147"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-85") { // 대원강업
		rdParams.push({key:"fileName", value:"RD_06_S_001_148"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-86") { // 에스와이에스리테일(IF) (KRSYS-0002)
		rdParams.push({key:"fileName", value:"RD_06_S_001_149"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-87") { // 경농(주) (KRKYUN0184)
		rdParams.push({key:"fileName", value:"RD_06_S_001_150"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-88") { // 동화그룹 (KRDONGG007)
		rdParams.push({key:"fileName", value:"RD_06_S_001_151"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-89") { // SPC
		rdParams.push({key:"fileName", value:"RD_06_S_001_152"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-90") { // 넥센타이어 IF(KRNEXE0008, KRNEXE0009)
		rdParams.push({key:"fileName", value:"RD_06_S_001_153"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-91") { // non-IF 품목코드, 발주번호, 관리코드 표준 거래명세서
		rdParams.push({key:"fileName", value:"RD_06_S_001_300"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-92") { // 지에스건설 (KRGS-E0001)
		rdParams.push({key:"fileName", value:"RD_06_S_001_400"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-93") { // 한화기계그룹(KRHANW0096, KRHANW0097, KRHANW0098)
		rdParams.push({key:"fileName", value:"RD_06_S_001_155"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-94") { /* 한화방산글로벌(KRHANW0085, KRHANW0086, KRHANW0087, KRHANW0088, KRHANW0089, KRHANW0090, KRHANW0091, 
														KRHANW0092, KRHANW0093, KRHANW0094, KRHANW0100)*/
		rdParams.push({key:"fileName", value:"RD_06_S_001_156"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-95") { // 램리서치코리아테크놀로지(KRLAM-0001)
		reportTrOpen("", params);
		rdParams.push({key:"fileName", value:"RD_06_S_001_157"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-96") { // 팔도(KRPALD0001, KRPALD0002, KRPALD0003, KRPALD0004, KRPALD0005)
		rdParams.push({key:"fileName", value:"RD_06_S_001_158"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-97") { // 엘에스메탈(주)장항공장(KRLS-M0002)
		rdParams.push({key:"fileName", value:"RD_06_S_001_201"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-98") { // 롯데알미늄(KRLOTT0070,KRLOTT0071,	KRLOTT0072, KRLOTT0073, KRLOTT0074, KRLOTT0075,	KRLOTT0076, KRLOTT0077)
		rdParams.push({key:"fileName", value:"RD_06_S_001_133"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-99") { // 삼기(KRSAMK0030,KRSAMK0031)
		rdParams.push({key:"fileName", value:"RD_08_M_006_56"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-100") { // 삼기이브이(KRSAMK0032,KRSAMK0033)
		rdParams.push({key:"fileName", value:"RD_06_S_001_160"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-101") { // 금호석유화학(KRKUMH0043~KRKUMH0053)
		rdParams.push({key:"fileName", value:"RD_06_S_001_172"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-102") { // 코오롱(NON IF, P08-0000011-47 와 같은 형식이지만 LEGACY_IV_SERIAL을 체크하지 않음)
		rdParams.push({key:"fileName", value:"RD_06_T_003_01"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-103") { // 솔브레인 그룹
		if(dhim_legacy_po_no == "4" && legacy_iv_serial == ""){ // IF발주에 LEGACY_IV_SERIAL 없는 것들
			alert("고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)");
			return;
		}else{
			rdParams.push({key:"fileName", value:"RD_06_S_001_164"});
			rdParams.push({key:"param", value:params});
			OpenReportPost(url, "REPORTPOP1", rdParams);
			rdParams = [];
		}
	}else if (sgid == "P08-0000011-104") { // SK마이크로웍스(KRSK--0001, KRSK--0002, KRSK--0003, KRSK--0004)
		rdParams.push({key:"fileName", value:"RD_06_S_001_165"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-105") { // 피유코어 주식회사(KRSKPU0001)
		rdParams.push({key:"fileName", value:"RD_06_S_001_166"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-106") { // 깨끗한나라(KRKLEA0003)
		rdParams.push({key:"fileName", value:"RD_06_S_001_173"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-107") { // (주)일진베어링, KRILJI0094
		rdParams.push({key:"fileName", value:"RD_06_S_001_175"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-108") { // 디알비동일(KRDRB-0004, KRDRB-0005, KRDRB-0006)
		rdParams.push({key:"fileName", value:"RD_06_S_001_176"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];		
	}else if (sgid == "P08-0000011-109") { // (주)일진, KRILJI0093
		rdParams.push({key:"fileName", value:"RD_06_S_001_174"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
		rdParams.push({key:"fileName", value:"RD_06_S_001_175"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP2", rdParams);
		rdParams = [];
	}else if (sgid == "P08-0000011-110") { // (주)종근당(KRCHON0034), 주식회사뉴라테온(KRNURA0001)
		rdParams.push({key:"fileName", value:"RD_06_S_001_167"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}else {
		// 리포트 디자이너 Sheet Open
		rdParams.push({key:"fileName", value:"RD_08_M_006_54"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "DEFAULT_REPORTPOP1", rdParams);
		rdParams = [];
		
		rdParams.push({key:"fileName", value:"RD_08_M_006_55"});
		rdParams.push({key:"param", value:params});
		OpenReportPost(url, "DEFAULT_REPORTPOP2", rdParams);
		rdParams = [];
	}

	/* 기본 출력과 함께 필요한 케이스 */
	if (sgid == "P08-0000011-101") { // 금호석유화학(KRKUMH0043~KRKUMH0053) 검수보고서 추가 출력
		rdParams.push({key:"fileName", value:"RD_06_S_001_161"});
		rdParams.push({key:"param", value:params1});
		OpenReportPost(url, "REPORTPOP1", rdParams);
		rdParams = [];
	}
	// 출력 end
}
