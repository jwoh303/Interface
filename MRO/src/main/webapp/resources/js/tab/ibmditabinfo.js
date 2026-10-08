/**
 * 2020-12-27
 * ibmditab 라이선스 체크 로직 버그로 인하여 라이선스를 이쪽으로 옮김
 * ibsheet 배선영 차장.
 * */
/*var ibleaders;
ibleaders = ibleaders || {};

ibleaders = {
    /**
     * license
     *
     * 개발 도메인 :  ht*://tomatobo.scanbuy.co.kr/
     * 제안사항   : 2021-05-28 까지 (1년)
     
		     
    license:"W2FtSztPKCFwazYxYjJxbn9NNREsHjUkd20kO217dyR9ckhmAndSOnx2d2wtLDl+MnZzS28TYx16Z3kjZD1uNmFuIGxTMllgByMoaDtne3J0OXFkNBZiT2ZAICZhPCpoKiYkKnhsFXQCcEw0MmQ1ZSgxKC19KzYCZwRkRDNtPi94bn83NSBhNRg+SykPYzA5bWcsdzh+bH8/Q3QQMB5mI2RnPXpkZ2F+PSABfB97UngpPy1mY2E1dCM3eldjHW8bdnk2fi5uKDJ5Z3wuE2tddl09ZmAmaz4+PzpnamlWM0tgTSh6bT5maXI+MiNhMRdwTy1DcX8qaj0zMnstKm4hRHkZNx1mJ2spOXQlMGEjc39FawpzEXp7ey0+KGFiYCJ3Ik8xXHULcGk5MnwgbikzLSsoGTlHNU0n"
};*/


// for IBMDITab
// nTabType = 0 : IBMDITab
// nTabType = 1 : IBTab
function createIBMDITab(id, width, height, strTheme, nTabType) {
	var div_str = "";
    div_str += "<div class='cIBTabMainDiv' id='DIV_" + id + "' style='width:" + width + ";height:" + height + ";'>														\n";
    div_str += "<script> IBTab('" + id + "', '" + nTabType + "','" + width + "','" + height + "','" + strTheme + "'); </script>";
	div_str += "</div>\n";

	//<![CDATA[
    document.write(div_str);
	//]]>

	window[id] =IBTabs[id];
}

function createIBTab(id, width, height, strTheme, nTabType) {
	var div_str = "";
    div_str += "<div class='cIBTabMainDiv' id='DIV_" + id + "' style='width:" + width + ";height:" + height + ";'>														\n";
    div_str += "<script> IBTab('" + id + "', '" + nTabType + "','" + width + "','" + height + "','" + strTheme + "'); </script>";
	div_str += "</div>\n";

	//<![CDATA[
    document.write(div_str);
	//]]>

	window[id] =IBTabs[id];
}

// 컨트롤에서 사용하는 문자열 정리
IBTAB7_MSG_000 = "_OnLoad() 함수가 없습니다.";
IBTAB7_MSG_001 = "는 탭이 없는 경우에만 설정 가능합니다.";
IBTAB7_MSG_002 = "는 0 보다 큰 값을 설정해야 합니다.";
IBTAB7_MSG_003 = "는 left, center, right 값 중 하나로 설정 가능합니다.";
IBTAB7_MSG_004 = "는 모바일 기기에서 탭이 없는 경우에만 설정 가능합니다.";
IBTAB7_MSG_005 = "더 이상 탭을 추가할 수 없습니다.";
IBTAB7_MSG_006 = "[IB Sheet 7] License is not valid.";
IBTAB7_MSG_007 = "[IB Sheet 7] License has expired.";
IBTAB7_MSG_008 = "컨트롤 구성요소 너비 지정에 문제가 발생했습니다.";

IBTAB7_LicenseFileName = "license";
