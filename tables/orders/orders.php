<?php
class tables_orders {
  
  function getTitle(&$record) {
    return 'Документ: '.$record->val('n').' от '.$record->strval('date');
  }

  function titleColumn() {
    return "CONCAT_WS(' ', n, `date`, LEFT(`text`, 80))";
  }
  function date__display(&$record) {
    return date('d/m/Y', strtotime($record->strval('date')));
  }
}
?>
