function calluComposer() {
	var url = "/uComposer/uComposerAction.do?SerivecName=uComposerAction-service";
	location.href = url;
}


function callDistribute() {
	var url = "/uComposer/distributeListAction.do?ServiceName=distributeList-service&find.x=1";
	location.href = url;
}


function callDistributeHistory() {
	var url = "/uComposer/distributeHistoryAction.do?ServiceName=distributeHistory-service&find.x=1";
	location.href = url;
}
