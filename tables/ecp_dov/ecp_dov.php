<?php
class tables_ecp_dov {
  
  function getTitle(&$record) {
    return 'Доверенность: '.$record->val('n').' '.$record->val('user_issuer').' -> '.$record->val('user_to').' '.$record->display('date_issue');
  }

  function date_issue__display(&$record) {
    return date('d/m/Y', strtotime($record->strval('date_issue')));
  }
  function date_upto__display(&$record) {
    return date('d/m/Y', strtotime($record->strval('date_upto')));
  }
}
?>
