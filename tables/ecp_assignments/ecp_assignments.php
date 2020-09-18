<?php
class tables_ecp_assignments {
  
  function getTitle(&$record) {
    return 'ЭЦП:'.$record->val('ecp').' -> '.$record->val('user_to').' (роспись:'.$record->val('rec_no').')';
  }

  function titleColumn() {
    return "CONCAT_WS('->', ecp, user_to)";
  }

  function date_assignment__display(&$record) {
    return date('d/m/Y H:i', strtotime($record->strval('date_assignment')));
  }
}
?>
