<?php //Main Application access point
require_once "/var/www/xfecp/xf/public-api.php";

//default sort
if (!isset($_REQUEST['-sort'])) {
  if (@$_REQUEST['-table'] == 'ecps') {
    $_REQUEST['-sort'] = $_GET['-sort'] = 'date_issue desc';
  } elseif (@$_REQUEST['-table'] == 'ecp_assignments') {
    $_REQUEST['-sort'] = $_GET['-sort'] = 'date_assignment desc';
  } elseif (@$_REQUEST['-table'] == 'skzi_assignments') {
    $_REQUEST['-sort'] = $_GET['-sort'] = 'date_assignment desc';
  }
}

df_init(__FILE__, "xf")->display();
