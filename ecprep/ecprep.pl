#!/usr/bin/perl -w

use strict;
use warnings;
use utf8;
use v5.12;

use FindBin;
use Date::Simple('today');
use Mojo::mysql;

my $cfg;
{ # slurp config
  open my $fh, '<', "$FindBin::Bin/ecprep.conf" or die "Can't read config file!\n";
  local $/ = undef;
  $cfg = eval <$fh>;
  close $fh;
}
die "Error found in config file.\n" if (!$cfg or ref($cfg) ne 'HASH');

####
# report parameters

my $rep_day = today();

binmode STDOUT, ":utf8";
if (@ARGV != 1) {
  die "Genuine help: $0 template.xml > ecprep.xml\n";
}
my $template_file = shift;

my $mysql_pdata = Mojo::mysql->new($cfg->{db});

# build xml
open(TPLFILE, '<:utf8', $template_file) 
  or die "Can't open template file: $!\n";

my %fh = (
  'REP_DAY' => \&rep_day,
  'REP_ECPS' => \&rep_ecps,
  'REP_SKZI' => \&rep_skzi,
  'REP_TOKENS' => \&rep_tokens,
  'REP_ECP_ASSIGNMENTS' => \&rep_ecp_assignments,
  'REP_SKZI_ASSIGNMENTS' => \&rep_skzi_assignments,
);

while (<TPLFILE>) {
  while (/%%([A-Za-z0-9_-]+)%%/) { 
    print $`;
    #print "***Match: $& ($1)***"; 
    if (my $ff = $fh{$1}) {
      &{$ff}($1);
    } else {
      print $&;
      warn "Unhandled template $& found!";
    }
    $_ = $';
  }
  print $_;
}

close TPLFILE;

exit 0;

#--------------------------------------------------
# template handlers

sub rep_day {
  print $rep_day->format('%d.%m.%Y');
}


sub rep_ecps {
  my $db = $mysql_pdata->db;
  my $res = $db->query("SELECT CONCAT_WS('/', NULLIF(e.owner_ul,''), u.fio) AS owner, \
    DATE_FORMAT(e.date_issue,'%e.%m.%y') AS date_issue, DATE_FORMAT(e.date_end,'%e.%m.%y') AS date_end, \
    i.name AS issuer, \
    CASE e.status WHEN 1 THEN 'Действительна' WHEN 2 THEN 'Отозвана' WHEN 3 THEN 'Просрочена' ELSE 'Неопределено' END AS status, \
    CONCAT_WS(' ', CASE o.type WHEN 1 THEN 'Служебная записка' WHEN 2 THEN 'Приказ' ELSE 'Прочее' END, CONCAT('№', o.n), DATE_FORMAT(o.date, '%e.%m.%y'), o.text) AS `order` \
    FROM ecps e \
    LEFT JOIN users_cache u ON u.id = e.owner_fl_id \
    LEFT JOIN issuers i ON i.id = e.issuer_id \
    LEFT JOIN orders o ON o.id = e.order_id \
    ORDER BY e.date_issue DESC");
  my $cnt = 1;
  while (my $n = $res->hash) {
    say '<row>';
    say "<entry>$cnt</entry>";
    say "<entry>$n->{owner}</entry>";
    say "<entry>$n->{date_issue}</entry>";
    say "<entry>$n->{date_end}</entry>";
    say "<entry>$n->{issuer}</entry>";
    say "<entry>$n->{status}</entry>";
    say "<entry>$n->{order}</entry>";
    say '</row>';
    $cnt++;
  }
  $res->finish;
}


sub rep_skzi {
  my $db = $mysql_pdata->db;
  my $res = $db->query("SELECT s.id AS id, \
    s.name AS name, \
    s.manufacturer AS manufacturer, \
    s.sn AS sn, \
    s.dist_placement AS dist_placement \
    FROM skzi s \
    ORDER BY s.name ASC, s.sn ASC");
  my $cnt = 1;
  while (my $n = $res->hash) {
    say '<row>';
    say "<entry>$cnt</entry>";
    say "<entry>$n->{name}</entry>";
    say "<entry>$n->{manufacturer}</entry>";
    say "<entry>$n->{sn}</entry>";
    say "<entry>$n->{dist_placement}</entry>";
    say '<entry>'.check_skzi_usage($n->{id}).'</entry>';
    say '</row>';
    $cnt++;
  }
}

sub check_skzi_usage {
  my $s_id = shift;
  my $db = $mysql_pdata->db;
  my $res = $db->query("SELECT arm_hostname \
    FROM skzi_assignments \
    WHERE skzi_id = ? ORDER BY date_assignment ASC", $s_id);
  my %h;
  while (my $n = $res->hash) {
     $h{$n->{arm_hostname}} = 1;
  }

  my $r = 0;
  foreach (keys %h) {
    $r++ if ($h{$_} > 0);
  }
  return 'Свободно' if $r == 0;
  return 'Установлено' if $r == 1;
  return 'Установлено несколько раз';
}


sub rep_tokens {
  my $db = $mysql_pdata->db;
  my $res = $db->query("SELECT t.id AS id, \
    tt.type AS type, \
    t.sn AS sn \
    FROM tokens t \
    LEFT JOIN token_types tt ON tt.id = t.type_id \
    ORDER BY tt.type ASC, t.sn ASC");
  my $cnt = 1;
  while (my $n = $res->hash) {
    say '<row>';
    say "<entry>$cnt</entry>";
    say "<entry>$n->{type}</entry>";
    say "<entry>$n->{sn}</entry>";
    say '<entry>'.check_token_usage($n->{id}).'</entry>';
    say '</row>';
    $cnt++;
  }
}

sub check_token_usage {
  my $t_id = shift;
  my $db = $mysql_pdata->db;
  my $res = $db->query("SELECT \
    IF((SELECT COUNT(*) FROM ecp_assignments a WHERE a.token_id = ?) > 0, 'Выдан', 'Свободен') AS `usage` \
  ", $t_id);
  return $res->array->[0];
}


sub rep_ecp_assignments {
  my $db = $mysql_pdata->db;
  my $res = $db->query("SELECT CONCAT(CONCAT_WS('/', NULLIF(e.owner_ul,''), ue.fio), ' ', i.name, ' ', DATE_FORMAT(e.date_issue, '%e.%m.%y')) AS ecp, \
    CONCAT_WS(', ', u.title, u.fio) AS user_to, \
    CONCAT_WS(' ', tt.type, t.sn) AS token, \
    DATE_FORMAT(a.date_assignment, '%e.%m.%y %H:%i') AS date_assignment, \
    CONCAT_WS(', ', uit.title, uit.fio) AS user_it, \
    CONCAT_WS(', ', CONCAT_WS(' ', CASE o.type WHEN 1 THEN 'Служебная записка' WHEN 2 THEN 'Приказ' ELSE 'Прочее' END, CONCAT('№', o.n), DATE_FORMAT(o.date, '%e.%m.%y'), o.text), IF(a.dov_id, CONCAT('выдача по доверенности №', d.n, ' выдал: ', ud_issuer.fio, ', кому: ', ud_to.fio, ', с: ', DATE_FORMAT(d.date_issue,'%e.%m.%y'), ', по: ', DATE_FORMAT(d.date_upto,'%e.%m.%y')), 'выдача владельцу')) AS `order` \
    FROM ecp_assignments a \
    LEFT JOIN ecps e ON e.id = a.ecp_id \
    LEFT JOIN users_cache ue ON ue.id = e.owner_fl_id \
    LEFT JOIN issuers i ON i.id = e.issuer_id \
    LEFT JOIN users_cache u ON u.id = a.user_to_id \
    LEFT JOIN tokens t ON t.id = a.token_id \
    LEFT JOIN token_types tt ON tt.id = t.type_id \
    LEFT JOIN users_cache uit ON uit.id = a.user_it_id \
    LEFT JOIN ecp_dov d ON d.id = a.dov_id \
    LEFT JOIN users_cache ud_issuer ON ud_issuer.id = d.user_issuer_id \
    LEFT JOIN users_cache ud_to ON ud_to.id = d.user_to_id \
    LEFT JOIN orders o ON o.id = a.order_id \
    ORDER BY a.date_assignment ASC");
  my $cnt = 1;
  while (my $n = $res->hash) {
    say '<row>';
    say "<entry>$cnt</entry>";
    say "<entry>$n->{date_assignment}</entry>";
    say "<entry>$n->{ecp}</entry>";
    say "<entry>$n->{user_to}</entry>";
    say "<entry>$n->{token}</entry>";
    say "<entry>$n->{user_it}</entry>";
    say "<entry>$n->{order}</entry>";
    say '</row>';
    $cnt++;
  }
  $res->finish;
}


sub rep_skzi_assignments {
  my $db = $mysql_pdata->db;
  my $res = $db->query("SELECT \
    CONCAT_WS(' ', s.name, s.sn) AS skzi, \
    CONCAT_WS(', ', a.arm_hostname, u.title, u.fio) AS arm_user_to, \
    DATE_FORMAT(a.date_assignment, '%e.%m.%y %H:%i') AS date_assignment, \
    CONCAT_WS(', ', uit.title, uit.fio) AS user_it, \
    CONCAT_WS(' ', CASE o.type WHEN 1 THEN 'Служебная записка' WHEN 2 THEN 'Приказ' ELSE 'Прочее' END, CONCAT('№', o.n), DATE_FORMAT(o.date, '%e.%m.%y'), o.text) AS `order` \
    FROM skzi_assignments a \
    LEFT JOIN skzi s ON s.id = a.skzi_id \
    LEFT JOIN users_cache u ON u.id = a.user_to_id \
    LEFT JOIN users_cache uit ON uit.id = a.user_it_id \
    LEFT JOIN orders o ON o.id = a.order_id \
    ORDER BY a.date_assignment ASC");
  my $cnt = 1;
  while (my $n = $res->hash) {
    say '<row>';
    say "<entry>$cnt</entry>";
    say "<entry>$n->{date_assignment}</entry>";
    say "<entry>$n->{skzi}</entry>";
    say "<entry>$n->{arm_user_to}</entry>";
    say "<entry>$n->{user_it}</entry>";
    say "<entry>$n->{order}</entry>";
    say '</row>';
    $cnt++;
  }
  $res->finish;
}
#--------------------------------------------------

###

#--------------------------------------------------


