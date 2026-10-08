(function(){
  const calendar = document.createElement('div');
  calendar.id = 'calendarContainer';
  calendar.className = 'calendar';
  calendar.style.display = 'none';
  document.body.appendChild(calendar);

  calendar.innerHTML = `
    <div class="calendar-header">
      <button id="prevMonth"></button>
      <div>
        <select id="yearSelect"></select>
        <select id="monthSelect"></select>
      </div>
      <button id="nextMonth"></button>
    </div>
    <div class="weekdays" id="weekdays"></div>
    <div class="days" id="days"></div>
    <button class="Monthconfirm-btn" id="confirmMonth" style="display:none;">확인</button>
  `;

  const weekdaysKR = ['일','월','화','수','목','금','토'];
  const monthsKR = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
  const weekdaysEl = document.getElementById('weekdays');
  const daysEl = document.getElementById('days');
  const yearSelect = document.getElementById('yearSelect');
  const monthSelect = document.getElementById('monthSelect');
  const prevBtn = document.getElementById('prevMonth');
  const nextBtn = document.getElementById('nextMonth');
  const confirmBtn = document.getElementById('confirmMonth');
  
  let today = new Date();
  let current = new Date();
  let selectedDate = null;
  let activeInput = null;
  let isMonthPicker = false;
  let isYearPicker = false;

  function pad(n){return n<10?('0'+n):n;}
  function formatDate(d){ return `${d.getFullYear()}/${pad(d.getMonth()+1)}/${pad(d.getDate())}`; }
  function formatDatePlain(d){ return `${d.getFullYear()}${pad(d.getMonth()+1)}${pad(d.getDate())}`; }
  function formatYearMonth(d){ return `${d.getFullYear()}/${pad(d.getMonth()+1)}`; }
  function formatYear(d){ return `${d.getFullYear()}`; }
  function iso(d){ return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`; }

  function renderWeekdays(){
    weekdaysEl.innerHTML = weekdaysKR.map(w=>`<div>${w}</div>`).join('');
  }

  function fillYearMonthSelect(){
    const currentYear = today.getFullYear();
    let htmlY='';
    for(let y=currentYear-30;y<=currentYear+10;y++){htmlY+=`<option value="${y}">${y}</option>`;}
    yearSelect.innerHTML=htmlY;
    let htmlM='';
    for(let m=0;m<12;m++){htmlM+=`<option value="${m}">${monthsKR[m]}</option>`;}
    monthSelect.innerHTML=htmlM;
  }

  function renderCalendar(triggerInput){
	const input = triggerInput || activeInput;
	if(!input){
		return;
	}
    const year=current.getFullYear();
    const month=current.getMonth();
    yearSelect.value=year;
    monthSelect.value=month;
    if(isMonthPicker){
        weekdaysEl.style.display='none';
        daysEl.style.display='none';
        confirmBtn.style.display='block';
        monthSelect.style.display = '';
        return;
    }else if(isYearPicker){
    	weekdaysEl.style.display='none';
        daysEl.style.display='none';
        confirmBtn.style.display='block';
        monthSelect.style.display = 'none';
        return;
    }else{
    	weekdaysEl.style.display='grid';
    	daysEl.style.display='grid';
    	confirmBtn.style.display='none';
    	monthSelect.style.display = '';
    }
    
    const firstDay=new Date(year,month,1);
    const lastDate=new Date(year,month+1,0).getDate();
    const prevLastDate=new Date(year,month,0).getDate();
    const startDayIndex=firstDay.getDay();

    const cells=[];
    for(let i=startDayIndex-1;i>=0;i--){
      const d=prevLastDate-i;
      cells.push({day:d,other:true,date:new Date(year,month-1,d)});
    }
    for(let d=1;d<=lastDate;d++){
      cells.push({day:d,other:false,date:new Date(year,month,d)});
    }
    let nextMonthDay = 1;
    while(cells.length%7!==0){
//      const d=(cells.length%7)-startDayIndex+1;
      const d = nextMonthDay ++;
      cells.push({day:d,other:true,date:new Date(year,month+1,d)});
    }
    daysEl.innerHTML=cells.map(cell=>{
      const isToday=iso(cell.date)===iso(today);
      let isSelected=selectedDate && iso(cell.date)===iso(selectedDate);

      // 기간 선택: 시작일과 종료일 모두 selected 표시
      if(activeInput && !isSelected){
        const wrapper = activeInput.closest('.datepicker-wrap');
        if(wrapper){
          const inputs = wrapper.querySelectorAll('input[type="text"]');
          inputs.forEach(inp => {
            if(inp.value){
              const parts = inp.value.split('/');
              if(parts.length === 3){
                const inputDate = new Date(parts[0], parts[1]-1, parts[2]);
                if(iso(cell.date) === iso(inputDate)){
                  isSelected = true;
                }
              }
            }
          });
        }
      }

      const cls=['day'];
      if(cell.other) cls.push('other');
      if(isToday) cls.push('today');
      if(isSelected) cls.push('selected');
      return `<div class="${cls.join(' ')}" data-date="${iso(cell.date)}">${cell.day}</div>`;
    }).join('');
    daysEl.querySelectorAll('.day').forEach(el=>el.addEventListener('click',e=>{
      const d=new Date(e.target.dataset.date);
      selectedDate=d;
      if(activeInput){
    	  activeInput.value=formatDate(d);
    	  const hidden = activeInput.closest('[data-datepicker]')?.querySelector('input[type="hidden"]');
          if(hidden){
        	  hidden.value = formatDatePlain(d);
          }
          
          if(calendar._callback) calendar._callback(formatDatePlain(d));
          
          //해당 input의 onchange를 발동시키기 위함
          const event = new Event('change',{bubbles:true});
          activeInput.dispatchEvent(event);
          
      }
      closeCalendar();
    }));
  }

  window.openCalendar = openCalendar;
  function openCalendar(input,monthOnly=false,yearOnly=false,callback){
    activeInput=input;
    isMonthPicker=monthOnly;
    isYearPicker =yearOnly;
    const rect=input.getBoundingClientRect();
    calendar.style.top=rect.bottom+window.scrollY+8+(window.calendarPositionOffset?.top||0)+'px';
    calendar.style.left=rect.left+window.scrollX+(window.calendarPositionOffset?.left||0)+'px';
    calendar.style.display='block';
    let parts = input.value.split('/');
    if(parts.length === 3){
    	const y = parseInt(parts[0],10);
    	const m = parseInt(parts[1],10)-1;
    	const d = parseInt(parts[2],10);
    	selectedDate = new Date(y,m,d);
    	current = new Date(y,m,1);
    }else if(parts.length === 2){
    	const y = parseInt(parts[0],10);
    	const m = parseInt(parts[1],10)-1;
    	selectedDate = new Date(y,m,1);
    	current = new Date(y,m,1);
    }else{
    	if(isYearPicker){
    		if(input.value != ""){
    			const y = parseInt(input.value,10);
            	selectedDate = new Date(y,1,1);
            	current = new Date(y,1,1);
    		}else{
    			const y = parseInt(parts[0],10);
            	selectedDate = null;
            	current = new Date();
    		}
        	
        }else{
        	selectedDate = null;
        	current = new Date();
        }
    }
    renderCalendar();
    
    calendar._callback = callback;
  }
  window.openCalendar = openCalendar;
  
  $(document).on('dateChanged','[data-datepicker] input' , function(){
	  const input = this;
	  const val = $(input).val();
	  if(!val) return;
	  
	  const parts = val.split('/');
	  
	  const newDate = new Date(parts[0],parts[1]-1,parts[2]);
	  
	  selectedDate = newDate;
	  current = new Date(newDate);
	  
	  const wrapper = input.closest('[data-datepicker]');
	  const hidden = wrapper ? wrapper.querySelector('input[type=hidden]') : null;
	  if(hidden){
		  const hiddenVal = parts.join('');
		  hidden.value = hiddenVal;
	  }
	  activeInput = input;
	  renderCalendar(input);

  })
  
  confirmBtn.addEventListener('click',()=>{
    if(activeInput){
      if(isMonthPicker){
    	  const year=parseInt(yearSelect.value);
          const month=parseInt(monthSelect.value);
          const d=new Date(year,month,1);
          activeInput.value=formatYearMonth(d);
          
          selectedDate=d;
      }else{
    	  const year=parseInt(yearSelect.value);
          const d=new Date(year,1,1);
          activeInput.value=formatYear(d);
          
          selectedDate=d;
      }
    }
    closeCalendar();
  });
  
  function closeCalendar(){ calendar.style.display='none'; activeInput=null;isMonthPicker=false; isYearPicker=false }

  document.addEventListener('click',function(e){
	  const wrapper = e.target.closest('[data-datepicker]');
	  const wrapper2 = e.target.closest('[data-monthpicker]');
	  const wrapper3 = e.target.closest('[data-yearpicker]');
	  if(wrapper){
		  const input=wrapper.querySelector('input');
		  if(e.target.tagName.toLowerCase() === 'button'){
	    		return;
	    	}
	    	openCalendar(input,false,false);
	  }else if(wrapper2){
		  const input=wrapper2.querySelector('input');
		  openCalendar(input,true,false);
	  }else if(wrapper3){
		  const input=wrapper3.querySelector('input');
		  openCalendar(input,false,true);
	  }else if(!calendar.contains(e.target)){
		  closeCalendar();
	  }
  })

  prevBtn.addEventListener('click',(e)=>{ e.stopPropagation(); if(isYearPicker){current=new Date(current.getFullYear()-1,1,1);}else {current=new Date(current.getFullYear(),current.getMonth()-1,1);} renderCalendar(); });
  nextBtn.addEventListener('click',(e)=>{ e.stopPropagation(); if(isYearPicker){current=new Date(current.getFullYear()+1,1,1);}else {current=new Date(current.getFullYear(),current.getMonth()+1,1);} renderCalendar(); });
  yearSelect.addEventListener('change',(e)=>{ e.stopPropagation(); current=new Date(parseInt(yearSelect.value),current.getMonth(),1); renderCalendar(); });
  monthSelect.addEventListener('change',(e)=>{ e.stopPropagation(); current=new Date(current.getFullYear(),parseInt(monthSelect.value),1); renderCalendar(); });

  renderWeekdays();
  fillYearMonthSelect();
  
})();

