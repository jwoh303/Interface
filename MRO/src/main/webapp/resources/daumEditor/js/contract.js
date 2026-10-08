TrexConfig.addTool("contract", {
	sync : false,
	status : true,
	options : [ {
		label : '선택',
		title : '선택',
		type : 'select',
		data : 'select',
		klass : 'tx-contract-input-0'
	}, {
		label : '텍스트입력',
		title : '텍스트입력',
		type : 'textInput000',
		data : 'textInput000',
		klass : 'tx-contract-input-1'
	}, {
		label : '숫자입력',
		title : '숫자입력',
		type : 'numbInput000',
		data : 'numbInput000',
		klass : 'tx-contract-input-1'
	}, {
		label : '날짜입력',
		title : '날짜입력',
		type : 'dateInput000',
		data : 'dateInput000',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약명',
		title : '계약명',
		type : 'textInput001',
		data : 'textInput001',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약시작년도',
		title : '계약시작년도',
		type : 'dateInput001',
		data : 'dateInput001',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약시작월',
		title : '계약시작월',
		type : 'dateInput002',
		data : 'dateInput002',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약시작일',
		title : '계약시작일',
		type : 'dateInput003',
		data : 'dateInput003',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약종료년도',
		title : '계약종료년도',
		type : 'dateInput004',
		data : 'dateInput004',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약종료월',
		title : '계약종료월',
		type : 'dateInput005',
		data : 'dateInput005',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약종료일',
		title : '계약종료일',
		type : 'dateInput006',
		data : 'dateInput006',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약번호',
		title : '계약번호',
		type : 'textInput002',
		data : 'textInput002',
		klass : 'tx-contract-input-1'
	}, {
		label : '공급물품',
		title : '공급물품',
		type : 'textInput003',
		data : 'textInput003',
		klass : 'tx-contract-input-1'
	}, {
		label : '대금지급조건',
		title : '대금지급조건',
		type : 'textInput004',
		data : 'textInput004',
		klass : 'tx-contract-input-1'
	}, {
		label : '지체상금',
		title : '지체상금',
		type : 'textInput005',
		data : 'textInput005',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약년도',
		title : '계약년도',
		type : 'dateInput007',
		data : 'dateInput007',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약월',
		title : '계약월',
		type : 'dateInput008',
		data : 'dateInput008',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약일',
		title : '계약일',
		type : 'dateInput009',
		data : 'dateInput009',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약금',
		title : '계약금',
		type : 'numbInput001',
		data : 'numbInput001',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약금(한글)',
		title : '계약금(한글)',
		type : 'textInput007',
		data : 'textInput007',
		klass : 'tx-contract-input-1'
	}, {
		label : '업체주소',
		title : '업체주소',
		type : 'textInput101',
		data : 'textInput101',
		klass : 'tx-contract-input-1'
	}, {
		label : '업체명',
		title : '업체명',
		type : 'textInput102',
		data : 'textInput102',
		klass : 'tx-contract-input-1'
	}, {
		label : '업체대표자명',
		title : '업체대표자명',
		type : 'textInput103',
		data : 'textInput103',
		klass : 'tx-contract-input-1'
	}, {
		label : '운영사주소',
		title : '운영사주소',
		type : 'textInput201',
		data : 'textInput201',
		klass : 'tx-contract-input-1'
	}, {
		label : '운영사명',
		title : '운영사명',
		type : 'textInput202',
		data : 'textInput202',
		klass : 'tx-contract-input-1'
	}, {
		label : '운영사대표',
		title : '운영사대표',
		type : 'textInput203',
		data : 'textInput203',
		klass : 'tx-contract-input-1'
	}, {
		label : '별첨',
		title : '별첨',
		type : 'areaInput001',
		data : 'areaInput001',
		klass : 'tx-contract-input-1'
	}, {
		label : '계약방법',
		title : '계약방법',
		type : 'selcInput001',
		data : 'selcInput001',
		klass : 'tx-contract-input-1'
	}, {
		label : '대금결정방식',
		title : '대금결정방식',
		type : 'selcInput002',
		data : 'selcInput002',
		klass : 'tx-contract-input-1'
	}, {
		label : '대금지급조건',
		title : '대금지급조건',
		type : 'selcInput003',
		data : 'selcInput003',
		klass : 'tx-contract-input-1'
	}, {
		label : '인도조건',
		title : '인도조건',
		type : 'selcInput004',
		data : 'selcInput004',
		klass : 'tx-contract-input-1'
	}, {
		label : '납품장소',
		title : '납품장소',
		type : 'selcInput005',
		data : 'selcInput005',
		klass : 'tx-contract-input-1'
	}
	]
});

Trex.Tool.Contract = Trex.Class.create( {
	$const : {
		__Identity : 'contract'
	},
	$extend : Trex.Tool,
	$mixins : [ Trex.I.ListExecution ],
	oninitialized : function(config) {

		var _tool = this;
		var _toolbar = this.toolbar;
		var _canvas = this.canvas;

		var _defaultProperty = "decimal";
		var _map = {};
		
		config.options.each(function(option) {
			_map[option.data] = {
				type : option.type,
				klass : option.klass,
				title : option.title
			};
		});

		var _getClassByValue = function(value) {
			//alert('_getClassByValue');
			if (_map[value]) {
				return _map[value].klass;
			} else {
				return _map[_defaultProperty].klass;
			}
		};

		var _toolHandler = function(data) {
			if (!_map[data]) {
				return;
			}
			var _type = _map[data].type;
			var _class = _map[data].klass;
			var _title = _map[data].title;
			var _attributes = {
				'style' : {
					'listStyleType' : data
				}
			};

			_canvas.execute(function(processor) {
				var _html = "";
				
				if (_type.substring(0,9) == "textInput" ||
					_type.substring(0,9) == "dateInput" ||
					_type.substring(0,9) == "numbInput" ) {
					_html = '<input type=text id=\"' + _type  + '\" value=' + _title
						+ ' style=\"font-size=9px;background-color=#FFFF66; \" name=\"' + _type + '\" title=\"' + _title + '\"  >';
				} else if (_type.substring(0,9) == "areaInput"){
					_html = '<textarea  id=\"' + _type  + '\" style=\"font-size=9px;background-color=#FFFF66; \" name=\"' + _type + '\" title=\"' + _title + '\" >' + _title + '</textarea>';
				}
				
				if (_type == "selcInput001"){
					_html =  '<select  id=\"' + _type  + '\" style=\"font-size=9px;background-color=#FFFF66; \" name=\"' + _type + '\" title=\"' + _title + '\" >';
					_html += '<option value=\"경쟁(제한,지명,공개)\">경쟁(제한,지명,공개)</option>';
					_html += '<option value=\"수의(특정,소액)\">수의(특정,소액)</option>';
					_html += '</select>';
				} else if (_type == "selcInput002"){
					_html =  '<select  id=\"' + _type  + '\" style=\"font-size=9px;background-color=#FFFF66; \" name=\"' + _type + '\" title=\"' + _title + '\" >';
					_html += '<option value=\"고정단가 계약\">고정단가 계약</option>';
					_html += '<option value=\"고정할인율 계약\">고정할인율 계약</option>';
					_html += '<option value=\"총액 계약\">총액 계약</option>';
					_html += '<option value=\"고정수수료 계약\">고정수수료 계약</option>';
					_html += '</select>';
				} else if (_type == "selcInput003"){
					_html =  '<select  id=\"' + _type  + '\" style=\"font-size=9px;background-color=#FFFF66; \" name=\"' + _type + '\" title=\"' + _title + '\" >';
					_html += '<option value=\"KeP조건결제\">KeP조건결제</option>';
					_html += '<option value=\"구매사조건결제\">구매사조건결제</option>';
					_html += '</select>';
				} else if (_type == "selcInput004"){
					_html =  '<select  id=\"' + _type  + '\" style=\"font-size=9px;background-color=#FFFF66; \" name=\"' + _type + '\" title=\"' + _title + '\" >';
					_html += '<option value=\"출하지차상도\">출하지차상도</option>';
					_html += '<option value=\"창고도착도\">창고도착도</option>';
					_html += '<option value=\"납품지차상도\">납품지차상도</option>';
					_html += '<option value=\"설치도\">설치도</option>';
					_html += '</select>';
				} else if (_type == "selcInput005"){
					_html =  '<select  id=\"' + _type  + '\" style=\"font-size=9px;background-color=#FFFF66; \" name=\"' + _type + '\" title=\"' + _title + '\" >';
					_html += '<option value=\"지정창고\">지정창고</option>';
					_html += '<option value=\"구매사 지정장소\">구매사 지정장소</option>';
					_html += '</select>';
				} 

				processor.pasteContent(_html, false);

				});
		};

		var _initHandler = function() {
			var _insideList = _canvas.query(function(processor) {
				return !!processor.findNode('%listhead');
			});
			var _elCancel = $tom.collect(_tool.menu.elMenu, 'li');
			if (_insideList) {
				$tx.show(_elCancel);
			} else {
				$tx.hide(_elCancel);
			}
		};

		/* button & menu weave */
		this.weave.bind(this)(
			/* button */
			new Trex.Button.Select(this.buttonCfg),
			/* menu */
			new Trex.Menu.Select(this.menuCfg),
			/* handler */
			_toolHandler,
			_initHandler
		);
			
			/**
		var _cachedProperty = _defaultProperty; 
		_canvas.observeJob(Trex.Ev.__CANVAS_PANEL_QUERY_STATUS, function() {
			var _data = _canvas.query(function(processor) {
				var _node = processor.findNode('%listhead');
				return processor.queryStyle(_node, 'listStyleType');
			});
			_data = _data || _defaultProperty;
			if(_cachedProperty == _data) {
				return;
			}

			var _text = _getClassByValue(_data);
			_tool.button.setText(_text);
			_cachedProperty = _data;
		});

		_canvas.observeKey({ // ctrl + alt + u
			ctrlKey: true,
			altKey: true,
			shiftKey: false,
			keyCode: 85
		}, _toolHandler.bind(this, "disc"));

		_canvas.observeKey({ // ctrl + alt + o
			ctrlKey: true,
			altKey: true,
			shiftKey: false,
			keyCode: 79
		}, _toolHandler.bind(this, "decimal"));
		*/
	}
	
});



