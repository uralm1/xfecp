<?php
class tables_skzi_assignments {
  
  function getTitle(&$record) {
    return $record->val('skzi').' -> '.$record->val('user_to').' ('.$record->val('arm_hostname').')';
  }

  function titleColumn() {
    return "CONCAT_WS('->', skzi, user_to)";
  }

  function date_assignment__display(&$record) {
    return date('d/m/Y H:i', strtotime($record->strval('date_assignment')));
  }
}
?>
