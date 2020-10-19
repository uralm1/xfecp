#!/usr/bin/perl

use Lemonldap::NG::Portal::SharedConf;
use HTML::Template;
use Encode;
use strict;
use warnings;
use feature ':5.10';

use Mojo::mysql;

my $portal = Lemonldap::NG::Portal::SharedConf->new(
    {
        # ACCESS TO CONFIGURATION
        # By default, Lemonldap::NG uses the default lemonldap-ng.ini file to
        # know where to find its configuration
        # (generaly /etc/lemonldap-ng/lemonldap-ng.ini)
        # You can specify by yourself this file :
        #configStorage => { confFile => '/path/to/my/file' },
        # or set explicitely parameters :
        #configStorage => {
        #  type => 'File',
        #  dirName => '/usr/local/lemonldap-ng/data//conf'
        #},
        # Note that YOU HAVE TO SET configStorage here if you've declared this
        # portal as SOAP configuration server in the manager

        # OTHERS
        # You can also overload any parameter issued from manager
        # configuration. Example:
        #globalStorage => 'Apache::Session::File',
        #globalStorageOptions => {
        #  'Directory' => '/var/lib/lemonldap-ng/sessions/',
        #  'LockDirectory' => '/var/lib/lemonldap-ng/sessions/lock/',
        #},
        # Note that YOU HAVE TO SET globalStorage here if you've declared this
        # portal as SOAP session server in the manager
    }
);

# Get skin and template parameters
my ( $templateName, %templateParams ) = $portal->display();

# HTML template creation
my $template = HTML::Template->new(
  filename          => "$templateName",
  path              => $portal->getApacheHtdocsPath().'/ads',
  die_on_bad_params => 0,
  cache             => 1, #cache in memory 90% speed
  global_vars       => 1,
  loop_context_vars => 1,
  filter            => [
    sub { $portal->translate_template(@_) },
    sub { $portal->session_template(@_) }
  ],
);

if ($templateName =~ /menu\.tpl$/i) {
  # Userinfo params
  my $uid = decode_utf8($portal->{sessionInfo}->{uid});
  my $cn = decode_utf8($portal->{sessionInfo}->{cn});
  my $title = decode_utf8($portal->{sessionInfo}->{title});
  my $room = decode_utf8($portal->{sessionInfo}->{room});
  my $phone = decode_utf8($portal->{sessionInfo}->{phone});
  my $mail = decode_utf8($portal->{sessionInfo}->{mail});
  my $l2;
  if ($uid =~ /.*\@testdomain$/i) { 
    $l2 = decode_utf8("Ограниченный вход для недоменных пользователей"); # old DBI logins
    $templateParams{USER_AD} = 0;
  } else {
    my @l2; # Kerberos logins
    push(@l2, $title) if $title;
    push(@l2, decode_utf8('к.').$room) if $room;
    push(@l2, decode_utf8('т.').$phone) if $phone;
    $l2 = join(', ', @l2);
    $l2 = ($l2) ? decode_utf8('<div title="Если данные неверны, пожалуйста подайте заявку в группу сетевого администрирования">').$l2.'</div>' : decode_utf8("<a href=\"https://otk.testdomain/otrs/customer.pl\" target=\"_blank\" title=\"Сообщите в группу сетевого администрирования\">Информация о пользователе недоступна</a>");
    $templateParams{USER_AD} = 1;
    $templateParams{USER_LOGIN} = lc($uid);
  }
  $templateParams{USER_DATA1} = ($cn) ? "$cn ($uid)" : $uid;
  $templateParams{USER_DATA2} = $l2;
  my $l3;
  if ($mail) {
    $templateParams{USER_HASEMAIL} = 1;
    # USER_EMAIL for ad mail-badmail.tpl
    $templateParams{USER_EMAIL} = $mail;

    if ($mail eq $uid || $mail =~ /^\Q$uid\E@/i) {
      $l3 = "<a href=\"https://rc.testdomain\" target=\"_blank\">$mail</a>";
      $templateParams{USER_VALIDEMAIL} = 1;
    } else {
      $l3 = decode_utf8("<span style=\"color:#f00000;\" title=\"Имя пользователя для входа на Ваш ящик почты не совпадает с текущим именем пользователя в облаке\">").$mail.decode_utf8(' (недоступен)</span>');
      $templateParams{USER_VALIDEMAIL} = 0;
    }
  } else {
    # no email
    $templateParams{USER_HASEMAIL} = 0;
    $l3 = "";
  }
  $templateParams{USER_DATA3} = $l3;

  # ESV
  if ($uid eq 'cds_tech@testdomain' or 
    $uid eq 'cdsdisp' or 
    $uid eq 'ural'
  ) {
    $templateParams{USER_ESV} = 1;
  }

  # ASU 
  my $groups = $portal->{sessionInfo}->{groups};
  if ($groups && $groups =~ /\bOTRS\.Agents\b/i) { 
    $templateParams{USER_ASU} = 1;
  }

  # ECP
  if ($templateParams{USER_LOGIN}) {
    eval {
      &read_ecp_db(\%templateParams);
    };
    $templateParams{USER_ECP} = 1 unless $@;
    #$templateParams{USER_ECP} = 1;
  }

  # Shares
  if ($uid eq 'ural') {
    $templateParams{USER_SHARES} = 1;
  }

  # Skud
  #if ($uid eq 'ural' or $uid eq 'valera') {
  $templateParams{USER_SKUD} = 1;
  #}

}#if ($templateName =~ /menu\.tpl$/i)

# Give parameters to the template
while ( my ( $k, $v ) = each %templateParams ) {
    $template->param( $k => $v );
}

# Display it
#my $oldfh = select;
#$portal->lmLog("*** output $oldfh", 'debug');
print $portal->header('text/html; charset=utf-8');
print $template->output;

exit 0;

#--------------------------------------------------
no warnings qw(redefine);
sub read_ecp_db {
  my $tp_ref = shift; #templateParams

  $tp_ref->{ECP_NOTHING} = 0;
  $tp_ref->{ECP_SECURITY_LABEL} = 0;
  my $mysql_pdata = Mojo::mysql->new('mysql://user:pass@dbserver/pdata');
  my $db = $mysql_pdata->db;
  # get user_id from $tp_ref->{USER_LOGIN}
  my $ulogin = $tp_ref->{USER_LOGIN};
  ###$ulogin = 'testuser' if $ulogin eq 'ural'; # for debug
  my $res = $db->query("SELECT id FROM users_cache WHERE login = ?", $ulogin);
  if ($res->rows == 0) {
    $res->finish;
    $tp_ref->{ECP_NOTHING} = 1;
    return;
  }
  my $user_id = $res->array->[0];
  $res->finish;

  # ecp1
  $res = $db->query("SELECT e.id AS ecp_id, \
    CONCAT_WS('/', NULLIF(e.owner_ul,''), u.fio) AS owner, \
    i.name AS issuer, \
    CONCAT_WS(', ', i.name, NULLIF(i.address,'')) AS issuer_full, \
    DATE_FORMAT(e.date_issue, '%e.%m.%y') AS date_issue, \
    DATE_FORMAT(e.date_end, '%e.%m.%y') AS date_end, \
    CASE e.status WHEN 1 THEN 'Действительна' WHEN 2 THEN 'Отозвана' WHEN 3 THEN 'Просрочена' ELSE 'Неопределен' END AS status, \
    CONCAT_WS(' ', CASE o.type WHEN 1 THEN 'Служебная записка' WHEN 2 THEN 'Приказ' ELSE 'Прочее' END, CONCAT('№', o.n), DATE_FORMAT(o.date, '%e.%m.%y'), o.text) AS `order`, \
    e.ticket_no AS ticket_no \
    FROM ecps e \
    INNER JOIN users_cache u ON u.id = e.owner_fl_id \
    LEFT JOIN issuers i ON i.id = e.issuer_id \
    LEFT JOIN orders o ON o.id = e.order_id \
    WHERE e.owner_fl_id = ? ORDER BY e.date_issue ASC", 
    $user_id);
  $tp_ref->{ECP1_TABLE} = $res->hashes->to_array;
  $res->finish;

  # retrive ecp assignments
  foreach my $href (@{$tp_ref->{ECP1_TABLE}}) {
    my $res = $db->query("SELECT \
      CONCAT_WS(', ', tt.type, t.sn) AS token, \
      DATE_FORMAT(ea.date_assignment, '%e.%m.%y %H:%i') AS date_assignment, \
      CONCAT_WS(', ', uit.title, uit.fio) AS user_it, \
      CONCAT_WS(', номер заявки: ', CONCAT_WS(' ', CASE o.type WHEN 1 THEN 'Служебная записка' WHEN 2 THEN 'Приказ' ELSE 'Прочее' END, CONCAT('№', o.n), DATE_FORMAT(o.date, '%e.%m.%y'), o.text), ea.ticket_no) AS `order` \
      FROM ecp_assignments ea \
      LEFT JOIN tokens t ON t.id = ea.token_id \
      LEFT JOIN token_types tt ON tt.id = t.type_id \
      LEFT JOIN users_cache uit ON uit.id = ea.user_it_id \
      LEFT JOIN orders o ON o.id = ea.order_id \
      WHERE ea.ecp_id = ? AND ea.user_to_id = ? ORDER BY ea.date_assignment ASC", 
      $href->{ecp_id}, $user_id);
    $href->{ECP1_ASSIGNMENTS_SUBTABLE} = $res->hashes->to_array;
    $res->finish;
  }

  # ecp2
  $res = $db->query("SELECT DISTINCT e.id AS ecp_id, \
    CONCAT_WS('/', NULLIF(e.owner_ul,''), u.fio) AS owner, \
    i.name AS issuer, \
    CONCAT_WS(', ', i.name, NULLIF(i.address,'')) AS issuer_full, \
    DATE_FORMAT(e.date_issue, '%e.%m.%y') AS date_issue, \
    DATE_FORMAT(e.date_end, '%e.%m.%y') AS date_end, \
    CASE e.status WHEN 1 THEN 'Действительна' WHEN 2 THEN 'Отозвана' WHEN 3 THEN 'Просрочена' ELSE 'Неопределен' END AS status, \
    CONCAT_WS(' ', CASE o.type WHEN 1 THEN 'Служебная записка' WHEN 2 THEN 'Приказ' ELSE 'Прочее' END, CONCAT('№', o.n), DATE_FORMAT(o.date, '%e.%m.%y'), o.text) AS `order`, \
    e.ticket_no AS ticket_no \
    FROM ecp_assignments ea \
    INNER JOIN ecps e ON e.id = ea.ecp_id \
    INNER JOIN users_cache u ON u.id = e.owner_fl_id \
    LEFT JOIN issuers i ON i.id = e.issuer_id \
    LEFT JOIN orders o ON o.id = e.order_id \
    WHERE ea.user_to_id = ? AND e.owner_fl_id <> ? \
    ORDER BY e.date_issue ASC",
    $user_id, $user_id);
  $tp_ref->{ECP2_TABLE} = $res->hashes->to_array;
  $res->finish;

  # retrive ecp assignments
  foreach my $href (@{$tp_ref->{ECP2_TABLE}}) {
    my $res = $db->query("SELECT \
      CONCAT_WS(', ', tt.type, t.sn) AS token, \
      DATE_FORMAT(ea.date_assignment, '%e.%m.%y %H:%i') AS date_assignment, \
      CONCAT_WS(', ', uit.title, uit.fio) AS user_it, \
      CONCAT_WS(', ', CONCAT_WS(', номер заявки: ', CONCAT_WS(' ', CASE o.type WHEN 1 THEN 'Служебная записка' WHEN 2 THEN 'Приказ' ELSE 'Прочее' END, CONCAT('№', o.n), DATE_FORMAT(o.date, '%e.%m.%y'), o.text), ea.ticket_no), \
        IF(ea.dov_id, CONCAT('выдано по доверенности №', d.n, ' от: ', ud_issuer.fio, ', кому: ', ud_to.fio, ', с: ', DATE_FORMAT(d.date_issue, '%e.%m.%y'), ', по: ', DATE_FORMAT(d.date_upto, '%e.%m.%y')), 'выдано без доверенности')) AS `order` \
      FROM ecp_assignments ea \
      LEFT JOIN tokens t ON t.id = ea.token_id \
      LEFT JOIN token_types tt ON tt.id = t.type_id \
      LEFT JOIN users_cache uit ON uit.id = ea.user_it_id \
      LEFT JOIN ecp_dov d ON d.id = ea.dov_id \
      LEFT JOIN users_cache ud_issuer ON ud_issuer.id = d.user_issuer_id \
      LEFT JOIN users_cache ud_to ON ud_to.id = d.user_to_id \
      LEFT JOIN orders o ON o.id = ea.order_id \
      WHERE ea.ecp_id = ? AND ea.user_to_id = ? ORDER BY ea.date_assignment ASC", 
      $href->{ecp_id}, $user_id);
    $href->{ECP2_ASSIGNMENTS_SUBTABLE} = $res->hashes->to_array;
    $res->finish;
  }

  if (@{$tp_ref->{ECP1_TABLE}} || @{$tp_ref->{ECP2_TABLE}}) {
    # ecp3
    $res = $db->query("SELECT ea.id AS ecp_assignment_id, \
      CONCAT_WS(', ', CONCAT_WS('/', NULLIF(e.owner_ul,''), u.fio), i.name, DATE_FORMAT(e.date_issue, '%e.%m.%y')) AS ecp, \
      CONCAT_WS(', ', uto.title, uto.fio) AS user_to, \
      DATE_FORMAT(ea.date_assignment, '%e.%m.%y %H:%i') AS date_assignment, \
      IF(ea.dov_id, CONCAT('№', d.n, ' от: ', ud_issuer.fio, ', кому: ', ud_to.fio, ', с: ', DATE_FORMAT(d.date_issue, '%e.%m.%y'), ', по: ', DATE_FORMAT(d.date_upto, '%e.%m.%y')), 'Нет доверенности') AS dov, \
      CONCAT_WS(', ', tt.type, t.sn) AS token, \
      CONCAT_WS(', ', uit.title, uit.fio) AS user_it, \
      CONCAT_WS(', ', CONCAT_WS(' ', CASE o.type WHEN 1 THEN 'Служебная записка' WHEN 2 THEN 'Приказ' ELSE 'Прочее' END, CONCAT('№', o.n), DATE_FORMAT(o.date, '%e.%m.%y'), o.text), IF(ea.dov_id, CONCAT('доверенность №', d.n, ' от: ', ud_issuer.fio, ', кому: ', ud_to.fio, ', с: ', DATE_FORMAT(d.date_issue, '%e.%m.%y'), ', по: ', DATE_FORMAT(d.date_upto, '%e.%m.%y')), '')) AS `order`, \
      ea.ticket_no AS ticket_no \
      FROM ecp_assignments ea \
      INNER JOIN ecps e ON e.id = ea.ecp_id \
      INNER JOIN users_cache u ON u.id = e.owner_fl_id \
      INNER JOIN users_cache uto ON uto.id = ea.user_to_id \
      LEFT JOIN issuers i ON i.id = e.issuer_id \
      LEFT JOIN tokens t ON t.id = ea.token_id \
      LEFT JOIN token_types tt ON tt.id = t.type_id \
      LEFT JOIN ecp_dov d ON d.id = ea.dov_id \
      LEFT JOIN users_cache ud_issuer ON ud_issuer.id = d.user_issuer_id \
      LEFT JOIN users_cache ud_to ON ud_to.id = d.user_to_id \
      LEFT JOIN users_cache uit ON uit.id = ea.user_it_id \
      LEFT JOIN orders o ON o.id = ea.order_id \
      WHERE e.owner_fl_id = ? AND ea.user_to_id <> ? \
      ORDER BY ea.date_assignment ASC",
      $user_id, $user_id);
    $tp_ref->{ECP3_TABLE} = $res->hashes->to_array;
    $res->finish;
  } else {
    $tp_ref->{ECP_NOTHING} = 1;
  }

  # skzi
  $res = $db->query("SELECT sa.id AS sa_id, \
    sa.arm_hostname AS comp, \
    CONCAT_WS(', ', s.name, s.sn) AS skzi, \
    DATE_FORMAT(sa.date_assignment, '%e.%m.%y %H:%i') AS date_assignment, \
    CONCAT_WS(', ', uit.title, uit.fio) AS user_it, \
    CONCAT_WS(', номер заявки: ', CONCAT_WS(' ', CASE o.type WHEN 1 THEN 'Служебная записка' WHEN 2 THEN 'Приказ' ELSE 'Прочее' END, CONCAT('№', o.n), DATE_FORMAT(o.date, '%e.%m.%y'), o.text), sa.ticket_no) AS `order`, \
    s.name AS skzi_name, \
    s.manufacturer AS skzi_manufacturer, \
    s.sn AS skzi_sn, \
    s.dist_placement AS dist_placement, \
    s.dist_checksum AS dist_checksum \
    FROM skzi_assignments sa \
    INNER JOIN skzi s ON s.id = sa.skzi_id \
    LEFT JOIN users_cache uit ON uit.id = sa.user_it_id \
    LEFT JOIN orders o ON o.id = sa.order_id \
    WHERE sa.user_to_id = ? ORDER BY sa.date_assignment ASC", 
    $user_id);
  $tp_ref->{SKZI_TABLE} = $res->hashes->to_array;
  $res->finish;

  # activate security warning
  if (@{$tp_ref->{SKZI_TABLE}} || $tp_ref->{ECP_NOTHING} == 0) {
    $tp_ref->{ECP_SECURITY_LABEL} = 1;
  }
} #read_ecp_db()
use warnings qw(redefine);

