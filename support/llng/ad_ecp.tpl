<div class="row shdr shdr-green-white" data-toggle="collapse" data-target="#coll-main-ecp">
  <div class="col-sm-11">Электронная-цифровая подпись</div>
  <div class="col-sm-1 shdr-toggle">
    <span class="glyphicon glyphicon-menu-down" aria-hidden="true"></span>
  </div>
</div>

<div class="row compact marquee-space marquee-divider collapse in" id="coll-main-ecp">
  <div class="col-sm-12">
    <p>Управление ИТ оказывает содействие пользователям корпоративной сети в получении или продлении электронных-цифровых подписей по служебной необходимости.</p>
    <TMPL_IF ECP_NOTHING>
    <p><b>На Ваше Имя не было оформлено ни одной электронной-цифровой подписи.</b></p>
    <TMPL_ELSE>
    <TMPL_IF ECP1_TABLE>
    <p><b>На Ваше Имя</b> были выпущены следующие электронные-цифровые подписи (нажмите на подпись для подробностей):</p>
    <div class="row row-ecp-title">
      <div class="col-sm-1 col-ecp-img col-ecp-title"></div>
      <div class="col-sm-3 col-ecp-first col-ecp-title">Владелец сертификата</div>
      <div class="col-sm-2 col-ecp-title">Удостоверяющий центр</div>
      <div class="col-sm-2 col-ecp-title">Дата выпуска</div>
      <div class="col-sm-2 col-ecp-title">Дата окончания</div>
      <div class="col-sm-2 col-ecp-title">Статус</div>
    </div>

    <TMPL_LOOP ECP1_TABLE>
    <div class="row row-ecp" data-toggle="collapse" data-target="#collecp1-<TMPL_VAR ecp_id>">
      <div class="col-sm-1 col-ecp-img"><img src="/img/ecp-icon.png"></div>
      <div class="col-sm-3 col-ecp-first"><TMPL_VAR owner escape=html></div>
      <div class="col-sm-2"><TMPL_VAR issuer escape=html></div>
      <div class="col-sm-2"><TMPL_VAR date_issue escape=html></div>
      <div class="col-sm-2"><TMPL_VAR date_end escape=html></div>
      <div class="col-sm-2"><TMPL_VAR status escape=html></div>
    </div>
    <!--collapsible row-->
    <div class="row collapse row-ecp-collapse1" id="collecp1-<TMPL_VAR ecp_id>">
      <div class="col-sm-12">
        <div class="row row-ecp1">
          <div class="col-sm-12"><b>Подробная информация об электронной-цифровой подписи</b></div>
        </div>
        <div class="row row-ecp1">
          <div class="col-sm-4">Удостоверяющий центр:</div>
          <div class="col-sm-8"><TMPL_VAR issuer_full escape=html></div>
        </div>
        <div class="row row-ecp">
          <div class="col-sm-4">Основание закупки:</div>
          <div class="col-sm-8"><TMPL_VAR order escape=html></div>
        </div>
        <div class="row row-ecp">
          <div class="col-sm-4">Номер заявки в системе техподдержки:</div>
          <div class="col-sm-8"><TMPL_VAR ticket_no escape=html></div>
        </div>
        <TMPL_IF ECP1_ASSIGNMENTS_SUBTABLE>
        <div class="row row-ecp1">
          <div class="col-sm-12"><b>Сведения о выдаче Вам носителей с данной электронной-цифровой подписью</b></div>
        </div>
        <div class="row row-ecp-title">
          <div class="col-sm-1 col-ecp-img col-ecp-title">№</div>
          <div class="col-sm-2 col-ecp-title">Операция</div>
          <div class="col-sm-2 col-ecp-title">Носитель, серийный номер</div>
          <div class="col-sm-2 col-ecp-title">Дата и время операции</div>
          <div class="col-sm-2 col-ecp-title">Исполнитель</div>
          <div class="col-sm-3 col-ecp-title">Основание выдачи</div>
        </div>
        <TMPL_LOOP ECP1_ASSIGNMENTS_SUBTABLE>
        <div class="row row-ecp">
          <div class="col-sm-1 col-ecp-img"><TMPL_VAR __counter__></div>
          <div class="col-sm-2">Выдача под роспись Вам (владельцу)</div>
          <div class="col-sm-2"><TMPL_VAR token escape=html></div>
          <div class="col-sm-2"><TMPL_VAR date_assignment escape=html></div>
          <div class="col-sm-2"><TMPL_VAR user_it escape=html></div>
          <div class="col-sm-3"><TMPL_VAR order escape=html></div>
        </div>
        </TMPL_LOOP>
        </TMPL_IF>
      </div>
    </div>
    </TMPL_LOOP>
    </TMPL_IF>

    <TMPL_IF ECP2_TABLE>
    <p><b>Вам доверены</b> личные электронные-цифровые подписи следующих сотрудников (нажмите на подпись для подробностей):</p>
    <div class="row row-ecp-title">
      <div class="col-sm-1 col-ecp-img col-ecp-title"></div>
      <div class="col-sm-3 col-ecp-first col-ecp-title">Владелец сертификата</div>
      <div class="col-sm-2 col-ecp-title">Удостоверяющий центр</div>
      <div class="col-sm-2 col-ecp-title">Дата выпуска</div>
      <div class="col-sm-2 col-ecp-title">Дата окончания</div>
      <div class="col-sm-2 col-ecp-title">Статус</div>
    </div>
    <TMPL_LOOP ECP2_TABLE>
    <div class="row row-ecp" data-toggle="collapse" data-target="#collecp2-<TMPL_VAR ecp_id>">
      <div class="col-sm-1 col-ecp-img"><img src="/img/ecp-icon-blue.png"></div>
      <div class="col-sm-3 col-ecp-first"><TMPL_VAR owner escape=html></div>
      <div class="col-sm-2"><TMPL_VAR issuer escape=html></div>
      <div class="col-sm-2"><TMPL_VAR date_issue escape=html></div>
      <div class="col-sm-2"><TMPL_VAR date_end escape=html></div>
      <div class="col-sm-2"><TMPL_VAR status escape=html></div>
    </div>
    <!--collapsible row-->
    <div class="row collapse row-ecp-collapse2" id="collecp2-<TMPL_VAR ecp_id>">
      <div class="col-sm-12">
        <div class="row row-ecp1">
          <div class="col-sm-12"><b>Подробная информация об электронной-цифровой подписи</b></div>
        </div>
        <div class="row row-ecp1">
          <div class="col-sm-4">Удостоверяющий центр:</div>
          <div class="col-sm-8"><TMPL_VAR issuer_full escape=html></div>
        </div>
        <div class="row row-ecp">
          <div class="col-sm-4">Основание закупки:</div>
          <div class="col-sm-8"><TMPL_VAR order escape=html></div>
        </div>
        <div class="row row-ecp">
          <div class="col-sm-4">Номер заявки в системе техподдержки:</div>
          <div class="col-sm-8"><TMPL_VAR ticket_no escape=html></div>
        </div>
        <TMPL_IF ECP2_ASSIGNMENTS_SUBTABLE>
        <div class="row row-ecp1">
          <div class="col-sm-12"><b>Сведения о выдаче Вам носителей с данной электронной-цифровой подписью</b></div>
        </div>
        <div class="row row-ecp-title">
          <div class="col-sm-1 col-ecp-img col-ecp-title">№</div>
          <div class="col-sm-2 col-ecp-title">Операция</div>
          <div class="col-sm-2 col-ecp-title">Носитель, серийный номер</div>
          <div class="col-sm-2 col-ecp-title">Дата и время операции</div>
          <div class="col-sm-2 col-ecp-title">Исполнитель</div>
          <div class="col-sm-3 col-ecp-title">Основание выдачи, доверенность</div>
        </div>
        <TMPL_LOOP ECP2_ASSIGNMENTS_SUBTABLE>
        <div class="row row-ecp">
          <div class="col-sm-1 col-ecp-img"><TMPL_VAR __counter__></div>
          <div class="col-sm-2">Выдача под роспись по доверенности</div>
          <div class="col-sm-2"><TMPL_VAR token escape=html></div>
          <div class="col-sm-2"><TMPL_VAR date_assignment escape=html></div>
          <div class="col-sm-2"><TMPL_VAR user_it escape=html></div>
          <div class="col-sm-3"><TMPL_VAR order escape=html></div>
        </div>
        </TMPL_LOOP>
        </TMPL_IF>
      </div>
    </div>
    </TMPL_LOOP>
    </TMPL_IF>

    <TMPL_IF ECP3_TABLE>
    <p><b>Вы доверили свою личную</b> электронную-цифровую подпись следующим сотрудникам (нажмите на запись для подробностей о выдаче):</p>
    <div class="row row-ecp-title">
      <div class="col-sm-1 col-ecp-img col-ecp-title"></div>
      <div class="col-sm-3 col-ecp-first col-ecp-title">Ваша электронная подпись</div>
      <div class="col-sm-3 col-ecp-title">Кому доверена</div>
      <div class="col-sm-2 col-ecp-title">Дата, время выдачи</div>
      <div class="col-sm-3 col-ecp-title">Ваша доверенность сотруднику</div>
    </div>
    <TMPL_LOOP ECP3_TABLE>
    <div class="row row-ecp" data-toggle="collapse" data-target="#collecp3-<TMPL_VAR ecp_assignment_id>">
      <div class="col-sm-1 col-ecp-img"><img src="/img/ecp-dov.png"></div>
      <div class="col-sm-3 col-ecp-first"><TMPL_VAR ecp escape=html></div>
      <div class="col-sm-3"><TMPL_VAR user_to escape=html></div>
      <div class="col-sm-2"><TMPL_VAR date_assignment escape=html></div>
      <div class="col-sm-3"><TMPL_VAR dov escape=html></div>
    </div>
    <!--collapsible row-->
    <div class="row collapse row-ecp-collapse3" id="collecp3-<TMPL_VAR ecp_assignment_id>">
      <div class="col-sm-12">
        <div class="row row-ecp1">
          <div class="col-sm-12"><b>Подробные сведения о передаче Вашей электронной-цифровой подписи доверенному сотруднику</b></div>
        </div>
        <div class="row row-ecp1">
          <div class="col-sm-4">Дата и время:</div>
          <div class="col-sm-8"><TMPL_VAR date_assignment escape=html></div>
        </div>
        <div class="row row-ecp">
          <div class="col-sm-4">Носитель, серийный номер:</div>
          <div class="col-sm-8"><TMPL_VAR token escape=html></div>
        </div>
        <div class="row row-ecp">
          <div class="col-sm-4">Исполнитель:</div>
          <div class="col-sm-8"><TMPL_VAR user_it escape=html></div>
        </div>
        <div class="row row-ecp">
          <div class="col-sm-4">Основание выдачи:</div>
          <div class="col-sm-8"><TMPL_VAR order escape=html></div>
        </div>
        <div class="row row-ecp">
          <div class="col-sm-4">Номер заявки в системе техподдержки:</div>
          <div class="col-sm-8"><TMPL_VAR ticket_no escape=html></div>
        </div>
      </div>
    </div>
    </TMPL_LOOP>

    <p><span class="label label-warning">Внимание</span> Если Вы <b>НЕ доверяли</b> этим людям свою личную электронную-цифровую подпись, <b>немедленно</b> обратитесь в Группу сетевого администрирования.</p>
    </TMPL_IF>
    </TMPL_IF>

    <TMPL_IF SKZI_TABLE>
    <h3>Средства криптографической защиты информации</h3>
    <p>По служебной необходимости, Вам установлены следующие средства криптографической защиты информации (нажмите на строку для подробностей):</p>
    <div class="row row-ecp-title">
      <div class="col-sm-1 col-ecp-img col-ecp-title"></div>
      <div class="col-sm-2 col-ecp-first col-ecp-title">Имя компьютера</div>
      <div class="col-sm-2 col-ecp-title">СКЗИ, серийный номер</div>
      <div class="col-sm-2 col-ecp-title">Дата и время операции</div>
      <div class="col-sm-2 col-ecp-title">Исполнитель</div>
      <div class="col-sm-3 col-ecp-title">Основание установки</div>
    </div>

    <TMPL_LOOP SKZI_TABLE>
    <div class="row row-ecp" data-toggle="collapse" data-target="#collskzi-<TMPL_VAR sa_id>">
      <div class="col-sm-1 col-ecp-img"><img src="/img/token-icon.png"></div>
      <div class="col-sm-2 col-ecp-first"><TMPL_VAR comp escape=html></div>
      <div class="col-sm-2"><TMPL_VAR skzi escape=html></div>
      <div class="col-sm-2"><TMPL_VAR date_assignment escape=html></div>
      <div class="col-sm-2"><TMPL_VAR user_it escape=html></div>
      <div class="col-sm-3"><TMPL_VAR order escape=html></div>
    </div>
    <!--collapsible row-->
    <div class="row collapse row-ecp-collapse1" id="collskzi-<TMPL_VAR sa_id>">
      <div class="col-sm-12">
        <div class="row row-ecp1">
          <div class="col-sm-12"><b>Подробная информация о средстве криптографической защиты информации</b></div>
        </div>
        <div class="row row-ecp1">
          <div class="col-sm-4">Наименование:</div>
          <div class="col-sm-8"><TMPL_VAR skzi_name escape=html></div>
        </div>
        <div class="row row-ecp">
          <div class="col-sm-4">Производитель:</div>
          <div class="col-sm-8"><TMPL_VAR skzi_manufacturer escape=html></div>
        </div>
        <div class="row row-ecp">
          <div class="col-sm-4">Серийный номер (лицензионный код скрыт):</div>
          <div class="col-sm-8"><TMPL_VAR skzi_sn escape=html></div>
        </div>
        <div class="row row-ecp">
          <div class="col-sm-4">Местонахождение дистрибутива:</div>
          <div class="col-sm-8"><TMPL_VAR dist_placement escape=html></div>
        </div>
        <div class="row row-ecp">
          <div class="col-sm-4">Данные контроля целостности:</div>
          <div class="col-sm-8"><TMPL_VAR dist_checksum escape=html></div>
        </div>
      </div>
    </div>
    </TMPL_LOOP>
    </TMPL_IF>

    <TMPL_IF ECP_SECURITY_LABEL>
    <p><span class="label label-danger">Важно</span> Использование электронных-цифровых подписей и средств криптографической защиты информации
обязывает Вас <b>соблюдать правила информационной безопасности</b> при работе за компьютером.
Вы лично несёте ответственность за сохранность и конфиденциальность Вашей личной или доверенной Вам электронной-цифровой подписи.<br>
Подробнее можно прочитать в
<a href="https://faq.testdomain/lib/exe/fetch.php?media=ecp:instruction_infotecs.pdf">Руководстве по обеспечению безопасности использования электронной подписи</a>.
    </p>
    </TMPL_IF>
  </div>
</div>
