<TMPL_INCLUDE NAME="h.tpl">
<div class="container" id="header">
  <div class="row compact">
    <div class="col-xs-2" id="header-logo">
      <div style="width:235px;" id="bstr0">
        <a href="#"><img alt="Корпоративное облако" src="/img/uwc-cloud.png"></a>
      </div>
    </div>
    <div class="col-xs-10" id="userinfo-block">
      <div id="bstr1">
        <div class="data-col-first"><TMPL_VAR NAME="USER_DATA1"></div>
        <div class="data-col"><TMPL_VAR NAME="USER_DATA2"></div>
        <div class="data-col"><TMPL_VAR NAME="USER_DATA3"></div>
      </div>
    </div>
  </div>
</div>

<div class="container" id="navb">
  <nav class="navbar navbar-default nb-cust">
    <div class="container-fluid">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#nc1" aria-expanded="false">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <div class="navbar-brand" id="bstr2">
	  <TMPL_IF NAME="AUTH_ERROR">
	  <div class="br-<TMPL_VAR NAME="AUTH_ERROR_TYPE">"><TMPL_VAR NAME="AUTH_ERROR"></div>
	  </TMPL_IF>
        </div>
      </div>
      <div class="collapse navbar-collapse" id="nc1">
        <ul class="nav navbar-nav">
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Список приложений <span class="caret"></span></a>
	    <TMPL_IF NAME="DISPLAY_MODULES">
	    <TMPL_LOOP NAME="DISPLAY_MODULES">
	      <TMPL_IF NAME="Appslist">
	      <ul class="dropdown-menu" id="appslist">
	      <TMPL_LOOP NAME="APPSLIST_LOOP">
		<TMPL_IF NAME="category">
		  <li class="dropdown-header"><TMPL_VAR NAME="catname"></li>

		  <TMPL_IF NAME="applications">
		  <TMPL_LOOP NAME="applications">
		     <TMPL_IF NAME="applogo"></TMPL_IF>
		     <li><a href="<TMPL_VAR NAME="appuri">" <TMPL_IF NAME="appdesc">title="<TMPL_VAR NAME="appdesc">"</TMPL_IF>><TMPL_VAR NAME="appname"></a></li>
		  </TMPL_LOOP>
		  </TMPL_IF>

		  <TMPL_IF NAME="categories">
		  <TMPL_LOOP NAME="categories">
		    <li class="dropdown-header"><TMPL_VAR NAME="catname"></li>
		    
		    <TMPL_IF NAME="applications">
		    <TMPL_LOOP NAME="applications">
		       <TMPL_IF NAME="applogo"></TMPL_IF>
		       <li><a href="<TMPL_VAR NAME="appuri">" <TMPL_IF NAME="appdesc">title="<TMPL_VAR NAME="appdesc">"</TMPL_IF>><TMPL_VAR NAME="appname"></a></li>
		    </TMPL_LOOP>
		    </TMPL_IF>
		  </TMPL_LOOP>
		  </TMPL_IF>

		</TMPL_IF>

	      </TMPL_LOOP>
	      </ul>
	      </TMPL_IF>
	    </TMPL_LOOP>
	    </TMPL_IF>
          </li>
        </ul>
	<TMPL_IF DISPLAY_MODULES>
	<ul class="nav navbar-nav navbar-right">
	  <TMPL_LOOP NAME="DISPLAY_MODULES">
	    <!-- dont use Appslist and ChangePassword -->
	    <TMPL_IF NAME="Appslist"></TMPL_IF>
	    <TMPL_IF NAME="ChangePassword"></TMPL_IF>
	    <TMPL_IF NAME="LoginHistory">
	      <li><a href="#" id="loghist-link"><span class="glyphicon glyphicon-sunglasses" aria-hidden="true"></span>&nbsp;История логинов</a></li>
	    </TMPL_IF>
	    <TMPL_IF NAME="Logout">
	      <li>
                <a href="#" id="logout-link"><span class="glyphicon glyphicon-log-out" aria-hidden="true"></span>&nbsp;Выход</a>
              </li>
	    </TMPL_IF>
	  </TMPL_LOOP>
	</ul>
	</TMPL_IF>
      </div>
    </div>
  </nav>
</div>

<!--[if lte IE 7]>
<div class="container" id="errorb">
  <div class="alert alert-danger alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <b>Внимание!</b> Вы используете устаревшую версию Internet Explorer.<br>Для работы в Корпоративном облаке, с почтой и сервисами поддержки необходимо использовать современную программу просмотра Интернет.<br>Обратитесь в участок технического обслуживания для обновления Вашей версии Internet Explorer.
  </div>
</div>
<![endif]-->

<div class="container" id="main">
<TMPL_IF USER_ESV>
  <TMPL_INCLUDE NAME="ad_esv.tpl">
</TMPL_IF>

<TMPL_IF USER_ASU>
  <TMPL_INCLUDE NAME="ad_asu.tpl">
</TMPL_IF>

<TMPL_IF USER_HASEMAIL>
  <TMPL_IF USER_VALIDEMAIL>
    <TMPL_INCLUDE NAME="ad_mail.tpl">
  <TMPL_ELSE>
    <TMPL_INCLUDE NAME="ad_badmail.tpl">
  </TMPL_IF>
<TMPL_ELSE>
  <TMPL_INCLUDE NAME="ad_nomail.tpl">
</TMPL_IF>

<TMPL_IF USER_ECP>
  <TMPL_INCLUDE NAME="ad_ecp.tpl">
</TMPL_IF>

<TMPL_IF USER_SHARES>
  <TMPL_INCLUDE NAME="ad_shares.tpl">
</TMPL_IF>

<TMPL_IF USER_AD>
  <TMPL_IF USER_SKUD>
    <TMPL_INCLUDE NAME="ad_skud.tpl">
  </TMPL_IF>
</TMPL_IF>

<TMPL_IF USER_AD>
  <TMPL_INCLUDE NAME="ad_inet.tpl">
</TMPL_IF>

<TMPL_UNLESS USER_ASU>
  <TMPL_IF USER_AD>
    <TMPL_INCLUDE NAME="ad_supp.tpl">
  <TMPL_ELSE>
    <TMPL_INCLUDE NAME="ad_supp_faqonly.tpl">
  </TMPL_IF>
<TMPL_ELSE>
  <TMPL_INCLUDE NAME="ad_supp_faqonly.tpl">
</TMPL_UNLESS>
</div>

<div class="modal" id="loghist-block" tabindex="-1" role="dialog" aria-labelledby="loghistlabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="loghistlabel">История входов в сеть под логином <TMPL_VAR NAME="AUTH_USER"></h4>
      </div>
      <div class="modal-body">
	<TMPL_IF DISPLAY_MODULES>
	<TMPL_LOOP NAME="DISPLAY_MODULES">
	  <TMPL_IF NAME="ChangePassword">
	    <!-- Changing password is not supported -->
	  </TMPL_IF>
	  <TMPL_IF NAME="LoginHistory">
	    <div>
	      <TMPL_IF NAME="SUCCESS_LOGIN">
		<h3 class="text-success">Последние удачные входы в сеть</h3>
		<TMPL_VAR NAME="SUCCESS_LOGIN">
	      </TMPL_IF>
	      <TMPL_IF NAME="FAILED_LOGIN">
		<h3 class="text-danger">Последние неудачные входы</h3>
		<TMPL_VAR NAME="FAILED_LOGIN">
	      </TMPL_IF>
              <p><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>&nbsp;Если Вы обнаружили, что кто-то другой заходил в сеть под вашей учётной записью и паролем, 
Вам необходимо <a href="https://faq.testdomain/doku.php?id=net:смена_пароля" target="_blank">сменить пароль</a> и связаться с администраторами сети предприятия.</p>
	    </div>
	  </TMPL_IF>
	</TMPL_LOOP>
	</TMPL_IF>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
  </div>
</div>


<TMPL_INCLUDE NAME="f0.tpl">

<!-- demo -->
<link href="/css/bootstro.min.css" rel="stylesheet">
<script src="/js/bootstro.min.js"></script>
<script src="/js/js.cookie.js"></script>

<script>
$(document).ready(function(){
  $('#logout-link').click(function(){$('#userinfo-block').popover('show');});
  $('#loghist-link').click(function(){$('#loghist-block').modal('show');});
  $('.shdr').click(function(){
    if ($(this).hasClass('collapsed')) {
      $(this).find('span.glyphicon').removeClass('glyphicon-menu-right');
      $(this).find('span.glyphicon').addClass('glyphicon-menu-down');
    } else {
      $(this).find('span.glyphicon').removeClass('glyphicon-menu-down');
      $(this).find('span.glyphicon').addClass('glyphicon-menu-right');
    }
  });
  $('#userinfo-block').popover({template: '<div class="popover" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="logout-content" style="min-width:270px;"><p>Можно не выходить из сети, а просто закрыть окно обозревателя Интернет. Тогда при следующем запуске Вы продолжите работать без повторного ввода имени пользователя и пароля.</p><p>Время от времени мы будем перезапрашивать Ваш пароль, так как этого требует безопасность.</p><button type="button" class="btn btn-primary" onclick="pop_hide()" style="margin-right:15px;">Отмена</button><a href="<TMPL_VAR NAME="LOGOUT_URL">" class="btn btn-default" role="button">Выход</a></div></div>', placement:"bottom", trigger:"manual", title:"Вы точно хотите выйти?", content:"1"});
  if(!navigator.userAgent.match(/(Trident|MSIE)/)) {
    $('a.winshare').click(function(){alert("Ссылка на сетевые каталоги Windows работает только из MS Internet Explorer, но вы можете скопировать ссылку в окно Проводника.");});
  }

  var _bstr=Cookies.get('netuwc-intro-completed'),_au='<TMPL_VAR NAME="AUTH_USER">',_reau=new RegExp(_au,'i');
  if (!_reau.test(_bstr)){bootstro.start('', {url:'/js/pp_maindemo.json', stopOnBackdropClick:false, nextButtonText:'Продолжить >>', prevButtonText:'<< Назад', finishButton:'<button class="btn btn-mini btn-default bootstro-finish-btn">Завершить обучение</button>', onExit:function(p){Cookies.set('netuwc-intro-completed',(_bstr)?_bstr+_au:_au,{expires:99999});}});}
});
function pop_hide(){$('#userinfo-block').popover('hide');}
</script>
<TMPL_IF NAME="PING">
  <!-- Keep session alive -->
  <script type="text/javascript">
    setTimeout('ping();',pingInterval);
  </script>
</TMPL_IF>

<TMPL_INCLUDE NAME="f.tpl">

